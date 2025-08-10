
gcloud auth list

export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

gcloud config set project "$DEVSHELL_PROJECT_ID"

gcloud config set compute/zone "$ZONE"

terraform

cat > instance.tf <<EOF_CP
resource "google_compute_instance" "terraform" {
  project      = "$DEVSHELL_PROJECT_ID"
  name         = "terraform"
  machine_type = "e2-medium"
  zone         = "$ZONE"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
EOF_CP

ls

terraform init

terraform plan

echo "yes" | terraform apply --auto-approve

