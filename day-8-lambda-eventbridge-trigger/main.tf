# Create IAM role for Lambda function
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  
}

# Attach AWSLambdaBasicExecutionRole policy to the role
resource "aws_iam_policy_attachment" "lambda_exec_role_attachment" {
  name       = "lambda_exec_role_attachment"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  
}

# Create Lambda function
resource "aws_lambda_function" "lambda_function" {
  function_name = "lambda_eventbridge_trigger"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  timeout = 900
  memory_size = 128

  filename = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

# Create EventBridge rule to trigger every 5 minutes
resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = "every_5_minutes_rule"
  description = "Triggers every 5 minutes"
  #schedule_expression = "rate(5 minutes)"  # Alternative way
  schedule_expression = "cron(*/5 * * * ? *)" # cron expression for every 5 minutes
}

# Create EventBridge target to invoke the Lambda function
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.event_rule.name
  target_id = "lambda"
  arn = aws_lambda_function.lambda_function.arn
}

# Grant EventBridge permission to invoke the Lambda function
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule.arn
}
