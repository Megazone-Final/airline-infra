# prod

This directory is the Terraform entrypoint for the shared AWS production environment.

Top-level files are the active Terraform root.
Reference material is split to keep the entrypoint readable:
- `examples/`: disabled `.tf.example` snippets
- `legacy/`: old commented-out reference files that should not be loaded by Terraform

Current active scope:
- shared VPC
- EKS and WAF module wiring kept in the root, but enablement depends on the active variables and apply flow

Terraform remote state:
- bucket: `s3-an2-airline-tfstate-036333380579-ap-northeast-2-an`
- key: `prod/terraform.tfstate`
- region: `ap-northeast-2`
- kms_key_id: `arn:aws:kms:ap-northeast-2:036333380579:key/40c16cfc-d284-4f40-a5ed-368bf54022a3`

Networking inputs in this environment follow the schema defined by `../../modules/vpc`.
The default values match the approved `10.0.0.0/24` primary CIDR and `100.64.0.0/23` pod CIDR layout.
If you need to change subnet ranges or placement, edit `cidr_block`, `pod_secondary_cidr`, and `subnets`.

Reference examples:
- `examples/cloudwatch.tf.example`
- `examples/eks.tf.example`
- `examples/iam.tf.example`
- `examples/s3.tf.example`
- `examples/security-group.tf.example`
- `examples/terraform.tfvars.example`
- `examples/waf.tf.example`

Do not create parallel `dev` or `stage` stacks unless the project budget and operational model actually require them.
