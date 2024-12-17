resource "aws_secretsmanager_secret" "clerk_keys" {
  name        = "clerk-app-keys"
  description = "Secrets for Clerk application"
}

resource "aws_secretsmanager_secret_version" "clerk_keys_version" {
  secret_id     = aws_secretsmanager_secret.clerk_keys.id
  secret_string = jsonencode({
    CLERK_PUBLIC_KEY  = var.clerk_public_key,
    CLERK_PRIVATE_KEY = var.clerk_private_key,
    CLERK_API_URL = var.clerk_api_url
  })
}