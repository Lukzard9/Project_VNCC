variable "environments" {
  type        = set(string)
  default     = ["dev", "test", "qa"]
}