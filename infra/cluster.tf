# --- Minikube Cluster ---
resource "minikube_cluster" "docker" {
  driver       = "docker"
  cluster_name = "terraform-cstrader"
  cni = "bridge"
  addons = [
    "default-storageclass",
    "storage-provisioner",
    "ingress",
    "ingress-dns",
    "metrics-server"
  ]
}