resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = aws_iam_role.role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = "access_secret_manager"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "app_policy" {
  name = "test_policy"
  role = aws_iam_role.role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ],
        "Resource": var.secret_manager_arn
      }
    ]
  })
}


resource "aws_iam_instance_profile" "cloudwatch_instance_profile" {
  name = "cloudwatch_instance_profile"
  role = aws_iam_role.ec2_cloudwatch.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role = aws_iam_role.ec2_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role" "ec2_cloudwatch" {
  name               = "ec2-cloudwatch-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}