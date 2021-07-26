resource "azurerm_resource_group" "demo" {
  name     = var.rgname
      location = var.region
}

resource "azurerm_virtual_machine" "demo-instance" {
  name                  = "${var.prefix}-vm"
  location              = var.region
  resource_group_name   = azurerm_resource_group.demo.name
  network_interface_ids = [azurerm_network_interface.dinterface.id]
  vm_size               = "Standard_A1_v2"

  # this is a demo instance, so we can delete all data on termination
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "vmadmin"
    admin_username = "vmadmin"
    admin_password = "September@2016"
  }
  os_profile_linux_config {
    disable_password_authentication = false
        }
  }

resource "azurerm_network_interface" "dinterface" {
  name                      = "${var.prefix}-instance1"
  location                  = var.region
  resource_group_name       = azurerm_resource_group.demo.name
  
  ip_configuration {
    name                          = "instance1"
    subnet_id                     = azurerm_subnet.demo-internal-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dinstance.id
  }
}

resource "azurerm_public_ip" "dinstance" {
    name                         = "instance1-public-ip"
    location                     = var.region
    resource_group_name          = azurerm_resource_group.demo.name
    allocation_method            = "Dynamic"
}