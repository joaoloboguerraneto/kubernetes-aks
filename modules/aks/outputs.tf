output "id" {
  description = "O ID do cluster AKS criado"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "name" {
  description = "O nome do cluster AKS"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "resource_group_name" {
  description = "O nome do grupo de recursos onde o AKS foi criado"
  value       = var.resource_group_name
}

output "location" {
  description = "A localização do cluster AKS"
  value       = azurerm_kubernetes_cluster.aks.location
}

output "kube_config" {
  description = "Objeto kubeconfig para o cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_config
  sensitive   = true
}

output "kube_config_raw" {
  description = "Arquivo kubeconfig bruto para o cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "kube_admin_config" {
  description = "Objeto kubeconfig admin para o cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config
  sensitive   = true
}

output "kube_admin_config_raw" {
  description = "Arquivo kubeconfig admin bruto para o cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive   = true
}

output "host" {
  description = "O endereço do servidor da API Kubernetes"
  value       = azurerm_kubernetes_cluster.aks.kube_config.0.host
  sensitive   = true
}

output "client_certificate" {
  description = "Certificado de cliente para autenticação"
  value       = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  sensitive   = true
}

output "client_key" {
  description = "Chave de cliente para autenticação"
  value       = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Certificado CA do cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
  sensitive   = true
}

output "node_resource_group" {
  description = "Nome do grupo de recursos que contém os recursos do nó do AKS"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "oms_agent_enabled" {
  description = "Indica se o agente OMS está habilitado"
  value       = var.enable_addons.oms_agent
}

output "oms_workspace_id" {
  description = "ID do workspace de Log Analytics criado para monitoramento"
  value       = var.enable_addons.oms_agent ? azurerm_log_analytics_workspace.aks[0].id : null
}

output "identity" {
  description = "Identidade gerenciada do cluster AKS"
  value       = azurerm_kubernetes_cluster.aks.identity
}

output "kubelet_identity" {
  description = "Identidade gerenciada do kubelet do AKS"
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity
}

output "kubernetes_version" {
  description = "Versão do Kubernetes em uso no cluster"
  value       = azurerm_kubernetes_cluster.aks.kubernetes_version
}