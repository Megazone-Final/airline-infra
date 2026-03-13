# prod

This directory is the Terraform entrypoint for the single shared AWS environment used by the project.

Use this folder to compose reusable modules from `../../modules` into the live runtime.
Right now the live entrypoint creates only the shared VPC.

Networking inputs in this environment follow the schema defined by `../../modules/vpc`.
The default values match the approved `10.0.0.0/24` main CIDR and `100.64.0.0/23` pod CIDR layout.
If you need to change subnet ranges, edit `cidr_block`, `subnet_cidrs`, and `pod_subnet_cidrs` rather than the old public/private subnet list pattern.

Recommended ownership:

- shared networking needed by the project

비활성 예시 파일은 `.tf.example` 확장자로 두었습니다.
현재 참고용 예시는 아래 파일들입니다.
- `s3.tf.example`
- `eks.tf.example`
- `iam.tf.example`
- `cloudwatch.tf.example`
- `rds.tf.example`
- `security-group.tf.example`
- `waf.tf.example`

Do not create parallel `dev` or `stage` stacks unless the project budget and operational model actually require them.

hi
