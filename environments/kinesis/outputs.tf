output "invocation_result" {
  value = jsondecode(aws_lambda_invocation.invoke_kinesis_lambda.result)
}

output "kinesis_stream_arn" {
  value = aws_kinesis_stream.lambda_stream.arn
}

output "lambda_iam_role_arn" {
  value = aws_iam_role.lambda_kinesis_role.arn
}

output "event_mapping_uuid" {
  value = aws_lambda_event_source_mapping.lambda_event_mapping.uuid
}