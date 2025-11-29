# Project 01 – AWS Static Website (S3 + CloudFront, Terraform)

This project deploys a globally available static website using **Amazon S3** for storage and **Amazon CloudFront** as a CDN, with all infrastructure managed using **Terraform**.  
The site is served over **HTTPS** using CloudFront’s default certificate (no custom domain needed).

> 💡 This is part of my Cloud Engineering learning path: starting with simple, production-style architectures and infrastructure-as-code.

---

## 🌍 Live Demo

> Replace the URL below with your own CloudFront domain.

**CloudFront URL:**  
`https://d52yylkcad2ep.cloudfront.net`

---

## 🧱 Architecture

```mermaid
graph TD
    U[User Browser] -->|HTTPS| CF[Amazon CloudFront<br/>Distribution]
    CF -->|HTTP| S3[S3 Static Website<br/>Public Bucket]

    subgraph AWS
      CF
      S3
    end

```markdown
## ⚙️ Infrastructure Details (Terraform)

**Main resources:**

- `aws_s3_bucket.site` – S3 bucket for the website.
- `aws_s3_bucket_website_configuration.site` – enables static website hosting.
- `aws_s3_bucket_public_access_block.public` – allows public policies for this bucket.
- `aws_s3_bucket_policy.public_read` – grants public `s3:GetObject` on `index.html`, `404.html`, etc.
- `aws_cloudfront_distribution.cdn` – CDN in front of the S3 website endpoint, using the **default CloudFront certificate** (HTTPS).

Outputs:

- `bucket_name` – name of the S3 bucket.
- `s3_website_url` – raw S3 website endpoint.
- `cloudfront_domain` – CloudFront domain (main URL to share).
