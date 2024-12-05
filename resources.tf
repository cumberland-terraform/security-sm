resource "random_password" "this" {
    count                       = local.conditions.is_random ? 1 : 0
    
    length                      = var.secret.random.length
    special                     = local.platform_defaults.special
    override_special            = var.secret.random.special_characters
}

resource "aws_key_pair" "this" {
    count                       = local.conditions.is_key ? 1 : 0

    key_name                    = local.name
    public_key                  = tls_private_key.this[0].public_key_openssh
}


resource "tls_private_key" "this" {
    count                       = local.conditions.is_key ? 1 : 0

    algorithm                   = var.secret.ssh_key.algorithm
    rsa_bits                    = var.secret.ssh_key.bits
}

resource "aws_secretsmanager_secret" "secret" {
    name                        = local.name
    kms_key_id                  = local.kms_key_id
    recovery_window_in_days     = local.platform_defaults.recovery_window_in_days
    tags                        = local.tags
    policy                      = local.policy
    
    lifecycle {
        # TF is interpretting the tag calculations as a modification everytime 
        #   a plan is run, so ignore until issue is resuled.
        ignore_changes          = [ tags ]
    }
} 

resource "aws_secretsmanager_secret_version" "secret_version" {
    secret_id                   = aws_secretsmanager_secret.secret.id
    secret_string               = local.secret_string
}