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
    
    ``` 

4. Terraforming
    
    1. Bootstrapping the remote terraform state storage
        ```shell script
        cd ~/workspace/ddos-resilient-reference-architecture/prod/bootstrap
        terraform apply
        ```  
        
    