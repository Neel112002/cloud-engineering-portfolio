terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "ca-central-1"
}

########################
# DynamoDB Table
########################

resource "aws_dynamodb_table" "feedback" {
  name         = "project02-feedback"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Project = "Project02-serverless-api"
  }
}

########################
# IAM Role for Lambda
########################

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "project02-feedback-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Allow Lambda to write to CloudWatch Logs + DynamoDB
data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "dynamodb:PutItem"
    ]
    resources = [aws_dynamodb_table.feedback.arn]
  }
}

resource "aws_iam_role_policy" "lambda_inline" {
  name   = "project02-feedback-lambda-policy"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_policy.json
}

########################
# Lambda Function (Python)
########################

resource "aws_lambda_function" "feedback" {
  function_name = "project02-feedback-handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.12"

  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.feedback.name
    }
  }
}

########################
# API Gateway HTTP API
########################

resource "aws_apigatewayv2_api" "http_api" {
  name          = "project02-feedback-api"
  protocol_type = "HTTP"

  # 👇 CORS so the browser (CloudFront static site) can call this API
  cors_configuration {
    allow_origins = ["*"]                # later you can restrict to your CloudFront URL
    allow_methods = ["OPTIONS", "POST"]
    allow_headers = ["Content-Type"]
    max_age       = 3600
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.feedback.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "post_feedback" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /feedback"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

########################
# Allow API Gateway to invoke Lambda
########################

resource "aws_lambda_permission" "api_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.feedback.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

########################
# Outputs
########################

output "api_invoke_url" {
  description = "Base URL for the feedback API"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}
