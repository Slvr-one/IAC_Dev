resource "google_gke_hub_membership" "anthos_registration" {
  provider      = google-beta
  project = var.project_id
  membership_id = "${var.cluster_name}-fleet"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${google_container_cluster.primary.id}"
    }
  }
}