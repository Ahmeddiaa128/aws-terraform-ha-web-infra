output "pub_sub1_id" {
  value = aws_subnet.public["pub_sub1"].id
}

output "pub_sub2_id" {
  value = aws_subnet.public["pub_sub2"].id
}

output "pri_sub1_id" {
    value = aws_subnet.private["pri_sub1"].id
}

output "pri_sub2_id" {
    value = aws_subnet.private["pri_sub2"].id
}