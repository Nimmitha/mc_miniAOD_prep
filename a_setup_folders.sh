#!/bin/bash

####################################################
##          Author: Nimmitha Karunarathna         ##
##          Date: 05/08/2024                      ##
####################################################

# This script creates directories/workspaces at ../ level
# If SIM directory is not empty, it copies files from SIM to corresponding directories
# Generic config files are then copied from the provided config folder
# Ex: ./setup_folder.sh Y2S 2018MC

# Define the base path of the config directory
CONFIG_BASE_PATH="ConfigFiles"

# Define the default workarea name (configurable)
DEFAULT_WORKAREA_NAME="hzeeymm"

# Check if Y2S directory and config folder name are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <directory> <config_folder_name>"
    exit 1
fi

# Check if provided directory exists
if [ ! -d "$1" ]; then
    echo "Error: Directory '$1' does not exist."
    exit 1
fi

# Check if config folder exists
if [ ! -d "$CONFIG_BASE_PATH/$2" ]; then
    echo "Error: Config folder '$2' does not exist in '$CONFIG_BASE_PATH/'."
    exit 1
fi

echo "Navigating to SIM directory inside $1..."
# Navigate to the SIM directory inside Y2S
cd "$1/SIM" || { echo "Error: Could not navigate to '$1/SIM'."; exit 1; }

# Check if SIM directory is empty
if [ -z "$(ls -A)" ]; then
    echo "SIM directory is empty."
    read -p "How many workareas would you like to create? " num_workareas
    
    # Validate input
    if ! [[ "$num_workareas" =~ ^[0-9]+$ ]]; then
        echo "Error: Please enter a valid number."
        exit 1
    fi

    # Create workareas
    for i in $(seq 1 $num_workareas); do
        folder_name="${DEFAULT_WORKAREA_NAME}_$i"
        echo "Creating folder '../$folder_name'..."
        mkdir -p "../$folder_name"

        # Copy config folder contents to corresponding folder
        echo "Copying config folder '$2' contents to '../$folder_name/'..."
        cp -r "../../$CONFIG_BASE_PATH/$2/." "../$folder_name/"
    done
else
    # Original logic for non-empty SIM directory
    for file in *.root; do
    # Get the file name without extension
        folder_name="${file%.root}"

        # Create folder at Y2S level if it doesn't exist
        if [ ! -d "../$folder_name" ]; then
            echo "Creating folder '../$folder_name'..."
            mkdir "../$folder_name"
        fi

        # Copy file to corresponding folder
        echo "Copying file '$file' to '../$folder_name/'..."
        cp "$file" "../$folder_name/SIM.root"

        # Copy config folder contents to corresponding folder
        echo "Copying config folder '$2' contents to '../$folder_name/'..."
        cp -r "../../$CONFIG_BASE_PATH/$2/." "../$folder_name/"
    done
fi

echo "Folders setup completed successfully!"