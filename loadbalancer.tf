
# Configuring the Load balancer
resource "aws_lb" "Load-Balancer" {
  name                              = "aws-load-balancer"
  internal                          = false
  load_balancer_type                = "application"
  enable_cross_zone_load_balancing = true
  security_groups                   = [aws_security_group.sg-1.id, aws_security_group.sg-2.id]
  subnets                           = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
}

# Target Group
resource "aws_lb_target_group" "tg1" {
  name     = "target-group-alb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc-asg.id
}

# Listener for the load balancer
resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.Load-Balancer.arn  
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }
}



