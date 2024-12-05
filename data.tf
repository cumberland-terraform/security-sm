data "aws_iam_policy_document" "merged" {
    count                       = local.conditions.merge ? 1 : 0

    source_policy_documents     = concat(
                                [ data.aws_iam_policy_document.unmerged.json ],
                                    var.secret.additional_policies
                                )
        
}

data "aws_iam_policy_document" "unmerged" {
    statement {
        sid                     = "EnableTenantAccess"
        effect                  = "Allow"
        actions                 = [ "secretsmanager:GetSecretValue" ]
        resources               = [ "*" ]

        principals {
            type                =  "AWS"
            identifiers         = local.unmerged_policy_principals
        }
    }
}