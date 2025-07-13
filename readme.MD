<h2 align="center">Roboshop Architecture</h2>

<p align="center">
  <img src="images/roboshop-infra-dev-saijyo.store-clean.svg" alt="Roboshop Architecture" width="1000">
</p>


# 🚀 Automated 3-Tier Architecture on AWS: Terraform & Ansible in Action

This project delivers a **secure, scalable, and modular 3-tier infrastructure** on AWS, fully automated using **Terraform** for provisioning and **Ansible** for configuration management. It’s a practical demonstration of real-world DevOps principles, showcasing end-to-end automation, reusable modules, and seamless service integration.

> ✅ **New Addition:** The repository now includes an `images/` folder containing screenshots of the project, architecture, infrastructure dashboard, and deployment outputs to help users visually understand the setup.

---

## 🌐 Project Overview

This initiative automates the entire deployment of a multi-tiered web application. It’s built to highlight:

* **Full Infrastructure Modularization:** Breaking down complex infrastructure into manageable, reusable components.
* **Secure Private Networking:** Implementing robust security measures for all application layers.
* **Seamless Provisioning & Configuration:** Orchestrating workflows for smooth, predictable deployments.
* **Automated Software & Service Deployment:** Handling installations and deployments with precision.
* **Flexible Access:** Providing secure access options through both VPN and a Bastion Host.

The featured application is a **Roboshop Microservices** suite, a collection of services built with Node.js, MongoDB, Redis, MySQL, and RabbitMQ, demonstrating a real-world, complex application stack.

**Environment URL:** [https://dev.saijyo.store](https://dev.saijyo.store)

---

## 🗺️ Architecture Diagram

> 📁 **Reference:** See the `images/` folder for the full architecture diagram and AWS Console views.

Our infrastructure is logically segmented into three distinct layers, designed for optimal performance, security, and scalability:

* **Frontend Layer:** A **Public Application Load Balancer (ALB)** distributing traffic to an **EC2 Auto Scaling Group (ASG)** running the Node.js application.
* **Backend Layer:** An **Internal ALB** routing requests to various private microservices.
* **Database Layer:** Critical data stores like MongoDB, MySQL, Redis, and RabbitMQ, all securely nestled within private subnets.

---

## 🏗️ Infrastructure Stack

The foundation of this project relies on key AWS services, meticulously configured to create a robust and secure environment:

* **Virtual Private Cloud (VPC):** Complete with public and private subnets for network isolation.
* **EC2 Instances:** Utilized for Bastion hosts, VPN servers, application servers, and database instances.
* **Application Load Balancers (ALBs):** Both public and private, ensuring efficient traffic distribution.
* **Auto Scaling Groups (ASG):** For dynamic scaling and high availability of application instances.
* **AWS Certificate Manager (ACM):** For provisioning and managing SSL/TLS certificates.
* **Amazon CloudFront:** Serving as a Content Delivery Network (CDN) for global content delivery and enhanced security.
* **AWS Systems Manager (SSM) Parameter Store:** Securely storing and managing configuration data.
* **IAM Roles & Security Groups:** Implementing granular access control and network security.

---

## 📦 Modules Breakdown

The infrastructure is built using a **modular Terraform approach**, with each module handling a specific, self-contained part of the architecture:

| Module             | Purpose                                                                            |
| :----------------- | :--------------------------------------------------------------------------------- |
| `00-vpc/`          | **Networking:** Sets up the VPC, subnets, and route tables.                        |
| `10-sg/`           | **Security Groups:** Defines security groups for each application layer.           |
| `20-bastion/`      | **Bastion Host:** Configures an optional Bastion host for secure access.           |
| `30-vpn/`          | **OpenVPN Server:** Provisions an OpenVPN server for secure, full-tunnel access.   |
| `40-databases/`    | **Databases:** Deploys MongoDB, MySQL, Redis, and RabbitMQ in private subnets.     |
| `50-backend-alb/`  | **Internal ALB:** Configures the internal ALB for backend services.                |
| `60-acm/`          | **SSL Certificate:** Manages SSL certificate provisioning via ACM.                 |
| `70-frontend-alb/` | **Public ALB + ASG:** Sets up the public ALB and ASG for the Node.js frontend.     |
| `90-components/`   | **Microservices:** Deploys individual microservices (e.g., cart, user, catalogue). |

---

## ⚙️ Provisioning Workflow

Terraform provisions the infrastructure in a specific, dependency-aware order.

### Deployment Order

To provision the infrastructure, execute these commands sequentially from the project root:

```bash
# Core Networking & Access
for i in 00-vpc/ 10-sg/ 30-vpn/; do
  cd $i && terraform init -reconfigure && terraform plan && terraform apply -auto-approve && cd ..
done

# App & Services
for i in 40-databases/ 50-backend-alb/ 60-acm/ 70-frontend-alb/ 90-components/; do
  cd $i && terraform init -reconfigure && terraform plan && terraform apply -auto-approve && cd ..
done
```

### Destruction Order

To safely tear down the infrastructure and avoid unnecessary charges, run these commands in reverse:

```bash
for i in 90-components/ 70-frontend-alb/ 60-acm/ 50-backend-alb/ 40-databases/ 30-vpn/ 10-sg/ 00-vpc/; do
  cd $i && terraform init -reconfigure && terraform destroy -auto-approve && cd ..
done
```

---

## 🤖 Ansible Configuration Management

Once Terraform provisions the infrastructure, Ansible takes over to configure software and deploy services on EC2 instances.

### Key Automation Steps:

* Install **Node.js**, **Python**, **Nginx**, and other dependencies
* Deploy **Roboshop microservices** pulled from GitHub
* Configure and initialize databases (MySQL, MongoDB, Redis, RabbitMQ)

### Ansible-Pull Explained

Instead of managing configurations from a central Ansible controller, this project uses **`ansible-pull`**, a GitOps-friendly method where the **EC2 instance pulls its configuration from GitHub**:

```bash
ansible-pull -i localhost, -U https://github.com/Nallagachu/ansible-roboshop-roles-tf.git -e component=user roboshop.yml
```

> 🔄 This method ensures each server is responsible for its configuration, promoting **idempotency**, **scalability**, and **decentralized deployments**. It also aligns well with CI/CD pipelines and cloud-native automation.

---

## 📸 Screenshots

Refer to the `images/` folder in this repository to view:

* ✅ **OpenVPN GUI** – Successful connection screen
* ⚙️ **Ansible Output** – Deployment and configuration logs
* 📊 **AWS Console** – Snapshots of deployed resources
* 🌐 **Roboshop UI** – Live application on [https://dev.saijyo.store](https://dev.saijyo.store)

...
