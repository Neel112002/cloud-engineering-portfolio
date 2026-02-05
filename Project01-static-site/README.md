## CI/CD Pipeline

This project uses GitHub Actions to automatically deploy a static website to AWS S3.

Pipeline steps:

- Triggered on push to `main`
- Syncs site files to S3
- Invalidates CloudFront cache to reflect updates

This demonstrates CI/CD automation and AWS deployment workflows.
