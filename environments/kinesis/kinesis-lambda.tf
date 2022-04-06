resource "aws_iam_role" "lambda_kinesis_role" {
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
  name        = "lambda_kinesis_role"
  tags        = {}
}

data "aws_iam_policy" "lambda_kinesis_service_role" {
  arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"
  name = "AWSLambdaKinesisExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda-kinesis-attach" {
  policy_arn = data.aws_iam_policy.lambda_kinesis_service_role.arn
  role       = aws_iam_role.lambda_kinesis_role.id
}

resource "aws_lambda_function" "process_kinesis" {
  function_name = "parse_event"
  handler       = "parse_event.parse_event"
  role          = aws_iam_role.lambda_kinesis_role.arn
  runtime       = "python3.9"
  filename      = "parse_event.py.zip"
}

resource "aws_lambda_invocation" "invoke_kinesis_lambda" {
  function_name = aws_lambda_function.process_kinesis.function_name
  input         = file("input.txt")
}

resource "aws_kinesis_stream" "lambda_stream" {
  name        = "lambda_stream"
  shard_count = 1
}

//resource "aws_lambda_event_source_mapping" "lambda_event_mapping" {
//  event_source_arn = aws_kinesis_stream.lambda_stream.arn
//  function_name    = aws_lambda_function.process_kinesis.function_name
//}