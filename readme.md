# Terraform workshop

In this example, we are creating a lambda function that can read/write in a DynamoDB table, using Terraform.

## Installation

- Be sure to have installed and configureed terraform and aws CLIs on your machine

Note that the identity used for aws needs specific permissions for S3, dynamoDB, IAM, lambda. More details will be displayed the first time you'll run the build.

```
yarn install
```

```
terraform init
```

## Execution

```
yarn build
```
