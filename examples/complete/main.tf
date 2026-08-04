module "organization" {
  source = "../.."

  settings = {
    name                                                         = var.github_owner
    billing_email                                                = var.billing_email
    display_name                                                 = "Example Platform Engineering"
    company                                                      = "Example Corp"
    description                                                  = "Complete example for managing a GitHub organization with Terraform"
    blog                                                         = "https://example.com/engineering"
    email                                                        = var.org_email
    twitter_username                                             = "exampleeng"
    location                                                     = "Remote"
    has_organization_projects                                    = false
    has_repository_projects                                      = false
    default_repository_permission                                = "read"
    members_can_create_repositories                              = false
    members_can_create_public_repositories                       = false
    members_can_create_private_repositories                      = false
    members_can_create_internal_repositories                     = false
    members_can_create_pages                                     = false
    members_can_create_public_pages                              = false
    members_can_create_private_pages                             = false
    members_can_fork_private_repositories                        = false
    web_commit_signoff_required                                  = true
    advanced_security_enabled_for_new_repositories               = true
    dependabot_alerts_enabled_for_new_repositories               = true
    dependabot_security_updates_enabled_for_new_repositories     = true
    dependency_graph_enabled_for_new_repositories                = true
    secret_scanning_enabled_for_new_repositories                 = true
    secret_scanning_push_protection_enabled_for_new_repositories = true
  }

  action_permissions = {
    allowed_actions          = "selected"
    enabled_repositories     = "selected"
    enabled_repository_names = ["platform-service", "standards-template"]
    github_owned_allowed     = true
    verified_allowed         = true
    patterns_allowed = [
      "actions/checkout@*",
      "actions/setup-node@*",
      "hashicorp/setup-terraform@*",
      "pre-commit/action@*",
    ]
  }

  teams = {
    platform = {
      description                            = "Core platform engineering team"
      privacy                                = "closed"
      all_users_team                         = true
      notify                                 = true
      review_request_delegation_algorithm    = "LOAD_BALANCE"
      review_request_delegation_member_count = 2
      repo_permission                        = "push"
      repo_permission_override = {
        standards-template = "admin"
        upstream-tooling   = "pull"
      }
    }
    release-engineering = {
      description                            = "Release tooling and automation maintainers"
      privacy                                = "secret"
      all_users_team                         = false
      notify                                 = false
      review_request_delegation_algorithm    = "ROUND_ROBIN"
      review_request_delegation_member_count = 1
      repo_permission                        = "maintain"
      repo_permission_override = {
        platform-service = "admin"
      }
    }
  }

  members = {
    (var.seed_admin_username) = {
      role    = "admin"
      blocked = false
      teams   = ["*"]
    }
    (var.blocked_username) = {
      role    = "member"
      blocked = true
      teams   = []
    }
  }

  repositories = {
    standards-template = {
      description                           = "Reusable repository template for internal standards"
      homepage_url                          = "https://example.com/engineering/standards"
      fork                                  = false
      source_owner                          = ""
      source_repo                           = ""
      visibility                            = "public"
      has_issues                            = true
      has_discussions                       = true
      has_projects                          = false
      has_wiki                              = false
      is_template                           = true
      allow_update_branch                   = true
      allow_merge_commit                    = false
      allow_squash_merge                    = true
      allow_rebase_merge                    = true
      allow_auto_merge                      = true
      archived                              = false
      delete_branch_on_merge                = true
      advanced_security                     = true
      code_security                         = true
      secret_scanning                       = true
      secret_scanning_ai_detection          = true
      secret_scanning_non_provider_patterns = true
      secret_scanning_push_protection       = true
      default_branch                        = "main"
      topics                                = ["github", "platform", "template", "terraform"]
      web_commit_signoff_required           = true
      issue_labels = {
        bug           = "d73a4a"
        documentation = "0075ca"
        enhancement   = "a2eeef"
      }
      status_checks = ["pre-commit", "terraform-validate"]
    }
    platform-service = {
      description                 = "Private application repository with branch protection"
      homepage_url                = "https://example.com/products/platform-service"
      fork                        = false
      source_owner                = ""
      source_repo                 = ""
      visibility                  = "private"
      has_issues                  = true
      has_discussions             = false
      has_projects                = false
      has_wiki                    = true
      is_template                 = false
      allow_update_branch         = true
      allow_merge_commit          = false
      allow_squash_merge          = true
      allow_rebase_merge          = false
      allow_auto_merge            = true
      archived                    = false
      delete_branch_on_merge      = true
      default_branch              = "main"
      topics                      = ["api", "platform", "service"]
      web_commit_signoff_required = true
      issue_labels = {
        incident      = "b60205"
        priority-high = "d93f0b"
      }
      status_checks = []
    }

    upstream-tooling = {
      description                 = "Example repository forked from an upstream source"
      homepage_url                = "https://example.com/engineering/tooling"
      fork                        = true
      source_owner                = var.fork_source_owner
      source_repo                 = var.fork_source_repository
      visibility                  = "private"
      has_issues                  = true
      has_discussions             = false
      has_projects                = false
      has_wiki                    = false
      is_template                 = false
      allow_update_branch         = false
      allow_merge_commit          = true
      allow_squash_merge          = true
      allow_rebase_merge          = true
      allow_auto_merge            = false
      archived                    = false
      delete_branch_on_merge      = false
      default_branch              = "main"
      topics                      = ["fork", "tooling", "upstream"]
      web_commit_signoff_required = false
      issue_labels                = {}
      status_checks               = []
    }
  }

  secrets = {
    NPM_TOKEN = {
      value        = var.npm_token
      visibility   = "selected"
      repositories = ["platform-service", "upstream-tooling"]
    }
    CLOUD_AUDIT_WEBHOOK = {
      value        = var.audit_webhook_token
      visibility   = "private"
      repositories = []
    }
  }

  bot_secrets = {
    DEPENDABOT_TOKEN = {
      value           = null
      value_encrypted = var.dependabot_token_encrypted
      visibility      = "selected"
      repositories    = ["platform-service"]
    }
  }

  webhooks = [
    {
      ident  = "audit-log"
      active = true
      events = ["repository", "team", "member"]
      configuration = {
        url          = var.webhook_url
        content_type = "json"
        secret       = var.webhook_secret
        insecure_ssl = false
      }
    }
  ]
}
