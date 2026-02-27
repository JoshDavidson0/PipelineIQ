# variable.tf defines all input variables.

variable "aws_region" {
    default = "us-east-1"
}

variable "project_name" {
    default = "pipelineiq"
}

variable "db_username" {
    description = "Postgres master username"
    type = string
    sensitive = true
}

variable "db_password" {
    description = "Postgres master password"
    type = string
    sensitive = true
}

variable "key_pair_name" {
    description = "Name of EC2 key pair for SSH"
    type = string
}
