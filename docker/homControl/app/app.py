# app.py
import streamlit as st

def main():
    st.title("Streamlit & Terraform CDK Example")

    st.write("Welcome to this example application!")

    if st.button("Click me!"):
        st.write("You clicked the button!")

if __name__ == "__main__":
    main()
