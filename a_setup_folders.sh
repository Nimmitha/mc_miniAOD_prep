#!/bin/bash

####################################################
##          Author: Nimmitha Karunarathna         ##
##          Date: 05/08/2024                      ##
##          Modified: [Current Date]              ##
####################################################

# This script creates directories/workspaces at ../ level
# If GEN directory is not empty, it copies files from GEN to corresponding directories
# Generic config files are then copied from the provided config folder
# Ex: ./setup_folder.sh Y2S path/to/config/folder

# Define the default workarea name (configurable)
DEFAULT_WORKAREA_NAME="hzmmjpsimm"

# Check if Y2S directory and config folder path are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <directory> <path_to_config_folder>"
    exit 1
fi

# Check if provided directory exists
if [ ! -d "$1" ]; then
    echo "Error: Directory '$1' does not exist."
    exit 1
fi

# Check if config folder exists and extract the folder name
if [ ! -d "$2" ]; then
    echo "Error: Config folder '$2' does not exist."
    exit 1
fi
CONFIG_FOLDER_NAME=$(basename "$2")

echo "Navigating to GEN directory inside $1..."
# Navigate to the GEN directory inside Y2S
cd "$1/GEN" || { echo "Error: Could not navigate to '$1/GEN'."; exit 1; }

# Check if GEN directory is empty
if [ -z "$(ls -A)" ]; then
    echo "GEN directory is empty."
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
        echo "Copying config folder '$CONFIG_FOLDER_NAME' contents to '../$folder_name/'..."
        cp -r "../../$2/." "../$folder_name/"
    done
else
    # Original logic for non-empty GEN directory
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
        cp "$file" "../$folder_name/GEN.root"

        # Copy config folder contents to corresponding folder
        echo "Copying config folder '$CONFIG_FOLDER_NAME' contents to '../$folder_name/'..."
        cp -r "../../$2/." "../$folder_name/"
    done
fi

echo "Folders setup completed successfully!"