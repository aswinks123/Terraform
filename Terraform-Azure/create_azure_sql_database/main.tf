provider   "azurerm"   { 
   #version   =   "= 2.0.0" 
   features   {} 
 } 


 #Creating an Azure resource group

resource "azurerm_resource_group" "aswin_resource_group" {

   name="aswin-resource-group"
   location =   "Canada Central"
 }


 #Deploy the Mysql Server

 resource "azurerm_mysql_server" "aswin-mysql-server" {
  name =   "aswin-mysql-server"
  location = azurerm_resource_group.aswin_resource_group.location
  resource_group_name = azurerm_resource_group.aswin_resource_group.name

  administrator_login = "aswin"
  administrator_login_password = "@#12345@ads" #Give a strong password. use of variables are recommanded

  sku_name = "B_Gen5_2"
  storage_mb = 5120
  version=  "5.7"
   


  auto_grow_enabled = true
  backup_retention_days = 7
  geo_redundant_backup_enabled = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled=true
  ssl_enforcement_enabled =true
  ssl_minimal_tls_version_enforced="TLS1_2"

 }