resource "aws_iam_group" "kops" {
  name = "kops"
}

resource "aws_iam_group_policy_attachment" "AmazonEC2FullAccess" {
  group = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "AmazonRoute53FullAccess" {
  group = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_group_policy_attachment" "AmazonS3FullAccess" {
  group = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_group_policy_attachment" "IAMFullAccess" {
  group = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}
resource "aws_iam_group_policy_attachment" "AmazonVPCFullAccess" {
  group = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_group_policy_attachment" "AmazonSQSFullAccess" {
  group = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_group_policy_attachment" "AmazonEventBridgeFullAccess" {
  group = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
}

resource "aws_iam_user" "kops" {
  name = "kops"
}

resource "aws_iam_group_membership" "kops_membership" {
  name = "kops_group_membership"
  group = aws_iam_group.kops.name
  users = [
    aws_iam_user.kops.name
  ]
}




