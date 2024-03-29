resource "aws_dynamodb_table" "table" {
  name      = var.table_name
  hash_key  = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  table_class    = "STANDARD"

  tags = {
    Name        = "dyanmodb-table-1"
    Environment = "production"
  }
}

# resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
#   max_capacity       = var.autoscale_max_capacity
#   min_capacity       = var.autoscale_min_capacity
#   resource_id        = "table/${var.table_name}"
#   scalable_dimension = "dynamodb:table:ReadCapacityUnits"
#   service_namespace  = "dynamodb"
# }

# resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
#   name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.dynamodb_table_read_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.dynamodb_table_read_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "DynamoDBReadCapacityUtilization"
#     }

#     target_value = var.target_utilization
#   }
# }

# resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
#   max_capacity       = var.autoscale_max_capacity
#   min_capacity       = var.autoscale_min_capacity
#   resource_id        = "table/${var.table_name}"
#   scalable_dimension = "dynamodb:table:WriteCapacityUnits"
#   service_namespace  = "dynamodb"
# }

# resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
#   name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_write_target.resource_id}"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.dynamodb_table_write_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.dynamodb_table_write_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.dynamodb_table_write_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "DynamoDBWriteCapacityUtilization"
#     }

#     target_value = var.target_utilization
#   }
# }