# Architecture & Deployment Guide

This document explains the internal architecture and deployment strategy for the Kubeflow Docs Agent. The infrastructure relies heavily on automated deployments utilizing **Terraform**, **Helm**, and **GitHub Actions**.

## Runtime Data Flow (How It Works)

When a user asks the Docs Agent a question, the request flows through the cluster in real-time:

1. **User Query**: The user submits a question via the frontend UI.
2. **KAgent Controller**: The request hits the KAgent gateway (via Istio), which acts as the main orchestrator for the conversation.
3. **MCP Tool Calling**: KAgent determines it needs more context, so it calls our **MCP Server** via the Model Context Protocol.
4. **Vector Retrieval (RAG)**:
   - The MCP Server sends the user's question to the **Embeddings Service** (KServe) to turn the text into a vector.
   - The MCP Server queries **Milvus** using that vector to retrieve the most relevant Kubeflow documentation chunks.
5. **LLM Generation**: The retrieved documentation is bundled as context and sent to the **Qwen LLM** (running on GPUs via KServe vLLM) to generate the final, accurate response.
6. **Streaming Response**: The final answer is streamed back through KAgent to the user's browser.

---

## The 3-Level CI/CD Deployment Strategy

Our architecture cleanly separates foundational cluster setup from application-level logic. This prevents configuration drift and makes updates lightning fast.

### Level 1: Infrastructure (Terraform)
We use Terraform for declarative, reproducible cluster infrastructure on Oracle Cloud Infrastructure (OKE).
Terraform provisions the "bare metal" cluster operators that make Kubernetes smart:
- **Knative Serving & Istio**: Handles networking, zero-trust routing, and serverless scaling.
- **KServe**: The operator that manages high-performance LLM inferences.
- **Kubeflow Pipelines (KFP)**: The standalone orchestrator that runs our documentation ingestion jobs.
- **Milvus Operator**: The controller that manages the vector database lifecycle.

All Terraform code is located in `docs-agent-mcp/terraform/`. To deploy the base cluster, simply run `terraform apply`.

### Level 2: Application (Helm)
While Terraform builds the cluster, Helm deploys the specific *Custom Resources* that power our agent.
Our Helm chart (`docs-agent-mcp/helm/docs-agent/`) deploys:
- **Milvus Standalone Instance**: The actual vector database storing document embeddings.
- **Qwen LLM InferenceService**: The `vLLM` powered HuggingFace model serving responses.
- **Embeddings InferenceService**: The local API for `all-mpnet-base-v2` that turns text into vectors.
- **MCP Server**: The Model Context Protocol backend.
- **Istio AuthorizationPolicies**: Zero-trust networking policies securing traffic between the MCP, the LLM, and the database.

*Note: Our Terraform scripts automatically trigger this Helm chart installation, so you don't need to run Helm manually.*

### Level 3: Data Ingestion (GitHub Actions)
Once the cluster and application are live, the database is still empty. 
We use a GitHub Actions workflow (`run-pipeline.yaml`) on a weekly Cron schedule to:
1. Trigger the Kubeflow Pipeline script (`kubeflow-pipeline.py`).
2. Scrape the latest Kubeflow documentation from GitHub.
3. Hit the local Embeddings service to vectorize the markdown text.
4. Insert those vectors into Milvus.

This ensures the agent always has the most up-to-date documentation context without requiring manual intervention.
