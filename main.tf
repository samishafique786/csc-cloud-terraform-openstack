
resource "openstack_networking_network_v2" "private_network" {
  name           = "private_network"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name            = "private_subnet"
  network_id      = openstack_networking_network_v2.private_network.id
  cidr            = "192.168.1.0/24"
  ip_version      = 4
}

resource "openstack_networking_secgroup_v2" "public_sg" {
  name        = "public_sg"
  description = "Allow SSH and HTTP"
}

resource "openstack_networking_secgroup_v2" "private_sg" {
  name        = "private_sg"
  description = "Allow internal traffic"
}

resource "openstack_networking_secgroup_rule_v2" "public_sg_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.public_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "public_sg_rule_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.public_sg.id
}

resource "openstack_compute_instance_v2" "vm" {
  count           = 3
  name            = "VM-${count.index + 2}" # Changed to start from VM-2 to avoid naming conflict
  image_id        = "990cb289-a887-4c46-a68b-22bb6240defb"
  flavor_name     = "standard.small"
  key_pair        = "KeyPair-Ex3"
  security_groups = [openstack_networking_secgroup_v2.private_sg.name]
  depends_on      = [openstack_networking_subnet_v2.private_subnet]

  network {
    uuid = openstack_networking_network_v2.private_network.id
  }
}


# Attach the public security group to VM1
resource "openstack_compute_instance_v2" "vm1" {
  depends_on = [openstack_compute_instance_v2.vm]
  name       = "VM-1"
  image_id   = "990cb289-a887-4c46-a68b-22bb6240defb"
  flavor_name = "standard.small"
  key_pair   = "KeyPair-Ex3"
  
  security_groups = [
    openstack_networking_secgroup_v2.public_sg.name,
    openstack_networking_secgroup_v2.private_sg.name,
  ]

  network {
    uuid = openstack_networking_network_v2.private_network.id
  }
}
# Assign a floating IP to VM1
resource "openstack_networking_floatingip_v2" "vm1_fip" {
  pool = "public"
}


resource "openstack_networking_router_v2" "router" {
  name                = "router"
  external_network_id = "26f9344a-2e81-4ef5-a018-7d20cff891ee" # name of my external network 
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.private_subnet.id
}

resource "openstack_compute_floatingip_associate_v2" "fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.vm1_fip.address
  instance_id = openstack_compute_instance_v2.vm1.id
}

# Allow all traffic within the private network for the private security group
resource "openstack_networking_secgroup_rule_v2" "private_sg_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "192.168.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.private_sg.id
}
