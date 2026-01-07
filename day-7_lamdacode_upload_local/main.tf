# create an IAM role for Lambda with necessary permissions
resource "aws_iam_role" "lambda_role" {
    name = "lambda_execution_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }]
    })
  
}

# create an IAM policy for Lambda logging
resource "aws_iam_role_policy_attachment" "lambda_policy" {
    role = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  
}

resource "aws_lambda_function" "lambda_function" {
    function_name = "my_lambda_function"
    role          = aws_iam_role.lambda_role.arn
    handler       = "lambda_function.lambda_handler"  
    runtime = "python3.8"
    memory_size = 128
    timeout     = 900
    filename = "lambda_function.zip"

    # Compute the base64-encoded SHA256 hash of the lambda function zip file
    source_code_hash = filebase64sha256("lambda_function.zip")  
    # Without source_code_hash, Terraform might not detect when the code in the ZIP file has changed — meaning your Lambda might not update even after uploading a new ZIP.

  
}