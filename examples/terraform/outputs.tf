output "parrent_group_ids" {
  description = "List of created GitLab group IDs."
  value       = module.gitlab_resources.parrent_group_ids
}
output "subgroups_group_ids" {
  description = "List of created GitLab group IDs."
  value       = module.gitlab_resources.subgroups_group_ids
}
output "project_ids" {
  description = "List of created GitLab project IDs."
  value       = module.gitlab_resources.project_ids
}
