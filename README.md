# ECS-TF

![Architecture](./Images/ECS.png)

This Terraform project automates the creation of a VPC with 2 public and 2 private subnets, an ECS cluster inside the VPC, an Application Load Balancer (ALB), target group, and listener. Additionally, it sets up the necessary IAM roles for the ECS cluster.

The VPC is created with the help of the Terraform AWS provider, which enables the creation of all the necessary networking resources, such as subnets, route tables, and internet gateways. The ECS cluster is then set up, allowing you to run and manage containerized applications within the VPC.

The Application Load Balancer, target group, and listener are also provisioned using the Terraform AWS provider. These resources enable the distribution of traffic across multiple instances of your application, ensuring high availability and scalability.

Finally, the project creates the required IAM roles for the ECS cluster, which provides the necessary permissions for managing the containers running on the cluster.

This Terraform project helps you quickly and easily set up a highly available and scalable infrastructure for running containerized applications, all in a repeatable and consistent manner.
