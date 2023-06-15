# Terraform

## prequsites:

## prequsites:

- [git][git] (utils: tree, [curl][curl], [tmux][tmux])
- [terraform cli][tf-cli] (1.2.0+) installed.
- AWS / DO / GCP / AZURE account and associated credentials for creating resources.
- Cloud provider cli for Auth config:
  - [AWS][aws-cli].
  - [GCP][gcp-cli].
  - [Digital Ocean][do-cli].
  - [Azure][azure-cli].

### Ready->

#### 0:
- configuring state to sit on s3 bucket, remotly
- Refer to the [gist][tf_r_0-gist].

#### 1:
- Basic provisioning of vpc, sg, ec2 & a load balancer.
- Refer to the [gist][tf_r_1-gist].


[git]: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
[curl]: https://curl.se/
[tmux]: https://github.com/tmux/tmux/wiki

[tf-cli]: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

[aws-cli]: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

[gcp-cli]: https://cloud.google.com/sdk/docs/install
[do-cli]: https://docs.digitalocean.com/reference/doctl/how-to/install/
[azure-cli]: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

[tf_r_0-gist]: https://gist.github.com/Slvr-one/224046e8936999c017181049cf373bc9 

[tf_r_1-gist]: https://gist.github.com/Slvr-one/1f6f46af65e82c9653389141369b8c30