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


/*resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "eu-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "gcve-jumpbpox-image"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  
*/
resource "google_compute_instance" "default" {
  name         = "gcve-jumpbox-ba"
  machine_type = "e2-medium"
  zone         = "europe-west2-c"

  tags = ["iap-jumpserver"]

  boot_disk {
    initialize_params {
      image = "gcvejumpserverimage"
    }
  }

  // Local SSD disk
 // scratch_disk {
  //  interface = "SCSI"
  //}

  network_interface {
    network    = data.google_compute_network.internal-vpc.id
    subnetwork = data.google_compute_subnetwork.internal-subnetwork.id
    #access_config {
      # add external ip to fetch packages
    #}
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  /*service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
  */
}

### Image creation for VyOS rolling latest
resource "google_compute_image" "vyos_image" {
  name = "vyos-rolling-202209020217"

  raw_disk {
    source = "https://storage.cloud.google.com/gcve-lab-iso-images-eu/vyos-rolling-202209020217.iso.tar.gz"
  }

  guest_os_features {
    type = "GVNIC"
  }

  guest_os_features {
    type = "MULTI_IP_SUBNET"
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

  #metadata = {
  #  foo = "bar"
  #}

  #metadata_startup_script = "echo hi > /test.txt"

  /*service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
  */
}

resource "google_compute_instance" "jumpbox-om" {
  name         = "jumpbox-om"
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
  }
  network_interface {
    network    = data.google_compute_network.mgmt-vpc.id
    subnetwork = data.google_compute_subnetwork.mgmt-subnetwork.id
  }    
}
