#!/bin/bash

####################################################
##          Author: Nimmitha Karunarathna         ##
##          Date: 05/08/2024                      ##
####################################################

# This script executes the different steps of the CMS
# workflow for each folder that matches the provided
# pattern in the base folder.
# Ex: ./b_execute_all_steps.sh Y2S hzmmyee
# It will look for directories named hzmmyee* inside
# Y2S directory and execute the steps.

# Function to verify CMSSW environment and execute command for a given step
execute_step() {
    local step=$1
    local current_dir=$(pwd)

    # Pick the CMSSW version based on the step
    if [ "$step" == "HLT" ]; then
        local cmssw_version="CMSSW_10_2_16_UL"
    else
        local cmssw_version="CMSSW_10_6_20"
    fi
    
    # local cmssw_version="CMSSW_12_4_14_patch3"

    # Verify CMSSW environment
    source verify_cmssw.sh
    verify_cmssw_version "$cmssw_version"

    # Find directories matching the pattern and store them in an array
    directories=($(find "$BASE_FOLDER" -type d -name "$SUB_FOLDER_PATTERN*"))

    # skip the first n directories
    # directories=("${directories[@]:8}")

    local folder_count=${#directories[@]}
    echo "Number of folders found: $folder_count"

    # Exit if no folders are found
    if [ $folder_count -eq 0 ]; then
        echo "No folders found matching the pattern '$SUB_FOLDER_PATTERN*' in '$BASE_FOLDER'. Exiting..."
        exit 1
    fi

    # print the directories
    for directory in "${directories[@]}"; do
        echo "$directory"
    done

    echo "Starting to run $step..."  # Indicate that the script is starting to run the specified step

    # Loop through directories matching the provided folder pattern
    for directory in "${directories[@]}"; do
        if [ -d "$directory" ]; then
            echo "Entering directory '$directory'..."
            cd "$directory" || { echo "Error: Could not navigate to '$directory'."; exit 1; }

            # Execute different commands based on the step
            if [ "$step" == "SIM" ]; then
                echo "Working in $(pwd)"
                nohup cmsRun SIM_2018_cfg.py >> output2.log 2>&1 &
            elif [ "$step" == "DIGI" ]; then
                echo "Working in $(pwd)"
                nohup cmsRun DIGIPremix_2018_cfg.py >> output3.log 2>&1 &
            elif [ "$step" == "HLT" ]; then
                echo "Working in $(pwd)"
                nohup cmsRun HLT_2018_cfg.py >> output4.log 2>&1 &
            elif [ "$step" == "RECO" ]; then
                echo "Working in $(pwd)"
                nohup cmsRun RECO_2018_cfg.py >> output5.log 2>&1 &
            elif [ "$step" == "MiniAOD" ]; then
                echo "Working in $(pwd)"
                nohup cmsRun MINIAOD_2018_cfg.py >> output6.log 2>&1 &
            else
                echo "Error: Unknown step '$step'."
                exit 1
            fi

            pid=$!  # Get the process ID of the last background command
            wait $pid  # Wait for the process to finish

            # After executing the code, navigate back to the base path
            cd "$current_dir" || { echo "Error: Could not navigate back to '$BASE_FOLDER'."; exit 1; }
        fi
    done

    echo "Execution of $step complete!"
}

# Check if base folder and folder pattern are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <base_folder> <sub_folder_pattern>"
    exit 1
fi

# Assign input arguments to variables
BASE_FOLDER="$1"
SUB_FOLDER_PATTERN="$2"

execute_step "SIM"
execute_step "DIGI"
execute_step "HLT"
execute_step "RECO"
execute_step "MiniAOD"
