# Serverless Bitcoin Price Monitor

An infrastructure-as-code lab that deploys a scheduled AWS Lambda function for retrieving the current Bitcoin price and writing a structured result to CloudWatch Logs.

This project demonstrates how Python application code, AWS services, Terraform, IAM, monitoring, and a Jenkins deployment pipeline can be combined into a small serverless workflow.

## Background

The goal was to automate a recurring data-collection task without maintaining a continuously running server. Terraform defines the AWS infrastructure, Python performs the API request and formats the result, and Amazon EventBridge (represented in this Terraform version by CloudWatch Events resources) invokes the Lambda function once per hour.

This is a learning and portfolio project rather than a production trading system. It retrieves and logs market data; it does not place trades.

## Architecture

1. An hourly AWS event rule invokes the Lambda function.
2. The Python handler requests the current BTC/USD price from the CoinDesk API.
3. The function produces a JSON record containing the ticker, current price, and Unix timestamp.
4. CloudWatch Logs stores the Lambda output with 30-day retention.
5. Lambda Insights provides additional runtime observability.
6. Terraform provisions the Lambda function, event schedule, IAM role, policies, permissions, and log group.
7. The Jenkins pipeline illustrates packaging Python dependencies and applying the Terraform configuration.

## Technologies

- Python 3.9
- Terraform
- AWS Lambda
- Amazon CloudWatch Logs and Lambda Insights
- Amazon EventBridge / CloudWatch Events
- AWS IAM
- Jenkins
- Git

## Repository Structure

```text
.
├── Jenkinsfile
└── terraform
    ├── btc.py
    ├── btc.zip
    ├── main.tf
    └── variables.tf
```

- `btc.py`: Lambda handler that retrieves and formats BTC/USD price data.
- `main.tf`: AWS Lambda, IAM, logging, monitoring, scheduling, and invocation permissions.
- `variables.tf`: Configurable Lambda function name.
- `Jenkinsfile`: Example CI/CD workflow for dependency packaging and Terraform deployment.
- `btc.zip`: Historical deployment package retained with the original lab.

## Skills Demonstrated

- Designing an event-driven serverless workflow
- Defining cloud resources with infrastructure as code
- Configuring IAM trust and logging permissions
- Scheduling recurring Lambda invocations
- Adding logging, retention, and Lambda Insights
- Packaging Python dependencies for Lambda
- Automating infrastructure deployment with Jenkins

## Deployment Notes

This repository is preserved as an educational implementation and may require updates before deployment because cloud-provider versions, external APIs, and dependency-packaging methods change over time.

Before experimenting:

1. Install Terraform, Python 3, and the AWS CLI.
2. Configure an AWS account and credentials with only the permissions required for the lab.
3. Review all Terraform resources and expected AWS charges.
4. Rebuild the Lambda deployment package instead of assuming the committed archive is current.
5. Update the external price API if the historical endpoint is no longer available.
6. Run `terraform fmt`, `terraform validate`, and `terraform plan` before applying changes.
7. Remove lab resources with `terraform destroy` when finished.

Never commit AWS credentials, API keys, Terraform state files, or other secrets.

## Possible Improvements

- Replace the historical price endpoint with a currently supported API
- Store observations in DynamoDB or S3
- Add CloudWatch alarms and failure notifications
- Add automated tests for the Python handler
- Pin Terraform provider and Python dependency versions
- Use a remote, encrypted Terraform state backend
- Add Jenkins validation and approval stages before deployment
