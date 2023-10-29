# Use an official Python runtime as the base image
FROM python:3.10-slim

EXPOSE 8501
# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY ./app/Pipfile.lock /app/Pipfile.lock
COPY ./app/Pipfile /app/Pipfile

# Install necessary system packages for Python packages with native extensions
RUN apt-get update && apt-get install -y \
    gcc \
    libffi-dev \
    libssl-dev \
    gnupg \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Set Terraform version
ARG TERRAFORM_VERSION="1.6.2"  # Adjust this to your desired version

# Update and install required dependencies
RUN apt-get update && \
    apt-get install -y wget unzip && \
    # Download Terraform
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    # Unzip and install Terraform
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    # Clean up
    apt-get remove -y wget unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install pipenv
RUN pip install --upgrade pip && pip install pipenv

# Install Python dependencies from Pipfile.lock
RUN pipenv install --deploy --ignore-pipfile --python $(which python3)

COPY ./app/ /app/

# Make port 8501 available to the world outside this container (Streamlit default port)

# Define environment variable (Optional)
# ENV NAME World

# Run app.py when the container launches using pipenv
CMD ["pipenv", "run", "streamlit", "run", "Home.py"]
