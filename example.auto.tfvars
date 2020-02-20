#
#  IMPORTANT: all values must be quoted. otherwise terraform with throw a misleading exception
#

aws_account_id = "REPLACE_WITH_YOUR_ACCCOUNT_ID"        # e.g. "123455678"
aws_profile    = "REPLACE_WITH_YOUR_AWS_CLI_PROFILE_ID" # e.g. "123455678"
aws_region     = "eu-central-1"                         # Keep or use a region closer to you

tf_state_bucket = "REPLACE_WITH_THE_S3_BUCKET_TO_STORE_THE_REMOTE_TERRAFORM_STATE" # e.g. amce-terraform-remote-state

organization = "REPLACE_WITH_THE_ORG_YOU_ARE_WORKING_FOR" # e.g. acme
env          = "REPLACE_WITH_THE_ENV_YOU_ARE_WORKING_ON"  # e.g. prod or stag

aws_linux_2_ami = "ami-0df0e7600ad0913a9"        #
my_ip_address   = "REPLACE_WITH_YOUR_IP_ADDRESS" # e.g. 91.65.136.222

admin_public_ssh_key = "REPLACE_WITH_YOUR_SSH_KEY" # e.g. ssh-rsa AAAAB3NzaC1yc2BBBBBBBBBBBBBBBB+xdOvvKxZYaG5sOREKYlwgH5Xfy0oIY8pIJ27d04kwoIWbbGuYXJ9C/1wOPq0URvOv6F5ztEyzAJ71KHREJymTwEqtrshIXqVokcAF76/QhEM+AtO0+7277WKtdsBPap4+jrwpJyUr2QaichfXHXBbDp56dpXCeXeool5d/ZuBg9RfFQM6V1aFwz7YroL3frJhRV2Eo/iPy50tTgBRj1hFUIxEkFwQRB6cU8CFZw95T5j9xt1Adn1u6h2IBiv3EdLlM1F8YQdanwstWQT1ipgjtGJdGrZMfEoFrPcv admin@acme