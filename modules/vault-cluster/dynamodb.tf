data "aws_caller_identity" "current" {}

resource "aws_dynamodb_table" "vault_dynamo" {
  name           = "${var.dynamo_table_name}"
  hash_key       = "Path"
  range_key      = "Key"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "Path"
    type = "S"
  }

  attribute {
    name = "Key"
    type = "S"
  }
}

resource "aws_iam_role_policy" "vault_dynamo" {
  name  = "vault_dynamo"
  role  = aws_iam_role.instance_role.id
  policy = data.aws_iam_policy_document.vault_dynamo.json
}

data "aws_iam_policy_document" "vault_dynamo" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:ListTables",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:DescribeTable"
    ]
    resources = [
      format("arn:aws:dynamodb:%s:%s:table/%s",
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id,
        var.dynamo_table_name
      )
    ]
  }
}
