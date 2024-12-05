module "platform" {
  source                = "github.com/cumberland-terraform/platform"
  
  platform              = var.platform
  hydration             = {
    vpc_query           = false
    subnets_query       = false
    dmem_sg_query       = false
    rhel_sg_query       = false
    eks_ami_query       = false
  }
}

module "kms" {
  count                 = local.conditions.provision_kms_key ? 1 : 0
  source                = "github.com/cumberland-terraform/security-kms"

  platform              = var.platform
  kms                   = {
      alias_suffix      = var.secret.suffix
  }
}