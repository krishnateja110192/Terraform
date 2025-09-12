location            = "East US"
resource_group_name = "cmaz-ey1bz94q-mod4-rg"
vnet_name           = "cmaz-ey1bz94q-mod4-vnet"
subnet_name         = "frontend"
nsg_name            = "cmaz-ey1bz94q-mod4-nsg"
nic_name            = "cmaz-ey1bz94q-mod4-nic"
pip_name            = "cmaz-ey1bz94q-mod4-pip"
dns_label           = "cmaz-ey1bz94q-mod4-nginx"
vm_name             = "cmaz-ey1bz94q-mod4-vm"
vm_sku              = "Standard_F2s_v2"
vm_os_version       = "ubuntu-24_04-lts"

tags = {
  Creator = "krishnateja_samudrala@epam.com"
}
