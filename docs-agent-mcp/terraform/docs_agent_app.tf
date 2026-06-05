resource "helm_release" "docs_agent_app" {
  name      = "docs-agent-app"
  chart     = "../helm/docs-agent"
  namespace = var.namespace_docs_agent

  set {
    name  = "mcpServer.image.repository"
    value = "${var.dockerhub_username}/mcp-kubeflow-docs"
  }

  set {
    name  = "global.domainName"
    value = var.domain_name
  }

  set {
    name  = "global.acmeEmail"
    value = var.acme_email
  }

  set {
    name  = "global.namespace.app"
    value = var.namespace_docs_agent
  }

  set {
    name  = "global.namespace.mlInfra"
    value = var.namespace_ml_infra
  }

  set {
    name  = "global.namespace.kubeflow"
    value = var.namespace_kubeflow
  }

  set {
    name  = "milvus.version"
    value = var.milvus_version
  }

  depends_on = [
    helm_release.kagent,
    kubernetes_namespace.ml_infra
  ]
}
