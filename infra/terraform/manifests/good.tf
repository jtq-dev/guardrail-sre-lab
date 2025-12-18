resource "aws_security_group_rule" "good_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["203.0.113.10/32"]
  security_group_id = "sg-123456"
}
