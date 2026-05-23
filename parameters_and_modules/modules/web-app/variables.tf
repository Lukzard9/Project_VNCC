variable "namespace" {
  description = "Il namespace Kubernetes di destinazione"
  type        = string
}

variable "app_name" {
  description = "Nome dell'applicazione"
  type        = string
  default     = "nginx"
}

variable "replicas" {
  description = "Numero di pod"
  type        = number
  default     = 2
}

variable "environment" {
  description = "Etichetta dell'ambiente"
  type        = string
}