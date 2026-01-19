# --- Minikube Cluster ---
resource "minikube_cluster" "docker" {
  driver       = "docker"
  cluster_name = "terraform-cstrader"
  addons = [
    "default-storageclass",
    "storage-provisioner",
    "ingress",
    "ingress-dns",
    "metrics-server"
  ]
}