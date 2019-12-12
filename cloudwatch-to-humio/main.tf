provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "humio_logging_role" {
  count = var.humio_auto_subscription ? 1 : 0

  name = "humio-logging-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = ["lambda.amazonaws.com", "apigateway.amazonaws.com", "logs.amazonaws.com"]
      }
    }]
    Version = "2012-10-17"
  })

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
}


resource "aws_iam_role_policy" "humio_logging_policy" {

  name = "humio-logging-policy"
  role = aws_iam_role.humio_logging_role[0].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
       "lambda:GetFunction",
       "lambda:InvokeAsync",
       "lambda:InvokeFunction",
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:DescribeLogGroups",
       "logs:DescribeLogStreams",
       "logs:DescribeSubscriptionFilters",
       "logs:PutSubscriptionFilter",
       "logs:DeleteSubscriptionFilter",
       "logs:PutLogEvents",
       "logs:GetLogEvents",
       "logs:FilterLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_lambda_function" "humio_cloudwatch_ingester" {

  function_name = "humio_cloudwatch_ingester"
  description   = "humio cloudwatch ingester"
  role          = aws_iam_role.humio_logging_role[0].arn
  s3_bucket     = "humio-public-${var.region}"
  s3_key        = "cloudwatch_humio.zip"
  handler       = "ingester.lambda_handler"
  memory_size   = var.memory_size
  timeout       = var.timeout
  runtime       = var.runtime

  environment {
    variables = {
      humio_dataspace_name      = var.humio_dataspace_name,
      humio_protocol            = var.humio_protocol,
      humio_host                = var.humio_host,
      humio_ingest_token        = var.humio_ingest_token,
      humio_subscription_enable = var.humio_auto_subscription
    }
  }

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
}

resource "aws_lambda_permission" "humio_cloudwatch_ingester_permission" {

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.humio_cloudwatch_ingester.function_name
  principal     = "logs.amazonaws.com"

}


resource "aws_lambda_function" "humio_cloudwatch_auto_subscriber" {

  function_name = "humio_cloudwatch_auto_subscriber"
  description   = "humio log group auto subscriber"
  role          = aws_iam_role.humio_logging_role[0].arn
  s3_bucket     = "humio-public-${var.region}"
  s3_key        = "cloudwatch_humio.zip"
  handler       = "auto_subscriber.lambda_handler"
  memory_size   = var.memory_size
  timeout       = var.timeout
  runtime       = var.runtime

  environment {
    variables = {
      humio_log_ingester_arn        = aws_lambda_function.humio_cloudwatch_ingester.arn,
      humio_subscription_prefix     = var.humio_subscription_prefix,
      humio_subscription_backfiller = var.humio_subscription_backfiller,
    }
  }

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
}

resource "aws_lambda_permission" "humio_cloudwatch_auto_subscriber_permission" {
  count = var.humio_auto_subscription ? 1 : 0

  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.humio_cloudwatch_auto_subscriber.arn
  principal      = "events.amazonaws.com"
  source_account = data.aws_caller_identity.current.account_id

}

resource "aws_lambda_permission" "humio_cloudwatch_auto_subscriber_permission_2" {
  count = var.humio_auto_subscription ? 1 : 0

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.humio_cloudwatch_auto_subscriber.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.humio_auto_subscription_eventrule[0].arn

}



resource "aws_lambda_function" "humio_cloudwatch_back_filler" {

  function_name = "humio_cloudwatch_back_filler"
  description   = "humio cloudwatch backfiller"
  role          = aws_iam_role.humio_logging_role[0].arn
  s3_bucket     = "humio-public-${var.region}"
  s3_key        = "cloudwatch_humio.zip"
  handler       = "backfiller.lambda_handler"
  memory_size   = var.memory_size
  timeout       = var.timeout
  runtime       = var.runtime

  environment {
    variables = {
      humio_log_ingester_arn    = aws_lambda_function.humio_cloudwatch_ingester.arn,
      humio_subscription_prefix = var.humio_subscription_prefix,
      humio_dataspace_name      = var.humio_dataspace_name,
      humio_protocol            = var.humio_protocol,
      humio_host                = var.humio_host,
      humio_ingest_token        = var.humio_ingest_token,
      humio_subscription_enable = var.humio_auto_subscription,
    }
  }

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
}

resource "aws_lambda_permission" "humio_cloudwatch_back_filler_permission" {

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.humio_cloudwatch_back_filler.arn
  principal     = "logs.amazonaws.com"

}


resource "aws_s3_bucket" "humio_auto_subscription_bucket" {
  count = var.humio_auto_subscription ? 1 : 0

  bucket        = "humio-${var.name}-cloudtrail"
  acl           = "bucket-owner-full-control"
  force_destroy = true

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
}

resource "aws_s3_bucket_policy" "humio_auto_subscription_bucket_policy" {
  count = var.humio_auto_subscription ? 1 : 0

  bucket = aws_s3_bucket.humio_auto_subscription_bucket[0].id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck20150319",
      "Effect": "Allow",
      "Principal": {"Service": "cloudtrail.amazonaws.com"},
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.humio_auto_subscription_bucket[0].arn}"
    },
    {
      "Sid": "AWSCloudTrailWrite20150319",
      "Effect": "Allow",
      "Principal": {"Service": "cloudtrail.amazonaws.com"},
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.humio_auto_subscription_bucket[0].arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      "Condition": {
         "StringEquals": {"s3:x-amz-acl": "bucket-owner-full-control"}
      }
    }
  ]
}
POLICY

  depends_on = [
    aws_s3_bucket.humio_auto_subscription_bucket
  ]

}

resource "aws_cloudtrail" "humio_auto_subscription_cloudtrail" {
  count = var.humio_auto_subscription ? 1 : 0

  name                          = "humio-${data.aws_caller_identity.current.account_id}"
  enable_logging                = true
  enable_log_file_validation    = false
  include_global_service_events = true
  is_multi_region_trail         = true
  s3_bucket_name                = "humio-${var.name}-cloudtrail"


  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )

  depends_on = [
    aws_s3_bucket_policy.humio_auto_subscription_bucket_policy
  ]

}


resource "aws_cloudwatch_event_rule" "humio_auto_subscription_eventrule" {
  count = var.humio_auto_subscription ? 1 : 0

  name          = "humio-auto-subscription-rule-${var.name}"
  description   = "Humio log group auto subscription event rule"
  event_pattern = <<PATTERN
{
  "source":["aws.logs"],
  "detail-type":["AWS API Call via CloudTrail"],
  "detail":{
    "eventSource":["logs.amazonaws.com"],
    "eventName":["CreateLogGroup"]
  }
}
PATTERN

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )

  depends_on = [
    aws_lambda_function.humio_cloudwatch_auto_subscriber
  ]

}

resource "aws_cloudwatch_event_target" "humio_auto_subscription_eventrule_target" {

  rule      = aws_cloudwatch_event_rule.humio_auto_subscription_eventrule[0].name
  target_id = "humio-auto-subscription-rule-${var.name}"
  arn       = aws_lambda_function.humio_cloudwatch_auto_subscriber.arn

}


# Backfiller lambda needs to be invoked to subscribe old log groups
data "aws_lambda_invocation" "humio_cloudwatch_back_filler" {
  function_name = aws_lambda_function.humio_cloudwatch_back_filler.function_name

  input = <<JSON
{
  "action": "manual_invoke"
}
JSON

  depends_on = [
    aws_lambda_function.humio_cloudwatch_back_filler
  ]

}
