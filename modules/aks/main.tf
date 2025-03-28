terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags

  default_node_pool {
    name                  = "default"
    node_count            = var.node_count
    vm_size               = var.node_size
    vnet_subnet_id        = azurerm_subnet.aks_subnet.id
    orchestrator_version  = var.kubernetes_version
    
    os_disk_size_gb       = var.os_disk_size_gb
    min_count             = var.min_count
    max_count             = var.max_count
    max_pods              = 110
    type                  = "VirtualMachineScaleSets"
    
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = var.network_plugin
    load_balancer_sku  = var.load_balancer_sku
    network_policy     = var.network_policy
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
  }

  role_based_access_control_enabled = var.enable_rbac

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  # Configuração para o Azure Monitor
  dynamic "oms_agent" {
    for_each = var.enable_addons.oms_agent ? [1] : []
    content {
      log_analytics_workspace_id = azurerm_log_analytics_workspace.aks[0].id
    }
  }

  # Configuração da Política do Azure
  azure_policy_enabled = var.enable_addons.azure_policy
  
  # Configurações de manutenção
  maintenance_window {
    allowed {
      day   = "Saturday"
      hours = [21, 22, 23, 0]
    }
  }
}

# Log Analytics Workspace para monitoramento
resource "azurerm_log_analytics_workspace" "aks" {
  count               = var.enable_addons.oms_agent ? 1 : 0
  name                = "${var.cluster_name}-workspace"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# Solução de Contêineres para Log Analytics
resource "azurerm_log_analytics_solution" "aks" {
  count                 = var.enable_addons.oms_agent ? 1 : 0
  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.aks[0].id
  workspace_name        = azurerm_log_analytics_workspace.aks[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

# Diagnostic settings para o AKS
resource "azurerm_monitor_diagnostic_setting" "aks" {
  count                          = var.enable_addons.oms_agent ? 1 : 0
  name                           = "${var.cluster_name}-diag"
  target_resource_id             = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.aks[0].id

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 30
    }
  }
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "${var.cluster_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.cluster_name}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}