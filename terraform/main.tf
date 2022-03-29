resource "aws_lambda_function" "btc_lambda" {
   filename      = "btc.zip"
   function_name = var.lambda_function_name
   role          = aws_iam_role.iam_for_lambda.arn
   handler       = "btc.lambda_handler"
   runtime       = "python3.9"

   layers = [
    "arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension:18"
  ]
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.btc_log,
  ]
}


resource "aws_cloudwatch_log_group" "btc_log" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 30
}


resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role     = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
resource "aws_iam_role_policy_attachment" "insights_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

resource "aws_cloudwatch_event_rule" "every_hour" {
    name = "every-hour"
    description = "Triggers every 1 hour"
    schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "check_every_hour" {
    rule = "${aws_cloudwatch_event_rule.every_hour.name}"
    target_id = "btc_lambda"
    arn = "${aws_lambda_function.btc_lambda.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.btc_lambda.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.every_hour.arn}"
}