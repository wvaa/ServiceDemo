# terraform/main.tf

# -----------------------------------------------------------------------------
# 1. Configuración de Providers
# -----------------------------------------------------------------------------

# El proveedor de Kubernetes se conecta automáticamente usando el kubeconfig.
# Si estás usando un clúster específico (como EKS/GKE), la configuración
# del host y certificado iría aquí, a menudo usando 'data' sources.
provider "kubernetes" {
  # Asume que 'kubectl' está configurado y funcionando
}

# El proveedor de Helm usa el mismo contexto de Kubernetes
provider "helm" {
  kubernetes {
    # Referencia al proveedor de Kubernetes configurado
    # Esto asegura que Helm utiliza la misma conexión al clúster
    config_path = "~/.kube/config"
  }
}

# -----------------------------------------------------------------------------
# 2. Despliegue del Chart de Helm (helm_release)
# -----------------------------------------------------------------------------

resource "helm_release" "servicedemo_app" {
  # Nombre único de la release de Helm
  name       = var.release_name
  namespace  = var.namespace

  # Ruta local a tu Chart de Helm (ajusta si la ruta es diferente)
  chart = "../ServiceDemo-chart"
  #chart      = "servicedemo-chart" # Nombre del chart en Chart.yaml



  # Valores dinámicos que sobrescriben los valores en values.yaml del Chart
  # Estos valores vienen de variables de Terraform (variables.tf)
  set {
    name  = "replicaCount"
    value = var.replica_count
  }

  set {
    name  = "image.tag"
    value = var.image_tag # Ejemplo: "2.0"
  }

  # Si quieres cambiar el tipo de servicio a LoadBalancer:
  # set {
  #   name  = "service.type"
  #   value = "LoadBalancer"
  # }
}