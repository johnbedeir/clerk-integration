##############################################################
# SECRET MANAGER
##############################################################
resource "aws_secretsmanager_secret" "clerk_secrets-v2" {
  name        = "clerk-app-secrets-v2"
  description = "Secrets for Clerk application"
}

resource "aws_secretsmanager_secret_version" "clerk_secrets_version" {
  secret_id     = aws_secretsmanager_secret.clerk_secrets-v2.id
  secret_string = jsonencode({
    CLERK_PUBLIC_KEY  = var.clerk_public_key,
    CLERK_PRIVATE_KEY = var.clerk_private_key,
    CLERK_API_URL = var.clerk_api_url
  })
}