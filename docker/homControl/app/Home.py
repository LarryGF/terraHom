# app.py
import streamlit as st
from PIL import Image

st.set_page_config(
    layout="wide",
    page_icon="https://raw.githubusercontent.com/LarryGF/pi-k8s/c1682af8f077bce0dcfd04c7d70b64375f2fa042/docker/homControl/app/files/logo_dark-transparent.svg"
    )

def main():
    image = Image.open('./logo.png')
    st.image(image,width=300)
    st.title("homControl")

    st.markdown("""
    Welcome to **homControl**! 

    This is part of the terraHom repo and provides an interactive way to deploy and manage your infrastructure using Terraform. 🚀

    ## Core Features

    - **Terraform Integration** 🛠: Skip the command line and interact directly with your Terraform configurations.
    - **Module Control** 📦: Handpick specific Terraform modules for deployment.
    - **Real-time Feedback** 📢: Stay in the loop with instant feedback on your deployments.
    - **Docker Enthusiast?** 🐳: Yep, we got you covered! Easily run this app inside a Docker environment.

    ## Navigating homControl

    1. **Application 📱**: Choose which apps to deploy and set the basics like namespace and priority.
    2. **Variables 🧮**: Tweak and tune your terraform variables as you see fit.
    3. **Terraform 🌐**:
        - **Initialization** (Optional but recommended) 🔍: Prep your Terraform configurations.
        - **Planning Ahead** 📝: Peek into the planned changes for your infrastructure.
        - **Deploy** 🚀: Satisfied with the plan? Go ahead and bring those changes to life!

    All set to simplify your Terraform deployment process? Let's make Infrastructure as Code (IAC) fun and accessible! 

    ## Kick-start Your Journey

    🧭 Use the sidebar to glide through the app. Begin with setting up your Terraform configurations and then march ahead to plan and deploy your modules.

    """)

if __name__ == "__main__":
    main()
