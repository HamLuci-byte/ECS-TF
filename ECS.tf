
# Create the ECS Cluster resource
resource "aws_ecs_cluster" "cluster" {
  name = "enhanced-architecture-fargate"
}

# Create the container security group
resource "aws_security_group" "container_sg" {
  name_prefix = "container_sg"
  description = "Access to the containers"
  vpc_id      = aws_vpc.main.id
}

# Allow traffic from the ECS security group to the container security group
resource "aws_security_group_rule" "ecs_to_container" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  source_security_group_id = aws_security_group.ECS.id
  security_group_id = aws_security_group.container_sg.id
}

