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
}

variable "action_permissions" {
  description = "GitHub organizational level Github Actions permissions"
  type = object({
    allowed_actions      = optional(string, "selected")
    enabled_repositories = optional(string, "all")
    github_owned_allowed = optional(bool, true)
    patterns_allowed     = optional(list(string), [])
    verified_allowed     = optional(bool, false)
  })
}

variable "teams" {
  default     = {}
  description = "Teams of the GitHub organization"
  type = map(object({
    description                            = string
    privacy                                = string
    all_users_team                         = optional(bool, false)
    review_request_delegation_algorithm    = optional(string, "LOAD_BALANCE")
    review_request_delegation_member_count = optional(number, 1)
    review_request_delegation_notify       = optional(bool, true)
    repo_permission                        = optional(string, "read")
    repo_permission_override               = optional(map(string), {})
  }))
}

variable "members" {
  default     = {}
  description = "GitHub organization members"
  type = map(object({
    role    = string
    blocked = optional(bool, false)
    teams   = optional(list(string), [])
  }))
}

variable "repositories" {
  default     = {}
  description = "GitHub organization repositories"
  type = map(object({
    description                 = string
    homepage_url                = optional(string, "")
    fork                        = optional(bool, false)
    source_owner                = optional(string, "")
    source_repo                 = optional(string, "")
    visibility                  = optional(string, "public")
    has_issues                  = optional(bool, false)
    has_downloads               = optional(bool, false)
    has_discussions             = optional(bool, false)
    has_projects                = optional(bool, false)
    has_wiki                    = optional(bool, false)
    is_template                 = optional(bool, false)
    allow_update_branch         = optional(bool, false)
    allow_merge_commit          = optional(bool, false)
    allow_squash_merge          = optional(bool, true)
    allow_rebase_merge          = optional(bool, true)
    allow_auto_merge            = optional(bool, false)
    archived                    = optional(bool, false)
    delete_branch_on_merge      = optional(bool, true)
    default_branch              = optional(string, "main")
    topics                      = optional(list(string), [])
    web_commit_signoff_required = optional(bool, true)
    issue_labels                = optional(map(string), {})
    status_checks               = optional(list(string), [])
  }))
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
    condition = alltrue([
      for webhook in var.webhooks : contains(["json", "form"], webhook.configuration.content_type)
    ])
    error_message = "Invalid 'content_type' specified for a webhook. Allowed values are \"json\" or \"form\"."
  }
}
