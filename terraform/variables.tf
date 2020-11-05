variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS Region"
}

variable "vpc_id" {
  type        = string
  description = "VPC to run inside"
}

variable "svc_name" {
  type        = string
  default     = "dummy"
  description = "Name of the service"
}

variable "svc_container" {
  type        = string
  description = "Container to run"
}

variable "svc_port" {
  type        = number
  description = "Service port (on instance) to connect to"
  default     = 80
}

variable "svc_internal_port" {
  type        = number
  description = "Port exposed inside the container.  If 0 is specified, then this will default to the same value of `service_port`"
  default     = 0
}
