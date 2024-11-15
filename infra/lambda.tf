data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "deno_test_lambda_role" {
  name               = "deno-test-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "deno_test_lambda_role_attachment" {
  role       = aws_iam_role.deno_test_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "deno_test" {
  function_name = "deno-test"
  role          = aws_iam_role.deno_test_lambda_role.arn
  image_uri     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/deno-aws:${var.git_sha}"
  package_type  = "Image"

}

/* generate a url for the function */
resource "aws_lambda_function_url" "deno_test_url" {
  function_name      = aws_lambda_function.deno_test.function_name
  authorization_type = "NONE"
}