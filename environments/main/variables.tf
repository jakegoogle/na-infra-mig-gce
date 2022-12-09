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


variable "project" {
  type = string
  description = "The project ID to deploy to"
}

variable "region" {
  type = string

  description = "The region to use"
  default     = "eu-west2"
}

variable "google_compute_machine_image" {
  type = string

  description = "The image to use to create the jumpbox"
  default     = "gcvejumpboximage"
}

variable "internal-vpc-vars" {
  type        = map(string)
  description = "vars for the internal VPC resources"
}

variable "mgmt-vpc-vars" {
  type        = map(string)
  description = "vars for the mgmt VPC resources"
}
variable "internal-vpc-name" {
  type = string
  description = "The internal VPC name for Data Lookup"
}
variable "internal-subnetwork-name" {
  type = string
  description = "The internal subnetwork name for Data Lookup"
}

variable "mgmt-vpc-name" {
  type = string
  description = "The internal VPC name for Data Lookup"
}
variable "mgmt-subnetwork-name" {
  type = string
  description = "The internal subnetwork name for Data Lookup"
}