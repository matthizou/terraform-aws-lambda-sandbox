import:
	terraform import aws_dynamodb_table.article_db Articles
	terraform import aws_lambda_function.myLambda article
	terraform import aws_s3_bucket.article_lambda_bucket lambda-article
	terraform import aws_iam_role.article_admin_role articleAdmin
