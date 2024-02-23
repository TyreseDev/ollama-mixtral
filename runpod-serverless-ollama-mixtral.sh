#!/bin/bash

# Define variables
DOCKER_HUB_USER="tyrese3915"
IMAGE_NAME="runpod-ollama"
IMAGE_TAG="mixtral"

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
echo "Temporary directory created at: $TEMP_DIR"

# Define the Dockerfile path within the temporary directory
DOCKERFILE_PATH="$TEMP_DIR/Dockerfile"
echo "Dockerfile will be located at: $DOCKERFILE_PATH"

# Generate Dockerfile
cat > $DOCKERFILE_PATH <<EOF
# Use pooyaharatian/runpod-ollama as the base
FROM pooyaharatian/runpod-ollama:0.0.7

# Update the command to mixtral
CMD ["mixtral"]
EOF

# Navigate to Dockerfile directory (not strictly needed if using absolute path)
cd $(dirname $DOCKERFILE_PATH)

# Build Docker image
echo "Building Docker image $DOCKER_HUB_USER/$IMAGE_NAME:$IMAGE_TAG..."
docker build -t $DOCKER_HUB_USER/$IMAGE_NAME:$IMAGE_TAG .

# Check if build was successful
if [[ $? -ne 0 ]]; then
  echo "Docker build failed, exiting."
  exit 1
fi

# Login to Docker Hub
echo "Logging in to Docker Hub..."
docker login -u $DOCKER_HUB_USER

# Check if login was successful
if [[ $? -ne 0 ]]; then
  echo "Docker login failed, exiting."
  exit 1
fi

# Push the Docker image
echo "Pushing image to Docker Hub..."
docker push $DOCKER_HUB_USER/$IMAGE_NAME:$IMAGE_TAG

# Finish
echo "Process completed."