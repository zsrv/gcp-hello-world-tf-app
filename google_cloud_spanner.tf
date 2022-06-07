resource "google_project_service" "spanner_api" {
  service = "spanner.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_spanner_instance" "app" {
  name             = var.spring_application_name
  config           = var.google_cloud_spanner_instance_config
  display_name     = "Cloud Spanner instance"
  processing_units = var.google_cloud_spanner_instance_processing_units
  force_destroy    = true

  depends_on = [
    google_project_service.spanner_api
  ]
}

resource "google_spanner_database" "app" {
  instance = google_spanner_instance.app.name
  name     = "main"

  # The recommendation is to use a schema versioning tool like Liquibase instead
  # https://cloud.google.com/blog/topics/developers-practitioners/provisioning-cloud-spanner-using-terraform
  ddl = [
    "CREATE TABLE messages (message_id STRING(36) NOT NULL, message STRING(255) NOT NULL, creation_timestamp TIMESTAMP NOT NULL) PRIMARY KEY (message_id)"
  ]

  deletion_protection = false
}
