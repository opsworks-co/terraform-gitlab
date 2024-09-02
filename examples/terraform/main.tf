locals {
  group_files = fileset("${path.module}/groups", "*.yaml")
  groups = flatten([
    for file in local.group_files : yamldecode(file("${path.module}/groups/${file}")).groups
  ])

  # Read all YAML files from the projects directory
  project_files = fileset("${path.module}/projects", "*.yaml")
  projects = flatten([
    for file in local.project_files : yamldecode(file("${path.module}/projects/${file}")).projects
  ])
}

module "gitlab_resources" {
  source = "../.." # Adjust the path if necessary

  gitlab_groups   = local.groups
  gitlab_projects = local.projects

  gitlab_token    = "xxx"
  gitlab_base_url = "https://gitlab.com/api/v4/"

  tier = "premium"
}
