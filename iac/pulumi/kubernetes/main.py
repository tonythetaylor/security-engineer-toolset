import pulumi
import pulumi_kubernetes as k8s

# Apply a Kubernetes Network Policy
network_policy = k8s.networking.v1.NetworkPolicy("secure-policy",
    metadata={"name": "deny-all"},
    spec={
        "podSelector": {},
        "policyTypes": ["Ingress", "Egress"]
    }
)

pulumi.export("network_policy", network_policy.metadata["name"])
