module "github_org" {
  source = "../.."

  settings = {
    name          = var.github_owner
    display_name  = "My GitHub Organization"
    billing_email = var.billing_email
  }

  action_permissions = {
    allowed_actions      = "selected"
    enabled_repositories = "all"
    github_owned_allowed = true
    verified_allowed     = true
  }

  teams = {
    "backend" = {
      description = "Backend development team"
      privacy     = "secret"
    }
    "frontend" = {
      description = "Frontend development team"
      privacy     = "secret"
    }
  }

  members = {
    "alice" = {
      role  = "member"
      teams = ["backend"]
    }
    "bob" = {
      role  = "member"
      teams = ["frontend"]
    }
  }

  repositories = {
    "example-backend" = {
      description = "Example backend repository"
      visibility  = "private"
      has_issues  = true
    }
    "example-frontend" = {
      description = "Example frontend repository"
      visibility  = "private"
      has_issues  = true
    }
  }
}
