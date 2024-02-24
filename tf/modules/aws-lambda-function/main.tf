data "archive_file" "update_view_count" {
  type = "zip"
  source_file = "${path.cwd}/scripts/update_view_count.py"
  output_path = "${path.cwd}/scripts/update_view_count.zip"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role_tf" {
  name               = "iam_for_lambda_tf"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "lambda_policy_tf" {
  name        = "lambda_policy_tf"
  path        = "/"
  description = "lambda policy for tf"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:Scan",
            "dynamodb:UpdateItem",
            "dynamodb:DescribeTable"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:ap-southeast-1:271407076537:table/*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.lambda_role_tf.name
 policy_arn  = aws_iam_policy.lambda_policy_tf.arn
}

resource "aws_lambda_function" "update_view_count_lambda" {
  filename = "${path.cwd}/scripts/update_view_count.zip"
  function_name = var.function_name
  role = aws_iam_role.lambda_role_tf.arn
  handler = "main.lambda_handler"
  runtime = "python3.12"
  source_code_hash = data.archive_file.update_view_count.output_base64sha256
}