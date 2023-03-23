# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

/********************************************
Enable OS Config from VM Manager project
*******************************************
locals {
  os-manager-metadata = {
    "enable-osconfig" = "TRUE",
    "enable-guest-attributes" = "TRUE"
  }
}
resource "google_compute_project_metadata_item" "os_manager_metadata" {
  for_each = local.os-manager-metadata 
  project = var.project
  key     = each.key
  value   = each.value
}
*/

/********************************************
Cloud NAT
********************************************/
resource "google_compute_router" "mgmt-euw6_nat_router" {
  name    = "mgmt-euw6-nat-router"
  region  = "europe-west6"
  network = data.google_compute_network.mgmt_vpc_name.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "mgmt-euw6_nat_gateway" {
  name                               = "mgmt-euw6-nat-gateway"
  router                             = google_compute_router.mgmt-euw6_nat_router.name
  region                             = google_compute_router.mgmt-euw6_nat_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

/********************************************
CIS RHEL Image
********************************************/
resource "google_compute_instance" "rhel_9" {
  name         = "rhel-9"
  machine_type = "e2-medium"
  zone         = "europe-west6-a"

  tags = ["iap-jumpserver","allow-internal","mgmt-iap-jumpserver"]

  boot_disk {
    initialize_params {
      image = "rhel-cloud/rhel-9"
    }
  }

  network_interface {
    network    = data.google_compute_network.mgmt_vpc_name.id
    subnetwork = data.google_compute_subnetwork.mgmt_subnetwork_euw6.id
  } 

  metadata = {
    enable-osconfig         = "TRUE"
    enable-guest-attributes = "TRUE"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "jumpbox@rcb-gcve.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "cis_rhel_9" {
  name         = "cis-rhel-9"
  machine_type = "e2-medium"
  zone         = "europe-west6-a"

  tags = ["iap-jumpserver","allow-internal","mgmt-iap-jumpserver"]

  boot_disk {
    initialize_params {
      image = "projects/cis-public/global/images/cis-red-hat-enterprise-linux-9-level-1-v1-0-0-1"
    }
  }

  network_interface {
    network    = data.google_compute_network.mgmt_vpc_name.id
    subnetwork = data.google_compute_subnetwork.mgmt_subnetwork_euw6.id
  } 

  metadata = {
    enable-osconfig         = "TRUE"
    enable-guest-attributes = "TRUE"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "jumpbox@rcb-gcve.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

/********************************************
Jumpboxs
********************************************/
resource "google_compute_instance" "jumpbox-ba" {
  name         = "jumpbox-ba"
  machine_type = "e2-medium"
  zone         = "europe-west6-a"

  tags = ["iap-jumpserver","allow-internal","mgmt-iap-jumpserver"]

  boot_disk {
    initialize_params {
      image = "gcvejumpserverimage"
    }
  }

  network_interface {
    network    = data.google_compute_network.mgmt_vpc_name.id
    subnetwork = data.google_compute_subnetwork.mgmt_subnetwork_euw6.id
  }
    network_interface {
    network    = data.google_compute_network.internal_vpc_name.id
    subnetwork = data.google_compute_subnetwork.internal_subnetwork_euw6.id
  }  

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "jumpbox@rcb-gcve.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "jumpbox-jw" {
  name         = "jumpbox-jw"
  machine_type = "e2-medium"
  zone         = "europe-west6-a"

  tags = ["iap-jumpserver","allow-internal","mgmt-iap-jumpserver"]

  boot_disk {
    initialize_params {
      image = "gcvejumpserverimage"
    }
  }

  network_interface {
    network    = data.google_compute_network.mgmt_vpc_name.id
    subnetwork = data.google_compute_subnetwork.mgmt_subnetwork_euw6.id
  }  

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "jumpbox@rcb-gcve.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "jumpbox-ed" {
  name         = "jumpbox-ed"
  machine_type = "e2-medium"
  zone         = "europe-west6-a"

  tags = ["iap-jumpserver","allow-internal","mgmt-iap-jumpserver"]

  boot_disk {
    initialize_params {
      image = "gcvejumpserverimage"
    }
  }

  network_interface {
    network    = data.google_compute_network.mgmt_vpc_name.id
    subnetwork = data.google_compute_subnetwork.mgmt_subnetwork_euw6.id
  }  
}

/********************************************
SQL Cluster VM
*******************************************
resource "google_service_account" "compute_sql_sa" {
  project      = var.project
  account_id   = "${var.project}-sql"
  display_name = "Project compute service account"
}

locals {
  instance_names = ["ltydevkeysql01", "ltydevkeysql02", "ltydevapxsql01"]
  ip_address     = ["10.1.1.20", "10.1.1.21", "10.1.1.22"]
  sites          = ["europe-west6-a", "europe-west6-a", "europe-west6-a"]
  add_disk       = [true, true, true]
  add_disk_space = ["100", "100", "100"]
}

## Addiitonal disks for sql cluster###
locals {
  attached_disks = {
    for disk in var.attached_disks :
    disk.name => disk
  }
  attached_disks_pairs = {
    for pair in setproduct(keys(local.names), keys(local.attached_disks)) :
    "${pair[0]}-${pair[1]}" => { name = pair[0], disk_name = pair[1] }
  }
  names = (
    { for i in range(0, length(local.instance_names)) : local.instance_names[i] => i }
  )
}

resource "google_compute_instance" "sql" {
  for_each     = var.use_instance_template ? {} : local.names
  project      = var.project
  machine_type = "e2-standard-2"
  zone = local.sites[each.value]
  name = each.key
  network_interface {
    network    = data.google_compute_network.internal_vpc_name.id
    subnetwork = data.google_compute_subnetwork.internal_subnetwork_euw6.self_link
  }

  boot_disk {
    initialize_params {
      type  = "pd-ssd"
      image = "windows-cloud/windows-server-2019-dc-v20221109"
      size  = 50
    }

  }

  dynamic "attached_disk" {
    for_each = {
      for resource_name, pair in local.attached_disks_pairs :
      resource_name => local.attached_disks[pair.disk_name] if pair.name == each.key
    }
    iterator = config
    content {
      device_name = config.value.name
      mode        = config.value.options.mode
      source      = google_compute_disk.ltydevkeysql01-disk[config.key].name
    }
  }
}

resource "google_compute_disk" "ltydevkeysql01-disk" {
  for_each = local.attached_disks_pairs
  project  = var.project
  name     = each.key #"sql-cluster-vm01-${local.disk_names[count.index]}"
  type     = local.attached_disks[each.value.disk_name].options.type
  zone     = var.zone
  size     = local.attached_disks[each.value.disk_name].size
}
*/