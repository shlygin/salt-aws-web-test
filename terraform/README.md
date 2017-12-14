# Terraform templates

This tempate creates new VPC, subnet, security group (22 and 80 ports from outside only) and web instance.
AMI id and keypair should be passed as variables (no default value).
Combination of access/secret keys or profile can be used to authenticate with AWS provider (should be placed in tfvars or use ENV).

IP of new instance can be found in output.

## examples:

```
# Launch stack
$ terraform apply

# Destroy stack
$ terraform deploy
```

## aws credentials usage:
If you want to use profile as credentials source put this in terraform.tfvars:
``` profile="<profile_name>" ```

Access/secret keys usage:
``` 
access="<access_key>"
secret="<secret_key>"
```
