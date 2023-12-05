locals {
  netowrk_settings = jsondecode(file("Network/network_configuration.json"))
  fw_settings = jsondecode(file("FW/fw_configuration.json"))
}

module "network" {
  source  = "app.terraform.io/cloud-castles/network/azurerm"
  version = "1.0.5"
  address_space = local.netowrk_settings.address_space
  location = local.netowrk_settings.location
  resource_group = local.netowrk_settings.resource_group
  subnet_objects = local.netowrk_settings.subnet_objects
  vnet_name = local.netowrk_settings.vnet_name
} 

module "fw" {
  source  = "app.terraform.io/cloud-castles/fw/azurerm"
  version = "1.0.7"
  location = local.netowrk_settings.location
  resource_group = local.netowrk_settings.resource_group
  subnet_id = element(module.network.subnet_ids, 0)
  pip_name = local.fw_settings.pip_name
  allocation_method = local.fw_settings.allocation_method
  pip_sku = local.fw_settings.pip_sku
  fw_policy_name = local.fw_settings.fw_policy_name
  fw_policy_sku = local.fw_settings.fw_policy_sku
  fw_name = local.fw_settings.fw_name
  fw_sku = local.fw_settings.fw_sku
  fw_tier = local.fw_settings.fw_tier
  ip_conf_name = local.fw_settings.ip_conf_name

  depends_on = [module.network]
}


# module "storage_account" {
#   source  = "app.terraform.io/cloud-castles/network/azurerm"
#   version = "1.0.0"
# }

# module "azure_function" {
#   source  = "app.terraform.io/cloud-castles/network/azurerm"
#   version = "1.0.0"
# }