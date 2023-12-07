# Check Point - Home Test

## Terraform
AWS:
- S3 bucket
- Lambda python function
- IAM role for Lambda
- API Gateway

GitHub:
- Repository
- Webhook with Pull requests option

## Lambda
The lambda is running with Python 3.10 and require the following requirements:
- `pygithub`: In order to pull the github information
- `boto3`: In order to upload data to S3
In order to uploade the code please run the `zip.sh` script under the `Python` folder, this script will install and package your zip file you will need for the lambda.

>Notice: Please do not use MacOS M1 proccsor in order to build the Python package, the Lambda will not work as it will be incompatible.

### Lambda IAM permissions
- `Lambda`: `GetObject`, `PutObject`, [Lambda execution role](https://docs.aws.amazon.com/lambda/latest/dg/lambda-intro-execution-role.html)

### Variables for Lambda
List of variables needed for the Lambda to work
- `bucket_name`: The name of the S3 bucket that will keep the logs
- `github_access_token`: GitHub access token that with all the repo permissions.