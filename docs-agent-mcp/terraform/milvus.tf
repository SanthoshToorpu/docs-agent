# =============================================================================
# milvus.tf
# Deploys the Milvus Operator (via Helm) and a lightweight standalone
# Milvus instance (via Milvus CRD) in the ml-infra namespace.
#
# The operator pattern means Milvus lifecycle (upgrades, failover) is managed
# by the operator controller — Terraform only owns the CR spec.
# =============================================================================

resource "helm_release" "milvus_operator" {
  name             = "milvus-operator"
  repository       = "https://zilliztech.github.io/milvus-operator"
  chart            = "milvus-operator"
  namespace        = "milvus-operator"
  create_namespace = true

  # OKE enforces short-name registry policy — must use FQDN to avoid
  # "ambiguous image name" ImageInspectError on node pull.
  set {
    name  = "image.repository"
    value = "docker.io/milvusdb/milvus-operator"
  }
}

# Wait for the Milvus CRD to be registered before creating a Milvus CR.
# Uses /bin/sh explicitly for cross-platform CI compatibility.
resource "null_resource" "wait_for_milvus_crd" {
  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    command     = "kubectl wait --for condition=established --timeout=120s crd/milvuses.milvus.io"
  }

  depends_on = [helm_release.milvus_operator]
}

