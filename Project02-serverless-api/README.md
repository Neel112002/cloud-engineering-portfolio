# Project 02 — Serverless Feedback API  
(API Gateway + Lambda + DynamoDB + Terraform)

This project implements a fully serverless backend API for collecting website feedback.  
It is part of my Cloud Engineering Portfolio and demonstrates API development, event-driven architecture, and Infrastructure as Code using Terraform.

---

## 🌐 Live API Endpoint

**Base Invoke URL:**  
```text
https://<your-api-id>.execute-api.ca-central-1.amazonaws.com

## 📌 Project Overview

This backend service is built to integrate with my static website (Project 01).  
When users submit feedback from the frontend form, the API receives the request, processes it through a Lambda function, and stores the data in DynamoDB.

All AWS resources—API Gateway, Lambda, DynamoDB, IAM roles—are automatically deployed using Terraform.

## 🔄 Request Flow

1. User submits feedback form from the Project 01 website.
2. API Gateway receives the POST `/feedback` request.
3. API Gateway passes the request to the Lambda function.
4. Lambda parses JSON, generates a UUID, and writes the item to DynamoDB.
5. DynamoDB stores the feedback.
6. Lambda returns `{ "message": "Feedback saved", "id": "<uuid>" }`.
7. CloudWatch Logs store execution logs for monitoring.

## 🧰 Tech Stack

| Layer       | Technology                                 |
|-------------|---------------------------------------------|
| Compute     | AWS Lambda (Python 3.12)                    |
| API Layer   | API Gateway (HTTP API)                      |
| Database    | DynamoDB (PAY_PER_REQUEST)                  |
| IaC         | Terraform                                   |
| Monitoring  | CloudWatch Logs                             |
| Region      | ca-central-1 (Canada)                       |

## 📂 Project Structure

Project02-serverless-api/
│
├── infra/
│   ├── main.tf        # Terraform: Lambda, API Gateway, DynamoDB, IAM
│   ├── lambda.zip     # Packaged Lambda code
│   └── app.py         # Python Lambda handler
│
└── README.md

## 🗂️ DynamoDB Schema

| Attribute | Type   | Description                     |
|----------|--------|---------------------------------|
| id       | String | Primary key (UUID)              |
| name     | String | User name                       |
| email    | String | Submitted email                 |
| message  | String | Feedback content                |

## 🧪 Testing the API

Use this cURL command to submit test feedback:

```bash
API_URL="https://<your-api-id>.execute-api.ca-central-1.amazonaws.com"

curl -X POST "$API_URL/feedback" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Neel",
    "email": "neel@example.com",
    "message": "This is test feedback"
  }'

## 🧠 Key Skills Demonstrated

- Designing and deploying serverless APIs with AWS
- Building event-driven Lambda architectures
- Working with DynamoDB NoSQL storage
- Implementing least-privilege IAM role policies
- Packaging Lambda functions in Python
- Infrastructure as Code with Terraform
- Connecting backend APIs with a static website frontend

