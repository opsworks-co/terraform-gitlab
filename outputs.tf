
# Outputs for the GitLab module

output "parrent_group_ids" {
  description = "List of created GitLab group IDs."
  value       = [for group in gitlab_group.parent_groups : group.id]
}

output "subgroups_group_ids" {
  description = "List of created GitLab group IDs."
  value       = [for group in gitlab_group.subgroups : group.id]
}

output "project_ids" {
  description = "List of created GitLab project IDs."
  value       = [for project in gitlab_project.this : project.id]
}

output "deploy_token_ids" {
  description = "IDs of created deploy tokens."
  value       = [for token in gitlab_deploy_token.this : token.id]
}

output "pipeline_schedule_ids" {
  description = "IDs of created pipeline schedules."
  value       = [for schedule in gitlab_pipeline_schedule.this : schedule.id]
}

output "integration_slack_ids" {
  description = "IDs of Slack integrations."
  value       = [for integration in gitlab_integration_slack.this : integration.id]
}
