terraform {
  #source = "git@github.com:opsworks-co/terraform-gitlab.git//.?ref=${include.root.locals.terraform-gitlab}"
  source = get_repo_root()
}

# Include all settings from the root terragrunt.hcl file
include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  alpha_groups   = yamldecode(file("${get_terragrunt_dir()}/config/groups/alpha.yaml"))
  roles_groups   = yamldecode(file("${get_terragrunt_dir()}/config/groups/roles.yaml"))
  alpha_projects = yamldecode(file("${get_terragrunt_dir()}/config/projects/alpha_projects.yaml"))
}

inputs = {

  gitlab_groups   = concat(local.alpha_groups.groups, local.roles_groups.groups)
  gitlab_projects = local.alpha_projects.projects
  gitlab_token    = "xxx"
  gitlab_base_url = "https://gitlab.com/api/v4/"
  tier            = "premium"

}
