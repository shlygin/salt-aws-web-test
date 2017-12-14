# Packer builder

Template in this folder creates a new ami from official Centos 7 HVM image (Marketplace).
New ami name will be 'centos-7-zfree {{timestamp}}'. On first run it can ask for legal agreement.

```
# AWS credentials profile can be used:
$ packer build -var 'profile=zfree-dev' build.json

# or access/secret pair
$ packer build -var 'access=<access_key>' -var 'secret=<secret_key>' build.json
```
