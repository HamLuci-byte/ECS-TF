
# Create a target group
resource "aws_lb_target_group" "ECS" {
  name        = "ECS-TG"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}




# Create a security group for the load balancer
resource "aws_security_group" "ECS" {
  name_prefix = "ECS-SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "env"       = "dev"
    "createdBy" = "binpipe"
  }
}

# Create an application load balancer
resource "aws_lb" "ECS" {
  name               = "ECS"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public.id, aws_subnet.public2.id]
  security_groups    = [aws_security_group.ECS.id]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Create a listener for the load balancer
resource "aws_lb_listener" "ECS" {
  load_balancer_arn = aws_lb.ECS.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ECS.arn
    type             = "forward"
  }
}
