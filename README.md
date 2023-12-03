# CSC Cloud Environment Setup with Terraform

## Introduction
This project utilizes Terraform to define and provision a cloud environment within CSC's OpenStack cloud infrastructure in Finland. It's designed to demonstrate the creation of a secure, scalable, and highly available virtual architecture suitable for a variety of applications.

## Architecture Overview
The infrastructure consists of a set of interconnected virtual resources managed by Terraform:

- **Virtual Machines (VMs):** Four Ubuntu instances, where one is exposed to the internet and the others are isolated within a private network.
- **Network:** A single private network for inter-instance communication.
- **Subnet:** A subnet within the private network with a specified CIDR block.
- **Security Groups:** Two security groups to regulate access to the VMs, one for public-facing services and another for private network communications.
- **Router:** A router to connect the private subnet to the external network, allowing outbound internet access and inbound access to one VM.
- **Floating IP:** A floating IP associated with the public VM to enable direct internet connectivity.

## Usage:

The project sets up the following resources:

**VM1:**

Connected to both public_sg and private_sg security groups.
Has a floating IP for internet access.
Open ports: 22 (SSH) and 80 (HTTP).

**VMs 2-4:**

Connected to private_sg security group.
No public internet access; only communicate within the private network.
Open ports: All ports are open within the private network (192.168.1.0/24).

**Security Groups:**

public_sg allows SSH and HTTP traffic from any IP address.
private_sg allows all traffic within the private network.

**Router and Subnet:**

The router connects the private network to the external network.
The subnet provides IP addresses to the VMs.
To interact with the infrastructure, you can use both OpenStack CLI and Terraform commands to manage and modify resources.

![Architecture Diagram](https://drive.google.com/file/d/185hCLc-aZQplh7KDERQO5nxb8X6NHxzr/view?usp=sharing)
*Architecture diagram showing the OpenStack environment setup.*

## Prerequisites
- Terraform installed on your local machine.
- Access to CSC Cloud with valid credentials.
- Basic knowledge of Terraform and OpenStack operations.

## Installation & Configuration
Clone the repository and navigate to its directory:

```bash
git clone https://github.com/yourusername/csc-cloud-terraform.git
cd csc-cloud-terraform

