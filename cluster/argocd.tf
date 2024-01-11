provider "helm" {
    kubernetes {
        host                   = data.aws_eks_cluster.cluster.endpoint
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
            exec {
                api_version = "client.authentication.k8s.io/v1beta1"
                args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
                command     = "aws"
            }
    }
}

provider "kubernetes" {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
}

variable "namespace" {
  default = "argocd"
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name       = var.namespace
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.27.3"
  namespace  = var.namespace
  timeout    = "1200"
  values     = [templatefile("./argocd/install.yaml", {})]
}

resource "null_resource" "password" {
  provisioner "local-exec" {
    working_dir = "./argocd"
    command     = "kubectl -n ${var.namespace} get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d > argocd-login.txt"
  }
}

resource "null_resource" "del-argo-pass" {
  depends_on = [null_resource.password]
  provisioner "local-exec" {
    command = "kubectl -n ${var.namespace} delete secret argocd-initial-admin-secret"
  }
}
