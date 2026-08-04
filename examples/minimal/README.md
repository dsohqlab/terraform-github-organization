# Minimal Example

This example demonstrates basic usage of the GitHub Organization module.

## Prerequisites

- GitHub Personal Access Token with `admin:org` scope
- Terraform >= 1.11.1

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars`:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your values:
   - `github_owner`: Your GitHub organization name
   - `github_token`: Your GitHub personal access token
   - `billing_email`: Email for organization billing

3. Initialize Terraform:

   ```bash
   terraform init
   ```

4. Preview changes:

   ```bash
   terraform plan
   ```

5. Apply changes:

   ```bash
   terraform apply
   ```

## What This Example Creates

- **Organization Settings**: Basic org configuration
- **Teams**: "backend" and "frontend" teams
- **Members**: alice (backend) and bob (frontend)
- **Repositories**: example-backend and example-frontend
- **GitHub Actions**: Limited to selected actions from GitHub and verified creators

## Cleanup

To destroy resources:

```bash
terraform destroy
```
