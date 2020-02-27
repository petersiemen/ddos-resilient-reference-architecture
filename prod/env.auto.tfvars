aws_account_id = "982023434191"     # e.g. 123455678
aws_profile    = "free-development" # e.g. 123455678
aws_region     = "eu-central-1"     # Keep or use a region closer to you
aws_az_a       = "eu-central-1a"    # Keep or use a region closer to you

organization = "acme" # e.g. acme
env          = "prod" # e.g. prod or stag
domain       = "ddos-resilient-architecture.com"

tf_state_bucket = "acme-development-terraform-remote-state" # e.g. amce-terraform-remote-state
my_ip_address   = "91.65.136.126"                           # e.g. 91.65.136.222
aws_linux_2_ami = "ami-0df0e7600ad0913a9"                   #

admin_public_ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7u+xdOvvKxZYaG5sOREKYlwgH5Xfy0oIY8pIJ27d04kwoIWbbGuYXJ9C/1wOPq0URvOv6F5ztEyzAJ71KHREJymTwEqtrshIXqVokcAF76/QhEM+AtO0+7277WKtdsBPap4+jrwpJyUr2QaichfXHXBbDp56dpXCeXeool5d/ZuBg9RfFQM6V1aFwz7YroL3frJhRV2Eo/iSPPHspDQXlODcjYCVB/ECZy1dR56W8RsA8VivNGZJHtb1Py50tTgBRj1hFUIxEkFwQRB6cU8CFZw95T5j9xt1Adn1u6h2IBiv3EdLlM1F8YQdanwstWQT1ipgjtGJdGrZMfEoFrPcv peter@xps"
developer_name       = "peter"
developer_ssh_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7u+xdOvvKxZYaG5sOREKYlwgH5Xfy0oIY8pIJ27d04kwoIWbbGuYXJ9C/1wOPq0URvOv6F5ztEyzAJ71KHREJymTwEqtrshIXqVokcAF76/QhEM+AtO0+7277WKtdsBPap4+jrwpJyUr2QaichfXHXBbDp56dpXCeXeool5d/ZuBg9RfFQM6V1aFwz7YroL3frJhRV2Eo/iSPPHspDQXlODcjYCVB/ECZy1dR56W8RsA8VivNGZJHtb1Py50tTgBRj1hFUIxEkFwQRB6cU8CFZw95T5j9xt1Adn1u6h2IBiv3EdLlM1F8YQdanwstWQT1ipgjtGJdGrZMfEoFrPcv peter@xps"

lambda_functions_bucket = "acme-development-lambda-functions"

lambda_update_security_groups_prefix = "v1.0/2556bce27016954f6c7d70ec68022c6f"
lambda_api_gateway_prefix            = "lambda-api-gateway/v1.0/9a7c6f92b8444a84354ccfc83a1237a2"