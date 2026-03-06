---

date: 2026-03-04
title: You've probably been sleeping on this SSM superpower
tags: ['AWS']

---

We all know that SSM allows us to send commands and even "start sessions" with
EC2 instances. But have you tried to create SSH-like tunnels to reach fully
private resources like RDS instances or EKS clusters using it?

<!--more-->

Yes, you can and it is called _SSM sessions_, which is already
[well documented](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-sessions-start.html).
The thing is that when you're in a hurry you wouldn't look it up like that;
instead you would ask "How can I do X on a private EC2 instance that doesn't
have a public IP address?" or "How can I use this Kubernetes terraform/tofu
provider if the EKS Cluster API is already private?". So even if by chance you
get to that documentation page, it requires more than a simple glance to
actually get how to apply it to your exact scenario.

## SSM sessions, the trenches definition

But first let's agree what SSM sessions can be defined as. And one could be tempted to
say that it is the AWS native SSH replacement and most AWS users may
agree with you (including me). However, when you say it just like that, you're
skipping a couple of very important aspects:

1. It fully relies on AWS API and the AWS Agent running on your virtual device
   (ie: EC2 instance)
2. It doesn't need any public address since everything is handled by AWS within
   its own infrastructure

That said, a better definition would be: _SSM sessions can be used as an SSH
replacement that doesn't require a public address nor well-known open port on
the host, since everything is handled by AWS and its internal constructs (eg:
API, EC2 agent)_.

So when you let that prior definition sink in, you'll realize that it can be
used for SSH-like tunnels and forward private resources back into your localhost.

## SSM as SSH-like tunnels

Until a few weeks ago, I used SSM as a means to establish a connection to a
remote host (that has the required policies attached), jump into it, do my
thing, log out. But turns out you can actually use SSM and the AWS CLI to
establish a tunnel on ports reachable by the target.

Let's say I need to reach an RDS database through a bastion

```sh
export BASTION_ID="[EC2 instance identifier]"
export RDS_HOST="[instance ID].[region].rds.amazonaws.com"

aws ssm start-session \
  --target $BASTION_ID \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "{\"host\":[\"$RDS_HOST\"],\"portNumber\":[\"5432\"],\"localPortNumber\":[\"5432\"]}"

# On a new terminal
psql "host=localhost port=5432 dbname=postgres user=[pg-user] password=[pg-password] sslmode=disable"
```

And now we have it! You are able to directly establish a connection into the RDS
instance through localhost using the SSM tunnel.

Hold on, did you notice that I had to disable the `sslmode`? The thing is
that because we're connecting against `localhost` instead of the RDS instance's
FQDN, the certificate SNI won't match, rendering the certificates "invalid" to
any verification. However, since these are private resources inside your VPC,
disabling it is a reasonable trade-off.

To this point you'll get the gist of it, but I'd like to share the other
scenarios that pushed me to dig into this topic.

### Provisioning private EKS clusters with terraform/tofu

If you come from CDK, you already know that you easily can manage workloads and
configurations in private EKS clusters, because everything happens within the
same VPC as your cluster after your code is transformed into CloudFormation and
lambdas.

However, when you are working with Terraform or OpenTofu, the provisioning logic
will always run outside the VPC making it hard to achieve the same objective.
This pushes the Infrastructure engineer to compromise in the process, which in
most cases requires a bastion and SSH.

But what if you could configure the Kubernetes-based providers (ie: kubernetes,
helm, kubectl) to use the SSM tunnel on your localhost directly? Well, that's
exactly what brought me here, and it can be condensed in the codeblock below.

```hcl
variable "use_ssm_tunnel" {
  description = "Configure Kubernetes-related providers to use SSM tunnel"
  type        = bool
  default     = false
}

locals {
  k8s_host            = var.use_ssm_tunnel ? "https://127.0.0.1:${var.ssm_tunnel_port}" : module.eks.cluster_endpoint
  k8s_tls_server_name = var.use_ssm_tunnel ? replace(module.eks.cluster_endpoint, "https://", "") : null
  k8s_exec_args       = # The method used for issuing the Kubernetes cluster access token
}

provider "kubernetes" {
  host                   = local.k8s_host
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  tls_server_name        = local.k8s_tls_server_name

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = local.k8s_exec_args
  }
}
```

The important parts of this HCL script you need to keep in mind are:

1. There's a sentinel value to toggle between reaching the Kubernetes API
   directly or through the SSM tunnel
2. When the tunnel is enabled, the proper values for Kubernetes host,
   tls_server_name and cluster CA are reset
3. Most of the Kubernetes-based providers like helm and kubectl have the same
   "connection config" contract, so you can easily replicate it

### Accessing private EKS Kubernetes API

This is very similar to the RDS example, with regard to switching the FQDN to
localhost and disabling TLS verification.

```sh
export BASTION_ID="[EC2 instance identifier]"
export EKS_ENDPOINT="[EKS' API server endpoint]"

aws ssm start-session \
  --target $BASTION_ID \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "{\"host\":[\"$EKS_ENDPOINT\"],\"portNumber\":[\"443\"],\"localPortNumber\":[\"8443\"]}"

# On a new terminal
kubectl config set-cluster [cluster-name] \
    --server=https://localhost:8443 \
    --insecure-skip-tls-verify=true

kubectl get ns
```

{{< details summary="Or do this to avoid skipping tls verification" >}}


However, if you don't want to compromise on skipping the TLS verification,
you'll be required to perform some extra steps, as shown below:

```sh
BASTION_ID="[EC2 instance identifier]"
EKS_ENDPOINT="[EKS' API server endpoint]"
EKS_HOST=$(echo "$EKS_ENDPOINT" | sed 's|https://||')
EKS_CA_PATH="/tmp/eks-ca.crt"

# Get endpoint's CA
aws eks describe-cluster --name [cluster-name] \
    --query "cluster.certificateAuthority.data" \
    --output text | base64 -d >$EKS_CA_PATH

# Configure cluster
kubectl config set-cluster [cluster-name] \
    --server=https://localhost:8443 \
    --certificate-authority="$EKS_CA_PATH" \
    --tls-server-name="$EKS_HOST"

# Start tunnel
aws ssm start-session \
  --target $BASTION_ID \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "{\"host\":[\"$EKS_ENDPOINT\"],\"portNumber\":[\"443\"],\"localPortNumber\":[\"8443\"]}"

# On a new terminal interact with the cluster
kubectl get ns
```

The important aspects of this version are:

- The cluster CA must exist on your localhost, that's why we export it
  beforehand
- The `tls-server-name`  still needs to be set, otherwise it would be inferred as `localhost`

{{< /details >}}

## My two cents

I needed to share these specific cases on how to use SSM sessions as SSH-like
tunnels to access fully private resources from localhost, since one often misses
that when passing through AWS documentation.

Also, I learned that going with this SSM approach is better (if you're on an
AWS-only shop) because:

- You have a cheaper and easier to manage approach to establish connections to
  private resources. No public IP addresses, no NAT, no exposed well-known ports
- SSM sessions enable you to reach private resources from your localhost without
  relying on SSH. This unblocks things that you might have compromised in the
  past; for me it was a way to finally have an honest to God fully private EKS
  cluster when using terraform/tofu
