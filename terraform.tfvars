# Copie para terraform.tfvars e preencha
region           = "sa-saopaulo-1"
compartment_ocid = "ocid1.tenancy.oc1..abcdefg"

accept_eula         = true
ssh_public_key_path = "~/.ssh/id_rsa.pub"
ssh_allowed_cidr    = "0.0.0.0/0"

minecraft_version  = "latest"
instance_ocpus     = 2
instance_memory_gb = 12
server_motd        = "Servidor dos amigos"
max_players        = 8
