variable "cluster_name" {
  description = "name of eks cluster"
  type = string
}

variable "env" {
  description = "env in which infra is setup"
  type = string
}

variable "namespace" {
  description = "namespace for fluentbit pod"
  type = string
}

variable "region" {
  description = "aws region where resources ar created"
  type = string
}

variable "oidc_provider_arn" {
  description = "arn of oidc provider"
  type = string
}

variable "oidc_provider_url" {
  description = "url of oidc provider"
  type = string
}

variable "cluster_ready" {
  description = "confirm the eks cluster and iam access have been completed"
}
