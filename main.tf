provider "aws" {
  # region = "us-east-1"
  region = "eu-west-3"
}


resource "aws_dynamodb_table" "article_db" {
  name           = "Articles"
  hash_key       = "Article"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  attribute {
    name = "Article"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "default-article" {
  table_name = aws_dynamodb_table.article_db.name
  hash_key   = aws_dynamodb_table.article_db.hash_key

  item = <<ITEM
{
  "Article": {"S": "Magic mandolina"},
  "Counter": {"N": "2"}
}
ITEM
}

resource "aws_iam_role" "article_admin_role" {
  name = "articleAdmin"
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

resource "aws_iam_role_policy" "article_admin_role_policy" {
  name = "article_policy"
  role = aws_iam_role.article_admin_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AccessObject",
      "Effect": "Allow",
      "Action": [
        "dynamodb:BatchGetItem",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:BatchWriteItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

# "Resource": "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${var.dynamodb_config_table}"

# resource "aws_iam_role_policy_attachment" "my-policy-attach" {
#   role = "${aws_iam_role.role_for_lambda.name}"
#   policy_arn = "${aws_iam_policy.my-policy.arn}"
# }

data "archive_file" "article_lambda_zip" {
  type        = "zip"
  source_dir  = "./dist"
  output_path = "dist/lambda.zip"
}

resource "aws_lambda_function" "myLambda" {
  function_name = "article"
  filename      = "dist/lambda.zip"
  source_code_hash = data.archive_file.article_lambda_zip.output_base64sha256
  #s3_bucket     = "lambda-article"
  #s3_key        = "lambda.zip"
  role          = aws_iam_role.article_admin_role.arn
  handler       = "index.handler"
  runtime       = "nodejs12.x"
}


resource "aws_s3_bucket" "article_lambda_bucket" {
   bucket = "lambda-article"
   acl = "private"
}