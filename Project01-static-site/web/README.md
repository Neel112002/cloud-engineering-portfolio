# 🚀 Project 01 — Static Website Deployment on AWS (S3 + CloudFront + Terraform)

This project deploys a static website using **Amazon S3** for hosting and **Amazon CloudFront** as a global CDN. All cloud resources are provisioned with **Terraform**, following Infrastructure as Code (IaC) best practices to ensure consistent, repeatable deployments without manual configuration.

---

## 🌐 Live Application

| Endpoint | Purpose |
|---------|---------|
| **CloudFront URL** | https://d52yylkcad2ep.cloudfront.net |
| **S3 Website URL** | http://neel-static-demo-d9476064.s3-website.ca-central-1.amazonaws.com |

> Always use the **CloudFront URL**. It provides HTTPS, caching, low latency, and global delivery.

---

## 📖 Project Overview

This project demonstrates a **serverless static hosting solution** using AWS. It requires **no servers**, provides global reach, supports automatic caching, and costs almost nothing to run — ideal for hosting personal portfolios, landing pages, product pages, and documentation sites.

---

## 🔁 Request Flow

1. User visits the CloudFront URL in their browser.
2. CloudFront checks the nearest AWS **Edge Location** for cached content.
3. If found, CloudFront responds instantly (**cache hit**).
4. If not, CloudFront forwards the request to the **S3 website**.
5. S3 returns the HTML file and assets.
6. CloudFront caches the response for future visitors.
7. The user receives the content over HTTPS.

```mermaid
graph TD
    U[User Browser] -->|HTTPS Request| CF[CloudFront CDN]
    CF -->|Cache Miss| S3[S3 Static Website]
    S3 --> CF
    CF -->|HTTPS Response| U
