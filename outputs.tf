output "public_ip" {
  description = "IP público da VM"
  value       = oci_core_instance.mc.public_ip
}

output "minecraft_address" {
  description = "Endereço para colocar no multiplayer do Minecraft"
  value       = "${oci_core_instance.mc.public_ip}:25565"
}

output "ssh_command" {
  description = "Comando para acessar a VM"
  value       = "ssh ubuntu@${oci_core_instance.mc.public_ip}"
}
