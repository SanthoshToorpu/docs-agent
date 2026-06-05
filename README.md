# Kubeflow Documentation AI Assistant & LLM Hosting Template


[![KEP-867](https://img.shields.io/badge/KEP--867-Documentation%20AI%20Assistant-blue)](https://github.com/kubeflow/community/issues/867)

## Overview

This repository serves a dual purpose:

1. **The Official Kubeflow Docs Agent**: An intelligent, RAG-powered AI assistant that helps users instantly search and query the extensive Kubeflow documentation. It understands the context of your questions and streams accurate answers in real-time.
2. **A Universal LLM Self-Hosting Platform**: Beyond the docs agent, this entire repository acts as an enterprise-grade, "batteries-included" template for anyone who wants to easily self-host their own Large Language Models (like Llama 3, Qwen, etc.) on Kubernetes. 

Whether you want to deploy our documentation bot or spin up your own custom LLM infrastructure anywhere in the cloud, this repository provides the automated blueprints to do so.

---

## What's Inside? (In Simple Terms)

We built a modern, cloud-native AI stack using the best open-source tools available:

- **Milvus**: A highly scalable vector database utilized for storing document embeddings and performing low-latency semantic similarity search.
- **KServe**: A Kubernetes-native model inference platform that efficiently serves our Large Language Models (LLMs) and embedding models with optimized GPU utilization via vLLM.
- **Kubeflow Pipelines**: An automated ML workflow orchestration engine responsible for scraping documentation, generating embeddings, and ingesting vectorized data into Milvus.
- **MCP Server**: A Model Context Protocol backend that enables the AI to intelligently interact with external tools, fetch dynamic context, and route queries to the inference engines.

---

## Technical Architecture & Deployment

We have strictly separated our code so it's easy to maintain. 
- **Terraform** sets up the core Kubernetes cluster.
- **Helm** configures the AI applications.
- **GitHub Actions** automates the data processing.

If you are a developer looking to deploy, configure, or understand the infrastructure behind this project, please read our **[Architecture & Deployment Guide](ARCHITECTURE.md)**.

---

## Contributing

We welcome contributions! Please see our [contributing guidelines](CONTRIBUTING.md) for details.

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

### Mentors
- [Francisco Javier Arceo](https://www.linkedin.com/in/franciscojavierarceo/) - Project mentor and guidance
- [Chase Christensen](https://www.linkedin.com/in/chase-c-695463162/) - Project mentor and technical support

### Organizations
- [Google Summer of Code (GSoC)](https://summerofcode.withgoogle.com/) for providing this incredible opportunity
- [Hugging Face](https://huggingface.co/) for the model hosting and sentence transformers library
- [Oracle Cloud Infrastructure (OCI)](https://www.oracle.com/cloud/) for providing cloud resources and infrastructure

### Open Source Community
- [Kubeflow Community](https://github.com/kubeflow/community) for the KEP-867 proposal
- [Milvus](https://milvus.io/) for the vector database
- [KServe](https://kserve.github.io/website/) for model serving
- [vLLM](https://github.com/vllm-project/vllm) for high-performance LLM inference
