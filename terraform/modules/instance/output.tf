output "nginx1_id" {
  value = aws_instance.nginx["nginx_1"].id
}
output "nginx2_id" {
  value = aws_instance.nginx["nginx_2"].id
}

output "web1_id" {
  value = aws_instance.apache["apache_1"].id
}
output "web2_id" {
  value = aws_instance.apache["apache_1"].id
}