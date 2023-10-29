import os
import yaml
import streamlit as st
import json
import hcl2
import re
from streamlit_extras.stylable_container import stylable_container 
from python_terraform import *

stages = ['Initialization', 'Changes to Apply', 'Applying Changes']
st.set_page_config(layout="wide")
st.title("Terraform Modules")

def load_hcl(file_path):
    """Load and parse the YAML file."""
    with open(file_path, 'r') as file:
        return hcl2.load(file)

def load_json(file_path):
    """Load and parse the YAML file."""
    with open(file_path, 'r') as file:
        return json.load(file)

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

def deploy_terraform_modules(tf_client,variables,modules_to_deploy):
    plan_finished = False
    if modules_to_deploy:
        # Step 2: terraform apply (just show changes)
        with st.status("Creating plan",expanded=True):
            st.write(f"Planning a deployment for: {', '.join(modules_to_deploy)}")
            plan_name = f"plan-{'-'.join(modules_to_deploy)}"
            st.write("Generating plan file")
            code,stdout, stderror = tf_client.plan(var=variables,target=modules_to_deploy,out=plan_name)
            if stderror:
                st.write(stderror)
            else:
                st.write(f"Generated plan file: {plan_name}")
                plan_finished = True
                

        if plan_finished:
            with st.status("Changes to deploy",expanded=True):
                st.write("Reading values from plan file")
                code,stdout, stderror = tf_client.show(plan_name,json=True)
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
                

        if plan_finished:
            if st.button("Confirm and Apply Changes"):
                # Step 3: Actual terraform apply
                with st.status("Applying terraform changes...",expanded=True):
                    result = "Sample result of apply"  # Placeholder
                    st.write(result)

            else:
                st.warning("Changes not confirmed. Deployment halted.")
    else:
        st.warning("You need to select at least one module to deploy")
    
def main():
    
    # Determine YAML path based on environment
    if os.getenv('docker'):
        st.toast(":red[Running inside docker]")
        base_path = '.'
    else:
        st.toast(":orange[Running from Console]")
        base_path = '../../../'
    tf_modules_path = os.path.join(base_path, 'terraform')
    terraform_client = Terraform(working_dir=tf_modules_path)
    
    if 'deploy_stage' not in st.session_state:
        st.session_state.deploy_stage = None
    
    with st.sidebar:
        
        st.sidebar.header("Terraform Modules Control") 
        if st.button('Deploy Modules', type="primary"):
            st.session_state.deploy_stage = 'plan'
        if st.button('Terraform Init'):
            st.session_state.deploy_stage = 'init'
    st.session_state.modules_in_use = get_used_modules(tf_modules_path)
    
    num_cols = 5
    cols = st.columns(num_cols)
    
    for index, (module, module_details) in enumerate(st.session_state.modules_in_use.items()):
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

    modules_to_deploy = [f"module.{module}" for module in st.session_state.modules_in_use if st.session_state.modules_in_use[module]["deploy"]]
    tf_client = Terraform(working_dir=tf_modules_path)
    if st.session_state.deploy_stage == "init":
        with st.status("Running terraform init...",expanded=True):
            code,stdout,stderror = tf_client.init()
            st.write(stdout)

    if st.session_state.deploy_stage == "plan":
        variables = load_json(os.path.join(base_path, 'terraform', 'terraform.tfvars.json'))
        
        deploy_terraform_modules(terraform_client,variables,modules_to_deploy)

if __name__ == "__main__":
    main()
