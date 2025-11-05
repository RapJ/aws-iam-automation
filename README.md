# 🛡️ Project 4: IAM Roles and Secure Access Automation (AWS Implementation)

## 📘 Overview
This project automates secure **Identity and Access Management (IAM)** and **network infrastructure setup** in AWS using **Bash scripting** and **GitHub Actions (CI/CD)**.  
It ensures consistency, security, and repeatability in cloud deployments — key for DevOps and cloud automation.

---

## 🎯 Objectives
- Automate IAM setup (users, groups, roles, policies)  
- Automate VPC and subnet creation  
- Assign least-privilege permissions to IAM groups  
- Integrate automation with GitHub CI/CD  
- Enable cleanup automation for cost and resource control  

---

## 🧩 Architecture Diagram

Below is a conceptual design of the automated AWS setup:

```
+---------------------------------------------------+
|                     AWS Cloud                     |
|                                                   |
|  +---------------------+       +----------------+ |
|  |  Web Subnet (AZ A)  |       | DB Subnet (AZ B)| |
|  |  - WebAdmins IAM     |       | - DBAdmins IAM  | |
|  |  - TestWebUser       |       | - TestDBUser    | |
|  +---------------------+       +----------------+ |
|                                                   |
|             VPC (10.0.0.0/16)                     |
+---------------------------------------------------+
```

📸 *Image Placeholder:*  

![AWS Architecture Diagram](images/Capstone-11.png)

---

## ⚙️ Automation Flow

### **1️⃣ Deployment Script (`deploy_iam.sh`)**
Automates:
- Creation of VPC and subnets  
- IAM groups (`WebAdmins`, `DBAdmins`)  
- IAM users (`TestWebUser`, `TestDBUser`)  
- Group assignments and role permissions  

Run manually:
```bash
bash deploy_iam.sh
```

📸 *Placeholder:*  
![Deployment CLI Output](images/aws_proj_2iAM.JPG)

---

### **2️⃣ Cleanup Script (`cleanup_iam.sh`)**
Safely deletes all created AWS resources.

Run manually:
```bash
bash cleanup_iam.sh
```

📸 *Placeholder:*  
![Cleanup CLI Output](images/cleanup_success.png)

---

## 🔁 CI/CD Pipeline (GitHub Actions)

| Workflow | Trigger | Description |
|-----------|----------|-------------|
| `deploy.yml` | On push to `main` | Deploys VPC, IAM groups, and users |
| `cleanup.yml` | Manual trigger | Cleans up all AWS resources |

┌──────────────┐      ┌─────────────────────┐      ┌───────────────────────┐
│  Developer   │ ---> │  Push to GitHub     │ ---> │  GitHub Actions Deploy │
└──────────────┘      └─────────────────────┘      └───────────────────────┘
                                                          │
                                                          ▼
                                                  AWS CLI Executes Scripts
                                                          │
                                                          ▼
                                                   IAM + VPC Created


📸 *Placeholder:*  
![GitHub Pipeline](images/github_pipeline.png)

### **CI/CD Flow Diagram**
```
Developer → Push to GitHub → GitHub Actions Deploy → AWS CLI Executes → IAM + VPC Created
```

---

## 🔐 Security Considerations
- AWS credentials stored as **GitHub Secrets**
  - `AWS_REGION`
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
- IAM uses **least privilege** model  
- All AWS resources tagged for auditing  

📸 *Placeholder:*  
![GitHub Secrets Setup](images/Capstone-9.PNG)

---

## 🧱 Folder Structure
```
aws-iam-cicd-project/
│
├── deploy_iam.sh
├── cleanup_iam.sh
├── README.md
└── .github/
    └── workflows/
        ├── deploy.yml
        └── cleanup.yml
```

---

## 🚀 How to Use

1. **Clone the repository**
   ```bash
   git clone (https://github.com/RapJ/aws-iam-automation.git)
   cd aws-iam-automation
   ```

2. **Add AWS credentials in GitHub Secrets**
   - Go to your repository → **Settings → Secrets → Actions**

3. **Push to main branch**
   - Automatically triggers deployment

4. **Monitor GitHub Actions**
   - Watch real-time execution in **Actions tab**

5. **Run cleanup manually**
   - Go to **Actions → Cleanup Workflow → Run Workflow**

---

## 🧠 Learning Outcomes
You will learn to:
- Use **AWS CLI** for infrastructure automation  
- Implement **IAM roles and access control**  
- Create **GitHub Actions workflows** for CI/CD  
- Manage infrastructure with **Bash scripting**  
- Apply **Infrastructure-as-Code (IaC)** concepts  

---

## 📸 Screenshot Requirements
Add screenshots for submission:
1. Successful **GitHub Actions** pipeline run  
2. IAM Groups & Users in AWS Console  
3. VPC & Subnets visible in AWS Console  
4. GitHub Secrets Configuration page  

---

## 🧰 Tools & Technologies
- AWS CLI  
- GitHub Actions  
- Bash scripting  
- IAM & VPC  
- CI/CD Automation  

---

## ✅ Deliverables
- `deploy_iam.sh` and `cleanup_iam.sh` scripts  
- `.github/workflows/deploy.yml` and `.github/workflows/cleanup.yml`  
- `README.md` with visuals  
- Screenshot folder `/images`  

---

## 🏁 Summary
This project showcases **end-to-end DevOps automation** using AWS and GitHub.  
It provides a secure, repeatable model for managing cloud IAM and infrastructure via CI/CD pipelines.

---
