import pulumi
import pulumi_gcp as gcp

# Secure GCP VPC
vpc = gcp.compute.Network("secure-vpc", auto_create_subnetworks=False)

# Firewall rules allowing only SSH from a specific IP
firewall = gcp.compute.Firewall("secure-firewall",
    network=vpc.id,
    allows=[{
        "protocol": "tcp",
        "ports": ["22"]
    }],
    source_ranges=["203.0.113.0/32"]
)

pulumi.export("vpc_name", vpc.name)
