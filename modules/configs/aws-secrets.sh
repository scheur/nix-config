#!/bin/bash
# Load AWS secrets from Secrets Manager into environment variables
# This script is sourced by shells to provide API keys as env vars

# Function to load secrets
load_aws_secrets() {
    # Check if AWS CLI is available
    if ! command -v aws &> /dev/null; then
        echo "⚠️  AWS CLI not found. Skipping secrets loading." >&2
        return 1
    fi
    
    # Check if we have AWS credentials
    if ! aws sts get-caller-identity &> /dev/null; then
        echo "⚠️  AWS credentials not configured. Skipping secrets loading." >&2
        return 1
    fi
    
    # Fetch the api-keys secret
    local secret_json
    secret_json=$(aws secretsmanager get-secret-value \
        --secret-id "api-keys" \
        --region "${AWS_DEFAULT_REGION:-us-east-1}" \
        --query 'SecretString' \
        --output text 2>/dev/null)
    
    if [[ $? -ne 0 ]] || [[ -z "$secret_json" ]]; then
        echo "⚠️  Could not fetch 'api-keys' from AWS Secrets Manager" >&2
        return 1
    fi
    
    # Parse and export each key-value pair EXCEPT GITHUB_TOKEN
    # Uses jq if available, otherwise falls back to Python
    if command -v jq &> /dev/null; then
        while IFS="=" read -r key value; do
            if [[ "$key" != "GITHUB_TOKEN" ]] && [[ -n "$key" ]]; then
                export "$key=$value"
            fi
        done < <(echo "$secret_json" | jq -r 'to_entries | .[] | "\(.key)=\(.value)"')
    elif command -v python3 &> /dev/null; then
        while IFS="=" read -r key value; do
            if [[ "$key" != "GITHUB_TOKEN" ]] && [[ -n "$key" ]]; then
                export "$key=$value"
            fi
        done < <(python3 -c "
import json, sys
data = json.loads(sys.argv[1])
for k, v in data.items():
    if k != 'GITHUB_TOKEN':
        print(f'{k}={v}')
" "$secret_json")
    else
        echo "⚠️  Neither jq nor python3 available. Cannot parse secrets." >&2
        return 1
    fi
    
    # List loaded variables (without values for security)
    local loaded_vars=$(echo "$secret_json" | jq -r 'keys | map(select(. != "GITHUB_TOKEN")) | join(", ")' 2>/dev/null || \
                       python3 -c "import json, sys; print(', '.join([k for k in json.loads(sys.argv[1]).keys() if k != 'GITHUB_TOKEN']))" "$secret_json" 2>/dev/null)
    
    if [[ -n "$loaded_vars" ]]; then
        echo "✅ AWS secrets loaded: $loaded_vars" >&2
    fi
}

# Load secrets when script is sourced
load_aws_secrets
