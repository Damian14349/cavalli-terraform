# WordPress Application Deployment with AWS (ALB, CloudFront, S3, RDS) and Terraform

## Project Overview

This project is designed to deploy a scalable WordPress application on AWS using a combination of Application Load Balancer (ALB), CloudFront as a CDN, S3 for static asset storage, and RDS for database management. It can be used in different Regions (in this example the Region is eu-central-1). The deployment is fully automated using **Terraform**.

## Infrastructure Components

1. **Application Load Balancer (ALB):** Distributes traffic across EC2 instances.
2. **Auto Scaling Group (ASG):** Automatically scales EC2 instances based on load.
3. **Amazon CloudFront (CDN):** Delivers content quickly by caching it globally.
4. **Amazon S3:** Used to store static assets like images.
5. **Amazon RDS (Relational Database Service):** Hosts the WordPress MySQL database.
6. **Amazon Cognito:** Handles user authentication.
7. **Amazon Route 53:** Manages DNS records to route traffic to CloudFront and ALB.
8. **AWS Certificate Manager (ACM):** Manages SSL certificates for HTTPS.

## Prerequisites

- AWS account with permissions to create EC2, S3, CloudFront, Route 53, RDS, and ACM resources.
- **Terraform** installed on your local machine.
- A registered domain name.
- Access to your domain registrar's DNS settings.
- SSL certificates issued in ACM

## Setup Instructions

### Step 1: Clone the Repository

```bash
git clone <repository-url>
cd <repository-folder>
```

### Step 2: Create SSL Certificates in AWS Certificate Manager (ACM)

- Go to the **AWS Certificate Manager (ACM)** in both **us-east-1** (for CloudFront) and your desired region (for ALB, e.g., **eu-central-1**).
- Request a certificate for your domain (e.g., `devopser.pl`) in both regions.
- Verify the domain ownership via **DNS** by adding the required CNAME records in **Route 53** or your domain registrar.

### Step 3: Configure DNS in Route 53

1. **Create Hosted Zone in Route 53:**

   - In **Route 53**, create a hosted zone for your domain (e.g., `devopser.pl`).

2. **Add DNS Records:**
   - Add an **A record** (alias) for your domain pointing to your **CloudFront distribution**.
   - Add **CNAME records** for SSL validation.

### Step 4: Initialize and Apply Terraform

Before applying Terraform, ensure you update the following variables:

- **`domain_name`** – Your registered domain name (e.g., `devopser.pl`).
- **`region`** – AWS region for ALB (e.g., `eu-central-1`).
- **`cert_arn`** – ARN of the ACM certificate you created for your domain.

1. **Initialize Terraform:**

   ```bash
   terraform init
   ```

2. **Plan the Terraform Deployment:**

   ```bash
   terraform plan
   ```

3. **Apply the Terraform Configuration:**

   ```bash
   terraform apply
   ```

   This will create the required AWS infrastructure, including S3 buckets, CloudFront distribution, ALB, security groups, RDS instance, and EC2 instances for WordPress.

### Step 5: Update Your Domain DNS Records

- Once the **CloudFront distribution** is deployed, add the **CloudFront domain name** (e.g., `dXXXXXX.cloudfront.net`) as a **A record** for your domain (e.g., `devopser.pl`) in **Route 53**.

### Step 6: Add instances to created Target Group

- Once th **Application Load Balancer** is deployed, register the instances (targets) to the Target Group

### Step 7: Verify the Deployment

1. **Access your WordPress site** at your domain (e.g., `https://devopser.pl`).
2. **Check SSL:** Ensure that SSL certificates are correctly applied, and the site is accessible over HTTPS.
3. **Check CloudFront Caching:** Verify that static assets are served from **CloudFront** by inspecting headers in the browser's developer tools.
4. **Check ALB Health Checks:** Ensure all EC2 instances behind the **ALB** are marked as healthy.

### Step 8: Setup WordPress

Once your infrastructure is running, go to your domain, and you should see the WordPress default page.

1. Customize your site as needed.
2. Install plugins as needed.

## Infrastructure Diagram

The final architecture consists of:

- **Route 53**: DNS routing to CloudFront.
- **CloudFront**: Caches static content and forwards dynamic requests to ALB.
- **ALB (Application Load Balancer)**: Distributes traffic across EC2 instances hosting WordPress.
- **S3**: Stores WordPress media files using **WP Offload Media Lite**.
- **ASG**: Scales in and out based on the actual traffic.
- **RDS**: Manages the WordPress MySQL database.
- **Cognito**: Manages user authentication

## Troubleshooting

### Common Issues

1. **502 Bad Gateway:**

   - This indicates communication issues between CloudFront and ALB. Ensure your ALB is healthy and accessible.
   - Verify that **CloudFront** can access the **ALB** origin by checking security groups and certificates.

2. **SSL Errors:**

   - Ensure the **ACM certificates** are correctly validated and applied to both CloudFront and ALB.

3. **CloudFront Errors:**

   - Check the **CloudFront logs** (enabled during setup) for detailed error messages.

4. **Unhealthy Target Instances:**
   - Check **ALB** health check settings. Ensure the instances are serving content correctly on the expected port.

## Clean-up

To remove the entire infrastructure, use the following Terraform command:

```bash
terraform destroy
```

This will delete all resources created by Terraform.

---

## Variables

- `region`: AWS region for ALB and other resources (e.g., `eu-central-1`).
- `domain_name`: Your domain name (e.g., `devopser.pl`).
- `cert_arn`: ARN of the SSL certificate for your domain.
- `use_existing_sg`: Boolean to specify whether to use an existing security group.
- `db_name`: Database name for WordPress.
- `db_user`: Database username.
- `db_password`: Password for the database.

---

### Notes

- **Security:** Ensure that your AWS credentials and other sensitive information are not exposed in the repository.
- **Backup:** Make sure to configure automatic backups for your **RDS** instance in case of data loss.

---
