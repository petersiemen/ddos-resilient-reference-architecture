# ddos-resilient-reference-architecture

A fully functional kickstarter codebase for the DDoS resilient reference architecture
on AWS described in the AWS whitepaper [AWS Best Practices for DDos Resiliency](https://d0.awsstatic.com/whitepapers/Security/DDoS_White_Paper.pdf)


### Getting Started


1. Prerequisites
    * [aws-cli](https://aws.amazon.com/cli/) 
    * [terraform](https://www.terraform.io/)
    * [terragrunt](https://terragrunt.gruntwork.io/)
    * AWS account
    * IAM user in AWS with programmatic access activate (ACCESS_KEY_ID, SECRET_ACCESS_KEY)
    * configure [aws-cli](https://aws.amazon.com/cli/) to use a AWS_PROFILE with the downloaded ACCESS_KEY_ID, SECRET_ACCESS_KEY associated
    * Buy a domain and register it in AWS Route53  
    
2. Prepare environment
    ```shell script
    cd ~/workspace/ddos-resilient-reference-architecture
    cp example.env ./prod/.env
    ```
3. Alias **terraform** and **terragrunt** to use your AWS_PROFILE
    ```shell script
    alias aws-REPLACE_WITH_YOUR_AWS_PROFILE="AWS_PROFILE=REPLACE_WITH_YOUR_AWS_PROFILE aws"
    alias terraform-REPLACE_WITH_YOUR_AWS_PROFILE="AWS_PROFILE=REPLACE_WITH_YOUR_AWS_PROFILE terraform"
    alias terragrunt-REPLACE_WITH_YOUR_AWS_PROFILE="AWS_PROFILE=REPLACE_WITH_YOUR_AWS_PROFILE terragrunt"
    alias sam-REPLACE_WITH_YOUR_AWS_PROFILE="AWS_PROFILE=REPLACE_WITH_YOUR_AWS_PROFILE sam"
    ``` 
4. In order to create the ddos resilient architecture in one go using **terragrunt** we need to have one S3 bucket
in place that we use as an artifact store for our **AWS Lambda** functions.
    ```shell script
    cd ~/workspace/ddos-resilient-reference-architecture/prod/s3
    source ../.env
    terragrunt-REPLACE_WITH_YOUR_AWS_PROFILE apply
    ```   
5. A **AWS Lambda** function that ensures that the security groups we attach to the **alb** let through cloudfront requests. 
   The **lambda** function is triggered by the SNS event (AmazonIpSpaceChanged).
    * Clone the lambda function
        ```shell script
        cd ~/workspace 
        git clone git@github.com:petersiemen/update-security-group-for-cloudfront-access.git
        cd ~/workspace/update-security-group-for-cloudfront-access 
        sam package --s3-prefix update-security-group-for-cloudfront-access/v1.0 --s3-bucket REPLACE_WITH_YOUR_S3_BUCKET_FOR_LAMBDA_ARTIFACTS
        ```    
6. Another **AWS Lambda** function proxied by **API Gateway** to showcase how to securely host an API
using regional **API Gateway** deployments and a customer **CloudFront** distribution  
    * Clone the lambda function
        ```shell script
        cd ~/workspace 
        git clone git@github.com:petersiemen/lambda-api-gateway.git
        cd ~/workspace/lambda-api-gateway 
        sam package --s3-prefix lambda-api-gateway/v1.0 --s3-bucket REPLACE_WITH_YOUR_S3_BUCKET_FOR_LAMBDA_ARTIFACTS
        ``` 
7. Update `TF_VAR_lambda_update_security_groups_prefix` and `TF_VAR_lambda_api_gateway_prefix` in `~/workspace/ddos-resilient-reference-architecture/prod/.env` file with
the hashed prefix that both `sam package` commands returned.       
    
8. Terragrunt the ddos resilient reference architecture
    ```shell script
    cd ~/workspace/ddos-resilient-reference-architecture/prod
    source .env
    terragrunt-REPLACE_WITH_YOUR_AWS_PROFILE apply-all
    ```
   
9. We need to trigger the **AWS Lambda** function manually once to simulate the SNS Topic Notification (arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged)
in order to update the security groups attached to the **alb** with the up to date list of IP addresses of all cloudfront edge locations
    ```shell script
    aws-REPLACE_WITH_YOUR_AWS_PROFILE lambda invoke --function-name UpdateSecurityGroups --payload file://~/workspace/update-security-group-for-cloudfront-access/events/event.json response.json
    ```
