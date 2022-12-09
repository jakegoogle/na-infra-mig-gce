# Environment Variables
project                         = "rcb-gcve"
region                          = "eu-west2"
google_compute_machine_image    = "gcvejumpboximage"
internal-vpc-name               = "gve-lab-vpc-internal"
internal-subnetwork-name        = "internal-euw2-subnet"
mgmt-vpc-name                   = "gve-lab-vpc-mgmt"
mgmt-subnetwork-name            = "mgmt-euw2-subnet"
internal-vpc-vars = {
  vpc-name = "gve-lab-vpc-internal"
  euw6-subnetwork-name = "internal-euw6-subnet"
  euw2-subnetwork-name = "internal-euw2-subnet"
}
mgmt-vpc-vars = {
  vpc-name = "gve-lab-vpc-mgmt"
  euw6-subnetwork-name = "mgmt-euw6-subnet"
  euw2-subnetwork-name = "mgmt-euw2-subnet"
}