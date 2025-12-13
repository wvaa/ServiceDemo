# terraform/variables.tf

variable "namespace" {
  description = "El namespace de Kubernetes donde se desplegará la aplicación."
  type        = string
  default     = "default"
}

variable "release_name" {
  description = "El nombre de la release de Helm."
  type        = string
  default     = "servicedemo-release"
}

variable "image_tag" {
  description = "El tag de la imagen de Docker a desplegar (ej. '2.0')."
  type        = string
}

variable "replica_count" {
  description = "El número de réplicas de la aplicación."
  type        = number
  default     = 1
}