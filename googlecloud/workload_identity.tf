resource "google_iam_workload_identity_pool" "github" {
  project = var.gcp_project

  workload_identity_pool_id = "github-pool"
  display_name              = "github-pool"
  description               = "Identity pool for GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github_oidc" {
  project = var.gcp_project

  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions"

  display_name        = "GitHub OIDC"
  description         = "GitHub OIDC identity pool provider for GitHub Actions in Your Org"
  disabled            = false
  attribute_condition = "\"${var.org_name}\" == assertion.repository_owner"

  // https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#understanding-the-oidc-token
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.ref"              = "assertion.ref"
    "attribute.environment"      = "assertion.environment"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}


