output "vpc_id" {
  value = module.vpc.vpc_id
}

output "svc_name" {
  value = random_pet.service_name.id
}