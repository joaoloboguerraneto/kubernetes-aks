variable "resource_group_name" {
  description = "Nome do grupo de recursos onde o cluster AKS será criado"
  type        = string
  default     = "servers"
}

variable "location" {
  description = "Localização do Azure onde os recursos serão criados"
  type        = string
  default     = "East US"
}

variable "cluster_name" {
  description = "Nome do cluster AKS"
  type        = string
  default     = "aks-wolf"
}

variable "dns_prefix" {
  description = "Prefixo DNS usado para o cluster AKS"
  type        = string
  default     = "aks"
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes a ser usada"
  type        = string
  default     = "1.26.6"
}

variable "node_count" {
  description = "Número inicial de nós no pool padrão"
  type        = number
  default     = 1
}

variable "min_count" {
  description = "Número mínimo de nós no pool quando auto-scaling estiver habilitado"
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Número máximo de nós no pool quando auto-scaling estiver habilitado"
  type        = number
  default     = 3
}

variable "node_size" {
  description = "Tamanho da VM para nós do AKS"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "os_disk_size_gb" {
  description = "Tamanho do disco OS em GB para os nós"
  type        = number
  default     = 50
}

variable "admin_username" {
  description = "Nome de usuário admin para os nós Linux"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "Chave pública SSH para acesso aos nós"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet onde o AKS será implantado"
  type        = string
  default     = "de4f3e91-6d47-436a-953d-754e9ac52434"
}

variable "service_cidr" {
  description = "CIDR para os serviços Kubernetes"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dns_service_ip" {
  description = "IP para o serviço DNS do Kubernetes"
  type        = string
  default     = "10.1.0.10"
}

variable "docker_bridge_cidr" {
  description = "CIDR para a ponte Docker"
  type        = string
  default     = "172.17.0.1/16"
}

variable "network_plugin" {
  description = "Plugin de rede para o Kubernetes"
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "Política de rede para o Kubernetes"
  type        = string
  default     = "calico"
}

variable "load_balancer_sku" {
  description = "SKU do load balancer"
  type        = string
  default     = "standard"
}

variable "enable_auto_scaling" {
  description = "Habilitar auto-scaling para o node pool"
  type        = bool
  default     = true
}

variable "enable_rbac" {
  description = "Habilitar RBAC no cluster"
  type        = bool
  default     = true
}

variable "enable_addons" {
  description = "Addons a serem habilitados no cluster"
  type = object({
    oms_agent    = bool
    azure_policy = bool
  })
  default = {
    oms_agent    = true
    azure_policy = true
  }
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default     = {}
}