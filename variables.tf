variable "platform" {
  description                           = "Platform metadata configuration object. See [Platform Module] (https://source.mdthink.maryland.gov/projects/etm/repos/mdt-eter-platform/browse) for detailed information about the permitted values for each field."
  type                                  = object({
    client                              = string
    environment                         = string
  })
}

variable "secret" {
  description                           = "Secret configuration. If the `secret_value` is not passed in then `random.enabled` or `key.enabled` must be set to `true`. If the value of `random.enabled` is set to `true`, the value of the secret will be randomized according to the properties nested underneath the `random` propery. If `key.enabled` is set to `true`, the the value of the secret will be a RSA 4096 byte PEM key. The key material can be configured through the properties nested underneath `key`. While it would be desirable to determine based on if `secret_value` is null, whether or not the value of the secret should be randomized or generated as an SSH key; However, this can not be handled currently in Terraform, since the value of the secret must be known ahead of a `plan` or `apply`. Therefore, the current approach of setting a `bool` to randomize the secret value is the only current valid solution. `suffix` is appended to the platform resource prefixes. The `policy_principals` is a list of IAM principal ARNs to add to the access policy. If no `policy_principals` are provided, access will be provided to all principals in the account."
  type                                  = object({
    suffix                              = string
    random                              = optional(object({
      enabled                           = optional(bool, false)
      length                            = optional(number, 16)
      special_characters                = optional(string, "!#$%&*()-_=+[]{}<>:?")
    }), {
      enabled                           = false
      length                            = 16
      special_characters                = "!#$%&*()-_=+[]{}<>:?"
    }),
    ssh_key                             = optional(object({
      enabled                           = optional(bool, false)
      algorithm                         = optional(string, "RSA")
      bits                              = optional(number, 4096)
    }), {
      enabled                           = false
      algorithm                         = "RSA"
      bits                              = 4096
    })
    policy_principals                   = optional(list(string), null)      
    additional_policies                 = optional(list(string), null)
    kms_key                             = optional(object({
      aws_managed                       = optional(bool, false)
      id                                = optional(string, null)
      arn                               = optional(string, null)
    }), null)
  })
}

variable "value" {
  description                           = "Value of secret to be provisioned. It is recommended to use this only as a last resort. The value of the secret should be generated through randomization procedures within the module."
  type                                  = any
  sensitive                             = true
  default                               = null
}
