data "azurerm_kubernetes_cluster" "this" {
  name                = "${var.env}-${var.aks_name}"
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_kubernetes_cluster.this]
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.this.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = "monitoring"


  create_namespace = true

}
resource "helm_release" "linkerd_crds" {
  name       = "linkerd-crds"
  repository = "https://helm.linkerd.io/edge"
  chart      = "linkerd-crds"
  namespace  = "linkerd"

  create_namespace = true
}

resource "helm_release" "linkerd_control_plane" {
  name       = "linkerd-control-plane"
  repository = "https://helm.linkerd.io/edge"
  chart      = "linkerd-control-plane"
  namespace  = "linkerd"

  depends_on = [helm_release.linkerd_crds]

  set {
    name  = "identityTrustAnchorsPEM"
    value = file("${path.module}/ca.crt")
  }

  set {
    name  = "identity.issuer.tls.crtPEM"
    value = file("${path.module}/issuer.crt")
  }

  set {
    name  = "identity.issuer.tls.keyPEM"
    value = file("${path.module}/issuer.key")
  }

  # Optional: Enable high availability by using an external values file
#   values = [
#     file("${path.module}/values-ha.yaml")
#   ]
}