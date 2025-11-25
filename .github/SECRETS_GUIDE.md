# 🔒 Secrets Management Guide

## Overview

This guide explains how to handle secrets, API keys, tokens, and credentials in Banner Studio.

## Core Principles

1. **Never commit secrets to the repository**
2. **Always use placeholders in code** (e.g., `YOUR_API_KEY`)
3. **Store real values in environment variables** (via `.env` files)
4. **Use `.env.example` as a template** for required variables

---

## Current Status

Banner Studio is a **local-only tool** that doesn't currently require:
- API keys
- External service tokens
- Authentication credentials
- Database passwords

However, this guide ensures we're prepared if future features require external services.

---

## Best Practices

### ✅ DO

**Use placeholders in code:**
```python
# ✅ CORRECT
api_key = os.getenv("API_KEY", "YOUR_API_KEY_HERE")
if api_key == "YOUR_API_KEY_HERE":
    raise ValueError("Please set API_KEY environment variable")
```

**Use environment variables:**
```python
# ✅ CORRECT
import os
api_key = os.getenv("API_KEY")  # Load from environment
```

**Create `.env.example` files:**
```bash
# ✅ CORRECT - .env.example (committed to repo)
API_KEY=YOUR_API_KEY_HERE
API_SECRET=YOUR_API_SECRET_HERE
```

**Use `.env` for real values (gitignored):**
```bash
# ✅ CORRECT - .env (NOT committed, gitignored)
API_KEY=sk_live_abc123xyz789  # Real value, stays local
```

### ❌ DON'T

**Never hardcode secrets:**
```python
# ❌ WRONG - Never do this
api_key = "sk_live_abc123xyz789"
token = "Bearer eyJhbGc..."
password = "MySecret123"
```

**Never commit `.env` files:**
```bash
# ❌ WRONG - .env should be in .gitignore
git add .env  # NEVER do this
```

**Never put secrets in comments:**
```python
# ❌ WRONG - Even in comments
# API key: sk_live_abc123xyz789
# Password: MySecret123
```

**Never use real values in examples:**
```python
# ❌ WRONG - Even in example code
example_api_key = "sk_test_123456"
```

---

## Implementation Guide

### Step 1: Identify Required Secrets

If you're adding a feature that needs credentials:

1. List all required secrets
2. Document them in `.env.example`
3. Use clear, descriptive names

### Step 2: Code Implementation

```python
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Use placeholders as defaults
API_KEY = os.getenv("API_KEY")
if not API_KEY or API_KEY == "YOUR_API_KEY_HERE":
    raise ValueError(
        "API_KEY not set. Please create a .env file with your API key. "
        "See .env.example for template."
    )
```

### Step 3: Create Template File

**`.env.example`** (committed to repo):
```bash
# API Configuration
API_KEY=YOUR_API_KEY_HERE
API_SECRET=YOUR_API_SECRET_HERE

# Service Endpoints
API_BASE_URL=https://api.example.com/v1
```

**`.env`** (gitignored, not committed):
```bash
API_KEY=your_actual_key_here
API_SECRET=your_actual_secret_here
API_BASE_URL=https://api.example.com/v1
```

### Step 4: Documentation

Update README.md:
```markdown
## Configuration

1. Copy `.env.example` to `.env`
2. Replace placeholders with your actual values
3. Never commit `.env` to the repository
```

---

## CI/CD Considerations

### GitHub Actions

Our CI workflow automatically scans for secrets using TruffleHog. If you see warnings:

1. **Review the flagged code**
2. **Replace any real secrets with placeholders**
3. **Ensure secrets are only in `.env` files (which are gitignored)**

### Pre-commit Checks

Before every commit, check:

```bash
# Review what you're about to commit
git diff --cached

# Look for common secret patterns
git diff --cached | grep -i "api_key\|token\|secret\|password"

# If you see real values, remove them and use placeholders
```

---

## If Secrets Are Accidentally Committed

### Immediate Actions

1. **Revoke/Rotate the exposed credentials immediately**
   - Change API keys
   - Update passwords
   - Regenerate tokens

2. **Remove from Git history**:
   ```bash
   # Option 1: Use git filter-branch (for small repos)
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch path/to/file" \
     --prune-empty --tag-name-filter cat -- --all
   
   # Option 2: Use BFG Repo-Cleaner (recommended for large repos)
   # See: https://rtyley.github.io/bfg-repo-cleaner/
   ```

3. **Force push** (coordinate with team):
   ```bash
   git push origin --force --all
   git push origin --force --tags
   ```

4. **Notify team members** to re-clone the repository

### Prevention

- Use pre-commit hooks to scan for secrets
- Enable branch protection rules on GitHub
- Review PRs carefully before merging
- Use automated secret scanning tools

---

## Common Patterns

### Pattern 1: Optional API Key

```python
import os

API_KEY = os.getenv("API_KEY")
if API_KEY:
    # Use API features
    pass
else:
    # Fallback to local-only mode
    print("Warning: API_KEY not set. Using local mode.")
```

### Pattern 2: Required API Key

```python
import os

API_KEY = os.getenv("API_KEY")
if not API_KEY or API_KEY == "YOUR_API_KEY_HERE":
    raise ValueError(
        "API_KEY is required. Set it in .env file. "
        "See .env.example for template."
    )
```

### Pattern 3: Multiple Configurations

```python
import os

config = {
    "api_key": os.getenv("API_KEY"),
    "api_secret": os.getenv("API_SECRET"),
    "base_url": os.getenv("API_BASE_URL", "https://api.default.com"),
}
```

---

## Checklist

Before committing code that uses secrets:

- [ ] Used placeholders (`YOUR_API_KEY`) in code
- [ ] Created/updated `.env.example` with placeholders
- [ ] Real values are only in `.env` (gitignored)
- [ ] Code handles missing environment variables gracefully
- [ ] Documentation explains how to set up `.env`
- [ ] No secrets in comments or example code
- [ ] Reviewed `git diff` before committing

---

## Questions?

If you're unsure about handling secrets:
1. Ask in a GitHub issue
2. Review this guide
3. Check `.env.example` for examples
4. When in doubt, use placeholders

Remember: **It's better to ask than to accidentally expose secrets!**

