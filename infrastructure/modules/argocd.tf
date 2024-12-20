##############################################################
# ARGOCD
##############################################################
variable "argocd_values" {
  type    = string
  default = <<-EOF
    server:
      service:
        type: LoadBalancer
    EOF
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.51.4"
  cleanup_on_fail  = true
  namespace        = "argocd"
  create_namespace = true

  values = [var.argocd_values]

  depends_on = [module.eks.cluster_id]
}
