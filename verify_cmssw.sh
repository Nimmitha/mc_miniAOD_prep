#!/bin/bash

# Function to verify CMSSW environment and log outputs
verify_cmssw_version() {
    local version="$1"

    CMSSW_BASE_DIR="/uscms/home/wkarunar/nobackup/datasets/prep/$version" 

    # Log the command being executed
    echo "Activating CMSSW environment..." >> "$LOG_FILE"

    # Check if the CMSSW directory exists
    if [ ! -d "$CMSSW_BASE_DIR" ]; then
        echo "Error: CMSSW directory '$CMSSW_BASE_DIR' not found." >> "$LOG_FILE"
        exit 1
    fi

    # Change to the CMSSW src directory and log the output
    cd "$CMSSW_BASE_DIR/src" || { echo "Error: Could not navigate to '$CMSSW_BASE_DIR/src'." >> "$LOG_FILE"; exit 1; }
    echo "Changed directory to '$CMSSW_BASE_DIR/src'." >> "$LOG_FILE"

    # Source the cmsset_default.sh script to activate CMSSW environment and log the output
    eval "$(scram runtime -sh)" >> "$LOG_FILE" 2>&1
    echo "Activated CMSSW environment." >> "$LOG_FILE"

    # Navigate back to the previous directory and log the output
    cd - >> "$LOG_FILE" || { echo "Error: Could not navigate back to the previous directory." >> "$LOG_FILE"; exit 1; }
    echo "Navigated back to the previous directory." >> "$LOG_FILE"

    # Check if the actual CMSSW version matches the expected version
    if [ "$CMSSW_VERSION" == "$version" ]; then
        echo "CMSSW Version: $CMSSW_VERSION" >> "$LOG_FILE"
        return 0  # Return true
    else
        echo "Error: CMSSW version '$CMSSW_VERSION' does not match the expected version '$version'." >> "$LOG_FILE"
        exit 1  # Return false
    fi
}

# Example usage
# verify_cmssw_version "CMSSW_10_6_20"
