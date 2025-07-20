module "eks_auth" {
  source = "aidanmelen/eks-auth/aws"
  eks    = module.eks

  map_roles = [
    {
      rolearn  = "arn:aws:iam::${var.account_number}:user/${var.eksUser}"
      username = "${var.eksUser}"
      groups   = ["system:masters"]
    }
  ]
}