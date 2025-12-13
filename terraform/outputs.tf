# terraform/outputs.tf

output "servicedemo_url" {
  description = "URL para acceder al servicio ServiceDemo (asumiendo NodePort o LoadBalancer)."
  value = "Revisa el servicio 'servicedemo-service' en el namespace '${var.namespace}' para obtener la IP/NodePort."
}