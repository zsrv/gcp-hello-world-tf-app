variable "tfe_organization" {
  type        = string
  description = "The Terraform Enterprise/Cloud organization to retrieve output values from"
}

variable "tfe_workspace" {
  type        = string
  description = "The Terraform Enterprise/Cloud organization to retrieve output values from (from the app initialization Terraform configuration)"
}

variable "google_project_id" {
  type        = string
  description = "The Google Project ID to deploy to"
}

variable "google_region" {
  type        = string
  description = "The Google Cloud region to deploy to"
  default     = "us-central1"
}

variable "google_zone" {
  type        = string
  description = "The Google Cloud zone to deploy to (for zonal resources)"
  default     = "us-central1-c"
}

variable "spring_application_name" {
  type        = string
  description = "Spring Boot application name. This should match the value of the spring.application.name property in the Spring Boot project's bootstrap.properties file"
  default     = "gcp-hello-world"
}

variable "spring_application_image_tag" {
  type        = string
  description = "The container image tag to deploy"
}

variable "spring_profile" {
  type        = string
  description = "Spring Boot configuration profile to activate"
  default     = "default"
}

variable "google_cloud_spanner_instance_config" {
  type        = string
  description = "Google Cloud Spanner instance configuration (location)"
  default     = "regional-us-central1"
}

variable "google_cloud_spanner_instance_processing_units" {
  type        = number
  description = "Number of processing units to assign to the Google Cloud Spanner instance"
  default     = 1000
}

variable "datadog_enabled" {
  type        = bool
  description = "Whether to enable publishing to Datadog"
  default     = false
}

variable "datadog_uri" {
  type        = string
  description = "Datadog URI"
  default     = "https://api.datadoghq.eu"
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API key. Required if datadog_enabled = true"
  sensitive   = true
  default     = ""
}

variable "datadog_application_key" {
  type        = string
  description = "Datadog application key"
  sensitive   = true
  default     = ""
}

variable "datadog_step" {
  type        = string
  description = "The interval at which metrics are sent to Datadog"
  default     = "30s"
}
