<div align="center">

# ⚛️ Amazona — React Frontend

**React application**
**delivered via Amazon CloudFront with full Infrastructure as Code and automated CI/CD.**

[![React](https://img.shields.io/badge/React-61DAFB?style=for-the-badge&logo=react&logoColor=black)](https://reactjs.org)
[![AWS CloudFront](https://img.shields.io/badge/CloudFront-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/cloudfront)
[![Amazon S3](https://img.shields.io/badge/Amazon_S3-569A31?style=for-the-badge&logo=amazon-s3&logoColor=white)](https://aws.amazon.com/s3)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://terraform.io)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)](https://github.com/features/actions)

</div>

---

## 📋 Table of Contents

- [Architecture Overview](#-architecture-overview)
- [Infrastructure as Code](#️-infrastructure-as-code-terraform)
- [CI/CD Pipeline](#-continuous-delivery-github-actions)
- [Repository Structure](#-repository-structure)
- [Local Development](#-local-development)
- [Backend Integration](#-backend-integration)

---

## 🏗 Architecture Overview

```
Browser (Anywhere)
        │
        ▼
┌───────────────────────────────────┐
│        Amazon CloudFront          │  ← Global Edge Network
│   (CDN · HTTPS · SPA Routing)     │    millisecond load times worldwide
└──────────────┬────────────────────┘
               │  Origin Access Control (OAC)
               │  Private — no direct public access
               ▼
┌──────────────────────────────────┐
│         Amazon S3 Bucket         │  ← Static React Build Assets
│    (Private Origin · Versioned)  │
└──────────────────────────────────┘
```

The React app is built once and deployed to a **private S3 bucket** — never exposed directly to the internet. **CloudFront** acts as the sole entry point, serving assets from edge locations worldwide. A **CloudFront Invalidation** on every deploy ensures users always receive the latest build instantly.

---

## ☁️ Infrastructure as Code (Terraform)

The entire AWS delivery layer is defined as code. One command provisions the full global infrastructure from scratch — no manual console clicks.

### What Gets Provisioned

> 🔹 **Amazon CloudFront** — Global CDN caching assets at edge locations for millisecond-level load times
>
> 🔹 **Amazon S3** — Private origin bucket storing all static React build assets
>
> 🔹 **Origin Access Control (OAC)** — Enforces that S3 is only reachable through CloudFront, never directly
>
> 🔹 **SPA Routing** — Custom 404 → `index.html` redirect so React Router handles all browser navigation

### Provision the Infrastructure

```bash
terraform init && terraform apply -auto-approve
```

---

## 🔄 Continuous Delivery (GitHub Actions)

Every push to `main` triggers a fully automated deployment that takes the React source code all the way to the global CDN.

```
git push → GitHub Actions
               │
               ├── 1️⃣  Inject ALB API URL into the React build environment
               ├── 2️⃣  Generate optimised production bundle  (npm run build)
               ├── 3️⃣  Authenticate with AWS (OIDC — no stored credentials)
               ├── 4️⃣  Sync  build/  →  private S3 origin bucket
               └── 5️⃣  Invalidate CloudFront cache → ✅ Users see latest version instantly
```

> **Environment Injection** — The backend ALB URL is injected at build time as `REACT_APP_API_URL`, so the same codebase targets local, staging, or production without any code changes.

---

## 📂 Repository Structure

```
amazona-frontend/
│
├── 📁 .github/workflows/       # CI/CD: Automated S3 sync & CDN invalidation
│
├── 📁 terraform/               # IaC: S3, CloudFront & OAC definitions
│   ├── cloudfront.tf           #   → Distribution, cache behaviours, SPA routing
│   ├── s3.tf                   #   → Private origin bucket
│   └── oac.tf                  #   → Origin Access Control policy
│
├── 📁 public/                  # Static public assets
│
├── 📁 src/                     # React components & state logic
│   ├── components/             #   → Shared UI components
│   ├── screens/                #   → Page-level screen components
│   └── App.js                  #   → Root component & routing
│
├── 🔐 .env.example             # Required environment variable templates
└── 📦 package.json             # React project manifest & scripts
```

---

## 💻 Local Development

The app can be run locally for UI/UX testing and development against any backend target.

### 1 · Install Dependencies

```bash
npm install
```

### 2 · Configure Environment Variables

```env
# .env
REACT_APP_API_URL=http://localhost:4000   # or your staging ALB URL
```

> ⚠️ **Never commit your `.env` file.** Use `.env.example` to document required variables.

### 3 · Start the Dev Server

```bash
npm start
```

The app will open at **`http://localhost:3000`** with hot-reloading enabled.

---

## 🔗 Backend Integration

The frontend is fully decoupled from the backend. All API communication flows through the backend's **Application Load Balancer**, configured dynamically via the `REACT_APP_API_URL` environment variable.

| Environment | `REACT_APP_API_URL` |
|---|---|
| **Local** | `http://localhost:4000` |
| **Staging** | `http://<staging-alb-url>` |
| **Production** | `http://<production-alb-url>` *(injected by CI/CD)* |

No code changes are needed to switch targets — only the environment variable changes.

---

<div align="center">

 Delivered  by Amazon CloudFront

</div>
