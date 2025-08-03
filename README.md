# Enterprise Terraform 
## Cumberland Cloud Platform
## AWS Security - Secrets Manager

Documentation goes here.

### Usage

The bare minimum deployment can be achieved with the following configuration,

***providers.tf**

```hcl
provider "aws" {
    region                  = "us-east-1"

    assume_role {
        role_arn            = "arn:aws:iam::<target-account>:role/<target-role>"
    }
}
```
**modules.tf**

```
module "secret" {
	source 					= "github.com/cumberland-terraform/security-sg"
	
	platform				= {
		client          	= "<client>"
    	environment         = "<environment>"
	}

	secret 					= {
		suffix 				= "<suffix>"
		random 				= {
			enabled 		= true
		}
	}

	kms 					= {
		aws_managed 		= true
	}

}
```

`platform` is a parameter for *all* **Cumberland Cloud** modules. For more information about the `platform`, in particular the permitted values of the nested fields, see the ``platform`` module documentation. 

## KMS Key Deployment Options

### 1: Module Provisioned Key

If the `var.kms` is set to `null` (default value), the module will attempt to provision its own KMS key. This means the role assumed by Terraform in the `provider` 

### 2: User Provided Key

If the user of the module prefers to use a pre-existing customer managed key, the `id`, `arn` and `alias_arn` of the `var.kms` variable must be passed in. This will override the provisioning of the KMS key inside of the module.

### 3: AWS Managed Key

If the user of the module prefers to use an AWS managed KMS key, the `var.kms.aws_managed` property must be set to `true`.
