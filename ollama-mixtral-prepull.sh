#!/bin/bash

# Define variables
DOCKER_HUB_USER="tyrese3915"
BASE_IMAGE="ollama/ollama:latest"
CONTAINER_NAME="ollama-prepulled"
IMAGE_NAME="ollama-prepulled"
MODEL_NAME="mixtral"
TAG_NAME="mixtral"

# Log in to Docker Hub
echo "Logging into Docker Hub..."
docker login -u ${DOCKER_HUB_USER}

# Pull the base image
docker pull ${BASE_IMAGE}

# Run the base image as a daemon
CONTAINER_ID=$(docker run -d --name ${CONTAINER_NAME} ${BASE_IMAGE})

# Make sure the container started correctly
if [ $? -ne 0 ]; then
    echo "Failed to start the container."
    exit 1
fi

# Give the container some time to start up properly
sleep 10

# Execute the desired command in the running container
docker exec ${CONTAINER_ID} ollama pull ${MODEL_NAME}

# Commit the container to a new image
# Here you can specify a new ENTRYPOINT or CMD if needed using the --change parameter
docker commit ${CONTAINER_ID} ${DOCKER_HUB_USER}/${IMAGE_NAME}:${TAG_NAME}

# Push the new image to Docker Hub
docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${TAG_NAME}

# Cleanup: stop and remove the temporary container
docker stop ${CONTAINER_ID}
docker rm ${CONTAINER_ID}

# Log out of Docker Hub
echo "Logging out of Docker Hub..."
docker logout

echo "Image ${IMAGE_NAME}:${TAG_NAME} has been uploaded to Docker Hub successfully!"