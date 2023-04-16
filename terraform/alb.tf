# create application load balancer
resource "aws_lb" "animalrekog_alb" {
  name               = "animalrekog_alb"
  internal           = false
  load_balancer_type = "application"

  subnets = aws_subnet.public_subnet.*.id

  security_groups = [aws_security_group.animalrekog_alb_sg.id]
}

# create target group for alb
resource "aws_lb_target_group" "animalrekog_targetgroup" {
  name     = "animalrekog_targetgroup"
  port     = 80
  protocol = "HTTP"

  vpc_id = aws_vpc.animalrekog_vpc.id

  target_type = "ip"
}

# application load balancer security group
resource "aws_security_group" "animalrekog_alb_sg" {
  name_prefix = "animalrekog_alb_sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/"]
 }
} 