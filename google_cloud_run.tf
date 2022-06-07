resource "google_project_service" "run_api" {
  service = "run.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_cloud_run_service" "app" {
  name     = var.spring_application_name
  location = data.google_client_config.current.region

  template {
    spec {
      containers {
        image = "${data.tfe_outputs.current.values.google_artifact_registry_docker_repo}/${var.spring_application_name}:${var.spring_application_image_tag}"
        env {
          name  = "SPRING_PROFILES_ACTIVE"
          value = var.spring_profile
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true

  depends_on = [
    google_project_service.run_api
  ]
}


data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers"
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.app.location
  project  = google_cloud_run_service.app.project
  service  = google_cloud_run_service.app.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
