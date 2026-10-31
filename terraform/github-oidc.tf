data "http" "repo" {
  url = "https://api.github.com/repos/${var.github_owner}/${var.github_repo}"

  request_headers = {
    Accept = "application/vnd.github+json"
  }
}

locals {
  repo_json = jsondecode(data.http.repo.response_body)
  repo_id   = local.repo_json.id
  owner_id  = local.repo_json.owner.id

  subject_name = "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/main"
  subject_id   = "repo:${var.github_owner}@${local.owner_id}/${var.github_repo}@${local.repo_id}:ref:refs/heads/main"
}

resource "azuread_application" "github" {
  display_name = "gh-${var.github_repo}"
}

resource "azuread_service_principal" "github" {
  client_id = azuread_application.github.client_id
}

resource "azuread_application_federated_identity_credential" "main_name" {
  application_id = azuread_application.github.id
  display_name   = "github-main-name"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = local.subject_name
}

resource "azuread_application_federated_identity_credential" "main_id" {
  application_id = azuread_application.github.id
  display_name   = "github-main-id"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = local.subject_id
}

resource "azurerm_role_assignment" "github_acr_push" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPush"
  principal_id         = azuread_service_principal.github.object_id
}

locals {
  env_subject_name = "repo:${var.github_owner}/${var.github_repo}:environment:production"
  env_subject_id   = "repo:${var.github_owner}@${local.owner_id}/${var.github_repo}@${local.repo_id}:environment:production"
}

resource "azuread_application_federated_identity_credential" "prod_name" {
  application_id = azuread_application.github.id
  display_name   = "github-prod-name"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = local.env_subject_name
}

resource "azuread_application_federated_identity_credential" "prod_id" {
  application_id = azuread_application.github.id
  display_name   = "github-prod-id"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = local.env_subject_id
}