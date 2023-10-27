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
    && rm -rf /var/lib/apt/lists/*

# Install pipenv
RUN pip install --upgrade pip && pip install pipenv

# Install Python dependencies from Pipfile.lock
RUN pipenv install --deploy --ignore-pipfile --python $(which python3)

COPY ./app/ /app/

# Make port 8501 available to the world outside this container (Streamlit default port)

# Define environment variable (Optional)
# ENV NAME World

# Run app.py when the container launches using pipenv
CMD ["pipenv", "run", "streamlit", "run", "app.py"]
