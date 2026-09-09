output "instance_profile" {
  value = aws_iam_instance_profile.instance_profile.id
}
output "cloudwatch_instance_profile" {
  value = aws_iam_instance_profile.cloudwatch_instance_profile.id
}