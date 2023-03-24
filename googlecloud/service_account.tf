resource "google_service_account" "github_actions_foo" {
  account_id   = "github-actions-foo"
  display_name = "GitHub Actions Foo"
}

resource "google_service_account" "github_actions_bar" {
  account_id   = "github-actions-bar"
  display_name = "GitHub Actions Bar"
}

resource "google_service_account" "github_actions_baz" {
  account_id   = "github-actions-baz"
  display_name = "GitHub Actions Baz"
}

locals {
  foo_roles = toset([
    "roles/viewer",
    "roles/storage.admin",
  ])

  bar_roles = toset([
    "roles/viewer",
  ])

  baz_roles = toset([
    "roles/editor",
  ])
}

resource "google_project_iam_member" "foo_roles" {
  for_each = local.foo_roles

  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.github_actions_foo.email}"
}

resource "google_project_iam_member" "bar_roles" {
  for_each = local.bar_roles

  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.github_actions_bar.email}"
}

resource "google_project_iam_member" "baz_roles" {
  for_each = local.baz_roles

  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.github_actions_baz.email}"
}

resource "google_service_account_iam_binding" "github_actions_foo_wi_binding" {
  service_account_id = google_service_account.github_actions_foo.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principal://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/subject/repo:komazarari/example_githubactions_oidc:ref:refs/heads/main",
  ]
}

resource "google_service_account_iam_binding" "github_actions_bar_wi_binding" {
  service_account_id = google_service_account.github_actions_bar.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principal://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/subject/repo:komazarari/example_githubactions_oidc:ref:refs/heads/develop",
  ]
}

resource "google_service_account_iam_binding" "github_actions_baz_wi_binding" {
  service_account_id = google_service_account.github_actions_baz.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.environment/production",
  ]
}
