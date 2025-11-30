# Project 02 — Serverless Feedback API  
(API Gateway + Lambda + DynamoDB + Terraform)

This project implements a fully serverless backend API for collecting website feedback.  
It is part of my Cloud Engineering Portfolio and demonstrates API development, event-driven architecture, and Infrastructure as Code using Terraform.

---

## 🌐 Live API Endpoint

**Base Invoke URL:**  
https://<your-api-id>.execute-api.ca-central-1.amazonaws.com

markdown
Copy code

**Feedback Endpoint:**  
POST /feedback

yaml
Copy code

---

## 📌 Project Overview

This backend service integrates with my static website (Project 01).  
When a user submits a feedback form, the data is processed by a Lambda function and stored in DynamoDB.

All resources (Lambda, API Gateway, DynamoDB, IAM) are provisioned automatically using Terraform.

---

## 🏗️ Architecture Diagram

```mermaid
flowchart TD
    A[Static Website\n(Project 01)] -->|POST /feedback| B(API Gateway\nHTTP API)
    B --> C(Lambda Function\nPython Handler)
    C --> D(DynamoDB Table\nproject02-feedback)
    C --> E(CloudWatch Logs\nMonitoring)
🔄 Request Flow
User submits feedback from the website (Project 01).

API Gateway receives the POST /feedback request.

API Gateway triggers the Lambda function.

Lambda parses JSON, assigns a UUID, and writes to DynamoDB.

Lambda returns a success message.

CloudWatch Logs capture execution details.

🧰 Tech Stack
Component	Technology
Compute	AWS Lambda (Python 3.12)
API Layer	API Gateway (HTTP API)
Database	DynamoDB (On-Demand PAY_PER_REQUEST)
IaC	Terraform
Logging	CloudWatch Logs
Region	ca-central-1

📂 Project Structure
python
Copy code
Project02-serverless-api/
│── infra/
│   ├── main.tf          # Terraform for Lambda, API Gateway, DynamoDB, IAM
│   ├── lambda.zip       # Packaged Lambda code
│   └── app.py           # Python Lambda handler
│
└── README.md
🗂️ DynamoDB Schema
Attribute	Type	Description
id	String (PK)	Auto-generated UUID
name	String	User name
email	String	User email
message	String	Feedback message

📬 Example API Request (Testing)
bash
Copy code
curl -X POST "https://<api-id>.execute-api.ca-central-1.amazonaws.com/feedback" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Neel",
    "email": "neel@example.com",
    "message": "This is test feedback"
  }'
Expected Response:

json
Copy code
{
  "message": "Feedback saved",
  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
🚀 Deployment Summary
terraform init — initialize providers

terraform apply — deploy all resources

terraform destroy — remove resources

Everything is deployed using repeatable Infrastructure as Code.

🧠 Key Skills Demonstrated
Building serverless backends

Designing event-driven systems

Implementing least-privilege IAM roles

Writing Lambda functions in Python

Provisioning AWS resources via Terraform

Integrating frontend static sites with backend APIs

