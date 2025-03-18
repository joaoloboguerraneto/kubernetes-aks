variable "resource_group_name" {
  description = "Nome do grupo de recursos para o AKS"
  type        = string
  default     = "endpoint-monitor-rg"
}

variable "location" {
  description = "Localização para os recursos Azure"
  type        = string
  default     = "eastus"
}

variable "cluster_name" {
  description = "Nome do cluster AKS"
  type        = string
  default     = "endpoint-monitor-aks"
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes"
  type        = string
  default     = "1.26.6"
}

variable "dns_prefix" {
  description = "Prefixo DNS para o cluster AKS"
  type        = string
  default     = "endpoint-monitor"
}

variable "admin_username" {
  description = "Nome de usuário admin para os nós Linux"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "Chave pública SSH para acesso aos nós"
  type        = string
  default     = ""
}

variable "node_count" {
  description = "Número de nós no pool padrão"
  type        = number
  default     = 1
}

variable "node_size" {
  description = "Tamanho da VM para os nós"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "EndpointMonitor"
  }
}

variable "vnet_address_space" {
  description = "Espaço de endereços da VNET"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Prefixos de endereço da subnet do AKS"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}