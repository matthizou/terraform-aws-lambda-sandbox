# This script is useful if an error happens in which you cannot rebuild and terraform tells you that the resources already exist
# Happens if you delete the terraform.tfstate file by mistake
terraform import aws_dynamodb_table.article_db Articles
terraform import aws_lambda_function.myLambda article
terraform import aws_s3_bucket.article_lambda_bucket lambda-article
terraform import aws_iam_role.article_admin_role articleAdmin