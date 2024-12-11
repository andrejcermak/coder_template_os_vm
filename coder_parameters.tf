data "coder_parameter" "project_id" {
  name        = "project_id"
  description = "Project id"
  type        = "string"
  mutable     = false
  default     = "e495700ad00349bab1d6c75fa13d0ad1"
}
data "coder_parameter" "application_credential_name" {
  name        = "application_credential_name"
  description = "application_credential_name"
  type        = "string"
  mutable     = false
  default = "just_reader"
}
data "coder_parameter" "application_credential_id" {
  name        = "application_credential_id"
  description = "application_credential_id"
  type        = "string"
  mutable     = false
  default     = "34e9dd18dfcc4208bb8baed1d1cc9533" 
}
data "coder_parameter" "application_credential_secret" {
  name        = "application_credential_secret"
  description = "application_credential_secret"
  type        = "string"
  mutable     = false
  default     = "ScPOaem7j-aKQUPF2UEdpQj8dKu4GuhfjfkIC6KRyh5G5DpR-yYMlS1-dsfCkXPIWVPBOdhLiyAjAY3PjAHwhA"
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