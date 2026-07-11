
locals {
  tags = {
    env          = "dev"
    Project      = "my-app"
    ManagedBy    = "terraform"
  }
  aws_secret_manager = {
    secret_for_rds = {
      db_name = "dev-postgres-db"
      username = "my-app-dev"
      password = "set up in secret manager module"
    }
  }
  irsa = { 
    enable_eks_addons = {
      cluster_name          = "dev-my-app-eks"
      region                = "us-east-1"
      enable_alb_controller = true
      enable_dns_external   = true
      enable_ebs_csi_driver = true
      enable_eso            = true
      enable_karpenter      = true
      enable_cluster_autoscaler    = true
  }
    service_accounts = {
      alb_service_sa          = "aws-load-balancer-controller"
      karpenter_sa            = "karpenter"
      external_secrets_sa     = "external-secrets"
      ebs_csi_driver_sa       = "ebs-csi-controller-sa"
      ebs_csi_version         = "v1.30.0-eksbuild.1"
      external_dns_sa         = "external-dns"
      cluster_autoscaler_sa   = "cluster-autoscaler"
  }
  }
  vpc = {
    vpc_cidr = "10.0.0.0/16"
    azs = [
      "us-east-1a",
      "us-east-1b"
    ]
    private_subnets = [
      "10.0.1.0/24",
      "10.0.2.0/24"
    ]
    public_subnets = [
      "10.0.101.0/24",
      "10.0.102.0/24"
    ]
    enable_nat_gateway = true
    single_nat_gateway = true

  }
  rds = {
    engine_version = "15"
    multi_az       = false
    instance_class = "db.t3.micro"
    db_name        = "devpostgresdb"
    db_username    = "devmyappdb"
  }
  eks = {
      cluster_version = "1.30"
      enable_irsa     = true
      node_groups = {
        group1 = {
          node_instance_type = "t3.xlarge"
          desired_size       = 2
          min_size           = 2
          max_size           = 7
        }
    }
  }
  route53 = {
    domain_name = "quanldl.click"
  }
 
}

