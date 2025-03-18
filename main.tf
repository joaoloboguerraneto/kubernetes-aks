provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.cluster_name}-vnet"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.cluster_name}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefixes

  # Para configurar o service endpoints
  service_endpoints = [
    "Microsoft.ContainerRegistry",
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.cluster_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "aks_rule" {
  name                        = "aks-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Usando o módulo AKS
module "aks" {
  source = "./modules/aks"

  # Variáveis básicas
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  cluster_name        = var.cluster_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  
  # Configuração de nós
  node_count          = var.node_count
  min_count           = var.min_count
  max_count           = var.max_count
  node_size           = var.node_size
  os_disk_size_gb     = var.os_disk_size_gb
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  
  # Configuração de rede
  subnet_id           = azurerm_subnet.aks_subnet.id
  network_plugin      = var.network_plugin
  network_policy      = var.network_policy
  load_balancer_sku   = var.load_balancer_sku
  service_cidr        = var.service_cidr
  dns_service_ip      = var.dns_service_ip
  docker_bridge_cidr  = var.docker_bridge_cidr
  
  # Configurações de recursos
  enable_auto_scaling = var.enable_auto_scaling
  enable_rbac         = var.enable_rbac
  enable_addons       = var.enable_addons
  
  # Tags
  tags                = var.tags
}

# Adicionar container registry
resource "azurerm_container_registry" "acr" {
  name                     = replace("${var.cluster_name}acr", "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Standard"
  admin_enabled            = true
  tags                     = var.tags
}

# Atribuir permissão para o AKS acessar o ACR
resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id                     = module.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}