locals {
  # iam_role     = "arn:aws:iam::012345678912:role/terragrunt"
  # session_name = "gitlab-terragrunt-012345678912"
  # Modules version (sorted a-z)
  terraform-gitlab = "v0.1.0" # https://github.com/opsworks-co/terraform-gitlab
}

terraform_version_constraint  = "= 1.5.7"
terragrunt_version_constraint = "= 0.67.1"
# iam_role                      = local.iam_role

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
#remote_state {
#  backend = "s3"
#  config = {
#    encrypt        = true
#    bucket         = "gitlab-terraform-state"
#    key            = "${path_relative_to_include()}/terraform.tfstate"
#    region         = local.aws_region
#    dynamodb_table = "terraform-locks"
#  }
#  generate = {
#    path      = "backend.tf"
#    if_exists = "overwrite_terragrunt"
#  }
#}
