resource "aws_dynamodb_table" "table" {
    name = var.table_name
    hash_key = var.hash_key
    range_key = var.range_key

    attribute {
      name = var.hash_key
      type = var.hash_key_type
    }

    attribute {
      name = var.range_key
      type = var.range_key_type
    }

    tags = {
        Name = "dyanmodb-table-1"
        Environment = "production"
    }
}