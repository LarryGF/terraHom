import os
import yaml
import streamlit as st
from uuid import uuid4
from streamlit_extras.stylable_container import stylable_container 

st.set_page_config(layout="wide")
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

    num_cols = 4
    cols = st.columns(num_cols)
    
    for index, (app_name, app_details) in enumerate(st.session_state.apps_data.items()):
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
                            else:
                                st.text_input(f"{key}", str(val), key=f"{app_name}-{vol_name}-{key}")
                    if st.button("Add New Volume", key=f"{app_name}-add-volume"):
                        # Create a new unique volume name (this can be changed later by the user)
                        new_volume_name = str(uuid4())[:8]
                        # Initialize the new volume with default values
                        st.session_state[f"{app_name}-{new_volume_name}-create"] = False
                        st.session_state[f"{app_name}-{new_volume_name}-name"] = new_volume_name
                        st.session_state[f"{app_name}-{new_volume_name}-size"] = ""
                        st.session_state[f"{app_name}-{new_volume_name}-access_modes"] = "['']"
                        st.session_state.apps_data[app_name]['volumes'][new_volume_name] = {
                            "create": False,
                            "name": new_volume_name,
                            "size": "",
                            "access_modes": "['']"
                        }
                # Update session state data with widget changes
                st.session_state.apps_data[app_name]['deploy'] = st.session_state[app_name]
                st.session_state.apps_data[app_name]['namespace'] = st.session_state[f"{app_name}-namespace"]
                st.session_state.apps_data[app_name]['priority'] = st.session_state[f"{app_name}-priority"]
                
                # Update volumes in session state
                for vol_name, vol_details in app_details.get('volumes', {}).items():
                    for key, val in vol_details.items():
                        if isinstance(val, bool):
                            st.session_state.apps_data[app_name]['volumes'][vol_name][key] = st.session_state[f"{app_name}-{vol_name}-{key}"]
                        else:
                            st.session_state.apps_data[app_name]['volumes'][vol_name][key] = st.session_state[f"{app_name}-{vol_name}-{key}"]

    st.write(st.session_state['apps_data']['nextcloud'])
    if st.button('Save Changes'):
        with open(yaml_path, 'w') as yaml_file:
            yaml.dump(st.session_state.apps_data, yaml_file)
        st.success("Changes saved!")

if __name__ == "__main__":
    main()
