#!/bin/bash

# Function to verify CMSSW environment and log outputs
verify_cmssw_version() {
    local version="$1"
    local temp_current=$(pwd)

    CMSSW_BASE_DIR="/uscms/home/wkarunar/nobackup/datasets/prep/$version" 

    # Log the command being executed
    echo "Activating CMSSW environment..."

    # Check if the CMSSW directory exists
    if [ ! -d "$CMSSW_BASE_DIR" ]; then
        echo "Error: CMSSW directory '$CMSSW_BASE_DIR' not found."
        exit 1
    fi

    # Change to the CMSSW src directory and log the output
    cd "$CMSSW_BASE_DIR/src" || { echo "Error: Could not navigate to '$CMSSW_BASE_DIR/src'."; exit 1; }
    echo "Changed directory to '$CMSSW_BASE_DIR/src'."

    # Source the cmsset_default.sh script to activate CMSSW environment and log the output
    eval "$(scram runtime -sh)" 2>&1
    echo "Activated CMSSW environment."

    # Navigate back to the previous directory and log the output
    cd "$temp_current" || { echo "Error: Could not navigate back to "$temp_current"."; exit 1; }
    echo "Navigated back to "$temp_current"."

    # Check if the actual CMSSW version matches the expected version
    if [ "$CMSSW_VERSION" == "$version" ]; then
        echo "CMSSW Version: $CMSSW_VERSION"
        return 0  # Return true
    else
        echo "Error: CMSSW version '$CMSSW_VERSION' does not match the expected version '$version'."
        exit 1  # Return false
    fi
}

# Example usage
# verify_cmssw_version "CMSSW_10_6_20"
