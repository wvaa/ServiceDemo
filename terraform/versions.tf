# terraform/versions.tf

terraform {
  required_providers {
    # El proveedor de Kubernetes para que Helm pueda interactuar con el clúster
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    # El proveedor de Helm para instalar y gestionar el Chart
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
  }
}