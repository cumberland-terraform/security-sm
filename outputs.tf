output "secret" {
    value                   = merge({
        secret              = aws_secretsmanager_secret.secret
        version             = aws_secretsmanager_secret_version.secret_version
        string              = sensitive(local.secret_string)
    }, local.conditions.is_key ? {
        public_key_openssh  = tls_private_key.this[0].public_key_openssh
        public_key_pem      = tls_private_key.this[0].public_key_pem
        key_name            = aws_key_pair.this[0].key_name
    }: { })
}