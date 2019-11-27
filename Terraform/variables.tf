variable "region" {
  default = "eu-central-1"
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

variable "mysql_exposure" {
  type = map
  default = {
    "LocalExecutor" = "localhost"
    "CeleryExecutor" = "0.0.0.0"
  }
}

