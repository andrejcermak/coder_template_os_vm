data "coder_parameter" "project_id" {
  name        = "project_id"
  description = "Project id"
  type        = "string"
  mutable     = false
  default     = "e495700ad00349bab1d6c75fa13d0ad1"
}

data "coder_parameter" "pubkey"{
  name        = "pubkey"
  description = "pubkey"
  type        = "string"
  mutable     = false
}

data "coder_parameter" "openstack_region"{
  name        = "openstack_region"
  description = "openstack_region"
  type        = "string"
  mutable     = false
  default     = "Brno1"
}
data "coder_parameter" "openstack_identity_provider"{
  name        = "openstack_identity_provider"
  description = "openstack_identity_provider"
  type        = "string"
  mutable     = false
  default     = "https://identity.brno.openstack.cloud.e-infra.cz/v3"
}