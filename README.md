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

}
```

**NOTE**: `platform` is a parameter for *all* **Cumberland Cloud** modules. For more information about the `platform`, in particular the permitted values of the nested fields, refer to the platform module documentation. The following section goes into more detail regarding the `sg` variable.
on goes into more detail regarding the `ec2` variable.