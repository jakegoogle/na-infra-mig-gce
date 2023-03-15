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

#SQL Server
name            = "sql-instance"
region_euw6     = "europe-west6"
zone            = "europe-west6-a"
network_interfaces = [
  {
    nat        = false
    network    = "projects/rcb-gcve/global/networks/gve-lab-vpc-internal"
    subnetwork = "projects/rcb-gcve2/regions/eu-west6/subnetworks/internal-euw6-subnet"
    addresses  = null
  }
]
attached_disks = [

  {
    name  = "g-sql-data"
    image = null
    size  = 150
    options = {
      auto_delete = false
      mode        = "READ_WRITE"
      source      = null
      type        = "pd-balanced"
    }
  },
  {
    name  = "l-sql-tlog"
    image = null
    size  = 50
    options = {
      auto_delete = false
      mode        = "READ_WRITE"
      source      = null
      type        = "pd-balanced"
    }
  },
  {
    name  = "r-backup"
    image = null
    size  = 100
    options = {
      auto_delete = false
      mode        = "READ_WRITE"
      source      = null
      type        = "pd-balanced"
    }
  },
  {
    name  = "t-tempdb"
    image = null
    size  = 10
    options = {
      auto_delete = false
      mode        = "READ_WRITE"
      source      = null
      type        = "pd-balanced"
    }
  }
]