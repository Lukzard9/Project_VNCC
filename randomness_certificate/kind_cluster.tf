resource "kind_cluster" "local_cluster" {
  name           = "tf-kind-cluster"
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      extra_port_mappings {
        container_port = 30080
        host_port      = 30080
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30443
        host_port      = 30443
        protocol       = "TCP"
      }
    }
  }
}