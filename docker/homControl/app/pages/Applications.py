import os
import yaml
import streamlit as st
from uuid import uuid4
from streamlit_extras.stylable_container import stylable_container 

st.set_page_config(
    layout="wide",
    page_icon="https://raw.githubusercontent.com/LarryGF/pi-k8s/c1682af8f077bce0dcfd04c7d70b64375f2fa042/docker/homControl/app/files/logo_dark-transparent.svg"
    )
st.title("Applications Configuration Dashboard")

def load_yaml(file_path):
    """Load and parse the YAML file."""
    with open(file_path, 'r') as file:
        return yaml.safe_load(file)

def main():
    
    # Determine YAML path based on environment
    if os.getenv('docker'):
        st.toast(":red[Running inside docker]")
        yaml_path = os.path.join('.', 'terraform', 'applications.yaml')
    else:
        st.toast(":orange[Running from Console]")
        yaml_path = os.path.join('../../../', 'terraform', 'applications.yaml')
    
    # Initialize session state for apps_data
    if 'apps_data' not in st.session_state:
        if os.path.exists(yaml_path):
            st.session_state.apps_data = load_yaml(yaml_path)
        else:
            st.error("YAML file not found!")
            return

    with st.sidebar:
        
        st.sidebar.header("Applications Control") 
        if st.sidebar.button("Enable all "):
            for app_name in st.session_state.apps_data:
                st.session_state.apps_data[app_name]['deploy'] = True
            
        if st.sidebar.button("Disable all"):
            for app_name in st.session_state.apps_data:
                st.session_state.apps_data[app_name]['deploy'] = False
        if st.button('Save Changes', type="primary"):
            with open(yaml_path, 'w') as yaml_file:
                # Add a comment at the beginning (optional)
                yaml_file.write("# This file contains the configuration for applications.\n")
                yaml_file.write("# Make changes with caution!\n\n")
                
                # Dump the data in a human-readable format
                yaml.safe_dump(st.session_state.apps_data, yaml_file, default_flow_style=False, indent=2, allow_unicode=True)
            
            st.toast(":green[Changes saved!]")
            
    num_cols = 5
    cols = st.columns(num_cols)
    # Extract the dictionary items from st.session_state.apps_data
    items = list(st.session_state.apps_data.items())
    # Sort the items based on the 'deploy' key within each nested dictionary
    sorted_items = sorted(items, key=lambda x: x[1].get('deploy', False), reverse=True)

    search_term = st.text_input("Search", "")

    if search_term:
        sorted_items = [item for item in sorted_items if search_term.lower() in item[0].lower()]

    for index, (app_name, app_details) in enumerate(sorted_items):
        col = cols[index % num_cols]
        with col:
            with stylable_container(
                key=app_name,
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
                    st.write(f"### {app_name}")
                    st.checkbox("Deploy", app_details.get('deploy', False), key=app_name)
                    st.text_input("Namespace", app_details.get('namespace', ''), key=f"{app_name}-namespace")
                    st.text_input("Priority", app_details.get('priority', ''), key=f"{app_name}-priority")
                    
                    # Volumes handling
                    volumes = app_details.get('volumes', {})
                    with st.expander("**Volumes**"):
                        for vol_name, vol_details in volumes.items():
                            st.write(f"- {vol_name}")
                            for key, val in vol_details.items():
                                if isinstance(val, bool):
                                    st.checkbox(key, vol_details.get(key, False), key=f"{app_name}-{vol_name}-{key}")
                        
                        if not volumes:
                            st.write("No PVCs for this app")
                    st.session_state.apps_data[app_name]['deploy'] = st.session_state[app_name]
                    st.session_state.apps_data[app_name]['namespace'] = st.session_state[f"{app_name}-namespace"]
                    st.session_state.apps_data[app_name]['priority'] = st.session_state[f"{app_name}-priority"]
                    
                    # # Update volumes in session state
                    for vol_name, vol_details in app_details.get('volumes', {}).items():
                        for key, val in vol_details.items():
                            if isinstance(val, bool):
                                st.session_state.apps_data[app_name]['volumes'][vol_name][key] = st.session_state[f"{app_name}-{vol_name}-{key}"]



if __name__ == "__main__":
    main()
