import pulumi
import pulumi_aws as aws

# Secure AWS VPC
vpc = aws.ec2.Vpc("secure-vpc",
    cidr_block="10.0.0.0/16",
    enable_dns_support=True,
    enable_dns_hostnames=True
)

# Security Group allowing only SSH from a specific IP
security_group = aws.ec2.SecurityGroup("secure-sg",
    vpc_id=vpc.id,
    ingress=[{
        "protocol": "tcp",
        "from_port": 22,
        "to_port": 22,
        "cidr_blocks": ["203.0.113.0/32"]  # Replace with your IP
    }]
)

# Launch a hardened EC2 instance
instance = aws.ec2.Instance("secure-instance",
    ami="ami-0abcdef1234567890",
    instance_type="t3.micro",
    vpc_security_group_ids=[security_group.id],
    user_data="""#!/bin/bash
        apt update -y
        apt install fail2ban -y
        systemctl enable fail2ban
        systemctl start fail2ban
    """
)

pulumi.export("instance_public_ip", instance.public_ip)
