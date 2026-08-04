variable "settings" {
  description = "GitHub organization settings."
  type = object({
    name                                                         = string
    billing_email                                                = string
    display_name                                                 = string
    company                                                      = optional(string, "")
    description                                                  = optional(string, "")
    blog                                                         = optional(string, "")
    email                                                        = optional(string, "")
    twitter_username                                             = optional(string, "")
    location                                                     = optional(string, "")
    has_organization_projects                                    = optional(bool, false)
    has_repository_projects                                      = optional(bool, false)
    default_repository_permission                                = optional(string, "read")
    members_can_create_repositories                              = optional(bool, false)
    members_can_create_public_repositories                       = optional(bool, false)
    members_can_create_private_repositories                      = optional(bool, false)
    members_can_create_internal_repositories                     = optional(bool, false)
    members_can_create_pages                                     = optional(bool, false)
    members_can_create_public_pages                              = optional(bool, false)
    members_can_create_private_pages                             = optional(bool, false)
    members_can_fork_private_repositories                        = optional(bool, false)
    web_commit_signoff_required                                  = optional(bool, true)
    advanced_security_enabled_for_new_repositories               = optional(bool, true)
    dependabot_alerts_enabled_for_new_repositories               = optional(bool, true)
    dependabot_security_updates_enabled_for_new_repositories     = optional(bool, true)
    dependency_graph_enabled_for_new_repositories                = optional(bool, true)
    secret_scanning_enabled_for_new_repositories                 = optional(bool, true)
    secret_scanning_push_protection_enabled_for_new_repositories = optional(bool, true)
  })

  validation {
    condition     = length(trimspace(var.settings.name)) > 0 && length(trimspace(var.settings.billing_email)) > 0 && length(trimspace(var.settings.display_name)) > 0 && contains(["read", "write", "admin", "none"], var.settings.default_repository_permission)
    error_message = "settings.name, settings.billing_email, and settings.display_name must be set, and default_repository_permission must be one of read, write, admin, or none."
  }
}

variable "action_permissions" {
  description = "GitHub organizational level Github Actions permissions"
  type = object({
    allowed_actions          = optional(string, "selected")
    enabled_repositories     = optional(string, "all")
    enabled_repository_names = optional(set(string), [])
    github_owned_allowed     = optional(bool, true)
    patterns_allowed         = optional(list(string), [])
    verified_allowed         = optional(bool, false)
  })

  validation {
    condition     = contains(["all", "local_only", "selected"], var.action_permissions.allowed_actions) && contains(["all", "none", "selected"], var.action_permissions.enabled_repositories)
    error_message = "action_permissions.allowed_actions must be one of all, local_only, or selected; enabled_repositories must be one of all, none, or selected."
  }

  validation {
    condition     = var.action_permissions.enabled_repositories != "selected" || length(var.action_permissions.enabled_repository_names) > 0
    error_message = "When action_permissions.enabled_repositories is selected, enabled_repository_names must contain at least one repository managed by this module."
  }

  validation {
    condition     = var.action_permissions.enabled_repositories != "selected" || alltrue([for name in var.action_permissions.enabled_repository_names : contains(keys(var.repositories), name)])
    error_message = "When action_permissions.enabled_repositories is selected, enabled_repository_names must reference repositories defined in var.repositories."
  }
}

variable "teams" {
  default     = {}
  description = "Teams of the GitHub organization"
  type = map(object({
    description                            = string
    privacy                                = string
    all_users_team                         = optional(bool, false)
    notify                                 = optional(bool, true)
    review_request_delegation_algorithm    = optional(string, "LOAD_BALANCE")
    review_request_delegation_member_count = optional(number, 1)
    repo_permission                        = optional(string, "read")
    repo_permission_override               = optional(map(string), {})
  }))

  validation {
    condition     = alltrue([for _, team in var.teams : contains(["secret", "closed"], team.privacy)])
    error_message = "Each team privacy must be either secret or closed."
  }

  validation {
    condition     = alltrue([for _, team in var.teams : alltrue([for repo_name in keys(team.repo_permission_override) : contains(keys(var.repositories), repo_name)])])
    error_message = "Each repo_permission_override key must reference a repository defined in var.repositories."
  }
}

variable "members" {
  default     = {}
  description = "GitHub organization members"
  type = map(object({
    role    = string
    blocked = optional(bool, false)
    teams   = optional(list(string), [])
  }))

  validation {
    condition     = alltrue([for _, member in var.members : contains(["member", "admin"], member.role)])
    error_message = "Each member role must be either member or admin."
  }

  validation {
    condition     = alltrue([for _, member in var.members : alltrue([for team_name in member.teams : team_name == "*" || contains(keys(var.teams), team_name)])])
    error_message = "Each referenced team name in members.teams must exist in var.teams, or use * to target all teams."
  }
}

variable "repositories" {
  default     = {}
  description = "GitHub organization repositories"
  type = map(object({
    description                           = string
    homepage_url                          = optional(string, "")
    fork                                  = optional(bool, false)
    source_owner                          = optional(string, "")
    source_repo                           = optional(string, "")
    visibility                            = optional(string, "public")
    advanced_security                     = optional(bool, false)
    code_security                         = optional(bool, false)
    secret_scanning                       = optional(bool, false)
    secret_scanning_push_protection       = optional(bool, false)
    secret_scanning_ai_detection          = optional(bool, false)
    secret_scanning_non_provider_patterns = optional(bool, false)
    has_issues                            = optional(bool, false)
    has_discussions                       = optional(bool, false)
    has_projects                          = optional(bool, false)
    has_wiki                              = optional(bool, false)
    is_template                           = optional(bool, false)
    allow_update_branch                   = optional(bool, false)
    allow_merge_commit                    = optional(bool, false)
    allow_squash_merge                    = optional(bool, true)
    allow_rebase_merge                    = optional(bool, true)
    allow_auto_merge                      = optional(bool, false)
    archived                              = optional(bool, false)
    delete_branch_on_merge                = optional(bool, true)
    default_branch                        = optional(string, "main")
    topics                                = optional(list(string), [])
    web_commit_signoff_required           = optional(bool, true)
    issue_labels                          = optional(map(string), {})
    status_checks                         = optional(list(string), [])
  }))

  validation {
    condition     = alltrue([for _, repo in var.repositories : contains(["public", "private", "internal"], repo.visibility)])
    error_message = "Each repository visibility must be one of public, private, or internal."
  }

  validation {
    condition     = alltrue([for _, repo in var.repositories : !repo.fork || (length(trimspace(repo.source_owner)) > 0 && length(trimspace(repo.source_repo)) > 0)])
    error_message = "When repositories.fork is true, both source_owner and source_repo must be set."
  }
}

variable "secrets" {
  default     = {}
  description = "Global organization secrets"
  type = map(object({
    value           = optional(string)
    value_encrypted = optional(string)
    visibility      = string
    repositories    = optional(set(string), [])
  }))

  validation {
    condition     = alltrue([for _, secret in var.secrets : contains(["all", "private", "selected"], secret.visibility)])
    error_message = "Each organization secret visibility must be one of all, private, or selected."
  }

  validation {
    condition     = alltrue([for _, secret in var.secrets : (secret.value == null) != (secret.value_encrypted == null)])
    error_message = "Each organization secret must set exactly one of value or value_encrypted."
  }

  validation {
    condition     = alltrue([for _, secret in var.secrets : secret.visibility != "selected" || length(secret.repositories) > 0])
    error_message = "When an organization secret visibility is selected, repositories must contain at least one repository name."
  }
}

variable "bot_secrets" {
  default     = {}
  description = "Global dependabot secrets"
  type = map(object({
    value           = optional(string)
    value_encrypted = optional(string)
    visibility      = string
    repositories    = optional(set(string), [])
  }))

  validation {
    condition     = alltrue([for _, secret in var.bot_secrets : contains(["all", "private", "selected"], secret.visibility)])
    error_message = "Each dependabot secret visibility must be one of all, private, or selected."
  }

  validation {
    condition     = alltrue([for _, secret in var.bot_secrets : (secret.value == null) != (secret.value_encrypted == null)])
    error_message = "Each dependabot secret must set exactly one of value or value_encrypted."
  }

  validation {
    condition     = alltrue([for _, secret in var.bot_secrets : secret.visibility != "selected" || length(secret.repositories) > 0])
    error_message = "When a dependabot secret visibility is selected, repositories must contain at least one repository name."
  }
}

variable "webhooks" {
  default     = []
  description = "List of webhook configurations."
  type = list(object({
    ident  = string
    active = optional(bool, true)
    events = list(string)
    configuration = object({
      url          = string
      content_type = optional(string, "json")
      secret       = optional(string)
      insecure_ssl = optional(bool, false)
    })
  }))

  validation {
    condition     = alltrue([for webhook in var.webhooks : contains(["json", "form"], webhook.configuration.content_type)])
    error_message = "Invalid 'content_type' specified for a webhook. Allowed values are \"json\" or \"form\"."
  }
}
