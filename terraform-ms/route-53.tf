resource "aws_route53_record" "lb-record" {
  zone_id = data.aws_route53_zone.zone.id
  type = "A"
  name = "ms.kevin-billerach.me"

  alias {
    name = aws_lb.lb.dns_name
    zone_id = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}