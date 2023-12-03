terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

provider "openstack" {
  user_name       = "<I-will-hide-my-username>"
  password        = "<also-my-password>"
  tenant_name     = "<also_my_tenant_name"
  auth_url        = "https://pouta.csc.fi:5001/v3"
  user_domain_name = "Default"
  region          = "regionOne"
}
