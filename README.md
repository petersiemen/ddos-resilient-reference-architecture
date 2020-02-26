# ddos-resilient-reference-architecture

Fully functional kickstarter codebase for a DDoS resilient architecture
on AWS described in the AWS whitepaper [AWS Best Practices for DDos Resiliency](https://d0.awsstatic.com/whitepapers/Security/DDoS_White_Paper.pdf)

Best practices in the AWS cloud to mitigate the risk of infrastructure and application layer
attacks in extendable and reusable [terraform](https://www.terraform.io/) modules.



### Getting Started


1. Prerequisites
    * [aws-cli](https://aws.amazon.com/cli/) 
    * [terraform](https://www.terraform.io/)
    * AWS account
    * IAM user in AWS with programmatic access activate (ACCESS_KEY_ID, SECRET_ACCESS_KEY)
    * configure [aws-cli](https://aws.amazon.com/cli/) to use a AWS_PROFILE with the downloaded ACCESS_KEY_ID, SECRET_ACCESS_KEY associated
    * Register a domain that you own in AWS Route53  
2. Prepare environment
    2.1
    ```shell script
    cd ~/workspace/ddos-resilient-reference-architecture
    cp example.auto.tfvars ./prod/env.auto.tfvars
    ```
3. Alias Terraform to use your AWS_PROFILE
    ```shell script
    alias terraform-REPLACE_WITH_YOUR_AWS_PROFILE="AWS_PROFILE=REPLACE_WITH_YOUR_AWS_PROFILE terraform"
    ``` 

4. Terraforming ...
    
    1. **bootstrap** the remote terraform state storage. 
    Terraform the S3 bucket and one DynamoDB table for storing the state of each layer and its lock. 
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/bootstrap
        terraform init 
        terraform apply
        ```  
    2. The foundation of an infrastructure with a minimal attack surface is  
    a custom **VPC (virtual private network)**. Each instance and service should be hardened by
    a custom set of **nacl's (network access control lists)** and **Security Groups** inside this VPC.
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/vpc
        terraform init
        terraform apply
        ```
    3. A **jumphost** will come in handy when something is not feeling right. We can ssh into the jumphost and onwards into the 
    private section of the custom VPC.  
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/jumphost
        terraform init
        terraform apply
        ```
    3. Create an **ssl certificate** using AWS certificate manager to be used in cloudfront 
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/certificates
        terraform init
        terraform apply
        ```       
              
    4. An **application load balancer** for our super simple flask page (flask because we want to make sure that dynamic content will be served later on through our CloudFront CDN) and
    an **autoscaling group**, it's **target group** and **launch template** (successor of launch configurations with some added functionality like versioning)
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/alb
        terraform init
        terraform apply
       
        cd ~/workspace/ddos-resilient-reference-architecture/prod/asg-webserver
        terraform init
        terraform apply
        ```
       
    5. A **web application firewall** with one simple rule configured to lock out "imaginary" rogue ip addresses from somewhere in china
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/waf
        terraform init
        terraform apply
        ```
          
    5. A **cloudfront distribution** that caches nothing by default. But since CloudFront only accepts well-formed HTTP connections it will help to 
    prevent many common DDoS attacks like SYN floods and UDP reflection attacks. 
    Going forward this cloudfront distribution can of course be extended to cache static content for specific URL paths.
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/cloudfront
        terraform init
        terraform apply
        ```