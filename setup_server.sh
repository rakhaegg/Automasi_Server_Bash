#!/bin/bash

# Set timezone to Asia/Jakarta
expected_timezone="Asia/Jakarta"

sudo timedatectl set-timezone $expected_timezone

current_timezone=$(timedatectl | grep "Time zone" | awk '{print $3}')

if [ "$current_timezone" != "$expected_timezone" ]; then
  echo "Error: Timezone is not set to $expected_timezone. Exiting..."
  exit 1
else
  echo "Timezone is set to $expected_timezone."
fi

# Update and Upgrade Ubuntu
sudo apt update

if [ $? -ne 0]; then
        echo "Error: Failed to update package list."
        exit 1
else
        echo "Success update package list."
fi

sudo apt upgrade -y
if [$? -ne 0]; then
        echo "Error: Failed to upgrade package list."
        exit 1
else
        echo "Success upgrade package list."
fi

sudo apt install -y git curl zip python3 python3-pip

if [ $? -ne 0]; then
        echo "Error: Failed to install. Exiting..."
        exit 1
else
        echo "Failed to install package curl zip python3 python3-pip"
fi



# Optional package for install docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add key GPG to verify file download docker from internet

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Setup docker repository ubuntu jammy
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update repository package
sudo apt update

# Install docker
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Optional : Check status intallation
if [ $? -ne 0 ]; then
  echo "Error: Failed to install Docker. Exiting..."
  exit 1
fi

echo "Docker installation completed successfully."