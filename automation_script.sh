#!/bin/bash

# Function to handle errors and stop the script if any command fails
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error occurred during the last operation. Exiting..."
        exit 1
    fi
}

# Function to install necessary tools
install_tools() {
    echo "Checking and installing necessary tools..."

    # Check and install Docker
    if ! command -v docker &> /dev/null
    then
        echo "Docker not found. Installing Docker..."
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        sudo chown root:docker /var/run/docker.sock
        sudo chmod 770 /var/run/docker.sock  # More secure permission
        echo "Docker installed successfully!"
    else
        echo "Docker is already installed."
    fi

    # Check and install Git
    if ! command -v git &> /dev/null
    then
        echo "Git not found. Installing Git..."
        sudo apt-get install -y git
        echo "Git installed successfully!"
    else
        echo "Git is already installed."
    fi
    echo "Configuring Git user settings..."
    git config --global user.name "Narayananraj"
    git config --global user.email "narayananraj330@gmail.com"
    check_command
    echo "Git configured with username and email."

    # Check and install Python
    if ! command -v python3 &> /dev/null
    then
        echo "Python not found. Installing Python..."
        sudo apt-get install -y python3
        echo "Python installed successfully!"
    else
        echo "Python is already installed."
    fi
}

# Function to create Python app
create_python_app() {
    echo "Creating Python program..."
    cat <<EOL > app.py
print("Hello cloud-engine labs!!")
EOL
    check_command
    echo "Python program created successfully!"
}

# Function to create Dockerfile
create_dockerfile() {
    echo "Creating Dockerfile..."
    cat <<EOL > Dockerfile
# Use official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Command to run the application
CMD ["python3", "./app.py"]
EOL
    check_command
    echo "Dockerfile created successfully!"
}

# Function to build the Docker image
build_docker_image() {
    echo "Building Docker image..."
    docker build -t cloud-engine-labs-python .
    check_command
    echo "Docker image built successfully!"
}

# Function to run the Docker container
run_docker_container() {
    echo "Running Docker container..."
    docker run --rm cloud-engine-labs-python
    check_command
    echo "Docker container ran successfully!"
}

# Function to initialize git repo and push to GitHub
push_to_github() {
    echo "Initializing Git repository..."
    git init
    git add .
    git commit -m "Initial commit: Added Python program and Dockerfile"
    check_command
    echo "Git repository initialized!"

    # GitHub repository URL (update these variables with your GitHub info)
    GITHUB_USERNAME="Narayananraj"
    GITHUB_REPO="assessment"

    echo "Setting remote GitHub repository..."
    git remote add origin https://github.com/$GITHUB_USERNAME/$GITHUB_REPO.git
    check_command

    # Push to GitHub
    echo "Pushing code to GitHub..."
    git push -u origin master
    check_command
    echo "Code pushed to GitHub successfully!"
}

# Main script execution

# Install necessary tools (Docker, Git, Python)
install_tools

# Create Python program and Dockerfile
create_python_app
create_dockerfile

# Build the Docker image
build_docker_image

# Run the Docker container to verify the output
run_docker_container

# Push code to GitHub repository
push_to_github

echo "Automation completed successfully!"

