# Copie para terraform.tfvars e preencha
region           = "sa-saopaulo-1"
compartment_ocid = "ocid1.tenancy.oc1..xxxxxxxx"

accept_eula         = true
ssh_public_key_path = "~/.ssh/id_rsa.pub"
ssh_allowed_cidr    = "0.0.0.0/0" # troque pelo seu IP/32

minecraft_version  = "latest"
instance_ocpus     = 2
instance_memory_gb = 12
