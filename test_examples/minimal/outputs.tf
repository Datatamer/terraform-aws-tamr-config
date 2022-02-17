output "tamr-config" {
  value     = module.examples_minimal.tamr-config
  sensitive = true
}

output "go-region" {
  value = data.aws_region.current.name
}
