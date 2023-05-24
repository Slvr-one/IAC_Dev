# Crossplane - Getting stated:

https://www.padok.fr/en/blog/kubernetes-infrastructure-crossplane

Crossplane can be considered as a Kubernetes add-on, which means that it makes use of custom resources to provide all of its functionality. There are 4 kinds of resources, which we are going to describe:

- Providers:
> They are the first kind of package in Crossplane’s terminology
  A package is simply an OCI image, like a Docker image for example
  It installs CustomResourceDefinitions to allow for the provisioning of resources on an external service like a cloud provider
  As of today, providers exist for AWS, GCP, Azure, Datadog, Alibaba, GitLab, Github, Kubernetes, and many more
- Managed resources:
> They are installed by Providers
  They represent infrastructure resources
- Configurations:
> They are the second kind of package according to Crossplane
  They leverage the CompositeResourceDefinition and Composition features of Crossplane
- Composite resources:
> They are defined using Crossplane configuration, as defined above
  They group-managed resources together to allow for the creation of more complex, business-oriented infrastructure resources

-  install the AWS provider:
> kubectl apply -f crossplane_config/aws_provider.yaml
- create a ProviderConfig:
> kubectl apply -f crossplane_config/aws_provider_config.yaml
- create resources:
> kubectl apply -f resources/