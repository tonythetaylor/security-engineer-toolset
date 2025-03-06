import pulumi
import pulumi_azure_native as azure

# Secure Azure Resource Group
resource_group = azure.resources.ResourceGroup("secure-rg")

# Virtual Machine with Network Security Group
nsg = azure.network.NetworkSecurityGroup("secure-nsg",
    resource_group_name=resource_group.name,
    security_rules=[{
        "name": "AllowSSH",
        "priority": 1000,
        "direction": "Inbound",
        "access": "Allow",
        "protocol": "Tcp",
        "source_port_range": "*",
        "destination_port_range": "22",
        "source_address_prefix": "203.0.113.0/32",
        "destination_address_prefix": "*"
    }]
)

pulumi.export("resource_group_name", resource_group.name)
