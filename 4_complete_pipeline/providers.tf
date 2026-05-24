terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30.0"
    }
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.4.0" 
    }
  }
}

provider "kind" {}

provider "kubernetes" {
  host                   = kind_cluster.local_cluster.endpoint
  client_certificate     = kind_cluster.local_cluster.client_certificate
  client_key             = kind_cluster.local_cluster.client_key
  cluster_ca_certificate = kind_cluster.local_cluster.cluster_ca_certificate
}
