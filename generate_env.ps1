# Load the JSON file
$paramMap = Get-Content -Raw -Path "param_map.json" | ConvertFrom-Json

# Initialize the .env file
$envFile = ".env"
"# Generated .env file" | Out-File -FilePath $envFile

# Fetch parameter values and write to .env file
foreach ($envVar in $paramMap.PSObject.Properties.Name) {
    $paramKey = $paramMap.$envVar
    
    # Fetch the parameter value using AWS CLI
    $paramValue = aws ssm get-parameter --name $paramKey --with-decryption --query "Parameter.Value" --output text 2>$null
    
    # Check if the fetch was successful
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error fetching parameter: $paramKey"
        continue
    }
    
    # Write the environment variable and its value to the .env file
    "$envVar=$paramValue" | Out-File -FilePath $envFile -Append
}

Write-Host ".env file generated successfully."
