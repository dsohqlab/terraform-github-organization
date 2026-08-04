# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_settings
# Create and manage settings for a GitHub Organization.
resource "github_organization_settings" "this" {
  name                                                         = var.settings.display_name
  company                                                      = var.settings.company
  description                                                  = var.settings.description
  email                                                        = var.settings.email
  billing_email                                                = var.settings.billing_email
  blog                                                         = var.settings.blog
  twitter_username                                             = var.settings.twitter_username
  location                                                     = var.settings.location
  has_organization_projects                                    = var.settings.has_organization_projects
  has_repository_projects                                      = var.settings.has_repository_projects
  default_repository_permission                                = var.settings.default_repository_permission
  members_can_create_repositories                              = var.settings.members_can_create_repositories
  members_can_create_public_repositories                       = var.settings.members_can_create_public_repositories
  members_can_create_private_repositories                      = var.settings.members_can_create_private_repositories
  members_can_create_internal_repositories                     = var.settings.members_can_create_internal_repositories
  members_can_create_pages                                     = var.settings.members_can_create_pages
  members_can_create_public_pages                              = var.settings.members_can_create_public_pages
  members_can_create_private_pages                             = var.settings.members_can_create_private_pages
  members_can_fork_private_repositories                        = var.settings.members_can_fork_private_repositories
  web_commit_signoff_required                                  = var.settings.web_commit_signoff_required
  advanced_security_enabled_for_new_repositories               = var.settings.advanced_security_enabled_for_new_repositories
  dependabot_alerts_enabled_for_new_repositories               = var.settings.dependabot_alerts_enabled_for_new_repositories
  dependabot_security_updates_enabled_for_new_repositories     = var.settings.dependabot_security_updates_enabled_for_new_repositories
  dependency_graph_enabled_for_new_repositories                = var.settings.dependency_graph_enabled_for_new_repositories
  secret_scanning_enabled_for_new_repositories                 = var.settings.secret_scanning_enabled_for_new_repositories
  secret_scanning_push_protection_enabled_for_new_repositories = var.settings.secret_scanning_push_protection_enabled_for_new_repositories
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_permissions
# Create and manage GitHub Actions permissions within your GitHub enterprise organizations.
resource "github_actions_organization_permissions" "this" {
  allowed_actions      = var.action_permissions.allowed_actions
  enabled_repositories = var.action_permissions.enabled_repositories

  allowed_actions_config {
    github_owned_allowed = var.action_permissions.github_owned_allowed
    patterns_allowed     = var.action_permissions.patterns_allowed
    verified_allowed     = var.action_permissions.verified_allowed
  }
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team
# This resource allows you to add/remove teams from your organization. When applied, a new team will be created. When destroyed, that team will be removed.
resource "github_team" "this" {
  for_each = var.teams

  name        = each.key
  description = each.value.description
  privacy     = each.value.privacy
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_settings
# This resource manages the team settings (in particular the request review delegation settings) within the organization.
resource "github_team_settings" "this" {
  for_each = var.teams

  team_id = github_team.this[each.key].id
  review_request_delegation {
    algorithm    = each.value.review_request_delegation_algorithm
    member_count = each.value.review_request_delegation_member_count
    notify       = each.value.review_request_delegation_notify
  }
  depends_on = [github_team.this]
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/membership
# This resource allows you to add/remove users from your organization.
resource "github_membership" "this" {
  for_each = var.members

  username = each.key
  role     = each.value.role
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_members
# This resource allows you to add/remove members from your teams.
resource "github_team_members" "this" {
  for_each = var.teams

  team_id = github_team.this[each.key].id

  dynamic "members" {
    for_each = { for name, user in var.members : name => user.role if try(user.teams[0], "") == "*" || contains(user.teams, each.key) || each.value.all_users_team }
    content {
      username = members.key
      role     = members.value == "admin" ? "maintainer" : "member"
    }
  }
  depends_on = [github_team.this, github_membership.this]
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_block
# This resource allows you to create and manage blocks for GitHub organizations.
resource "github_organization_block" "this" {
  for_each = { for name, user in var.members : name => user.blocked if user.blocked }

  username   = each.key
  depends_on = [github_team.this, github_membership.this]
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
# This resource allows you to create and manage repositories within your GitHub organization or personal account.
resource "github_repository" "this" {
  for_each = var.repositories

  name                        = each.key
  description                 = each.value.description
  homepage_url                = each.value.homepage_url
  fork                        = each.value.fork
  source_owner                = each.value.source_owner
  source_repo                 = each.value.source_repo
  visibility                  = each.value.visibility
  has_issues                  = each.value.has_issues
  has_discussions             = each.value.has_discussions
  has_projects                = each.value.has_projects
  has_wiki                    = each.value.has_wiki
  is_template                 = each.value.is_template
  allow_update_branch         = each.value.allow_update_branch
  allow_merge_commit          = each.value.allow_merge_commit
  allow_squash_merge          = each.value.allow_squash_merge
  allow_rebase_merge          = each.value.allow_rebase_merge
  allow_auto_merge            = each.value.allow_auto_merge
  delete_branch_on_merge      = each.value.delete_branch_on_merge
  archived                    = each.value.archived
  web_commit_signoff_required = each.value.web_commit_signoff_required
  topics                      = each.value.topics
  auto_init                   = true
  vulnerability_alerts        = true

  dynamic "security_and_analysis" {
    for_each = each.value.visibility == "public" ? [1] : []
    content {
      secret_scanning {
        status = "enabled"
      }
      secret_scanning_push_protection {
        status = "enabled"
      }
    }
  }
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection
# This resource allows you to configure branch protection for repositories in your organization.
resource "github_branch_protection" "this" {
  for_each = { for name, repo in var.repositories : name => repo if repo.visibility == "public" }

  repository_id = github_repository.this[each.key].node_id

  pattern                 = coalesce(each.value.default_branch, "main")
  enforce_admins          = false
  allows_deletions        = false
  require_signed_commits  = true
  required_linear_history = true

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    dismissal_restrictions          = []
    pull_request_bypassers          = []
    require_code_owner_reviews      = true
    require_last_push_approval      = false
    required_approving_review_count = 1
    restrict_dismissals             = false
  }
  required_status_checks {
    contexts = each.value.status_checks
    strict   = true
  }
  depends_on = [github_repository.this]
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default
# Configures the default branch for a GitHub repository.
resource "github_branch_default" "main" {
  for_each = var.repositories

  repository = each.key
  branch     = coalesce(each.value.default_branch, "main")
  depends_on = [github_repository.this]
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label
# This resource allows you to create and manage issue labels within your GitHub organization.
resource "github_issue_labels" "issue_labels" {
  for_each = { for name, repo in var.repositories : name => repo.repository.issue_labels if length(repo.issue_labels) > 0 }

  repository = each.key

  dynamic "label" {
    for_each = each.value
    content {
      name  = label.key
      color = label.value
    }
  }
  depends_on = [github_repository.this]
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborators
# This resource manages the complete set of collaborators for a repository, which includes both users and teams, in an authoritative manner.
resource "github_repository_collaborators" "this" {
  for_each = var.repositories

  repository = each.key

  dynamic "team" {
    for_each = var.teams
    content {
      permission = coalesce(try(team.value.repo_permission_override[each.key], null), team.value.repo_permission)
      team_id    = team.key
    }
  }

  depends_on = [github_team.this, github_repository.this]
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_secret
# This resource allows you to create and manage GitHub Actions secrets within your GitHub organization.
resource "github_actions_organization_secret" "this" {
  for_each = var.secrets

  secret_name     = each.key
  visibility      = each.value.visibility
  value           = lookup(each.value, "value", null)
  value_encrypted = lookup(each.value, "value_encrypted", null)
  key_id          = lookup(each.value, "value_encrypted", null) != null ? data.github_actions_organization_public_key.this.key_id : null
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_secret_repositories
# This resource allows you to manage the repositories allowed to access an actions secret within your GitHub organization.
resource "github_actions_organization_secret_repositories" "this" {
  for_each = { for name, secret in var.secrets : name => secret if secret.visibility == "selected" }

  secret_name             = github_actions_organization_secret.this[each.key].secret_name
  selected_repository_ids = [for r in each.value.repositories : data.github_repository.managed[r].repo_id]
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/dependabot_organization_secret
# This resource allows you to create and manage GitHub Dependabot secrets within your GitHub organization.
resource "github_dependabot_organization_secret" "this" {
  for_each = var.bot_secrets

  secret_name     = each.key
  visibility      = each.value.visibility
  value           = lookup(each.value, "value", null)
  value_encrypted = lookup(each.value, "value_encrypted", null)
  key_id          = lookup(each.value, "value_encrypted", null) != null ? data.github_dependabot_organization_public_key.this.key_id : null
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/dependabot_organization_secret_repositories
# This resource allows you to manage the repositories allowed to access a Dependabot secret within your GitHub organization.
resource "github_dependabot_organization_secret_repositories" "this" {
  for_each = { for name, secret in var.bot_secrets : name => secret if secret.visibility == "selected" }

  secret_name             = github_dependabot_organization_secret.this[each.key].secret_name
  selected_repository_ids = [for r in each.value.repositories : data.github_repository.managed[r].repo_id]
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_webhook
# This resource allows you to create and manage GitHub organization webhooks.
resource "github_organization_webhook" "this" {
  for_each = { for v in var.webhooks : v["ident"] => {
    active = v["active"]
    events = v["events"]
    configuration = {
      url          = v["configuration"]["url"]
      content_type = v["configuration"]["content_type"]
      secret       = v["configuration"]["secret"]
      insecure_ssl = v["configuration"]["insecure_ssl"]
    } }
  }

  active = each.value["active"]
  events = each.value["events"]

  configuration {
    url          = each.value["configuration"]["url"]
    content_type = each.value["configuration"]["content_type"]
    secret       = each.value["configuration"]["secret"]
    insecure_ssl = each.value["configuration"]["insecure_ssl"]
  }
}
