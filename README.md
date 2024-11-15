# Deno 2.X AWS Lambda - End-to-End Workflow Example

This repository demonstrates how to use [Deno 2.X](https://deno.com/) in AWS
Lambda (or ECS) with a complete end-to-end workflow for building images,
publishing them to ECR, and provisioning Lambda functions.

## Overview

While AWS doesn't natively support Deno as a runtime, you can run custom
runtimes via containers. This example showcases:

1. Creating a custom image based on the
   [official Deno image](https://hub.docker.com/r/denoland/deno)
2. Incorporating the
   [aws-lambda-adaptor](https://github.com/awslabs/aws-lambda-web-adapter)
3. Implementing a minimal API server using [Hono](https://hono.dev/)
4. Publishing the image to AWS ECR
5. Provisioning AWS Lambda using Terraform

> **Note**: While this example uses Terraform, you can adapt it to your
> preferred Infrastructure as Code (IaC) tool.

## Repository Structure

```
deno-aws/
├─ .github/
│  ├─ workflows/           # GitHub Actions workflow examples
├─ infra/
│  ├─ lambda.tf            # AWS Lambda provisioning via Terraform
├─ src/
│  ├─ index.ts             # Hono web server implementation
├─ Dockerfile              # Custom runtime container definition
```

## Prerequisites

To use this example in your AWS account, you'll need:

1. **AWS Resources**:
   - An Elastic Container Repository (ECR) named `deno-aws`
   - IAM role for
     [GitHub OIDC](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
     named `github-oidc-deployer-dev`

2. **GitHub Secrets**:
   - `AWS_ACCOUNT_ID`
   - `AWS_REGION`

## Event Handling Architecture

Unlike traditional AWS Lambda functions that invoke a specific handler, this
example uses the
[aws-lambda-adaptor](https://github.com/awslabs/aws-lambda-web-adapter) to run a
web server that handles incoming events.

### Testing the Deployment

Once deployed, you can test the basic endpoint:

```bash
wget -qO- https://[function_url].lambda-url.[region].on.aws
# Returns: "Hello lambda!"
```

### Event Routing

The AWS Lambda Adapter routes events to `/events` by default. You can customize
this using the `AWS_LWA_PASS_THROUGH_PATH` environment variable.

#### Recommended Event Structure

For a macro-services architecture, consider creating a route for every event and
then setting the `AWS_LWA_PASS_THROUGH_PATH` for every lambda you provision.
Example:

```
/events/sqs/{queue-name}
/events/eventbridge/{event-name}
/events/s3/{bucket-name}
```

**Example SQS payload extracted from Hono**

```json
{
  "headers": {
    "content-length": "449",
    "content-type": "application/json",
    "host": "127.0.0.1:8080",
    "x-amzn-lambda-context": "{\"request_id\":\"9f3d0b98-1cfa-4ff9-a2f8-bf08ae6356b5\",\"deadline\":1731634692098,\"invoked_function_arn\":\"arn:aws:lambda:us-west-2:123456789012:function:deno-test\",\"xray_trace_id\":\"Root=1-6736a5ff-25b8e80625995fc3195d1db8;Parent=1cd4b7ac54511616;Sampled=0;Lineage=1:01bc76f7:0\",\"client_context\":null,\"identity\":null,\"env_config\":{\"function_name\":\"deno-test\",\"memory\":128,\"version\":\"$LATEST\",\"log_stream\":\"\",\"log_group\":\"\"}}",
    "x-amzn-request-context": "null",
    "x-amzn-trace-id": "Root=1-6736a5ff-25b8e80625995fc3195d1db8;Parent=1cd4b7ac54511616;Sampled=0;Lineage=1:01bc76f7:0"
  },
  "json": {
    "Records": [
      {
        "messageId": "19dd0b57-b21e-4ac1-bd88-01bbb068cb78",
        "receiptHandle": "MessageReceiptHandle",
        "body": "Hello from SQS!",
        "attributes": {
          "ApproximateReceiveCount": "1",
          "SentTimestamp": "1523232000000",
          "SenderId": "123456789012",
          "ApproximateFirstReceiveTimestamp": "1523232000001"
        },
        "messageAttributes": {},
        "md5OfBody": "{{{md5_of_body}}}",
        "eventSource": "aws:sqs",
        "eventSourceARN": "arn:aws:sqs:us-east-1:123456789012:MyQueue",
        "awsRegion": "us-east-1"
      }
    ]
  }
}
```

### Potential benefits

1. **Local Testing**: Event handlers can be tested locally using standard REST
   tools
2. **Reusable Images**: Set unique `AWS_LWA_PASS_THROUGH_PATH` values per Lambda
   to reuse the same image across multiple functions
3. **Consistent Interface**: Standardized approach to handling various AWS
   events

## Getting Started

1. Clone this repository
2. Configure AWS credentials and GitHub secrets
3. Deploy the ECR repository
4. Run the GitHub workflow to build and push the image
5. Apply the Terraform configuration to provision the Lambda function

## A note about ECS

You can reuse this image on ECS, no changes required 😍
