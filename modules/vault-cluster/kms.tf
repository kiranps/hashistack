resource "aws_iam_role_policy" "vault_auto_unseal_kms" {
  name   = "vault_auto_unseal_kms"
  role   = aws_iam_role.instance_role.id
  policy = data.aws_iam_policy_document.vault_auto_unseal_kms.json

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "vault_auto_unseal_kms" {
  statement {
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]

    resources = [aws_kms_key.unseal_key.arn]
  }
}
