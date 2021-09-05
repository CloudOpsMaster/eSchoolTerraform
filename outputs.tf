output "loadbalanser_public_ip" {
  value = google_compute_instance.loadbalanser.network_interface.0.access_config.0.nat_ip
}
 output "app1_public_ip" {
   value = google_compute_instance.app1.network_interface.0.access_config.0.nat_ip
 }
 
output "app2_public_ip" {
  value = google_compute_instance.app2.network_interface.0.access_config.0.nat_ip
}

output "mysql__public_ip" {
  value = google_compute_instance.mysql.network_interface.0.access_config.0.nat_ip
}