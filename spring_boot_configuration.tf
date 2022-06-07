resource "google_project_service" "runtimeconfig_api" {
  service = "runtimeconfig.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_project_service" "secretmanager_api" {
  service = "secretmanager.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = true
}


resource "google_secret_manager_secret" "management_metrics_export_datadog_api_key" {
  secret_id = "management_metrics_export_datadog_api_key"

  replication {
    automatic = true
  }

  depends_on = [
    google_project_service.secretmanager_api
  ]
}

resource "google_secret_manager_secret_version" "management_metrics_export_datadog_api_key" {
  secret = google_secret_manager_secret.management_metrics_export_datadog_api_key.id

  secret_data = var.datadog_api_key
}


resource "google_secret_manager_secret" "management_metrics_export_datadog_application_key" {
  secret_id = "management_metrics_export_datadog_application_key"

  replication {
    automatic = true
  }

  depends_on = [
    google_project_service.secretmanager_api
  ]
}

resource "google_secret_manager_secret_version" "management_metrics_export_datadog_application_key" {
  secret = google_secret_manager_secret.management_metrics_export_datadog_application_key.id

  secret_data = var.datadog_application_key
}


resource "google_runtimeconfig_config" "app" {
  provider = google-beta

  name        = "${var.spring_application_name}_${var.spring_profile}"
  description = "Spring Boot configuration properties"

  depends_on = [
    google_project_service.runtimeconfig_api
  ]
}

resource "google_runtimeconfig_variable" "spring_cloud_gcp_spanner_enabled" {
  provider = google-beta

  parent = google_runtimeconfig_config.app.name
  name   = "spring.cloud.gcp.spanner.enabled"
  text   = "true"
}

resource "google_runtimeconfig_variable" "spring_cloud_gcp_spanner_instance_id" {
  provider = google-beta

  parent = google_runtimeconfig_config.app.name
  name   = "spring.cloud.gcp.spanner.instance-id"
  text   = google_spanner_instance.app.name
}

resource "google_runtimeconfig_variable" "spring_cloud_gcp_spanner_database" {
  provider = google-beta

  parent = google_runtimeconfig_config.app.name
  name   = "spring.cloud.gcp.spanner.database"
  text   = google_spanner_database.app.name
}

resource "google_runtimeconfig_variable" "management_metrics_export_datadog_enabled" {
  provider = google-beta

  parent = google_runtimeconfig_config.app.name
  name   = "management.metrics.export.datadog.enabled"
  text   = var.datadog_enabled
}

resource "google_runtimeconfig_variable" "management_metrics_export_datadog_uri" {
  provider = google-beta

  parent = google_runtimeconfig_config.app.name
  name   = "management.metrics.export.datadog.uri"
  text   = var.datadog_uri
}

resource "google_runtimeconfig_variable" "management_metrics_export_datadog_api_key" {
  provider = google-beta

  parent = google_runtimeconfig_config.app.name
  name   = "management.metrics.export.datadog.api-key"
  text   = "$${sm://${google_secret_manager_secret.management_metrics_export_datadog_api_key.id}}"
}

resource "google_runtimeconfig_variable" "management_metrics_export_datadog_application_key" {
  provider = google-beta

  parent = google_runtimeconfig_config.app.name
  name   = "management.metrics.export.datadog.application-key"
  text   = "$${sm://${google_secret_manager_secret.management_metrics_export_datadog_application_key.id}}"
}

resource "google_runtimeconfig_variable" "management_metrics_export_datadog_step" {
  provider = google-beta

  parent = google_runtimeconfig_config.app.name
  name   = "management.metrics.export.datadog.step"
  text   = var.datadog_step
}
