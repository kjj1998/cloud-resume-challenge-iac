resource "aws_apigatewayv2_api" "gateway" {
  name          = var.api_name
  protocol_type = var.api_protocol
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "POST /updateViewCountInDynamoDB"
}

data "aws_lambda_function" "existing" {
  function_name = "updateViewCountInDynamoDB"
}

resource "aws_apigatewayv2_integration" "lamda_integration" {
  api_id           = aws_apigatewayv2_api.gateway.id
  integration_type = "AWS_PROXY"

  connection_type           = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  description               = "Lambda example"
  integration_method        = "POST"
  integration_uri           = data.aws_lambda_function.existing.invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
  timeout_milliseconds      = 30000
  payload_format_version    = "2.0"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id = aws_apigatewayv2_api.gateway.id
  name   = "$default"
  auto_deploy = true
}