resource "aws_iam_role" "lambda-kinesis-role" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = ["sts:AssumeRole"]
          Effect = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  description = "Allows Lambda functions to call AWS services on your behalf."
  name        = "lambda-kinesis-role"
  tags        = {}
}

data "aws_iam_policy" "AWSLambdaKinesisExecutionRole" {
  arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"
  name = "AWSLambdaKinesisExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda-kinesis-attach" {
  policy_arn = data.aws_iam_policy.AWSLambdaKinesisExecutionRole.arn
  role       = aws_iam_role.lambda-kinesis-role.id
}

resource "aws_lambda_function" "process-kinesis" {
  function_name = "ProcessKinesisRecords"
  handler       = "index.handler"
  role          = aws_iam_role.lambda-kinesis-role.arn
  runtime       = "nodejs12.x"
  filename      = "index.js.zip"
}