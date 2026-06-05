# Future Scope: CI/CD Architecture

This directory is reserved for future GitHub Actions workflows that will automate the deployment and data ingestion of the Docs Agent.

Based on the Terraform + Helm architecture, the CI/CD should be split into three distinct levels:

### Level 1: Infrastructure CI/CD (`terraform-deploy.yml`)
- **Trigger**: Changes to the `terraform/` directory.
- **Action**: Runs `terraform plan` and `terraform apply`.
- **Purpose**: Provisions core cluster infrastructure, namespaces, operators (Istio, Knative, KServe), and triggers the baseline Helm chart.

### Level 2: Application CI/CD (`helm-deploy.yml`)
- **Trigger**: Changes to `mcp-server/` source code or `helm/` templates.
- **Action**: Builds the new Docker image for the MCP server, pushes it to Docker Hub, and runs `helm upgrade` with the new image tag.
- **Purpose**: Deploys application updates rapidly without modifying underlying Terraform infrastructure.

### Level 3: Data CI/CD (`pipeline-run.yml`)
- **Trigger**: Cron schedule (e.g., nightly) or manual dispatch.
- **Action**: Executes `python pipelines/kubeflow-pipeline.py`.
- **Purpose**: Scrapes the latest Kubeflow documentation, vectorizes the text using the Embeddings InferenceService, and ingests the vectors into the Milvus standalone database. Keeps the LLM context up to date.
