output "tamr-config" {
  value     = module.examples_minimal.tamr-config # .rendered
  sensitive = true
}
