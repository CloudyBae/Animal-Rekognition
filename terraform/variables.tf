variable "region" {
    default = "us-east-1"
}

variable "profile" {
    default = "vscode"
}

variable "shared_config_files" {
    default = "~/.aws/config"
}

variable "shared_credentials_files" {
    default = "~/.aws/credentials"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
    type  = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
    type = list(string)
  default = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "ami_id" {
  default = "ami-0532899d46335ff25"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "password"
}

variable "ecs_task_cpu" {
  default = 256
}

variable "ecs_task_memory" {
  default = 512
}

variable "ecs_task_container_port" {
  default = 5000
}

variable "ecs_service_desired_count" {
  default = 2
}