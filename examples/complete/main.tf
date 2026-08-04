# Example module usage
module "organization" {
  source = "../../"

  settings = {
    name                                                         = "example"
    display_name                                                 = "Example Corp"
    company                                                      = "Example Corp"
    description                                                  = "Example GitHub Organization"
    email                                                        = "info@example.com"
    billing_email                                                = "billing@example.com"
    location                                                     = "Global"
    has_organization_projects                                    = false
    has_repository_projects                                      = false
    default_repository_permission                                = "none"
    members_can_create_repositories                              = false
    members_can_create_public_repositories                       = false
    members_can_create_private_repositories                      = false
    members_can_create_internal_repositories                     = false
    members_can_create_pages                                     = false
    members_can_create_public_pages                              = false
    members_can_create_private_pages                             = false
    members_can_fork_private_repositories                        = false
    web_commit_signoff_required                                  = false
    advanced_security_enabled_for_new_repositories               = false
    dependabot_alerts_enabled_for_new_repositories               = true
    dependabot_security_updates_enabled_for_new_repositories     = true
    dependency_graph_enabled_for_new_repositories                = true
    secret_scanning_enabled_for_new_repositories                 = true
    secret_scanning_push_protection_enabled_for_new_repositories = true
  }

  action_permissions = {
    allowed_actions      = "selected"
    enabled_repositories = "all"
    github_owned_allowed = true
    verified_allowed     = false
    patterns_allowed     = ["actions/checkout@*", "actions/setup-python@", "actions-ecosystem/*", "pre-commit/action@*"]
  }

  members = {
    dsohqlab = {
      role    = "admin"
      blocked = false
      teams   = ["*"]
    }
  }

  teams = {
    admins = {
      description     = "Admins"
      privacy         = "closed"
      pr_member_count = 1
      pr_notification = true
      repo_permission = "admin"
    }

    members = {
      description     = "Members"
      privacy         = "closed"
      security        = true
      pr_member_count = 1
      pr_notification = true
      repo_permission = "triage"
      repo_permission_override = {
        provisioner = "pull"
      }
    }
  }

  repositories = {
    terraform-github-organization = {
      description                 = "Terraform module to manage GitHub Organization."
      homepage_url                = "https://github.com/dsohqlab/terraform-github-organization"
      visibility                  = "public"
      has_issues                  = true
      has_downloads               = false
      has_discussions             = false
      has_projects                = false
      has_wiki                    = true
      is_template                 = false
      allow_update_branch         = true
      allow_merge_commit          = false
      allow_squash_merge          = true
      allow_rebase_merge          = true
      allow_auto_merge            = false
      archived                    = false
      delete_branch_on_merge      = true
      vulnerability_alerts        = true
      default_branch              = "main"
      web_commit_signoff_required = true
      topics                      = ["github", "terraform", "iac", "terraform-module", "dsohqlab"]
      status_checks               = ["pre-commit"]
    }
  }
}
