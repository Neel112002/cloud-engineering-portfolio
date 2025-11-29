# Project 01 — Static Website Deployment on AWS (S3 + CloudFront + Terraform)

This project deploys a static website to AWS using Amazon S3 for hosting and Amazon CloudFront as a Content Delivery Network (CDN). All infrastructure resources are managed using Terraform, enabling reproducible, version-controlled deployments that follow Infrastructure as Code (IaC) best practices.

---

## Live Application

| Endpoint | Purpose |
|---------|---------|
| CloudFront URL | https://d52yylkcad2ep.cloudfront.net |
| S3 Website Endpoint | http://neel-static-demo-d9476064.s3-website.ca-central-1.amazonaws.com |

Use the CloudFront URL for accessing the website, as it provides HTTPS, improved performance, and global edge caching.

---

## Project Overview

The project demonstrates a fully serverless website hosting architecture using AWS services. It ensures low latency delivery, HTTPS access, zero server maintenance, and minimal operating cost — ideal for organizations deploying frontend static applications.

---

## Request Flow

1. The user requests the website via the CloudFront URL from a browser.
2. CloudFront checks its cache at the nearest AWS Edge Location.
3. If the content is cached, CloudFront returns it immediately.
4. If not cached, CloudFront forwards the request to the S3 website endpoint.
5. Amazon S3 serves the static HTML object.
6. CloudFront caches the object for subsequent users.
7. The response is returned to the user over HTTPS.

```mermaid
graph TD
    U[User Browser] -->|HTTPS Request| CF[CloudFront CDN]
    CF -->|Cache Miss| S3[S3 Static Website]
    S3 --> CF
    CF -->|Response| U


## Tech Stack 

| Component              | Technology        | Purpose                          |
| ---------------------- | ----------------- | -------------------------------- |
| Storage & Hosting      | Amazon S3         | Static file hosting              |
| CDN, SSL & Caching     | Amazon CloudFront | Global edge distribution & HTTPS |
| Infrastructure as Code | Terraform         | Declarative provisioning         |
| Deployment Tool        | AWS CLI           | Uploading static assets          |
| Region                 | ca-central-1      | Canadian deployment region       |

## Project Structure

Project01-static-site/
├── infra/                    # Terraform configuration
│   └── main.tf               # S3, CloudFront, IAM policy, outputs
└── web/                      # Website frontend
    ├── index.html            # Home page
    └── 404.html              # Error page

## Infrastructure Details

| Resource                                 | Description                               |
| ---------------------------------------- | ----------------------------------------- |
| aws_s3_bucket.site                       | S3 bucket hosting the website             |
| aws_s3_bucket_website_configuration.site | Enables index/404 routing                 |
| aws_s3_bucket_policy.public_read         | Grants public read access                 |
| aws_s3_bucket_public_access_block.public | Configures bucket to allow website access |
| aws_cloudfront_distribution.cdn          | CDN serving content globally over HTTPS   |
| random_id.suffix                         | Ensures unique bucket naming              |


## Deployment Steps

 1. Provision Infrastructure
 cd infra
 terraform init
terraform apply -auto-approve

 2. Upload Website Files
  cd ../web
BUCKET=$(terraform -chdir=../infra output -raw bucket_name)

 aws s3 cp index.html s3://$BUCKET/index.html
 naws s3 cp 404.html s3://$BUCKET/404.html

 3. Access Website

 Open the CloudFront domain from Terraform outputs or the URL listed above.

 Updating the Website

 If you modify index.html, update the deployed version:

 aws s3 cp index.html s3://$BUCKET/index.html


If CloudFront still shows the old version, invalidate the cache:

aws cloudfront create-invalidation --distribution-id <ID> --paths "/*"

## Cost Considerations

This architecture operates within the AWS Free Tier limits:

S3 storage and requests are minimal

CloudFront offers 1 TB/mo free data transfer for the first year

No EC2 instances, no servers, zero maintenance

## Key Skills Demonstrated

Deploying static websites using Amazon S3

Integrating CloudFront for global delivery and HTTPS

Managing AWS public access policies securely

Using Terraform to provision cloud infrastructure

Structuring cloud projects for real-world engineering use cases
