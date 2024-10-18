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