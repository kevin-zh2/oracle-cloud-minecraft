variable "oci_profile" {
  description = "Perfil do arquivo ~/.oci/config"
  type        = string
  default     = "DEFAULT"
}

variable "region" {
  description = "Região home da sua conta (ex: sa-saopaulo-1, us-ashburn-1). Always Free só vale na região home."
  type        = string
}

variable "compartment_ocid" {
  description = "OCID do compartimento. Para usar o root, informe o OCID do tenancy."
  type        = string
}

variable "availability_domain_index" {
  description = "Índice do Availability Domain (0, 1, 2). Troque se der 'Out of host capacity'."
  type        = number
  default     = 0
}

variable "ssh_public_key_path" {
  description = "Caminho da sua chave pública SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_allowed_cidr" {
  description = "CIDR com permissão de SSH. Ideal: seu IP, ex: 200.100.50.25/32"
  type        = string
  default     = "0.0.0.0/0"
}

variable "accept_eula" {
  description = "Você precisa aceitar o EULA da Mojang: https://aka.ms/MinecraftEULA"
  type        = bool

  validation {
    condition     = var.accept_eula == true
    error_message = "Defina accept_eula = true para aceitar o EULA do Minecraft."
  }
}

# ---------- VM ----------
variable "instance_ocpus" {
  description = "OCPUs da VM Arm (Always Free: até 4 no total, confira o limite atual da Oracle)"
  type        = number
  default     = 2
}

variable "instance_memory_gb" {
  description = "RAM da VM em GB (Always Free: até 24 no total, confira o limite atual da Oracle)"
  type        = number
  default     = 12
}

variable "boot_volume_gb" {
  description = "Tamanho do disco de boot em GB (Always Free: 200 GB no total)"
  type        = number
  default     = 50
}

# ---------- Minecraft ----------
variable "minecraft_version" {
  description = "Versão vanilla (ex: 1.21.4) ou 'latest' para a última release"
  type        = string
  default     = "latest"
}

variable "server_motd" {
  type    = string
  default = "Servidor Minecraft Vanilla"
}

variable "max_players" {
  type    = number
  default = 10
}

variable "difficulty" {
  description = "peaceful | easy | normal | hard"
  type        = string
  default     = "normal"
}

variable "view_distance" {
  type    = number
  default = 10
}

variable "whitelist_enabled" {
  description = "Se true, só jogadores na whitelist entram (gerencie com /whitelist add)"
  type        = bool
  default     = false
}
