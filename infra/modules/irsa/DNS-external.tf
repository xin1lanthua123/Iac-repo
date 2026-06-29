

resource "aws_iam_role" "externaldns_irsa" {
  count = var.enable_dns_external ? 1 : 0
  name = "${var.cluster_name}-externaldns-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = var.oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_host}:sub" = "system:serviceaccount:external-dns:${var.external_dns_sa}",
            "${local.oidc_host}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "externaldns_policy" {
  count = var.enable_dns_external ? 1 : 0
  name        = "${var.cluster_name}-externaldns-policy"
  description = "Allow ExternalDNS to manage Route53 DNS records"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # ExternalDNS needs to list zones and records
      {
        Effect = "Allow",
        Action = [
          "route53:ListHostedZones"
        ],
        Resource = ["*"]
      },

      # Allow changes only on specific hosted zones
      {
        Effect = "Allow",
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListTagsForResources",
          "route53:ListResourceRecordSets"
        ],
        # Resource = var.route53_zone_arns
        Resource = ["arn:aws:route53:::hostedzone/Z06648491EIV5VVWZPY0X"]  
      } 
    ]
  })
}

resource "aws_iam_role_policy_attachment" "externaldns_attach" {
  count = var.enable_dns_external ? 1 : 0
  role       = aws_iam_role.externaldns_irsa[0].name
  policy_arn = aws_iam_policy.externaldns_policy[0].arn
}
