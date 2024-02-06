provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket = "nancy-bucket-1"
    key = "tfstate.json"
    region = "eu-north-1"
  }
}

resource "aws_sqs_queue" "my_queue" {
  name                      = "nancyf-tf"
  delay_seconds             = 0
  max_message_size          = 1024
  message_retention_seconds = 86400
  visibility_timeout_seconds = 60
  receive_wait_time_seconds  = 0

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__owner_statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::933060838752:root"
      },
      "Action": "SQS:*",
      "Resource": "arn:aws:sqs:eu-north-1:933060838752:nancyf-tf"
    }
  ]
}
EOF
}

variable "telegram_token" {
  description = "Telegram Token for the bot"
}

resource "aws_secretsmanager_secret" "telegram_token_secret" {
  name = "nancyf_telegram_token_terraform"
}


resource "aws_secretsmanager_secret_version" "telegram_token_version" {
  secret_id     = aws_secretsmanager_secret.telegram_token_secret.id
  secret_string = <<EOT
{
  "TELEGRAM_TOKEN": "${var.telegram_token}"
}
EOT
}


resource "aws_s3_bucket" "my_bucket" {
  bucket = "nancyf-tf"

}

resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
  bucket = aws_s3_bucket.my_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "my_bucket_sse" {
  bucket = aws_s3_bucket.my_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "my_table" {
  name           = "nancyf-tf"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key = "prediction_id"

  attribute {
    name = "prediction_id"
    type = "S"
  }

}

resource "aws_appautoscaling_target" "read_target" {
  service_namespace  = "dynamodb"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  resource_id        = "table/nancyf-tf"
  min_capacity       = 1
  max_capacity       = 10
}

resource "aws_appautoscaling_target" "write_target" {
  service_namespace  = "dynamodb"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  resource_id        = "table/nancyf-tf"
  min_capacity       = 1
  max_capacity       = 10
}


resource "aws_appautoscaling_policy" "read_scaling_policy" {
  name                 = "read-scaling-policy"
  service_namespace   = aws_appautoscaling_target.read_target.service_namespace
  scalable_dimension   = aws_appautoscaling_target.read_target.scalable_dimension
  resource_id          = aws_appautoscaling_target.read_target.resource_id
  policy_type          = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_appautoscaling_policy" "write_scaling_policy" {
  name                 = "write-scaling-policy"
  service_namespace   = aws_appautoscaling_target.write_target.service_namespace
  scalable_dimension   = aws_appautoscaling_target.write_target.scalable_dimension
  resource_id          = aws_appautoscaling_target.write_target.resource_id
  policy_type          = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = 70.0
  }
}
