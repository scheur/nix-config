# ✅ AWS Secrets Integration

Your Nix configuration now includes **automatic AWS Secrets Manager integration**!

## 🔐 What This Does

When you start a new shell (zsh or nushell), the configuration:

1. **Connects to AWS Secrets Manager**
2. **Fetches the `api-keys` secret**
3. **Loads all keys as environment variables** (except `GITHUB_TOKEN`)
4. **Works in both zsh and nushell**

## 📋 How It Works

### In Zsh
```bash
# Automatically sources ~/.config/aws-secrets.sh
# This script:
# 1. Checks for AWS CLI and credentials
# 2. Fetches "api-keys" from Secrets Manager
# 3. Exports each key=value pair (except GITHUB_TOKEN)
# 4. Shows: ✅ AWS secrets loaded: ANTHROPIC_API_KEY, VOYAGE_API_KEY, etc.
```

### In Nushell
```nu
# Automatically runs load-aws-secrets function
# Same process but using Nushell syntax
# Results in same environment variables
```

## 🔧 Requirements

1. **AWS CLI installed** (included in Nix config ✅)
2. **AWS credentials configured** (via `aws configure` or IAM role)
3. **Permission to read `api-keys` secret**

## 🧪 Testing

After running `darwin-rebuild switch`:

```bash
# In any shell, check if secrets are loaded:
env | grep -E "ANTHROPIC|VOYAGE|_API_KEY"

# Should NOT see GITHUB_TOKEN (excluded as requested)
env | grep GITHUB_TOKEN  # Should return nothing
```

## 🚨 Troubleshooting

If secrets don't load, you'll see one of:
- `⚠️ AWS CLI not found` → AWS CLI not in PATH
- `⚠️ AWS credentials not configured` → Run `aws configure`
- `⚠️ Could not fetch 'api-keys'` → Check IAM permissions

## 🔒 Security Notes

- Secrets are loaded **per session** (not persisted)
- `GITHUB_TOKEN` is explicitly excluded
- Values are never logged or displayed
- Works with SSO, IAM roles, or static credentials

## 📝 Adding New Secrets

1. Update secret in AWS:
   ```bash
   aws secretsmanager update-secret \
     --secret-id "api-keys" \
     --secret-string '{"EXISTING_KEY":"value","NEW_KEY":"new_value"}'
   ```

2. New shells will automatically get the new variable

## 🎯 Integration Points

The AWS secrets are loaded:
- **Before** tool initialization (zoxide, atuin, etc.)
- **After** AWS region is set
- **In both** interactive and non-interactive shells
- **Automatically** on every new shell session

This ensures your MCP servers and tools have access to all required API keys! 🚀
