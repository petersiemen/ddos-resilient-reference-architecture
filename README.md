# ddos-resilient-reference-architecture

A fully functional kickstarter codebase for the DDoS resilient reference architecture
on AWS described in the AWS whitepaper [AWS Best Practices for DDos Resiliency](https://d0.awsstatic.com/whitepapers/Security/DDoS_White_Paper.pdf)


### Getting Started


1. Prerequisites
    * [aws-cli](https://aws.amazon.com/cli/) 
    * [terraform](https://www.terraform.io/)
    * AWS account
    * IAM user in AWS with programmatic access activate (ACCESS_KEY_ID, SECRET_ACCESS_KEY)
    * configure [aws-cli](https://aws.amazon.com/cli/) to use a AWS_PROFILE with the downloaded ACCESS_KEY_ID, SECRET_ACCESS_KEY associated
    * Register a domain that you own in AWS Route53  
2. Prepare environment
    ```shell script
    cd ~/workspace/ddos-resilient-reference-architecture
    cp example.auto.tfvars ./prod/env.auto.tfvars
    ```
3. Alias Terraform to use your AWS_PROFILE
    ```shell script
    alias terraform-REPLACE_WITH_YOUR_AWS_PROFILE="AWS_PROFILE=REPLACE_WITH_YOUR_AWS_PROFILE terraform"
    ``` 

4. Terraforming the layers one by one:     
    1. **bootstrap** a s3 bucket and a dynamo table as a lockable remote storage for terraform's state 
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/bootstrap
        terraform init 
        terraform apply
        ```  
    2. The foundation of a secure infrastructure with a minimal attack surface is  
    a custom **VPC**. Subnets, instances and services will be nicely locked up by
    a custom set of **nacl's (network access control lists)** and **Security Groups**.
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/vpc
        terraform init
        terraform apply
        ```
    3. A **jumphost** / **bastion host** to ssh into the cloud if something is not feeling right. 
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/jumphost
        terraform init
        terraform apply
        ```
    4. A **ssl certificate**. We are going to terminate ssl on cloudfront.    
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/certificates
        terraform init
        terraform apply
        ```       
              
    5. An **application load balancer** for our simple flask page (flask because we want to test that dynamic content will really not be cached by CloudFront CDN) and
    an **autoscaling group**, it's **target group** and **launch template** (successor of launch configurations with some added functionality like versioning)
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/alb
        terraform init
        terraform apply
       
        cd ~/workspace/ddos-resilient-reference-architecture/prod/asg-webserver
        terraform init
        terraform apply
        ```
       
    6. A **web application firewall** with one simple rule configured to lock out "imaginary" rogue ip addresses from somewhere in china
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/waf
        terraform init
        terraform apply
        ```
          
    7. A **cloudfront distribution** that caches nothing by default. Since CloudFront only accepts well-formed HTTP connections it will help to 
    prevent many common DDoS attacks like SYN floods and UDP reflection attacks. 
    Going forward this cloudfront distribution can be extended to cache static content for specific URL paths.
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/cloudfront
        terraform init
        terraform apply
        ```

    8. A **lambda** function that ensures that the security groups we attached to the **alb** let thourgh    cloudfront requests. 
    The **lambda** function is triggered by the SNS event (AmazonIpSpaceChanged).
        * Clone the lambda function
            ```shell script
            cd ~/workspace 
            git clone git@github.com:petersiemen/update-security-group-for-cloudfront-access.git
            ```
        * Terraform an **s3** bucket that will serve as lamdba code artifact
            ```shell script
            cd ~/workspace/ddos-resilient-reference-architecture/prod/s3
            terraform init
            terraform apply
            ```
        * Package and update the lambda function to s3
            ```shell script
            cd ~/workspace/update-security-group-for-cloudfront-access 
            sam package --s3-prefix v1.0 --s3-bucket REPLACE_WITH_YOUR_S3_BUCKET_FOR_LAMBDA_ARTIFACTS
            ```
        * Terraform the **lambda** function, **iam role** and **iam policy** for lambda and 
        the **sns** topic that we are going to subscribe to
            ```shell script
            cd ~/workspace/ddos-resilient-reference-architecture/prod/lambda-update-security-groups
            terraform init
            terraform apply
            ```