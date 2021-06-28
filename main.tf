provider "aws" {
  region = var.aws_region
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
  "Article": {"S": "Gauntlet of Misery"},
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
        "arn:aws:dynamodb:${var.aws_region}:*:table/Articles"
      ]
    }
  ]
}
EOF
}

# START - Policy attachment
# Rather than an inline policy attached/coupled to our role, we could create a generic policy, and linked it to the role via
# a policy attachment (loose coupling, can be used with multiple roles)
# 1/ Use aws_iam_policy instead of aws_iam_role_policy
# 2/ Add the following: 
# resource "aws_iam_role_policy_attachment" "my-policy-attach" {
#   role = "${aws_iam_role.role_for_lambda.name}"
#   policy_arn = "${aws_iam_policy.my-policy.arn}"
# }
# END - Policy attachment



data "archive_file" "article_lambda_zip" {
  type        = "zip"
  source_dir  = "./dist"
  output_path = "dist/lambda.zip"
}


resource "aws_lambda_function" "myLambda" {
  function_name = "article"
  filename      = "dist/lambda.zip"
  source_code_hash = data.archive_file.article_lambda_zip.output_base64sha256
  # s3_bucket     = "lambda-article"
  # s3_key        = "lambda.zip"
  role          = aws_iam_role.article_admin_role.arn
  handler       = "index.handler"
  runtime       = "nodejs12.x"
}


# START - Lambda code in S3
# If you have a large zip file (>50MB) for the lambda code, store it in S3
# Uncomment code below. 
# The only extra step required is to add the following properties into your lambda definition:
#   s3_bucket     = "lambda-article"
#   s3_key        = "lambda.zip"
# and remove `filename`

# resource "aws_s3_bucket" "article_lambda_bucket" {
#    bucket = "lambda-article"
#    acl = "private"
# }


# resource "aws_s3_bucket_object" "bucket_with_article_lambda_code" {
#   bucket = aws_s3_bucket.article_lambda_bucket.id
#   key    = "lambda.zip"
#   source = "dist/lambda.zip"
#   etag = data.archive_file.article_lambda_zip.output_base64sha256
# }
# END - Lambda code in S3