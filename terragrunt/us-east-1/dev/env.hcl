
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
      domain_name           = "quanldl.uk"
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
      cluster_autoscaler_sa   = "cluster_autoscaler"
  }
  }
  vpc = {
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
          node_instance_type = "t3.large"
          desired_size       = 2
          min_size           = 2
          max_size           = 4
        }
    }
  }
  route53 = {
    domain_name = "quanldl.click"
  }
 
}

