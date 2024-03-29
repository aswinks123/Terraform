#First authenticate to Azure using the az login command.


#Mentioning the provider as Azure

provider   "azurerm"   { 
   #version   =   "= 2.0.0" 
   features   {} 
 } 


 #Creating an Azure resource group

resource "azurerm_resource_group" "aswin_resource_group" {

   name="aswin-resource-group"
   location =   "Canada Central"
 }


 #Creating a Virtual Network

 resource "azurerm_virtual_network" "aswin-VPC" {
    name    =   "aswin-VPC"
    address_space = ["10.0.0.0/16"]
    location = "Canada Central"
    resource_group_name = azurerm_resource_group.aswin_resource_group.name
 }

#Create a subnet inside the Virtual Network

resource "azurerm_subnet" "aswin-subnet" {
    name = "aswin-subnet"
    resource_group_name = azurerm_resource_group.aswin_resource_group.name
    virtual_network_name = azurerm_virtual_network.aswin-VPC.name
    address_prefixes = ["10.0.1.0/24"]
      
}

#Create a public IP address

resource "azurerm_public_ip" "aswin-public-ip" {
    name = "aswin-public-ip"
    location = "Canada Central"
    resource_group_name = azurerm_resource_group.aswin_resource_group.name
    allocation_method = "Dynamic"
    sku = "Basic"
      
}

#Create a network interface for the Virtual machine

resource "azurerm_network_interface" "aswin-nw-interface" {
    name    =   "aswin-nw-interface"
    location = "Canada Central"
    resource_group_name = azurerm_resource_group.aswin_resource_group.name

    ip_configuration {
      
      name  =   "ipconfiguration-1"
      subnet_id = azurerm_subnet.aswin-subnet.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.aswin-public-ip.id
      
    }
  
}


#Create a Virtual machine in the created Virtual network

resource "azurerm_linux_virtual_machine" "aswin-linux-vm" {
    name = "aswin-linux-vm"
    resource_group_name = azurerm_resource_group.aswin_resource_group.name
    network_interface_ids = [azurerm_network_interface.aswin-nw-interface.id]
    location = "Canada Central"
    size = "Standard_B1s"
    computer_name = "aswin-linux"
    admin_username= "your-username123"
    admin_password =   "your-password123"  #use strong password. Use of key pair is recommanded. Use password auth only for testing!
    disable_password_authentication="false"  #Use this only for testing!
    
    #Installing nginx in the VM using custom script
    custom_data=filebase64("customdata.tpl")
    
    source_image_reference {
      publisher = "Canonical"
      offer = "UbuntuServer"
      sku = "18.04-LTS"
      version = "latest"
    }
    
    os_disk {
      
      caching= "ReadWrite"
      storage_account_type="Standard_LRS"
    }

}





#Create a security group and open port 22 to SSH

resource "azurerm_network_security_group" "aswin-NSG" {
    name =     "aswin-NSG"
    location = "Canada Central"
    resource_group_name = azurerm_resource_group.aswin_resource_group.name

    security_rule  {
        name="SSH"
        priority=1001
        direction="Inbound"
        access="Allow"
        protocol="Tcp"
        source_port_range="*"
        destination_port_range="22"
        source_address_prefix="*"
        destination_address_prefix="*"
    }
  security_rule  {
        name="HTTP"
        priority=1002
        direction="Inbound"
        access="Allow"
        protocol="Tcp"
        source_port_range="*"
        destination_port_range="80"
        source_address_prefix="*"
        destination_address_prefix="*"
    }

  
}

#Create an association to link security group and the NIC of virtual machine

resource "azurerm_network_interface_security_group_association" "aswin-NW-SG-association" {

    network_interface_id = azurerm_network_interface.aswin-nw-interface.id
    network_security_group_id = azurerm_network_security_group.aswin-NSG.id
  
}


#Print the public IP of VM in terminal to log in

output "public-ip" {
    value = azurerm_linux_virtual_machine.aswin-linux-vm.public_ip_address
  
}
