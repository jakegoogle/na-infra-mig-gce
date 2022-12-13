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

### Cloud NAT Creation
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
  router                             = google_compute_router.euw6_nat_router.name
  region                             = google_compute_router.euw6_nat_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}


### Jumpboxs
resource "google_compute_instance" "jumpbox-ba" {
  name         = "jumpbox-ba"
  machine_type = "e2-medium"
  zone         = "europe-west6-c"

  tags = ["iap-jumpserver","allow-internal"]

  boot_disk {
    initialize_params {
      image = "gcvejumpserverimage"
    }
  }

  network_interface {
    network    = data.google_compute_network.internal_vpc_name.id
    subnetwork = data.google_compute_subnetwork.internal_subnetwork_euw6.id
    #access_config { when commented out, will not be assigned external IP
      # add external ip to fetch packages
    #}
  }
    network_interface {
    network    = data.google_compute_network.mgmt_vpc_name.id
    subnetwork = data.google_compute_subnetwork.mgmt_subnetwork_euw6.id
  }  
}

resource "google_compute_instance" "jumpbox-rcb" {
  name         = "jumpbox-rcb"
  machine_type = "e2-small"
  zone         = "europe-west2-c"

  tags = ["iap-jumpserver","allow-internal"]

  boot_disk {
    initialize_params {
      image = "gcvejumpserverimage"
    }
  }
  network_interface {
    network    = data.google_compute_network.internal-vpc.id
    subnetwork = data.google_compute_subnetwork.internal-subnetwork.id
    #access_config { when commented out, will not be assigned external IP
      # add external ip to fetch packages
    #}
  }
    network_interface {
    network    = data.google_compute_network.mgmt-vpc.id
    subnetwork = data.google_compute_subnetwork.mgmt-subnetwork.id
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
    #access_config { when commented out, will not be assigned external IP
      # add external ip to fetch packages
    #}
  }
    network_interface {
    network    = data.google_compute_network.internal_vpc_name.id
    subnetwork = data.google_compute_subnetwork.internal_subnetwork_euw6.id
  }  
}
