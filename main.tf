locals {
  java_heap_gb = max(1, var.instance_memory_gb - 2)
}

# ---------------------------------------------------------------
# Dados: Availability Domain e imagem Ubuntu 24.04 (Arm)
# ---------------------------------------------------------------

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}

data "oci_core_images" "ubuntu" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# ---------------------------------------------------------------
# Rede
# ---------------------------------------------------------------
resource "oci_core_vcn" "mc" {
  compartment_id = var.compartment_ocid
  display_name   = "minecraft-vcn"
  cidr_blocks    = ["10.0.0.0/16"]
  dns_label      = "minecraft"
}

resource "oci_core_internet_gateway" "mc" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.mc.id
  display_name   = "minecraft-igw"
  enabled        = true
}

resource "oci_core_route_table" "mc" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.mc.id
  display_name   = "minecraft-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.mc.id
  }
}

resource "oci_core_security_list" "mc" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.mc.id
  display_name   = "minecraft-sl"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # SSH
  ingress_security_rules {
    protocol = "6" # TCP
    source   = var.ssh_allowed_cidr

    tcp_options {
      min = 22
      max = 22
    }
  }

  # Minecraft
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"

    tcp_options {
      min = 25565
      max = 25565
    }
  }
}

resource "oci_core_subnet" "mc" {
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.mc.id
  display_name               = "minecraft-public-subnet"
  cidr_block                 = "10.0.1.0/24"
  dns_label                  = "mcpublic"
  route_table_id             = oci_core_route_table.mc.id
  security_list_ids          = [oci_core_security_list.mc.id]
  prohibit_public_ip_on_vnic = false
}

# ---------------------------------------------------------------
# Instância
# ---------------------------------------------------------------
resource "oci_core_instance" "mc" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain_index].name
  display_name        = "minecraft-server"
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory_gb
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu.images[0].id
    boot_volume_size_in_gbs = var.boot_volume_gb
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.mc.id
    assign_public_ip = true
    display_name     = "minecraft-vnic"
  }

  metadata = {
    ssh_authorized_keys = file(pathexpand(var.ssh_public_key_path))
    user_data = base64encode(templatefile("${path.module}/cloud-init.sh.tftpl", {
      mc_version    = var.minecraft_version
      heap_gb       = local.java_heap_gb
      motd          = var.server_motd
      max_players   = var.max_players
      difficulty    = var.difficulty
      view_distance = var.view_distance
      whitelist     = var.whitelist_enabled
    }))
  }

  lifecycle {
    ignore_changes = [source_details[0].source_id]
  }
}
