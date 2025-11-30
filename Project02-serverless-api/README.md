Project 02 — Serverless Feedback API (API Gateway + Lambda + DynamoDB + Terraform)

This project implements a fully serverless backend API for collecting website feedback. It is part of my Cloud Engineering Portfolio, demonstrating serverless design, API development, event-driven architecture, and Infrastructure as Code using Terraform.

🌐 Live API Endpoint

Base Invoke URL:

https://<api-id>.execute-api.ca-central-1.amazonaws.com


Feedback Endpoint:

POST /feedback

📌 Project Overview

This backend service is designed to integrate seamlessly with a static website (Project 01). Users submit feedback, which gets processed by a Lambda function and stored in DynamoDB. All AWS resources (Lambda, API Gateway, DynamoDB, IAM) are automatically provisioned using Terraform.

🧩 Architecture Diagram
flowchart TD
    A[Static Website<br/>Project 01] -->|POST /feedback| B[API Gateway<br/>HTTP API]
    B --> C[Lambda Function<br/>Python Handler]
    C --> D[DynamoDB<br/>project02-feedback Table]
    C --> E[CloudWatch Logs<br/>Monitoring]

🔄 Request Flow

User submits feedback from Project 01 form.

API Gateway receives POST /feedback.

API Gateway triggers Lambda (Python).

Lambda validates input and writes a new record to DynamoDB.

Lambda returns JSON response (message, id).

Browser displays success message.

🧰 Tech Stack
Component	Technology	Purpose
API Layer	Amazon API Gateway (HTTP API)	Exposes REST endpoint
Compute	AWS Lambda (Python 3.12)	Handles feedback logic
Storage	Amazon DynamoDB	Stores feedback messages
IaC	Terraform	Infrastructure provisioning
Monitoring	CloudWatch Logs	Lambda logs
Region	ca-central-1	Canadian deployment
📂 Project Structure
Project02-serverless-api/
├── infra/
│   ├── main.tf        # Terraform: API Gateway, Lambda, DynamoDB, IAM
│   └── lambda.zip     # Packaged Lambda function
└── src/
    └── app.py         # Python Lambda handler

📝 Lambda Function Behavior

Parses JSON request body

Validates fields: name, email, message

Generates UUID (id)

Writes item to DynamoDB

Returns JSON response:

{
  "message": "Feedback saved",
  "id": "uuid-value"
}

🗄️ DynamoDB Record Example
{
  "id": "d9f9bca2-1dd5-4c0c-9ec4-6494fb036ad2",
  "name": "Neel",
  "email": "neel@example.com",
  "message": "Testing feedback",
  "created_at": "2025-11-29T22:14:00Z"
}

🌐 Integration With Project 01 (Frontend)

The static site uses:

fetch(FEEDBACK_API_URL, {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify(payload)
})


The browser form directly sends requests to this API, creating a full frontend → backend → database workflow.

💰 Cost & Free Tier
Service	Usage	Cost
Lambda	Free-tier (1M requests/month)	$0
API Gateway HTTP API	Very low traffic	$0
DynamoDB	Pay-per-request	~$0
CloudWatch Logs	Minimal usage	Free-tier

Total cost: $0 (portfolio demonstration).

🧠 Skills Demonstrated

Serverless architecture design

API Gateway + Lambda integration

DynamoDB table design (single primary key)

IAM least-privilege policy setup

Terraform-based provisioning

CORS configuration

Packaging and deploying Lambda functions

Observability via CloudWatch

Integration with static frontend

🏁 Summary

Project 02 delivers a real, production-style serverless backend powering the feedback form of the static site (Project 01). It demonstrates strong cloud engineering foundations with AWS serverless services and IaC.