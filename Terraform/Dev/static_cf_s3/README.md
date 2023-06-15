# S3 & CloudFront for Delivering Static Assets on the Web

<!-- https://www.velotio.com/engineering-blog/s3-cloudfront-to-deliver-static-asset -->


This configuration file creates a CloudFront distribution with an S3 bucket as the origin. 
It also creates an OAI and attaches it to the CloudFront distribution to access private S3 content via CloudFront. 
The S3 bucket policy is updated to allow access from the OAI.

adding an AWS WAFv2 Web ACL with a simple rule that blocks requests from countries other than the United States and Canada.
The Web ACL is then associated with the CloudFront distribution using the web_acl_id attribute.
Visibility configuration is enabled for both the Web ACL and the rule, 
which allows you to monitor requests using CloudWatch metrics and sampled requests.