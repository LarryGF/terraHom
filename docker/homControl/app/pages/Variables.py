import os
import yaml
import streamlit as st
import json
import hcl2

st.set_page_config(layout="wide")
st.title("Terraform Variables")

def load_hcl(file_path):
    """Load and parse the YAML file."""
    with open(file_path, 'r') as file:
        return hcl2.load(file)

def load_json(file_path):
    """Load and parse the YAML file."""
    with open(file_path, 'r') as file:
        return json.load(file)


def main():
    
    # Determine YAML path based on environment
    if os.getenv('docker'):
        st.toast(":red[Running inside docker]")
        base_path = '.'
    else:
        st.toast(":orange[Running from Console]")
        base_path = '../../../'
    tfvars_path = os.path.join(base_path, 'terraform', 'terraform.tfvars')
    tfvars_path_json = os.path.join(base_path, 'terraform', 'terraform.tfvars.json')
    tfvars_example_path = os.path.join(base_path, 'terraform', 'terraform.tfvars.example')
    
    # Initialize session state for tfvars
    if 'tfvars' not in st.session_state:
        if os.path.exists(tfvars_path):
            st.session_state.tfvars = load_json(tfvars_path_json)
            st.toast(":green[Loaded vars from generated JSON!]")
            
        elif os.path.exists(tfvars_path):
            st.session_state.tfvars = load_hcl(tfvars_path)
            st.toast(":orange[Loaded vars from existing tfvars!]")
            
        elif os.path.exists(tfvars_example_path):
            st.session_state.tfvars = load_hcl(tfvars_example_path)
            st.toast(":red[Loaded vars from example tfvars!]")
            
            
        else:
            st.error("Tfvars file not found!")
            return

    api_keys = list(st.session_state.tfvars["api_keys"].items())
    generic_vars = [item for item in st.session_state.tfvars.items() if item[0] != "api_keys" and item[0] != "nfs_servers"]

    with st.sidebar:
        
        st.sidebar.header("Variables Control") 
        if st.button('Save Changes', type="primary"):
            tfvars_json_path = f"{tfvars_path}.json"
            
            for row,value in st.session_state["vars-data-editor"]["edited_rows"].items():
                st.session_state.tfvars[generic_vars[row][0]] = eval(value["1"])
            
            for row,value in st.session_state["vars-api-keys-editor"]["edited_rows"].items():
                st.session_state.tfvars["api_keys"][api_keys[row][0]] = value["1"]
            with open(tfvars_json_path, 'w') as file:
                json.dump(st.session_state.tfvars, file, indent=2)
            # Get generic variables into session_state.tfvars
               
                
            
            st.toast(":green[Changes saved!]")
    
    st.header("Generic Variables", divider="red")
    generic_data_df = st.data_editor(
        generic_vars, 
        hide_index=True, 
        use_container_width=True,
        key="vars-data-editor",
        disabled=[1],
        column_config={
            1:"Terraform Variable Name",
            2:"Terraform Variable Value"},
        )
    st.header("Api Keys", divider="red")
    api_keys_df = st.data_editor(
        api_keys,
        hide_index=True,
        column_config={
            1:"Api Key Name",
            2:"Api Key Value"},
        use_container_width=True,
        key="vars-api-keys-editor",
        disabled=[1])
    # for key,value in st.session_state["vars-data-editor"]["edited_rows"].items():
    #     st.session_state.tfvars[key] = [st.session_state.tfvars[key][0],value["1"]]
    
if __name__ == "__main__":
    main()
