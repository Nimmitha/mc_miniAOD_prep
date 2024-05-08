#!/bin/bash

####################################################
##          Author: Nimmitha Karunarathna         ##
##          Date: 05/08/2024                      ##
####################################################

# This script takes the files inside the GEN in a given input directory.
# Then it creates directories/workspaces for each file at ../ level
# and copy the files to correponding directories
# Generic config files are then copied from the provided config folder
# Ex: ./setup_folder.sh Y2S 2018MC

# Define the base path of the config directory
CONFIG_BASE_PATH="ConfigFiles"

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

echo "Navigating to GEN directory inside $1..."
# Navigate to the GEN directory inside Y2S
cd "$1/GEN" || { echo "Error: Could not navigate to '$1/GEN'."; exit 1; }

# Loop through each root file
for file in *.root; do
    # Get the file name without extension
    folder_name="${file%.root}"

    # Create folder at Y2S level if it doesn't exist
    if [ ! -d "../$folder_name" ]; then
        echo "Creating folder '../$folder_name'..."
        mkdir "../$folder_name"
    fi

    # Copy file to corresponding folder with a fixed name
    echo "Copying file '$file' to '../$folder_name/'..."
    cp "$file" "../$folder_name/GEN.root"

    # Copy config folder contents to corresponding folder
    echo "Copying config folder '$2' contents to '../$folder_name/'..."
    cp -r "../../$CONFIG_BASE_PATH/$2/." "../$folder_name/"
done

echo "Folders setup completed successfully!"
