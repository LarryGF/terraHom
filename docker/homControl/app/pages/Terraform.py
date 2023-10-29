import os
import yaml
import streamlit as st
import json
import hcl2
import re
from streamlit_extras.stylable_container import stylable_container 
from python_terraform import *

st.set_page_config(layout="wide")
st.title("Terraform Modules")
def main():
    st.session_state.initial_keys = set(st.session_state.keys())
    # Determine YAML path based on environment
    base_path = determine_base_path()
    tf_modules_path = os.path.join(base_path, 'terraform')
    terraform_client = Terraform(working_dir=tf_modules_path)

    if 'deploy_stage' not in st.session_state:
        st.session_state.deploy_stage = None
    
    handle_sidebar(terraform_client)

    st.session_state.modules_in_use = get_used_modules(tf_modules_path) if 'modules_in_use' not in st.session_state else st.session_state.modules_in_use
    
    display_modules(st.session_state.modules_in_use)
    
    modules_to_deploy = [f"module.{module}" for module in st.session_state.modules_in_use if st.session_state.modules_in_use[module]["deploy"]]

    if st.session_state.deploy_stage == "init":
        handle_init(terraform_client)

    if st.session_state.deploy_stage == "plan":
        variables = load_json(os.path.join(base_path, 'terraform', 'terraform.tfvars.json'))
        deploy_terraform_modules(terraform_client, variables, modules_to_deploy)

def determine_base_path():
    if os.getenv('docker'):
        st.toast(":red[Running inside docker]")
        return '.'
    else:
        st.toast(":orange[Running from Console]")
        return '../../../'

def handle_sidebar(tf_client):
    with st.sidebar:        
        st.sidebar.header("Terraform Modules Control") 
        if st.button('Deploy Modules', type="primary"):
            st.session_state.deploy_stage = 'plan'
        if st.button('Terraform Init'):
            st.session_state.deploy_stage = 'init'

def display_modules(modules_in_use):
    num_cols = 5
    cols = st.columns(num_cols)
    
    for index, (module, module_details) in enumerate(modules_in_use.items()):
        col = cols[index % num_cols]
        with col:
            with stylable_container(
                key=module,
                css_styles="""
                    {
                        border: 2px solid rgba(49, 51, 63, 0.2);
                        border-radius: 10px;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                        padding: 10px;
                        margin-bottom: 20px;
                    }
                    """
            ):
                with st.columns(1)[0]:
                    st.write(f"### {module}")
                    st.code(f'''
                            {f"Source: {module_details.get('source', '')}" }
                            {f"For each: {module_details.get('for_each', 'Singular')}" }
                            ''', language="hcl")
                    st.checkbox("Deploy", module_details.get('deploy', False), key=module)
                    
        # Update session state data with widget changes
        st.session_state.modules_in_use[module]['deploy'] = st.session_state[module]

def handle_init(tf_client):
    with st.status("Running terraform init...", expanded=True):
        st.write("Initializing...")
        code, stdout, stderror = tf_client.init()
        st.write(stdout)

def get_used_modules(terraform_dir):
    used_modules = {}

    # Loop through all .tf files in the specified directory
    for file in os.listdir(terraform_dir):
        if file.endswith(".tf"):
            parsed_data = load_hcl(os.path.join(terraform_dir,file))
            if 'module' in parsed_data:
                for module in parsed_data['module']:
                    print(module)
                    module[list(module.keys())[0]].update({"deploy":False})
                    used_modules.update(module)
                    # used_modules.update(module.update({"deploy":False}))
    return used_modules

def load_hcl(file_path):
    """Load and parse the YAML file."""
    with open(file_path, 'r') as file:
        return hcl2.load(file)

def load_json(file_path):
    """Load and parse the YAML file."""
    with open(file_path, 'r') as file:
        return json.load(file)

def deploy_terraform_modules(tf_client,variables,modules_to_deploy):
    if "plan_finished" not in st.session_state:
        st.session_state.plan_finished = False
    if modules_to_deploy:
        # Step 2: terraform apply (just show changes)
        with st.status("Creating plan",expanded=True):
            if not st.session_state.plan_finished:
                st.write(f"Planning a deployment for: {', '.join(modules_to_deploy)}")
                st.session_state.plan_name = f"plan-{'-'.join(modules_to_deploy)}"
                st.write("Generating plan file")
                code,stdout, stderror = tf_client.plan(var=variables,target=modules_to_deploy,out=st.session_state.plan_name)
                if stderror:
                    st.write(stderror)
                else:
                    st.write(f"Generated plan file: {st.session_state.plan_name}")
                    st.session_state.plan_finished = True
            else:
                st.write(f"Using existing plan file: {st.session_state.plan_name}")
                

        if st.session_state.plan_finished:
            if "changes_shown" not in st.session_state:
                st.session_state.changes_shown = False
            
            with st.status("Changes to deploy",expanded=True):
                if not st.session_state.changes_shown:
                    st.write("Reading values from plan file")
                    code,stdout, stderror = tf_client.show(st.session_state.plan_name,json=True)
                    if stderror:
                        st.write(stderror)
                    else:
                        st.write("Loading the values")
                        plan = json.loads(stdout)
                        st.write("Getting resource changes")
                        resource_changes = [resource for resource in plan["resource_changes"] if resource["change"]["actions"][0] != "no-op"]
                        st.write("Formatting resource changes")
                        formatted_resource_changes = [{
                            "module": resource["module_address"],
                            "resource": resource["address"],
                            "actions": resource["change"]["actions"]
                            } for resource in resource_changes]
                        st.write("Fetched the following changes:")
                        generate_markdown(formatted_resource_changes)
                        # with open('test.json','w') as file:
                        #     json.dump(resource_changes, file, indent=2)
                        st.session_state.changes_shown = True
                else:
                    st.write(f"Changes approved")

        # if st.session_state.changes_shown:
        #     if st.button("Confirm and Apply Changes"):
        #         # Step 3: Actual terraform apply
        #         with st.status("Applying terraform changes...",expanded=True):
        #             result = "Sample result of apply"  # Placeholder
        #             code,stdout, stderror = tf_client.apply(st.session_state.plan_name,var=None)
        #             if stderror:
        #                 st.write(stderror)
        #             else:
        #                 st.write(stdout)

        #     else:
        #         st.warning("Changes not confirmed. Deployment halted.")
        if st.session_state.changes_shown:
            # Check if the button was clicked before
            if 'button_clicked' not in st.session_state:
                st.session_state.button_clicked = False

            # Only display button if it wasn't clicked before
            if not st.session_state.button_clicked:
                if st.button("Confirm and Apply Changes"):
                    st.session_state.button_clicked = True

                    # Step 3: Actual terraform apply
                    with st.status("Applying terraform changes...", expanded=True):
                        result = "Sample result of apply"  # Placeholder
                        code, stdout, stderror = tf_client.apply(st.session_state.plan_name, var=None)
                        if stderror:
                            st.write(stderror)
                        else:
                            st.write(stdout)
                        
                        clear_new_session_keys(st.session_state.initial_keys)
                        # Delete the plan file after writing to stdout
                        try:
                            os.remove(os.path.join(base_path,'terraform',st.session_state.plan_name))
                            st.write("Plan file deleted successfully.")
                        except Exception as e:
                            st.write(f"Error deleting plan file: {e}")

            else:
                st.warning("Changes not confirmed. Deployment halted.")

    else:
        st.warning("You need to select at least one module to deploy")

def generate_markdown(data):
    # Dictionary to map action to a more readable representation
    action_map = {
        "create": "🟢 Create",
        "read": "🔵 Read",
        "update": "🟡 Update",
        "delete": "🔴 Delete"
    }

    # Header
    
    # Iterate over the data
    for entry in data:
        module_name = entry["module"]
        resource_name = entry["resource"]
        actions = ', '.join([action_map[action] for action in entry["actions"]])

        st.write(f"{actions} Resource: `{resource_name}`")
        st.write(f" Module: `{module_name}`")
        st.write("---")  # Horizontal line for separation

def clear_new_session_keys(initial_keys):
    """Clear only the keys added during this script's execution."""
    current_keys = set(st.session_state.keys())
    new_keys = current_keys - initial_keys

    for key in new_keys:
        del st.session_state[key]

if __name__ == "__main__":
    main()
