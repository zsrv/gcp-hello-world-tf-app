provider "google" {
  project = var.google_project_id
  region  = var.google_region
  zone    = var.google_zone
}

provider "google-beta" {
  project = var.google_project_id
  region  = var.google_region
  zone    = var.google_zone
}

data "google_client_config" "current" {
  provider = google
}

# The application infra/initialization Terraform configuration
# executed before this one set output values that we want to
# use in this configuration
data "tfe_outputs" "current" {
  organization = var.tfe_organization
  workspace    = var.tfe_workspace
}
