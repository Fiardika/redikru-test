output "vpc_instance_id" {
  value = "${aws_vpc.vpc_instance.id}"
}

output "public_subnets_instance_id" {
  value = aws_subnet.public_subnet_instance.*.id
}

output "instance_sg_id" {
  value = "${aws_security_group.instance_sg.id}"
}

output "instance_id" {
  value = "${aws_instance.instance.id}"
}