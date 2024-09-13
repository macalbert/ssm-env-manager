# SSM-Env-Manager

**SSM-Env-Manager** is a tool designed to help you manage AWS Systems Manager (SSM) Parameter Store parameters and synchronize them with your environment files (`.env`). This repository provides scripts and guides to add, update, delete, and retrieve SSM parameters, focusing on secure environment management for your applications.

## Features

- Manage environment variables securely using AWS SSM Parameter Store.
- Generate `.env` files automatically from SSM parameters.
- Cross-platform support (Linux, Mac, and Windows).
- Easy setup and integration with your CI/CD pipelines.

## Prerequisites

- **AWS CLI**: Installed and configured with necessary permissions.
- **jq**: Command-line JSON processor (required for parsing JSON files).
- **Permissions**: Ensure your AWS CLI user/role has access to SSM Parameter Store.

## Setup

### 1. Clone the repository

  ```bash
   git clone https://github.com/yourusername/SSM-Env-Manager.git
   cd SSM-Env-Manager
  ```

### 2. Make the script executable (for Linux/Mac)

  ```bash
  chmod +x generate_env.sh
  ```

### 3. Create the `param_map.json` File

Create a `param_map.json` file in the root directory of the project. This file maps your environment variable names to their corresponding AWS SSM Parameter Store paths.

Example `param_map.json`:

```json
{
  "ENVIRONMENT_VARIABLE_NAME": "aws/ssm/parameter/name",
}
```

**Note**: Replace the parameter names and paths with your actual environment variables and SSM parameter paths.

### 3. Prepare the Script

For Linux/Mac:
Make the script executable:

```bash
chmod +x generate_env.sh
```

For Windows:

```powershell
.\generate_env.ps1
```

No additional steps are required for Windows PowerShell scripts.

## Managing SSM Parameters

### Creating a Secure String (Encrypted)

The following command creates a secure string parameter in the SSM Parameter Store. Secure strings are encrypted using AWS Key Management Service (KMS), keeping sensitive data like passwords and connection strings secure.

```bash
aws ssm put-parameter --overwrite \
                      --type "SecureString" \
                      --name "/AWS/SSM/Key" \
                      --value "secretValue"
```

Explanation:

- `--type "SecureString"`: Specifies that the parameter is stored as an encrypted secure string.
- `--name "/AWS/SSM/Key"`: The name of the parameter, organized hierarchically for easy management.
- `--value "secretValue"`: The actual value of the parameter. This should be sensitive information that needs encryption.

### Retrieving a Secure String

To fetch a secure string parameter from SSM Parameter Store, including decryption, use the following command:

```bash
aws ssm get-parameter --with-decryption --name "/AWS/SSM/Key"
```

Explanation:

- `--with-decryption`: Decrypts the secure string parameter so you can read the value.
- `--name "/AWS/SSM/Key"`: The name of the parameter to retrieve.

### Deleting a Secure String

To delete a secure string parameter from the SSM Parameter Store, use this command:

```bash
aws ssm delete-parameter --name "/AWS/SSM/Key"
```

Explanation:

- `--name "/AWS/SSM/Key"`: Specifies the parameter to be deleted. This action cannot be undone.

## Using the Helper Script

### Generating a `.env` File

The provided script `generate_env.sh` (for Linux/Mac) or `generate_env.ps1` (for Windows) reads parameter mappings from `param_map.json` and generates a `.env` file with the parameter values retrieved from SSM.

Ensure Your `param_map.json` is Correctly Configured

Make sure your `param_map.json` contains the correct environment variable names and their corresponding SSM parameter paths.

Example `param_map.json`:

```json
{
  "API_KEY": "/YourApp/Production/ApiKey",
  "DB_PASSWORD": "/YourApp/Production/DatabasePassword",
  "JWT_SECRET": "/YourApp/Production/JwtSecret"
}
```

#### Running the Script on Linux/Mac

  1. Run the script:

      ```bash
      ./generate_env.sh
      ```

  2. The script will generate a `.env` file with the fetched parameter values.

#### Running the Script on Windows

  1. Open PowerShell and navigate to the script's directory.

  2. Run the script:

      ```powershell
      ./generate_env.ps1
      ```

  3. The script will generate a `.env` file with the fetched parameter values.

**Note**: Ensure that your execution policy allows running scripts. You may need to set the execution policy by running PowerShell as an administrator:

```powershell
Set-ExecutionPolicy RemoteSigned
```

## Best Practices

- Use descriptive and organized names for your parameters (e.g., `/Application/Environment/Setting`).
- Use IAM roles and policies to manage access to sensitive parameters.
- Regularly audit your parameter store and clean up unused or obsolete parameters.

## Contributing

Contributions are welcome! Please feel free to submit issues, suggest improvements, or create pull requests.

## License

This project is licensed under the MIT License. See the [LICENSE](MIT-LICENSE.txt) file for details.
