variable "region" {
  default = "eu-cental-1"
}

variable "worker_instance_type" {
  default = "t2.small"
}

variable "server_instance_type" {
  default = "t2.small"
}

variable "executor_type" {
  default = "CeleryExecutor"
}

variable "server_ami" {
  default = ""
}

variable "worker_ami" {
  default = ""
}

variable "aws_key_path" {
  default = ""
}

