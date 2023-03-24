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

data "google_compute_image" "my_image" {
  name  = "gcvejumpserverimage"
}
data "google_compute_network" "internal-vpc" {
  name = var.internal-vpc-vars["vpc-name"]
}
data "google_compute_subnetwork" "internal-subnetwork" {
  name   = var.internal-vpc-vars["euw2-subnetwork-name"]
  region = "europe-west2"
}
data "google_compute_network" "mgmt-vpc" {
  name = var.mgmt-vpc-vars["vpc-name"]
}
data "google_compute_subnetwork" "mgmt-subnetwork" {
  name   = var.mgmt-vpc-vars["euw2-subnetwork-name"]
  region = "europe-west2"
}

### Eu-west6
data "google_compute_network" "internal_vpc_name" {
  name = var.internal-vpc-vars["vpc-name"]
}
data "google_compute_subnetwork" "internal_subnetwork_euw6" {
  name   = var.internal-vpc-vars["euw6-subnetwork-name"]
  region = "europe-west6"
}
data "google_compute_network" "mgmt_vpc_name" {
  name = var.mgmt-vpc-vars["vpc-name"]
}
data "google_compute_subnetwork" "mgmt_subnetwork_euw6" {
  name   = var.mgmt-vpc-vars["euw6-subnetwork-name"]
  region = "europe-west6"
}
data "google_compute_network" "external_vpc_name" {
  name = var.external-vpc-vars["vpc-name"]
}
data "google_compute_subnetwork" "external_subnetwork_euw6" {
  name   = var.external-vpc-vars["euw6-subnetwork-name"]
  region = "europe-west6"
}