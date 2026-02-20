output "table_name" { 
    value = aws_dynamodb_table.ticker_winner.name 
}

output "table_arn" {
  value       = aws_dynamodb_table.ticker_winner.arn  
  description = "ARN of the created DynamoDB table"
}