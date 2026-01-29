# fluentbit-terraform-helm
Setting up fluentbit for eks cluster logging using terraform + helm 

pre-requisites:
- eks cluster is already existing as i have referred the oidc provider, eks cluster, and some outputa from this eks module
- terraform role creating infra has permissions to create service account, namespace in eks cluster.
