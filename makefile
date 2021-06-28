
# zipCode:
# 	mkdir -p dist
# 	rm -f dist/function.zip
# 	(cd lambda && zip -r ../dist/function.zip .)

# uploadLambda:
# 	aws s3 cp dist/function.zip s3://matts-bucket-1/index.zip

# uploadLambda2:
# 	aws lambda update-function-code --function-name my-function --zip-file fileb://function.zip

clean:
	rm -rf dist

# terraform:
# 	terraform apply

build: clean
	yarn --cwd ./lambda
	ncc build lambda/index.js -o dist   
	terraform apply


destroy: clean
	terraform destroy

# build: clean zipCode uploadLambda terraform