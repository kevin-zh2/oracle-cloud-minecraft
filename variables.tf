variable "oci_profile" {
  description = "Perfil do arquivo ~/.oci/config"
  type        = string
  default     = "DEFAULT"
}

variable "region" {
  description = "Região ."
  type        = string
}

variable "compartment_ocid" {
  description = "OCID do compartimento."
  type        = string
}

variable "availability_domain_index" {
  description = "Índice do Availability Domain."
  type        = number
  default     = 0
}

variable "ssh_public_key_path" {
  description = "Caminho da chave pública SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_allowed_cidr" {
  description = "CIDR com permissão de SSH."
  type        = string
  default     = "0.0.0.0/0"
}

variable "accept_eula" {
  description = "Aceitar o EULA da Mojang."
  type        = bool

  validation {
    condition     = var.accept_eula == true
    error_message = "Defina accept_eula = true para aceitar o EULA do Minecraft."
  }
}

# ---------- VM ----------
variable "instance_ocpus" {
  description = "OCPUs da VM Arm."
  type        = number
  default     = 2
}

variable "instance_memory_gb" {
  description = "RAM da VM em GB."
  type        = number
  default     = 12
}

variable "boot_volume_gb" {
  description = "Tamanho do disco de boot em GB."
  type        = number
  default     = 50
}

# ---------- Minecraft ----------
variable "minecraft_version" {
  description = "Versão do Minecraft."
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
  description = "Se ativado, só jogadores na whitelist entram no servidor."
  type        = bool
  default     = false
}
