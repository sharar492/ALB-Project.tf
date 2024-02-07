# Launch Template for AWS
resource "aws_launch_template" "web_server" {
  name          = "web-server-launch"
  instance_type = var.instance_type
  description   = "launch template for web server"
  image_id      = "ami-0a3c3a20c09d6f377"

  network_interfaces {
    subnet_id = aws_subnet.subnet-1.id
  }


}

# Auto-Scaling Group for architecture
resource "aws_autoscaling_group" "asg-group" {
  desired_capacity     = 3
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
  launch_template {
    id      = aws_launch_template.web_server.id
    version = "$Latest"
  }
}


resource "aws_autoscaling_attachment" "asg-attachment" {
    autoscaling_group_name = aws_autoscaling_group.asg-group.id
    lb_target_group_arn      = aws_lb_target_group.tg1.arn
}



