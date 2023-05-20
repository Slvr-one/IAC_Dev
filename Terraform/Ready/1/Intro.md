
## prequsites:
1. git
2. tree 
3. [terraform cli][tf-cli]
4. [aws cli][aws-cli]

## Geting started:

You'll start by cloning this repo to a local folder, changing directory (cd) to the first example ready to use:

```bash
    git clone https://github.com/Slvr-one/IAC_Dev `$USER_tf_training`
    cd `$USER_tf_training`/Terraform/Ready/1
    tree
```

This example uses the aws provider with Terraform, which basically means terraform uses the AWS api to provision resources of AWS (such as vpc, ec2 vm's, s3 buckets, etc.).
Feel free to look around, youll notice a file structure that seperats to diffrent categories, files & directories like so:

```bash
    PWD/
    ├── network/
    │   ├── main.tf
    ├── compute/
    │   ├── main.tf
    ├── storage/
    │   ├── main.tf
    ├── external/
    │   ├── main.tf
    ├── providers.tf
    ├── outputs.tf
    ├── variables.tf
    ├── providers.tf
    ├── providers.tf
    ├── main.tf
    ├── terraform.tfvars
```

A standard procedure with Terraform, is that all files with .tf extensions are propagated with project initiatoion, it doesn't matter how many files you separate your code into, so might as well organise by resources.

Directories also form independent of each other, to create modularity of code, so its possible to call a module (a dir of .tf files) more than once, with different values injected into it, from the root directory's main.tf file which call those modules by relative path. 

See you understand the basic usage of the module:
network module: for the vpc, subnets
compute: for ec2 instances, load balancing
storage: s3 buckets and associated resources
tls:
external:
iam:
helm:

[tf-cli]: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
[aws-cli]: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html