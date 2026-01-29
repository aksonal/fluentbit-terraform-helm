#pod role
data "aws_region" "ic_dev_region" {}

data "aws_caller_identity" "ic_dev_account" {}

resource "aws_iam_policy" "ic_dev_fluentbit_role_policy" {
  name = "eks-cluster-fluentbit-pod-role-policy-${var.env}"
  description = "IAM policy for fluentbit to push logs to cloudwatch"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "fluentBitLogManagement"
        Action = [
          "logs:PutLogEvents",
          "logs:Describe*",
          "logs:CreateLogStream"
        ]
        Effect   = "Allow"
        Resource = [
            "arn:aws:logs:${data.aws_region.ic_dev_region.name}:${data.aws_caller_identity.ic_dev_account.account_id}:log-group:/aws/containerinsights/${var.cluster_name}/application:*",
          "arn:aws:logs:${data.aws_region.ic_dev_region.name}:${data.aws_caller_identity.ic_dev_account.account_id}:log-group:/aws/containerinsights/${var.cluster_name}/dataplane:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "ic_dev_fluentbit_pod_role" {
  name = "fluentbit-pod-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(
              var.oidc_provider_url,
              "https://",
              ""
            )}:sub" = "system:serviceaccount:amazon-cloudwatch:fluentbit-custom-sa"

            "${replace(
              var.oidc_provider_url,
              "https://",
              ""
            )}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "fluentbit_pod_role_policy_attachment" {
  policy_arn = aws_iam_policy.ic_dev_fluentbit_role_policy.arn
  role       = aws_iam_role.ic_dev_fluentbit_pod_role.name
}
