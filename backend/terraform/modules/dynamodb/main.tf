resource "aws_dynamodb_table" "ticker_winner" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "Date"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "Date"
    type = "S"
  }

  tags = {
    STAGE = "dev"
  }
}