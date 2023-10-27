import os
import docker

def main():
    # Initialize the Docker client
    client = docker.from_env()

    # Get the UID and GID of the current folder
    uid = os.stat(".").st_uid
    gid = os.stat(".").st_gid

    print("Checking for existing container...")
    # Check if there's an existing container and stop it
    existing_containers = client.containers.list(filters={"name": "homcontrol_container"})
    for container in existing_containers:
        print(f"Stopping existing container with ID {container.id}...")
        container.stop()
        print(f"Removing container {container.id}...")
        container.remove()

    print("Building Docker image...")
    try:
        # Build the Docker image
        client.images.build(path="../../docker/homControl", tag="terrahom/homcontrol")
    except docker.errors.BuildError as e:
        print("Error during build:", e)
        return

    print("Starting Docker container...")
    # Run the Docker container with the specified configurations
    container = client.containers.run(
        "terrahom/homcontrol",
        name="homcontrol_container", # Name the container for easier reference
        detach=True,
        ports={'8501/tcp': 8501},  # Forward port 8501 on localhost to port 8501 in the container
        volumes={os.path.abspath('../../terraform'): {'bind': '/app/terraform', 'mode': 'rw'}},

    )
    print(f"Container {container.id} started.")

if __name__ == "__main__":
    main()
