module "platform" {
  source                = "github.com/cumberland-terraform/platform.git"
  
  platform              = var.platform
}

module "kms" {
  count                 = local.conditions.provision_kms_key ? 1 : 0
  source                = "github.com/cumberland-terraform/security-kms.git"

  platform              = var.platform
  kms                   = {
      alias_suffix      = var.secret.suffix
  }
}