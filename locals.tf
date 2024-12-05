locals {
    ## PLATFORM DEFAULTS
    #   These are platform specific configuration options. They should only need
    #       updated if the platform itself changes.   
    platform_defaults           = {
        recovery_window_in_days = 7
        special                 = true
    }

     ## CONDITIONS
    #   Configuration object containing boolean calculations that correspond
    #       to different deployment configurations.
    conditions                  = {
        merge                   = var.secret.additional_policies != null
        root_principal          = var.secret.policy_principals == null
        provision_kms_key       = var.secret.kms_key == null
        is_random               = var.secret.random.enabled
        is_key                  = var.secret.ssh_key.enabled
    }

    ## CALCULATED PROPERTIES
    #   Variables that change based on the deployment configuration. 
    kms_key_id                  = local.conditions.provision_kms_key ? (
                                    module.kms[0].key.id
                                ) : !var.secret.kms_key.aws_managed ? (
                                    var.secret.kms_key.id
                                ) : null

    tags                        = merge({
        # TODO: Secret specific tags
    }, module.platform.tags)

    name                        = upper(join("-", [
                                    "SM",
                                    module.platform.prefix,
                                    var.secret.suffix
                                ]))

    secret_string               = local.conditions.is_random ? (
                                    random_password.this[0].result
                                ) : local.conditions.is_key ? ( 
                                    tls_private_key.this[0].private_key_pem
                                ) : var.value
                                
    unmerged_policy_principals  = local.conditions.root_principal ? [
                                    module.platform.aws.arn.root
                                ] : var.secret.policy_principals

    policy                      = local.conditions.merge ? (
                                    data.aws_iam_policy_document.merged[0].json 
                                ) : data.aws_iam_policy_document.unmerged.json
}