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
Ops_Agent
*********************************************/
module "agent_policy_detailed" {
  source      = "../../modules/agent-policy"
  project_id  = var.project_id
  policy_id   = "ops-agents-install-policy"
  description = "Policy for deploying Cloud Monitroing Ops Agent"
  agent_rules = [
    {
      type               = "logging"
      version            = "current-major"
      package_state      = "installed"
      enable_autoupgrade = true
    },
    {
      type               = "metrics"
      version            = "current-major"
      package_state      = "installed"
      enable_autoupgrade = true
    },
  ]
  os_types = [
    {
      short_name = "debian"
    },
    {
      short_name = "rhel"
    }
  ]
  zones = [
    "europe-west6-a",
    "europe-west6-b",
    "europe-west6-c",
  ]
}
/*
module "rhel_agent_policy" {
  source     = "terraform-google-modules/cloud-operations/google//modules/agent-policy"
  version    = "0.2.4"

  project_id = var.project
  policy_id  = "rhel-ops-agents-policy"
  agent_rules = [
    {
      type               = "ops-agent"
      version            = "latest"
      package_state      = "installed"
      enable_autoupgrade = true
    },
  ]
  group_labels = [
    {
      ops-agent  = "true"
    }
  ]
    os_types = [
    {
      short_name = "rhel"
      version    = "8"
    }
  ]
}

module "debian_agent_policy" {
  source     = "terraform-google-modules/cloud-operations/google//modules/agent-policy"
  version    = "0.2.4"

  project_id = var.project
  policy_id  = "debian-ops-agents-policy"
  agent_rules = [
    {
      type               = "latest"
      version            = "current-major"
      package_state      = "installed"
      enable_autoupgrade = true
    },
  ]
  group_labels = [
    {
      ops-agent   = "true"
    }
  ]
  os_types = [
    {
      short_name  = "debian"
      version     = "11"
    }
  ]
}
*/
