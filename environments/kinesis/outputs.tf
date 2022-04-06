output "invocation_result" {
  value = jsondecode(aws_lambda_invocation.invoke_kinesis_lambda.result)
}

output "kinesis_stream_arn" {
  value = aws_kinesis_stream.lambda_stream.arn
}