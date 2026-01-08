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

resource "aws_iam_policy" "lamda_custom_policy" {
  name        = "lambda_custom_policy"
  description = "Custom policy for Lambda to access S3 and write logs to CloudWatch"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = [
          "s3:GetObject"
          
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::mybucketunique5689/*"
      }
    ]
  })
  
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "mybucketunique5689"
  
}

resource "aws_iam_role_policy_attachment" "lambda_custom_policy_attachment" {
  role = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lamda_custom_policy.arn
  
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "lambda_function"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  timeout = 900
  memory_size = 128

  filename = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

resource "aws_cloudwatch_event_rule" "s3_object_upload_rule" {
  name = "s3-object-upload-rule"

  event_pattern = jsonencode({
    source = ["aws.s3"]
    detail-type = ["Object Created"]
    detail = {
      bucket = {
        name = ["mybucketunique5689"]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.s3_object_upload_rule.name
  target_id = "lambda"
  arn = aws_lambda_function.lambda_function.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3_object_upload_rule.arn
}

resource "aws_s3_bucket_notification" "enable_eventbridge" {
  bucket      = "mybucketunique5689"
  eventbridge = true
}

