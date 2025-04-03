terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
    coder = {
      source = "coder/coder"
      version = "1.0.4"
    }
  }
}

data "coder_workspace" "me" {}

provider "openstack" {
  application_credential_id = data.coder_parameter.application_credential_id.value
  application_credential_name = data.coder_parameter.application_credential_name.value
  application_credential_secret = data.coder_parameter.application_credential_secret.value
  tenant_id = data.coder_parameter.project_id.value
  auth_url    = data.coder_parameter.openstack_identity_provider.value
  region      = data.coder_parameter.openstack_region.value
  allow_reauth = true
}

data "openstack_networking_network_v2" "network_default" {
  name = "internal-ipv4-general-private"
}

resource "openstack_compute_keypair_v2" "pubkey" {
  name       = "${data.coder_workspace.me.name}-keypair"
  public_key = data.coder_parameter.pubkey.value
}

resource "openstack_networking_secgroup_v2" "ood_security_group" {
  name        = "${data.coder_workspace.me.name}_secgroup"
  description = "My ood machine security group"
}

resource "openstack_networking_secgroup_rule_v2" "shh_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ood_security_group.id
}

data "openstack_networking_network_v2" "external_network" {
  name = "external-ipv4-general-public"
}

resource "openstack_networking_port_v2" "port" {
  network_id = data.openstack_networking_network_v2.network_default.id
  security_group_ids = [openstack_networking_secgroup_v2.ood_security_group.id]
}

resource "openstack_networking_floatingip_v2" "vip_fip" {
  pool  = "external-ipv4-general-public"
}



resource "openstack_compute_instance_v2" "ubuntu_from_ondemand" {
	name = "${data.coder_workspace.me.name}"
	image_name = "ubuntu-focal-x86_64"
	flavor_name = "e1.medium"
	key_pair = openstack_compute_keypair_v2.pubkey.name

  network {
    uuid = data.openstack_networking_network_v2.network_default.id
    port = openstack_networking_port_v2.port.id
  } 
  security_groups = [openstack_networking_secgroup_v2.ood_security_group.id]
}


resource "openstack_networking_floatingip_associate_v2" "res_vip_fip_associate" {
  floating_ip = openstack_networking_floatingip_v2.vip_fip.address
  port_id     = openstack_networking_port_v2.port.id
}

resource "null_resource" "coder_output" {
  depends_on = [
    openstack_compute_instance_v2.ubuntu_from_ondemand
    ]
}
resource "coder_metadata" "floating_ip" {
  resource_id = null_resource.coder_output.id
  item {
    key   = "floating_ip"
    value = openstack_networking_floatingip_v2.vip_fip.address
  }
}