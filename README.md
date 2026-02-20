# Stocks Serverless Pipeline

This project implements an automated, serverless data pipeline on AWS that tracks a daily "Top Mover" stock from a predefined watchlist. The system runs automatically every day, stores results in DynamoDB, and exposes a REST API that a frontend uses to visualize the last 7 days of top movers.

## Goal
Each day, the system:
1. Fetches daily stock data for a fixed watchlist:
["AAPL", "MSFT", "GOOGL", "AMZN", "TSLA", "NVDA"]
2. Computes which stock had the **highest absolute percentage change**.
3. Stores the result in DynamoDB.
4. Exposes a public API (`GET /movers`) to retrieve the last 7 days of winners.
5. Displays the results on a simple web dashboard.

---

## Architecture Overview

This project uses the following AWS services:

- **EventBridge (Cron Job)** → Triggers ingestion daily  
- **AWS Lambda (Ingestion)** → Fetches stock data & computes winner  
- **DynamoDB** → Stores daily top movers  
- **API Gateway + Lambda** → Serves `GET /movers` endpoint  
- **AWS Amplify** → Hosts frontend dashboard  

---

## Prerequisites (Required)

Before deploying or running this project, you must have:

### 1. AWS Account
You need an active AWS account (Free Tier is sufficient).

### 2. AWS CLI Installed & Configured

Install AWS CLI:
https://aws.amazon.com/cli/

Then configure your credentials:
```bash
aws configure
```
You will be prompted for:

AWS Access Key ID

AWS Secret Access Key

Default region (e.g., us-east-1)

Default output format (json)

⚠️ Your IAM user must have permissions to create:

Lambda

DynamoDB

API Gateway

EventBridge

S3 / Amplify

IAM roles

### 3. Massive.com API Key

Go to: https://www.massive.com and create an account.

Fetch your defualt API KEY and store in AWS Secret Manager and keep a note of the secret name to configure it in the environment variable.

# Setup Instructions

## 1. Clone the Repository

```bash
git clone https://github.com/adityas0604/pnmac-project.git
cd pnmac-project
```

## 2. Backend Set Up

### Install Dependencies

```bash
cd backend
npm i
```

### Configure Environment Variables

A sample environment file is provided in the repository as `.env.example` with a description. Set up all the required variables

**Important:** In addition to your local `.env` file, you must also set the same environment variables in your AWS Lambda configuration after deployment.

### Deploy the Infrastructure 

#### Option 1: Serverless Framework

```bash
npm run deploy
```
#### Option 2: Terraform

```
npm run build

cd terraform

terraform init

terraform plan # Optional: To see the chages that Terraform will make to your infrastructure

npm run deploy:terraform
```

### Seed DynamoDB with the required data of past 7 trading days

To populate DynamoDB with the last **7 trading days** of “winner” records (useful for first-time setup or testing)

```bash
npm run seed
```

### Run Locally (Optional)
```bash
npm run dev
```

## 3. Frontend Setup 

### Install dependencies and Set up Env Variable

``` bash
cd frontend
npm i
```
### Deploy Frontend Resources

#### Option 1: AWS Amplify

##### Install and Set Up Amplify CLI  (one-time)

```bash
npm install -g @aws-amplify/cli
```
Configure Amplify with your AWS credentials:

```bash
amplify configure
```

```bash
cd frontend
amplify add hosting
```
##### Deploy to AWS Amplify

```bash
npm run deploy
```
#### Option 2: Private S3 bucket + CloudFront 

##### Initialize Terraform

```bash
cd terraform
terraform init
terraform plan # Optional: To see the chages that Terraform will make to your infrastructure
```
##### Deploy Infrastructure

```
npm run deploy:terraform
```

This will:
- Build the project
- Add artificats to S3
- Invalidate CloudFront cache

### Run Locally (Optional)
```bash
npm run dev
```




















