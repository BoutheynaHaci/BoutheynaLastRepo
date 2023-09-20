resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_upload_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_instance_profile_public" {
  name = "ec2_s3_upload_instance_profile_public"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_instance_profile" "ec2_instance_profile_private" {
  name = "ec2_s3_upload_instance_profile_private"
  role = aws_iam_role.ec2_role.name
}



