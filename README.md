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