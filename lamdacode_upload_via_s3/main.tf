# create s3 bucket and upload lambda zip file to s3 bucket
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "my-lambda123456"
  
}

# create s3 object for lambda zip file
resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_function.zip"
  source = "./lambda_function.zip"
  etag   = filemd5("./lambda_function.zip")
}

 # create an IAM role for Lambda with necessary permissions
resource "aws_iam_role" "lambda_role" {
    name = "lambda-custom-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
  
}

 # create an IAM policy for Lambda to write logs to CloudWatch
resource "aws_iam_policy" "lambda_cloudwatch_policy" {
    name = "lambda-cloudwatch-policy"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
                Effect = "Allow"
                Resource = "arn:aws:logs:*:*:*"
            }
        ]
    })
  
}

# attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_logs_policy" {
    role = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.lambda_cloudwatch_policy.arn
  
}
 # create the lambda function using the s3 bucket and object
resource "aws_lambda_function" "lambda_function" {
    function_name = "my_lambda_function_s3"
    role          = aws_iam_role.lambda_role.arn
    handler       = "lambda_function.lambda_handler"  
    runtime       = "python3.8"
    memory_size   = 128
    timeout       = 900
    
    # specify the s3 bucket and key for the lambda code
    s3_bucket = aws_s3_bucket.lambda_bucket.id
    s3_key    = aws_s3_object.lambda_zip.key

    # create the source_code_hash to detect changes in the lambda zip file
    source_code_hash = filebase64sha256("./lambda_function.zip")

    # ensure the IAM role and policy attachment are created before the lambda function
    depends_on = [
    aws_iam_role_policy_attachment.attach_logs_policy
  ]
}
  