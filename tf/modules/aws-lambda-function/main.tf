data "archive_file" "update_view_count" {
  type = "zip"
  source_dir = "../../src/update_view_count.py"
  output_path = "../../src/update_view_count.zip"
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

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "update_view_count_lambda" {
  filename = "../../src/update_view_count.zip"
  function_name = var.function_name
  role = aws_iam_role.iam_for_lambda
  runtime = "python3.12"
  source_code_hash = data.archive_file.update_view_count.output_base64sha256
}