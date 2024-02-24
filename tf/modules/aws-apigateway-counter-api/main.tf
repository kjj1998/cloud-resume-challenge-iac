resource "aws_apigatewayv2_api" "lambda" {
  name          = var.api_name
  protocol_type = var.api_protocol

  cors_configuration {
    allow_origins = [ "https://*" ]
    allow_headers = [ "authorization", "accept", "content-type", "origin" ]
    allow_methods = [ "POST", "OPTIONS", "*" ]
    expose_headers = [ "date", "x-api-id" ]
    allow_credentials = true
    max_age = 300
  }
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 0
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id
  
  name = "test"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

data "aws_lambda_function" "existing" {
  function_name = "updateViewCountInDynamoDB2"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.lambda.id
  integration_type = "AWS_PROXY"

  connection_type           = "INTERNET"
  description               = "Lambda example"
  integration_method        = "POST"
  integration_uri           = data.aws_lambda_function.existing.invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
  timeout_milliseconds      = 30000
  payload_format_version    = "2.0"
}


resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.lambda.id
  
  route_key = "POST /updateViewCountInDynamoDB"
  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}


resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.existing.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}