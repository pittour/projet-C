resource "aws_lb" "lb" {
  name               = "${var.site}-lb-${var.user}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [aws_subnet.pub1.id, aws_subnet.pub2.id]
  tags = {
    Environment = "${var.site}-lb-${var.user}"
  }
}

resource "aws_lb_target_group" "my-tg" {
  target_type = "instance"
  name     = "${var.site}-tg-${var.user}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id
}

resource "aws_lb_target_group_attachment" "instance-atc1" {
  target_group_arn = aws_lb_target_group.my-tg.arn
  target_id = aws_instance.webserver-1.id
}

resource "aws_lb_target_group_attachment" "instance-atc2" {
  target_group_arn = aws_lb_target_group.my-tg.arn
  target_id = aws_instance.webserver-2.id
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.lb.arn
  port = "443"
  protocol = "HTTPS"
  certificate_arn = data.aws_acm_certificate.certificate.arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.my-tg.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}