# Complete Example

This example demonstrates every top-level module input and all current nested parameters exposed by the GitHub organization module.

## What it covers

- Full `settings` object with every supported field
- `action_permissions`, including selected repository allow-listing
- `teams`, including delegation, notifications, default permissions, and per-repository overrides
- `members`, including admin, regular, blocked, and `"*"` team assignment behavior
- `repositories`, including public, private, template, and forked repository examples
- `secrets` and `bot_secrets`
- `webhooks`

## Prerequisites

Set values in `terraform.tfvars` or export them as environment variables before applying:

- `github_owner`: GitHub organization login
- `github_token`: GitHub token with organization administration permissions
- `billing_email`: Organization billing email
- `org_email`: Public organization contact email
- `seed_admin_username`: Existing GitHub user to grant admin access
- `blocked_username`: User to demonstrate blocked membership management
- `fork_source_owner` / `fork_source_repository`: Upstream repository used by the fork example
- `npm_token`: Plaintext Actions secret value
- `audit_webhook_token`: Plaintext organization secret value
- `dependabot_token_encrypted`: GitHub-encrypted Dependabot secret value
- `webhook_url`: Webhook destination URL
- `webhook_secret`: Webhook signing secret

## Example terraform.tfvars

```hcl
github_owner               = "example-org"
github_token               = "ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
billing_email              = "billing@example.com"
org_email                  = "engineering@example.com"
seed_admin_username        = "octocat"
blocked_username           = "former-contractor"
fork_source_owner          = "hashicorp"
fork_source_repository     = "terraform-guides"
npm_token                  = "npm_xxxxxxxxxxxxxxxxxxxx"
audit_webhook_token        = "audit-token"
dependabot_token_encrypted = "BASE64_ENCRYPTED_SECRET"
webhook_url                = "https://hooks.example.com/github/org"
webhook_secret             = "super-secret-webhook-key"
```

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Notes

- Replace the fork source values with a repository your organization is allowed to fork.
- `dependabot_token_encrypted` must be encrypted for your organization using GitHub's public key before apply.
- This example intentionally uses realistic placeholder values; review every setting before applying to a production organization.
