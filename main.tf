provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "ddbtable" {
  name           = "mattsTestDB"
  hash_key       = "id"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "matts_test_policy"
  role = aws_iam_role.role_for_LDC.id

  policy = file("policy.json")
}


resource "aws_iam_role" "role_for_LDC" {
  name = "mattsTestRole"

  assume_role_policy = file("assume_role_policy.json")

}

data "archive_file" "my_lambda_function_zip" {
  type        = "zip"
  source_dir  = "./dist"
  output_path = "dist/lambda.zip"
}

resource "aws_lambda_function" "func" {
  filename      = "function.zip"
  function_name = "matts-sandbox"
  source_code_hash = data.archive_file.my_lambda_function_zip.output_base64sha256
  #s3_bucket     = "matts-bucket-1"
  #s3_key        = "index-1.zip"
  role          = aws_iam_role.role_for_LDC.arn
  handler       = "index.handler"
  runtime       = "nodejs12.x"
}
