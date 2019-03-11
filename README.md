Code which instantiate a Vault/Consul Cluster on AWS leveraging Iain Gray Terraform [Vault AWS Module](https://github.com/iainthegray/terraform-aws-vault)

# Deployment workflow

## Variables

First update the variable values in `terraform.tfvars` to reflect:

- `global_region`: in which region you want to deploy your cluster
- `dns_domain`: domain name of your deployment.
- `cluster_name`: Vault cluster name
- `vault_cluster_size`: How many Vault nodes to deploy
- `consul_cluster_size`: How many Consul nodes to deploy
- `instance_type`: instance form factor
- `ami_id`: AMI to use for the instances
- `my_bucket`: AWS S3 bucket where binairies and required files will be uploaded
- `ssh_key_name`: name of the AWS SSH key to use for our instances.
- `vpc_name`: Name of the VPC to create
- `availability_zones`: AZ where to deploy our nodes.
- `private_subnets`: Private subnets to create
- `public_subnets`: Public subnets to create
- `aws_access_key`: AWS access key, used for further automation  [Optional].

## S3 Bucket

You can now start the deployment workflow by initializing Terraform and creating a S3 bucket:

    terraform init
    terraform apply -target=module.private_s3

## Uploading required files

Now that our bucket has been created, you need to upload the required Certificates and scripts and binaries to it:

- cert.pem
- key.pem
- install-consul.sh
- install-final.sh
- install-vault.sh
- vault-enterprise_1.0.2+ent_linux_amd64.zip (if you want to deploy an enterprise cluster)

You'll find the install files in the following location there https://github.com/iainthegray/terraform-aws-vault/tree/master/packer/install_files

For TLS certificates I'm using [Let's Encrypt](https://letsencrypt.org/).

You can easily deploy an Open Source Vault cluster using the same code by replacing in `vault_cluster.tf` the following line

    vault_bin      = "vault-enterprise_1.0.2+ent_linux_amd64.zip"

by

    vault_version  = "1.0.3"

This will insure the Vault OSS binaries will be directly downloaded from HashiCorp release page.

## Deployment

You're now ready to deploy your cluster

```markdown
 terraform apply
```
