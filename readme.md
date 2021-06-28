# Terraform workshop

<img width="150" src="https://miro.medium.com/max/879/1*8r23G9nZvO-ETt-sdmp7Tw.png" />

In this example, we are creating a lambda function that can read in a DynamoDB table, using Terraform.
Along the way, we'll also:

- Create a role (and its policy) to give the required permissions to our lambda
- Use terraform to zip the code of the lambda, and then either store it on a S3 bucket, or inline in the lambda itself
- Use external dependency in a lambda (lodash here)
- Use a bundler reduce lambda's code size

## Installation

- Be sure to have installed and configured **terraform** and **aws** CLIs on your machine.

Note that the identity used for aws needs specific permissions for S3, dynamoDB, IAM, lambda. More details will be displayed the first time you'll run the build. If you don't want to bother, use admin roles for those services.

```
yarn install
```

```
terraform init
```

Set up your region and

## Execution

```
yarn build
# or
yarn build -auto-approve
```

## Resources

- Lambda to work with dynamoDB: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-dynamo-db.html
