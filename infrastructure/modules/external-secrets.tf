##############################################################
# EXTERNAL SECRETS
##############################################################

# resource "kubernetes_namespace" "external_secrets_ns" {
#   metadata {
#     name = "external-secrets"
#   }
# }

resource "aws_iam_role" "external_secrets_role" {
  name = "${var.environment}-${var.name_prefix}-external-secret-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = module.eks.oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "oidc.eks.eu-central-1.amazonaws.com/id/0E9776CCD653EB56BB6556C3B2F8AF69:sub" = "system:serviceaccount:external-secrets:external-secrets-sa",
            "oidc.eks.eu-central-1.amazonaws.com/id/0E9776CCD653EB56BB6556C3B2F8AF69:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "kubernetes_service_account" "external_secrets_sa" {
  metadata {
    name      = "external-secrets-sa"
    namespace = "external-secrets"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.external_secrets_role.arn
    }
  }
}

# IAM Policy for SecretsManager Access
resource "aws_iam_policy" "external_secrets_policy" {
  name        = "external-secrets-policy"
  description = "Allow External Secrets Operator to access Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["secretsmanager:GetSecretValue", "secretsmanager:ListSecretValue"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_external_secrets_policy" {
  role       = aws_iam_role.external_secrets_role.name
  policy_arn = aws_iam_policy.external_secrets_policy.arn
}

resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = "0.9.9"
  namespace        = "external-secrets"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}
