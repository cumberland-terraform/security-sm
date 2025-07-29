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

### Parameters

There are two main parameters to be aware of when using `security-sm`:

1. `secret`: This is an object that represents the configuration for a secret. This object contains several properties that allow the user to generate the value of the secret within the module. This is the recommended use of this module. By generating the secret within the module, it stays out of the Terraform state.
	- `suffix`: (*Required*) This is the suffix appended to the end of the secret name.
	- `random`: (*Optional*) An object that allows the user to randomize the secret value.
		- `enabled`: A boolean flag for enabling this subroutine. Defaults to `false`
		- `length`: The length of the generated string. Defaults to `16`
		- `special_characters`: A string that contains any special characters that should be included in generation. Defaults to `"!#$%&*()-_=+[]{}<>:?"`
	- `ssh_key`: (*Optional*) An object that allows the user to generate a private SSH key for the secret. 
		- `enabled`: A boolean flag for enabling this subroutine. Defaults to `false`.
		- `algorithm`: Algorithm used to generate key. Defaults to `RSA`
		- `bit`: Number of bits in key. Defaults to `4096`.
	- `kms_key`: (*Optional*) KMS key used to encrypt. If no KMS key is passed in, one will be provisioned. 
		- `id`:  Physical ID of the KMS Key
		- `arn`: AWS ARN of the KMS Key
2. `value`: (*Optional*) This argument is only required if you want to override the procedurally generated secrets with your own custom value. It is recommended this should only be done as a last resort, as the secret value will be exposed in the Terraform state. The type of the `value` variable is `any`, meaning any type of data structure may be passed in: a `map`, a `list`, stringified JSON, etc.

## Contributing

The below instructions are to be performed within Unix-style terminal. 

It is recommended to use Git Bash if using a Windows machine. Installation and setup of Git Bash can be found [here](https://git-scm.com/downloads/win)

### Step 1: Clone Repo

Clone the repository. Details on the cloning process can be found [here](https://support.atlassian.com/bitbucket-cloud/docs/clone-a-git-repository/)

If the repository is already cloned, ensure it is up to date with the following commands,

```bash
git checkout master
git pull
```

### Step 2: Create Branch

Create a branch from the `master` branch. The branch name should be formatted as follows:

	feature/<TICKET_NUMBER>

Where the value of `<TICKET_NUMBER>` is the ticket for which your work is associated. 

The basic command for creating a branch is as follows:

```bash
git checkout -b feature/<TICKET_NUMBER>
```

For more information, refer to the documentation [here](https://docs.gitlab.com/ee/tutorials/make_first_git_commit/#create-a-branch-and-make-changes)

### Step 3: Commit Changes

Update the code and commit the changes,

```bash
git commit -am "<TICKET_NUMBER> - description of changes"
```

More information on commits can be found in the documentation [here](https://docs.gitlab.com/ee/tutorials/make_first_git_commit/#commit-and-push-your-changes)

### Step 4: Merge With Master On Local


```bash
git checkout master
git pull
git checkout feature/<TICKET_NUMBER>
git merge master
```

For more information, see [git documentation](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)


### Step 5: Push Branch to Remote

After committing changes, push the branch to the remote repository,

```bash
git push origin feature/<TICKET_NUMBER>
```

### Step 6: Pull Request

Create a pull request. More information on this can be found [here](https://www.atlassian.com/git/tutorials/making-a-pull-request).

Once the pull request is opened, a pipeline will kick off and execute a series of quality gates for linting, security scanning and testing tasks.

### Step 7: Merge

After the pipeline successfully validates the code and the Pull Request has been approved, merge the Pull Request in `master`.

After the code changes are in master, the new version should be tagged. To apply a tag, the following commands can be executed,

```bash
git tag v1.0.1
git push tag v1.0.1
```

Update the `CHANGELOG.md` with information about changes.

### Pull Request Checklist

Ensure each item on the following checklist is complete before updating any tenant deployments with a new version of this module,

- [] Merge `master` into `feature/*` branch
- [] Open PR from `feature/*` branch into `master` branch
- [] Ensure tests are passing in Jenkins
- [] Get approval from lead
- [] Merge into `master`
- [] Increment `git tag` version
- [] Update Changelog
- [] Publish latest version on Confluence