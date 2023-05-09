resource "aws_iam_role" "autoscaling" {
  name = "autoscaling-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "application-autoscaling.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
    Version = "2012-10-17"
  })

  tags = {
    Name = "autoscaling-role"
  }
}

resource "aws_iam_role_policy" "autoscaling" {
  name = "service-autoscaling"
  policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Action = [
        "application-autoscaling:*",
        "cloudwatch:DescribeAlarms",
        "cloudwatch:PutMetricAlarm",
        "ecs:DescribeServices",
        "ecs:UpdateService"
      ]
      Resource = "*"
    }]
    Version = "2012-10-17"
  })

  role = aws_iam_role.autoscaling.name
}

# EC2 Role

resource "aws_iam_role" "EC2Role" {
  name = "EC2Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "EC2Role"
  }
}

resource "aws_iam_policy" "EC2RolePolicy" {
  name        = "EC2RolePolicy"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = [
          "ecs:CreateCluster",
          "ecs:DeregisterContainerInstance",
          "ecs:DiscoverPollEndpoint",
          "ecs:Poll",
          "ecs:RegisterContainerInstance",
          "ecs:StartTelemetrySession",
          "ecs:Submit*",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource  = "*"
      }
    ]
  })

  tags = {
    Name = "EC2RolePolicy"
  }
}

resource "aws_iam_role_policy_attachment" "EC2RolePolicyAttachment" {
  policy_arn = aws_iam_policy.EC2RolePolicy.arn
  role       = aws_iam_role.EC2Role.name
}



# Rules which allow ECS to attach network interfaces to instances
# on your behalf in order for awsvpc networking mode to work right
# Rules which allow ECS to update load balancers on your behalf
# with the information sabout how to send traffic to your containers

resource "aws_iam_role" "ecs_service_role" {
  name = "ecs_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_service_policy" {
  name = "ecs-service"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:AttachNetworkInterface",
          "ec2:CreateNetworkInterface",
          "ec2:CreateNetworkInterfacePermission",
          "ec2:DeleteNetworkInterface",
          "ec2:DeleteNetworkInterfacePermission",
          "ec2:Describe*",
          "ec2:DetachNetworkInterface",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:RegisterTargets"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_service_policy.arn
  role       = aws_iam_role.ecs_service_role.name
}

#Task Execution role

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ECSTaskExecutionRole"
  assume_role_policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
    Version = "2012-10-17"
  })

  tags = {
    Name = "ECSTaskExecutionRole"
  }
}

resource "aws_iam_role_policy" "ecs_task_execution_role_policy" {
  name = "AmazonECSTaskExecutionRolePolicy"
  policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "*"
    }]
    Version = "2012-10-17"
  })

  role = aws_iam_role.ecs_task_execution_role.name
}
