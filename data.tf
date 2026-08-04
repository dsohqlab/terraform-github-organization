# Use this data source to retrieve information about a GitHub Actions Organization public key. This data source is required to be used with other GitHub secrets interactions.
data "github_actions_organization_public_key" "this" {}

# Use this data source to retrieve information about a GitHub Dependabot Organization public key. This data source is required to be used with other GitHub secrets interactions.
data "github_dependabot_organization_public_key" "this" {}
