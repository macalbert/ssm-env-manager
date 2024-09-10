#!/bin/bash

# Define the path to the JSON file
JSON_FILE="param_map.json"

# Initialize the .env file
ENV_FILE=".env"
echo "# Generated .env file" > $ENV_FILE

# Check if jq is installed (required for parsing JSON)
if ! command -v jq &> /dev/null
then
    echo "jq is required but not installed. Please install jq to proceed."
    exit 1
fi

# Read keys and values from the JSON file
for row in $(jq -r 'to_entries[] | "\(.key) \(.value)"' $JSON_FILE); do
    # Split the row into environment variable name and parameter key
    ENV_VAR=$(echo $row | awk '{print $1}')
    PARAM_KEY=$(echo $row | awk '{print $2}')
    
    # Fetch the parameter value using AWS CLI
    PARAM_VALUE=$(aws ssm get-parameter --name "$PARAM_KEY" --with-decryption --query "Parameter.Value" --output text 2>/dev/null)
    
    # Check if the fetch was successful
    if [ $? -ne 0 ]; then
        echo "Error fetching parameter: $PARAM_KEY"
        continue
    fi
    
    # Write the environment variable and its value to the .env file
    echo "${ENV_VAR}=${PARAM_VALUE}" >> $ENV_FILE
done

echo ".env file generated successfully."
