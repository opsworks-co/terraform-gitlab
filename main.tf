
# Create Parent Groups
resource "gitlab_group" "parent_groups" {
  for_each = {
    for group in var.gitlab_groups :
    group.name => group
    if !contains(keys(group), "parent")
  }

  name             = each.value.name
  path             = lookup(each.value.settings, "path", each.value.name)
  description      = lookup(each.value.settings, "description", null)
  visibility_level = lookup(each.value.settings, "visibility", "private")

  # Group settings
  auto_devops_enabled                = lookup(each.value.settings, "auto_devops_enabled", false)
  lfs_enabled                        = lookup(each.value.settings, "lfs_enabled", true)
  mentions_disabled                  = lookup(each.value.settings, "mentions_disabled", false)
  project_creation_level             = lookup(each.value.settings, "project_creation_level", "maintainer")
  request_access_enabled             = lookup(each.value.settings, "request_access_enabled", false)
  require_two_factor_authentication  = lookup(each.value.settings, "require_two_factor_authentication", false)
  share_with_group_lock              = lookup(each.value.settings, "share_with_group_lock", false)
  subgroup_creation_level            = lookup(each.value.settings, "subgroup_creation_level", "owner")
  two_factor_grace_period            = lookup(each.value.settings, "two_factor_grace_period", 48)
  avatar                             = lookup(each.value.settings, "avatar", null)
  avatar_hash                        = lookup(each.value.settings, "avatar_hash", null)
  emails_enabled                     = lookup(each.value.settings, "emails_enabled", null)
  extra_shared_runners_minutes_limit = lookup(each.value.settings, "extra_shared_runners_minutes_limit", null)
  ip_restriction_ranges              = lookup(each.value.settings, "ip_restriction_ranges", null)
  membership_lock                    = lookup(each.value.settings, "membership_lock", null)
  prevent_forking_outside_group      = lookup(each.value.settings, "prevent_forking_outside_group", null)
  shared_runners_minutes_limit       = lookup(each.value.settings, "shared_runners_minutes_limit", null)
  shared_runners_setting             = lookup(each.value.settings, "shared_runners_setting", null)
  wiki_access_level                  = lookup(each.value.settings, "wiki_access_level", null)

  # Replace deprecated default_branch_protection with new block
  default_branch_protection_defaults {
    allow_force_push           = lookup(each.value.settings, "allow_force_push", false)
    allowed_to_merge           = lookup(each.value.settings, "allowed_to_merge", ["maintainer"])
    allowed_to_push            = lookup(each.value.settings, "allowed_to_push", ["maintainer"])
    developer_can_initial_push = lookup(each.value.settings, "developer_can_initial_push", false)
  }

  dynamic "push_rules" {
    for_each = length(lookup(each.value.settings, "push_rules", [])) > 0 ? toset(each.value.settings.push_rules) : []
    iterator = rule
    content {
      author_email_regex            = try(rule.value.author_email_regex, null)
      branch_name_regex             = try(rule.value.branch_name_regex, null)
      commit_committer_check        = try(rule.value.commit_committer_check, null)
      commit_message_negative_regex = try(rule.value.commit_message_negative_regex, null)
      commit_message_regex          = try(rule.value.commit_message_regex, null)
      deny_delete_tag               = try(rule.value.deny_delete_tag, null)
      file_name_regex               = try(rule.value.file_name_regex, null)
      max_file_size                 = try(rule.value.max_file_size, null)
      member_check                  = try(rule.value.member_check, null)
      prevent_secrets               = try(rule.value.prevent_secrets, null)
      reject_unsigned_commits       = try(rule.value.reject_unsigned_commits, null)
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Create Subgroups
resource "gitlab_group" "subgroups" {
  for_each = {
    for group in var.gitlab_groups :
    "${group.parent}/${group.name}" => group
    if contains(keys(group), "parent")
  }

  name             = each.value.name
  path             = lookup(each.value.settings, "path", each.value.name)
  description      = lookup(each.value.settings, "description", null)
  visibility_level = lookup(each.value.settings, "visibility", "private")

  # Set parent_id from the existing parent group
  parent_id = gitlab_group.parent_groups[each.value.parent].id

  # Group settings
  auto_devops_enabled                = lookup(each.value.settings, "auto_devops_enabled", false)
  lfs_enabled                        = lookup(each.value.settings, "lfs_enabled", true)
  mentions_disabled                  = lookup(each.value.settings, "mentions_disabled", false)
  project_creation_level             = lookup(each.value.settings, "project_creation_level", "maintainer")
  request_access_enabled             = lookup(each.value.settings, "request_access_enabled", false)
  require_two_factor_authentication  = lookup(each.value.settings, "require_two_factor_authentication", false)
  share_with_group_lock              = lookup(each.value.settings, "share_with_group_lock", false)
  subgroup_creation_level            = lookup(each.value.settings, "subgroup_creation_level", "owner")
  two_factor_grace_period            = lookup(each.value.settings, "two_factor_grace_period", 48)
  avatar                             = lookup(each.value.settings, "avatar", null)
  avatar_hash                        = lookup(each.value.settings, "avatar_hash", null)
  emails_enabled                     = lookup(each.value.settings, "emails_enabled", null)
  extra_shared_runners_minutes_limit = lookup(each.value.settings, "extra_shared_runners_minutes_limit", null)
  ip_restriction_ranges              = lookup(each.value.settings, "ip_restriction_ranges", null)
  membership_lock                    = lookup(each.value.settings, "membership_lock", null)
  prevent_forking_outside_group      = lookup(each.value.settings, "prevent_forking_outside_group", null)
  shared_runners_minutes_limit       = lookup(each.value.settings, "shared_runners_minutes_limit", null)
  shared_runners_setting             = lookup(each.value.settings, "shared_runners_setting", null)
  wiki_access_level                  = lookup(each.value.settings, "wiki_access_level", null)

  # Replace deprecated default_branch_protection with new block
  default_branch_protection_defaults {
    allow_force_push           = lookup(each.value.settings, "allow_force_push", false)
    allowed_to_merge           = lookup(each.value.settings, "allowed_to_merge", ["maintainer"])
    allowed_to_push            = lookup(each.value.settings, "allowed_to_push", ["maintainer"])
    developer_can_initial_push = lookup(each.value.settings, "developer_can_initial_push", false)
  }

  dynamic "push_rules" {
    for_each = try(each.value.settings.push_rules, [])
    iterator = rule
    content {
      author_email_regex            = try(rule.value.author_email_regex, null)
      branch_name_regex             = try(rule.value.branch_name_regex, null)
      commit_committer_check        = try(rule.value.commit_committer_check, null)
      commit_message_negative_regex = try(rule.value.commit_message_negative_regex, null)
      commit_message_regex          = try(rule.value.commit_message_regex, null)
      deny_delete_tag               = try(rule.value.deny_delete_tag, null)
      file_name_regex               = try(rule.value.file_name_regex, null)
      max_file_size                 = try(rule.value.max_file_size, null)
      member_check                  = try(rule.value.member_check, null)
      prevent_secrets               = try(rule.value.prevent_secrets, null)
      reject_unsigned_commits       = try(rule.value.reject_unsigned_commits, null)
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Create GitLab Group Access Tokens
resource "gitlab_group_access_token" "this" {
  for_each = merge([
    for group in var.gitlab_groups : {
      for token in lookup(group.settings, "access_tokens", []) : (
        contains(keys(group), "parent")
        ? "${group.parent}/${group.name}-${token.name}" # Use parent in the key if it exists
        : "${group.name}-${token.name}"                 # Fallback to group name only if no parent
        ) => {
        group_name = contains(keys(group), "parent") ? "${group.parent}/${group.name}" : group.name
        parent     = lookup(group, "parent", null)
        token      = token
      }
    }
  ]...)

  group = each.value.parent == null ? gitlab_group.parent_groups[each.value.group_name].id : gitlab_group.subgroups[each.value.group_name].id

  name         = each.value.token.name
  scopes       = each.value.token.scopes
  access_level = each.value.token.access_level

  # Conditionally set either `expires_at` or `rotation_configuration`, but not both
  expires_at = contains(keys(each.value.token), "rotation_configuration") ? null : each.value.token.expires_at

  rotation_configuration = contains(keys(each.value.token), "rotation_configuration") ? {
    expiration_days    = try(each.value.token.rotation_configuration.expiration_days, null)
    rotate_before_days = try(each.value.token.rotation_configuration.rotate_before_days, null)
  } : null
}

# Create GitLab Group Variables based on access tokens
resource "gitlab_group_variable" "access_token_this" {
  for_each = merge([
    for group in var.gitlab_groups : {
      for token in lookup(group.settings, "access_tokens", []) : (
        contains(keys(group), "parent")
        ? "${group.parent}/${group.name}-${token.name}" # Use parent in the key if it exists
        : "${group.name}-${token.name}"                 # Fallback to group name only if no parent
        ) => {
        group_name    = contains(keys(group), "parent") ? "${group.parent}/${group.name}" : group.name
        parent        = lookup(group, "parent", null)
        variable_name = lookup(token, "variable_name", null)
      } if lookup(token, "variable_name", null) != null # Only create variables if `variable_name` is set
    }
  ]...)

  group             = each.value.parent == null ? gitlab_group.parent_groups[each.value.group_name].id : gitlab_group.subgroups[each.value.group_name].id
  key               = each.value.variable_name
  value             = sensitive(gitlab_group_access_token.this[each.key].token)
  protected         = true
  masked            = true
  environment_scope = "*"
  description       = "Generated access token for ${gitlab_group_access_token.this[each.key].name}"
}

# Create GitLab Group Badges
resource "gitlab_group_badge" "this" {
  for_each = merge([
    for group in var.gitlab_groups : {
      for badge in lookup(group.settings, "badges", []) : (
        contains(keys(group), "parent")
        ? "${group.parent}/${group.name}-${badge.link_url}" # Use parent in the key if it exists
        : "${group.name}-${badge.link_url}"                 # Fallback to group name only if no parent
        ) => {
        group_name = contains(keys(group), "parent") ? "${group.parent}/${group.name}" : group.name
        parent     = lookup(group, "parent", null)
        badge      = badge
      }
    }
  ]...)

  group     = each.value.parent == null ? gitlab_group.parent_groups[each.value.group_name].id : gitlab_group.subgroups[each.value.group_name].id
  link_url  = each.value.badge.link_url
  image_url = each.value.badge.image_url
  name      = each.value.badge.name
}

# Create GitLab Group Custom Attributes
resource "gitlab_group_custom_attribute" "this" {
  for_each = merge([
    for group in var.gitlab_groups : {
      for attr in lookup(group.settings, "custom_attributes", []) : (
        contains(keys(group), "parent")
        ? "${group.parent}/${group.name}-${attr.key}" # Include parent in the key if it exists
        : "${group.name}-${attr.key}"                 # Fallback to group name only if no parent
        ) => {
        group_name = contains(keys(group), "parent") ? "${group.parent}/${group.name}" : group.name
        parent     = lookup(group, "parent", null)
        attribute  = attr
      }
    }
  ]...)

  group = each.value.parent == null ? gitlab_group.parent_groups[each.value.group_name].id : gitlab_group.subgroups[each.value.group_name].id
  key   = each.value.attribute.key
  value = each.value.attribute.value
}

# Create GitLab Group Labels
resource "gitlab_group_label" "this" {
  for_each = merge([
    for group in var.gitlab_groups : {
      for label in lookup(group.settings, "labels", []) : (
        contains(keys(group), "parent")
        ? "${group.parent}/${group.name}-${label.name}" # Include parent in the key if it exists
        : "${group.name}-${label.name}"                 # Fallback to group name only if no parent
        ) => {
        group_name = contains(keys(group), "parent") ? "${group.parent}/${group.name}" : group.name
        parent     = lookup(group, "parent", null)
        label      = label
      }
    }
  ]...)

  group       = each.value.parent == null ? gitlab_group.parent_groups[each.value.group_name].id : gitlab_group.subgroups[each.value.group_name].id
  name        = each.value.label.name
  description = lookup(each.value.label, "description", null)
  color       = each.value.label.color
}

# Create GitLab Group Epic Boards
resource "gitlab_group_epic_board" "this" {
  for_each = merge([
    for group in var.gitlab_groups : {
      for board in lookup(group.settings, "epic_boards", []) : (
        contains(keys(group), "parent")
        ? "${group.parent}/${group.name}-${board.name}" # Include parent in the key if it exists
        : "${group.name}-${board.name}"                 # Fallback to group name only if no parent
        ) => {
        group_name = contains(keys(group), "parent") ? "${group.parent}/${group.name}" : group.name
        parent     = lookup(group, "parent", null)
        board      = board
      }
    }
  ]...)

  name  = each.value.board.name
  group = each.value.parent == null ? gitlab_group.parent_groups[each.value.group_name].id : gitlab_group.subgroups[each.value.group_name].id

  dynamic "lists" {
    for_each = length(each.value.board.lists) > 0 ? toset(each.value.board.lists) : []
    iterator = rule
    content {
      label_id = lookup(local.label_map, rule.value.label_id, null)
    }
  }
}

# Create GitLab Group Hooks
resource "gitlab_group_hook" "this" {
  for_each = merge([
    for group in var.gitlab_groups : {
      for hook in lookup(group.settings, "hooks", []) : (
        contains(keys(group), "parent")
        ? "${group.parent}/${group.name}-${hook.url}" # Include parent in the key if it exists
        : "${group.name}-${hook.url}"                 # Fallback to group name only if no parent
        ) => {
        group_name = contains(keys(group), "parent") ? "${group.parent}/${group.name}" : group.name
        parent     = lookup(group, "parent", null)
        hook       = hook
      }
    }
  ]...)

  group                      = each.value.parent == null ? gitlab_group.parent_groups[each.value.group_name].id : gitlab_group.subgroups[each.value.group_name].id
  url                        = each.value.hook.url
  confidential_issues_events = lookup(each.value.hook, "confidential_issues_events", false)
  confidential_note_events   = lookup(each.value.hook, "confidential_note_events", false)
  custom_webhook_template    = lookup(each.value.hook, "custom_webhook_template", null)
  deployment_events          = lookup(each.value.hook, "deployment_events", false)
  enable_ssl_verification    = lookup(each.value.hook, "enable_ssl_verification", true)
  issues_events              = lookup(each.value.hook, "issues_events", false)
  job_events                 = lookup(each.value.hook, "job_events", false)
  merge_requests_events      = lookup(each.value.hook, "merge_requests_events", false)
  note_events                = lookup(each.value.hook, "note_events", false)
  pipeline_events            = lookup(each.value.hook, "pipeline_events", false)
  push_events                = lookup(each.value.hook, "push_events", false)
  push_events_branch_filter  = lookup(each.value.hook, "push_events_branch_filter", null)
  releases_events            = lookup(each.value.hook, "releases_events", false)
  subgroup_events            = lookup(each.value.hook, "subgroup_events", false)
  tag_push_events            = lookup(each.value.hook, "tag_push_events", false)
  token                      = lookup(each.value.hook, "token", null)
  wiki_page_events           = lookup(each.value.hook, "wiki_page_events", false)
}

# Create GitLab Group Issue Boards
resource "gitlab_group_issue_board" "this" {
  for_each = merge([
    for group in var.gitlab_groups : {
      for board in lookup(group.settings, "issue_boards", []) : (
        contains(keys(group), "parent")
        ? "${group.parent}/${group.name}-${board.name}" # Include parent in the key if it exists
        : "${group.name}-${board.name}"                 # Fallback to group name only if no parent
        ) => {
        group_name = contains(keys(group), "parent") ? "${group.parent}/${group.name}" : group.name
        parent     = lookup(group, "parent", null)
        board      = board
      }
    }
  ]...)

  name   = each.value.board.name
  group  = each.value.parent == null ? gitlab_group.parent_groups[each.value.group_name].id : gitlab_group.subgroups[each.value.group_name].id
  labels = each.value.board.labels
  dynamic "lists" {
    for_each = length(each.value.board.lists) > 0 ? toset(each.value.board.lists) : []
    iterator = rule
    content {
      label_id = lookup(local.label_map, rule.value.label_id, null)
      position = rule.value.position
    }
  }
  milestone_id = lookup(each.value.board, "milestone_id", null)
}

# Fetch User Data for Group Memberships
data "gitlab_user" "membership_user" {
  for_each = merge([
    for group in var.gitlab_groups : {
      for member in lookup(group.settings, "memberships", []) : member.user_id => member
    }
  ]...)

  username = each.value.user_id
}

# Create GitLab Group Memberships
resource "gitlab_group_membership" "this" {
  for_each = merge([
    for group in var.gitlab_groups : {
      for member in lookup(group.settings, "memberships", []) : (
        contains(keys(group), "parent")
        ? "${group.parent}/${group.name}-${member.user_id}" # Include parent in the key if it exists
        : "${group.name}-${member.user_id}"                 # Fallback to group name only if no parent
        ) => {
        group_name = contains(keys(group), "parent") ? "${group.parent}/${group.name}" : group.name
        parent     = lookup(group, "parent", null)
        member     = member
      }
    }
  ]...)

  group_id                      = each.value.parent == null ? gitlab_group.parent_groups[each.value.group_name].id : gitlab_group.subgroups[each.value.group_name].id
  access_level                  = each.value.member.access_level
  user_id                       = data.gitlab_user.membership_user[each.value.member.user_id].id
  expires_at                    = lookup(each.value.member, "expires_at", null)
  member_role_id                = contains(["premium", "ultimate"], lower(var.tier)) ? lookup(each.value.member, "member_role_id", null) : null
  skip_subresources_on_destroy  = lookup(each.value.member, "skip_subresources_on_destroy", false)
  unassign_issuables_on_destroy = lookup(each.value.member, "unassign_issuables_on_destroy", false)
}

# Create GitLab Protected Environments
resource "gitlab_group_protected_environment" "this" {
  for_each = merge([
    for group in var.gitlab_groups : {
      for env in lookup(group.settings, "protected_environments", []) : (
        contains(keys(group), "parent")
        ? "${group.parent}/${group.name}-${env.environment}" # Include parent in the key if it exists
        : "${group.name}-${env.environment}"                 # Fallback to group name only if no parent
        ) => {
        group_name = contains(keys(group), "parent") ? "${group.parent}/${group.name}" : group.name
        parent     = lookup(group, "parent", null)
        env        = env
      }
    }
  ]...)

  group                = each.value.parent == null ? gitlab_group.parent_groups[each.value.group_name].id : gitlab_group.subgroups[each.value.group_name].id
  deploy_access_levels = each.value.env.deploy_access_levels
  environment          = each.value.env.environment
  approval_rules       = each.value.env.approval_rules
}


# Create GitLab SAML Links
resource "gitlab_group_saml_link" "this" {
  for_each = merge([
    for group in var.gitlab_groups : {
      for saml_link in lookup(group.settings, "saml_links", []) : (
        contains(keys(group), "parent")
        ? "${group.parent}/${group.name}-${saml_link.saml_group_name}" # Use parent in the key if it exists
        : "${group.name}-${saml_link.saml_group_name}"                 # Fallback to group name only if no parent
        ) => {
        group_name = contains(keys(group), "parent") ? "${group.parent}/${group.name}" : group.name
        parent     = lookup(group, "parent", null)
        saml_link  = saml_link
      }
    }
  ]...)

  group           = each.value.parent == null ? gitlab_group.parent_groups[each.value.group_name].id : gitlab_group.subgroups[each.value.group_name].id
  access_level    = each.value.saml_link.access_level
  saml_group_name = each.value.saml_link.saml_group_name
}

# Create GitLab Group Variables
resource "gitlab_group_variable" "this_sensitive" {
  for_each = merge([
    for group in var.gitlab_groups : {
      for variable in lookup(group.settings, "variables", []) : (
        contains(keys(group), "parent")
        ? "${group.parent}/${group.name}-${variable.key}" # Include parent in the key if it exists
        : "${group.name}-${variable.key}"                 # Fallback to group name only if no parent
        ) => {
        group_name = contains(keys(group), "parent") ? "${group.parent}/${group.name}" : group.name
        parent     = lookup(group, "parent", null)
        variable   = variable
      } if lookup(variable, "masked", false) == true # Only sensitive ones
    }
  ]...)

  group             = each.value.parent == null ? gitlab_group.parent_groups[each.value.group_name].id : gitlab_group.subgroups[each.value.group_name].id
  key               = each.value.variable.key
  value             = each.value.variable.value
  protected         = lookup(each.value.variable, "protected", false)
  masked            = lookup(each.value.variable, "masked", false)
  hidden            = lookup(each.value.variable, "hidden", false)
  environment_scope = lookup(each.value.variable, "environment_scope", "*")
  description       = lookup(each.value.variable, "description", null)
  raw               = lookup(each.value.variable, "raw", false)
  variable_type     = lookup(each.value.variable, "variable_type", "env_var")
}

resource "gitlab_group_variable" "this" {
  for_each = merge([
    for group in var.gitlab_groups : {
      for variable in lookup(group.settings, "variables", []) : (
        contains(keys(group), "parent")
        ? "${group.parent}/${group.name}-${variable.key}" # Include parent in the key if it exists
        : "${group.name}-${variable.key}"                 # Fallback to group name only if no parent
        ) => {
        group_name = contains(keys(group), "parent") ? "${group.parent}/${group.name}" : group.name
        parent     = lookup(group, "parent", null)
        variable   = variable
      } if lookup(variable, "masked", false) == false # Only non-sensitive ones
    }
  ]...)

  group             = each.value.parent == null ? gitlab_group.parent_groups[each.value.group_name].id : gitlab_group.subgroups[each.value.group_name].id
  key               = each.value.variable.key
  value             = each.value.variable.value
  protected         = lookup(each.value.variable, "protected", false)
  masked            = lookup(each.value.variable, "masked", false)
  environment_scope = lookup(each.value.variable, "environment_scope", "*")
  description       = lookup(each.value.variable, "description", null)
  raw               = lookup(each.value.variable, "raw", false)
  variable_type     = lookup(each.value.variable, "variable_type", "env_var")
}

# Data sources to retrieve users and groups from GitLab
data "gitlab_users" "this" {}

data "gitlab_groups" "this" {}

# Locals to map users and groups for dynamic references
locals {
  label_map = { for group_name, label in gitlab_group_label.this : label.name => label.label_id }

  # Extract `share_groups` configurations from each group and remove duplicates
  share_groups = distinct(flatten([
    for group in var.gitlab_groups : [
      for share in lookup(group, "settings", {})["share_groups"] : merge(
        share,
        {
          group_id = group.name,
          parent   = lookup(group, "parent", null) # Ensure parent is included
        }
      )
    ] if contains(keys(lookup(group, "settings", {})), "share_groups")
  ]))

  # Group by username for users; this should not have duplicates
  exists_users = { for user in data.gitlab_users.this.users : user.email => user }

  # Group by name for groups, allowing for duplicates
  exists_groups = { for group in data.gitlab_groups.this.groups : group.full_path => group... }
}

# Create GitLab projects dynamically
resource "gitlab_project" "this" {
  for_each = {
    for project in var.gitlab_projects :
    "${project.namespace}/${project.name}" => project
  }

  name             = each.value.name
  description      = lookup(each.value, "description", null)
  visibility_level = lookup(each.value, "visibility", "private")

  namespace_id = try(
    local.exists_groups[each.value.namespace][0].group_id,
    gitlab_group.subgroups[each.value.namespace].id,
    gitlab_group.parent_groups[each.value.namespace].id,
    null
  )

  allow_merge_on_skipped_pipeline                  = lookup(each.value, "allow_merge_on_skipped_pipeline", null)
  analytics_access_level                           = lookup(each.value, "analytics_access_level", null)
  archive_on_destroy                               = lookup(each.value, "archive_on_destroy", null)
  archived                                         = lookup(each.value, "archived", null)
  auto_cancel_pending_pipelines                    = lookup(each.value, "auto_cancel_pending_pipelines", null)
  auto_devops_deploy_strategy                      = lookup(each.value, "auto_devops_deploy_strategy", null)
  auto_devops_enabled                              = lookup(each.value, "auto_devops_enabled", null)
  autoclose_referenced_issues                      = lookup(each.value, "autoclose_referenced_issues", null)
  avatar                                           = lookup(each.value, "avatar", null)
  avatar_hash                                      = lookup(each.value, "avatar_hash", null)
  build_git_strategy                               = lookup(each.value, "build_git_strategy", null)
  build_timeout                                    = lookup(each.value, "build_timeout", null)
  builds_access_level                              = lookup(each.value, "builds_access_level", null)
  ci_config_path                                   = lookup(each.value, "ci_config_path", null)
  ci_default_git_depth                             = lookup(each.value, "ci_default_git_depth", null)
  ci_forward_deployment_enabled                    = lookup(each.value, "ci_forward_deployment_enabled", null)
  ci_restrict_pipeline_cancellation_role           = lookup(each.value, "ci_restrict_pipeline_cancellation_role", null)
  ci_separated_caches                              = lookup(each.value, "ci_separated_caches", null)
  container_registry_access_level                  = lookup(each.value, "container_registry_access_level", null)
  default_branch                                   = lookup(each.value, "default_branch", "main")
  emails_enabled                                   = lookup(each.value, "emails_enabled", null)
  environments_access_level                        = lookup(each.value, "environments_access_level", null)
  external_authorization_classification_label      = lookup(each.value, "external_authorization_classification_label", null)
  feature_flags_access_level                       = lookup(each.value, "feature_flags_access_level", null)
  forked_from_project_id                           = lookup(each.value, "forked_from_project_id", null)
  forking_access_level                             = lookup(each.value, "forking_access_level", null)
  group_runners_enabled                            = lookup(each.value, "group_runners_enabled", null)
  group_with_project_templates_id                  = lookup(each.value, "group_with_project_templates_id", null)
  import_url                                       = lookup(each.value, "import_url", null)
  import_url_password                              = lookup(each.value, "import_url_password", null)
  import_url_username                              = lookup(each.value, "import_url_username", null)
  infrastructure_access_level                      = lookup(each.value, "infrastructure_access_level", null)
  initialize_with_readme                           = lookup(each.value, "initialize_with_readme", null)
  issues_access_level                              = lookup(each.value, "issues_access_level", null)
  issues_enabled                                   = lookup(each.value, "issues_enabled", true)
  issues_template                                  = lookup(each.value, "issues_template", null)
  keep_latest_artifact                             = lookup(each.value, "keep_latest_artifact", null)
  lfs_enabled                                      = lookup(each.value, "lfs_enabled", null)
  merge_commit_template                            = lookup(each.value, "merge_commit_template", null)
  merge_method                                     = lookup(each.value, "merge_method", null)
  merge_pipelines_enabled                          = lookup(each.value, "merge_pipelines_enabled", null)
  merge_requests_access_level                      = lookup(each.value, "merge_requests_access_level", null)
  merge_requests_enabled                           = lookup(each.value, "merge_requests_enabled", true)
  merge_requests_template                          = lookup(each.value, "merge_requests_template", null)
  merge_trains_enabled                             = lookup(each.value, "merge_trains_enabled", null)
  mirror                                           = lookup(each.value, "mirror", null)
  mirror_overwrites_diverged_branches              = lookup(each.value, "mirror_overwrites_diverged_branches", null)
  mirror_trigger_builds                            = lookup(each.value, "mirror_trigger_builds", null)
  monitor_access_level                             = lookup(each.value, "monitor_access_level", null)
  mr_default_target_self                           = lookup(each.value, "mr_default_target_self", null)
  only_allow_merge_if_all_discussions_are_resolved = lookup(each.value, "only_allow_merge_if_all_discussions_are_resolved", null)
  only_allow_merge_if_pipeline_succeeds            = lookup(each.value, "only_allow_merge_if_pipeline_succeeds", null)
  only_mirror_protected_branches                   = lookup(each.value, "only_mirror_protected_branches", null)
  packages_enabled                                 = lookup(each.value, "packages_enabled", null)
  pages_access_level                               = lookup(each.value, "pages_access_level", null)
  path                                             = lookup(each.value, "path", null)
  printing_merge_request_link_enabled              = lookup(each.value, "printing_merge_request_link_enabled", null)
  public_jobs                                      = lookup(each.value, "public_jobs", null)

  dynamic "container_expiration_policy" {
    for_each = try(each.value.container_expiration_policy, [])
    iterator = policy
    content {
      cadence           = policy.value.cadence
      enabled           = policy.value.enabled
      keep_n            = policy.value.keep_n
      name_regex_delete = policy.value.name_regex_delete
      name_regex_keep   = policy.value.name_regex_keep
      older_than        = policy.value.older_than
    }
  }

  dynamic "push_rules" {
    for_each = try(each.value.push_rules, [])
    iterator = rule
    content {
      author_email_regex            = try(rule.value.author_email_regex, null)
      branch_name_regex             = try(rule.value.branch_name_regex, null)
      commit_committer_check        = try(rule.value.commit_committer_check, null)
      commit_message_negative_regex = try(rule.value.commit_message_negative_regex, null)
      commit_message_regex          = try(rule.value.commit_message_regex, null)
      deny_delete_tag               = try(rule.value.deny_delete_tag, null)
      file_name_regex               = try(rule.value.file_name_regex, null)
      max_file_size                 = try(rule.value.max_file_size, null)
      member_check                  = try(rule.value.member_check, null)
      prevent_secrets               = try(rule.value.prevent_secrets, null)
      reject_unsigned_commits       = try(rule.value.reject_unsigned_commits, null)
    }
  }

  dynamic "timeouts" {
    for_each = try(each.value.timeouts, [])
    iterator = rule
    content {
      create = try(rule.value.create, null)
      delete = try(rule.value.delete, null)
    }
  }

  releases_access_level                   = lookup(each.value, "releases_access_level", null)
  remove_source_branch_after_merge        = lookup(each.value, "remove_source_branch_after_merge", null)
  repository_access_level                 = lookup(each.value, "repository_access_level", null)
  repository_storage                      = lookup(each.value, "repository_storage", null)
  request_access_enabled                  = lookup(each.value, "request_access_enabled", null)
  requirements_access_level               = lookup(each.value, "requirements_access_level", null)
  resolve_outdated_diff_discussions       = lookup(each.value, "resolve_outdated_diff_discussions", null)
  restrict_user_defined_variables         = lookup(each.value, "restrict_user_defined_variables", null)
  security_and_compliance_access_level    = lookup(each.value, "security_and_compliance_access_level", null)
  shared_runners_enabled                  = lookup(each.value, "shared_runners_enabled", null)
  skip_wait_for_default_branch_protection = lookup(each.value, "skip_wait_for_default_branch_protection", null)
  snippets_access_level                   = lookup(each.value, "snippets_access_level", null)
  snippets_enabled                        = lookup(each.value, "snippets_enabled", null)
  squash_commit_template                  = lookup(each.value, "squash_commit_template", null)
  squash_option                           = lookup(each.value, "squash_option", null)
  suggestion_commit_message               = lookup(each.value, "suggestion_commit_message", null)
  tags                                    = lookup(each.value, "tags", null)
  template_name                           = lookup(each.value, "template_name", null)
  template_project_id                     = lookup(each.value, "template_project_id", null)
  topics                                  = lookup(each.value, "topics", null)
  use_custom_template                     = lookup(each.value, "use_custom_template", null)
  wiki_access_level                       = lookup(each.value, "wiki_access_level", null)
  wiki_enabled                            = lookup(each.value, "wiki_enabled", null)
}

resource "gitlab_project_access_token" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for token in lookup(project.settings, "access_tokens", []) : "${project.namespace}-${project.name}-${token.name}" => {
        project_name      = project.name
        project_namespace = project.namespace
        token             = token
      }
    }
  ]...)

  project      = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  name         = each.value.token.name
  scopes       = each.value.token.scopes
  access_level = lookup(each.value.token, "access_level", "maintainer")

  # Conditionally set either `expires_at` or `rotation_configuration`, but not both
  expires_at = contains(keys(each.value.token), "rotation_configuration") ? null : each.value.token.expires_at
  rotation_configuration = contains(keys(each.value.token), "rotation_configuration") ? {
    expiration_days    = try(each.value.token.rotation_configuration.expiration_days, null)
    rotate_before_days = try(each.value.token.rotation_configuration.rotate_before_days, null)
  } : null
}

# Create GitLab Project Variables based on access tokens
resource "gitlab_project_variable" "access_token_this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for token in lookup(project.settings, "access_tokens", []) : "${project.namespace}-${project.name}-${token.name}" => {
        project_id    = gitlab_project.this["${project.namespace}/${project.name}"].id
        variable_name = lookup(token, "variable_name", null)
      } if lookup(token, "variable_name", null) != null # Only create variables if `variable_name` is set
    }
  ]...)

  project           = each.value.project_id
  key               = each.value.variable_name
  value             = sensitive(gitlab_project_access_token.this[each.key].token)
  protected         = true
  masked            = true
  environment_scope = "*"
  description       = "Generated access token for ${gitlab_project_access_token.this[each.key].name}"
}

resource "gitlab_project_approval_rule" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for rule in lookup(project.settings, "approval_rules", []) :
      "${project.namespace}-${project.name}-${rule.name}" => {
        project_name      = project.name
        project_namespace = project.namespace
        rule              = rule
      }
      if contains(["premium", "ultimate"], lower(var.tier))
    }
  ]...)

  # Correct the access to project ID
  project = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id

  name               = each.value.rule.name
  approvals_required = each.value.rule.approvals_required

  applies_to_all_protected_branches                     = lookup(each.value.rule, "applies_to_all_protected_branches", false)
  disable_importing_default_any_approver_rule_on_create = lookup(each.value.rule, "disable_importing_default_any_approver_rule_on_create", false)

  # Correctly resolve user and group IDs using keys
  user_ids  = length(lookup(each.value.rule, "user_emails", [])) > 0 ? [for user in lookup(each.value.rule, "user_emails", []) : local.exists_users[user].id] : null
  group_ids = length(lookup(each.value.rule, "group_names", [])) > 0 ? flatten([for group in lookup(each.value.rule, "group_names", []) : local.exists_groups[group][0].group_id]) : null

  rule_type = lookup(each.value.rule, "rule_type", null)
}

resource "gitlab_project_badge" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for badge in lookup(project.settings, "badges", []) :
      "${project.namespace}-${project.name}-${badge.name}" => {
        project_name      = project.name
        project_namespace = project.namespace
        badge             = badge
      }
    }
  ]...)

  # Use the correct project ID
  project   = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  link_url  = each.value.badge.link_url
  image_url = each.value.badge.image_url
  name      = each.value.badge.name
}

resource "gitlab_project_custom_attribute" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for attr in lookup(project.settings, "custom_attributes", []) :
      "${project.namespace}-${project.name}-${attr.key}" => {
        project_name      = project.name
        project_namespace = project.namespace
        attribute         = attr
      }
    }
  ]...)

  # Use the correct project ID
  project = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  key     = each.value.attribute.key
  value   = each.value.attribute.value
}

resource "gitlab_project_environment" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for env in lookup(project.settings, "environments", []) :
      "${project.namespace}-${project.name}-${env.name}" => {
        project_name      = project.name
        project_namespace = project.namespace
        environment       = env
      }
    }
  ]...)

  # Use the correct project ID
  project             = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  name                = each.value.environment.name
  external_url        = lookup(each.value.environment, "external_url", null)
  stop_before_destroy = lookup(each.value.environment, "stop_before_destroy", false)
}

resource "gitlab_project_freeze_period" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for freeze_period in lookup(project.settings, "freeze_periods", []) : "${project.namespace}-${project.name}-${freeze_period.freeze_start}" => {
        project_name      = project.name
        project_namespace = project.namespace
        freeze_period     = freeze_period
      }
    }
  ]...)

  # Use the correct project ID
  project       = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  freeze_start  = each.value.freeze_period.freeze_start
  freeze_end    = each.value.freeze_period.freeze_end
  cron_timezone = each.value.freeze_period.cron_timezone
}

resource "gitlab_project_hook" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for hook in lookup(project.settings, "hooks", []) :
      "${project.namespace}-${project.name}-${hook.url}" => {
        project_name      = project.name
        project_namespace = project.namespace
        hook              = hook
      }
      if contains(["premium", "ultimate"], lower(var.tier))
    }
  ]...)

  # Use the correct project ID
  project                    = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  url                        = each.value.hook.url
  confidential_issues_events = lookup(each.value.hook, "confidential_issues_events", false)
  confidential_note_events   = lookup(each.value.hook, "confidential_note_events", false)
  custom_webhook_template    = lookup(each.value.hook, "custom_webhook_template", null)
  deployment_events          = lookup(each.value.hook, "deployment_events", false)
  enable_ssl_verification    = lookup(each.value.hook, "enable_ssl_verification", true)
  issues_events              = lookup(each.value.hook, "issues_events", false)
  job_events                 = lookup(each.value.hook, "job_events", false)
  merge_requests_events      = lookup(each.value.hook, "merge_requests_events", false)
  note_events                = lookup(each.value.hook, "note_events", false)
  pipeline_events            = lookup(each.value.hook, "pipeline_events", false)
  push_events                = lookup(each.value.hook, "push_events", false)
  push_events_branch_filter  = lookup(each.value.hook, "push_events_branch_filter", null)
  releases_events            = lookup(each.value.hook, "releases_events", false)
  tag_push_events            = lookup(each.value.hook, "tag_push_events", false)
  token                      = lookup(each.value.hook, "token", null)
  wiki_page_events           = lookup(each.value.hook, "wiki_page_events", false)
}

resource "gitlab_project_issue" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for issue in lookup(project.settings, "issues", []) :
      "${project.namespace}-${project.name}-${issue.title}" => {
        project_name      = project.name
        project_namespace = project.namespace
        issue             = issue
      }
    }
  ]...)

  # Use the correct project ID
  project = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  title   = each.value.issue.title

  # Dynamically assign all attributes from the issue
  assignee_ids                            = lookup(each.value.issue, "assignee_ids", null)
  confidential                            = lookup(each.value.issue, "confidential", false)
  created_at                              = lookup(each.value.issue, "created_at", null)
  delete_on_destroy                       = lookup(each.value.issue, "delete_on_destroy", false)
  description                             = <<EOT
  Welcome to the ${each.value.project_name} project!
  EOT
  discussion_locked                       = lookup(each.value.issue, "discussion_locked", false)
  discussion_to_resolve                   = lookup(each.value.issue, "discussion_to_resolve", null)
  due_date                                = lookup(each.value.issue, "due_date", null)
  epic_issue_id                           = lookup(each.value.issue, "epic_issue_id", null)
  iid                                     = lookup(each.value.issue, "iid", null)
  issue_type                              = lookup(each.value.issue, "issue_type", "issue")
  labels                                  = lookup(each.value.issue, "labels", [])
  merge_request_to_resolve_discussions_of = lookup(each.value.issue, "merge_request_to_resolve_discussions_of", null)
  milestone_id                            = lookup(each.value.issue, "milestone_id", null)
  state                                   = lookup(each.value.issue, "state", "opened")
  updated_at                              = lookup(each.value.issue, "updated_at", null)
  weight                                  = lookup(each.value.issue, "weight", null)
}

resource "gitlab_project_job_token_scope" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for scope in lookup(project.settings, "job_token_scopes", []) :
      "${project.namespace}-${project.name}-${scope.target_project_id}" => {
        project_name      = project.name
        project_namespace = project.namespace
        job_token_scope   = scope
      }
    }
  ]...)

  # Use the correct project ID
  project           = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  target_project_id = gitlab_project.this[each.value.job_token_scope.target_project_id].id
}

resource "gitlab_project_label" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for label in lookup(project.settings, "labels", []) :
      "${project.namespace}-${project.name}-${label.name}" => {
        project_name      = project.name
        project_namespace = project.namespace
        label             = label
      }
    }
  ]...)

  # Use the correct project ID
  project     = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  name        = each.value.label.name
  description = lookup(each.value.label, "description", null)
  color       = lookup(each.value.label, "color", "#428BCA") # Default color if not specified
}

resource "gitlab_project_level_mr_approvals" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for approval in lookup(project.settings, "level_mr_approvals", []) :
      "${project.namespace}-${project.name}-${approval.project}" => {
        project_name       = project.name
        project_namespace  = project.namespace
        level_mr_approvals = approval
      }
      if contains(["premium", "ultimate"], lower(var.tier))
    }
  ]...)

  # Use the correct project ID
  project                                        = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  disable_overriding_approvers_per_merge_request = lookup(each.value.level_mr_approvals, "disable_overriding_approvers_per_merge_request", false)
  merge_requests_author_approval                 = lookup(each.value.level_mr_approvals, "merge_requests_author_approval", false)
  merge_requests_disable_committers_approval     = lookup(each.value.level_mr_approvals, "merge_requests_disable_committers_approval", false)
  require_password_to_approve                    = lookup(each.value.level_mr_approvals, "require_password_to_approve", false)
  reset_approvals_on_push                        = lookup(each.value.level_mr_approvals, "reset_approvals_on_push", false)
  selective_code_owner_removals                  = lookup(each.value.level_mr_approvals, "selective_code_owner_removals", false)
}

resource "gitlab_project_membership" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for member in lookup(project.settings, "memberships", []) :
      "${project.namespace}-${project.name}-${member.user_email}" => {
        project_name      = project.name
        project_namespace = project.namespace
        member            = member
      }
    }
  ]...)

  # Use the correct project ID
  project      = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  user_id      = contains(keys(local.exists_users), each.value.member.user_email) ? local.exists_users[each.value.member.user_email].id : null
  access_level = each.value.member.access_level
  expires_at   = lookup(each.value.member, "expires_at", null)
}

resource "gitlab_project_milestone" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for milestone in lookup(project.settings, "milestones", []) :
      "${project.namespace}-${project.name}-${milestone.title}" => {
        project_name      = project.name
        project_namespace = project.namespace
        milestone         = milestone
      }
    }
  ]...)

  # Use the correct project ID
  project     = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  title       = each.value.milestone.title
  description = lookup(each.value.milestone, "description", null)
  due_date    = lookup(each.value.milestone, "due_date", null)
  start_date  = lookup(each.value.milestone, "start_date", null)
  state       = lookup(each.value.milestone, "state", "active") # Default state if not specified
}

resource "gitlab_project_mirror" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for mirror in [lookup(project.settings, "mirror", null)] :
      "${project.namespace}-${project.name}-mirror" => {
        project_name            = project.name
        project_namespace       = project.namespace
        url                     = mirror.url
        enabled                 = lookup(mirror, "enabled", true)
        keep_divergent_refs     = lookup(mirror, "keep_divergent_refs", false)
        only_protected_branches = lookup(mirror, "only_protected_branches", false)
      }
      if mirror != null
    }
  ]...)

  project                 = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  url                     = each.value.url
  enabled                 = each.value.enabled
  keep_divergent_refs     = each.value.keep_divergent_refs
  only_protected_branches = each.value.only_protected_branches
}

resource "gitlab_project_protected_environment" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for env in lookup(project.settings, "protected_environments", []) :
      "${project.namespace}-${project.name}-${env.environment}" => {
        project_name      = project.name
        project_namespace = project.namespace
        environment       = env
      }
      if contains(["premium", "ultimate"], lower(var.tier))
    }
  ]...)

  # Use the correct project ID
  environment = each.value.environment.environment
  project     = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id


  # Dynamic block for access level
  dynamic "deploy_access_levels" {
    for_each = [for lvl in try(each.value.environment.deploy_access_levels, []) : lvl if lookup(lvl, "access_level", null) != null]
    iterator = lvl
    content {
      access_level = try(lvl.value.access_level, null)
    }
  }

  # Dynamic block for group_id
  dynamic "deploy_access_levels" {
    for_each = [for lvl in try(each.value.environment.deploy_access_levels, []) : lvl if lookup(lvl, "group", null) != null]
    iterator = lvl
    content {
      group_id = contains(keys(local.exists_groups), lvl.value.group) ? local.exists_groups[lvl.value.group][0].group_id : null
    }
  }

  # Dynamic block for user_id
  dynamic "deploy_access_levels" {
    for_each = [for lvl in try(each.value.environment.deploy_access_levels, []) : lvl if lookup(lvl, "user_email", null) != null]
    iterator = lvl
    content {
      user_id = contains(keys(local.exists_users), lvl.value.user_email) ? local.exists_users[lvl.value.user_email].id : null
    }
  }

  # Set approval rules directly as a list of objects
  approval_rules = flatten([
    for rule in lookup(each.value.environment, "approval_rules", []) : [
      {
        access_level       = lookup(rule, "access_level", null)
        required_approvals = lookup(rule, "required_approvals", null)
        group_id           = lookup(rule, "group", null) != null && contains(keys(local.exists_groups), lookup(rule, "group", "")) ? local.exists_groups[lookup(rule, "group", "")][0].group_id : null
        user_id            = lookup(rule, "user_email", null) != null && contains(keys(local.exists_users), lookup(rule, "user_email", "")) ? local.exists_users[lookup(rule, "user_email", "")].id : null
      }
    ]
  ])
}

resource "gitlab_project_runner_enablement" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for runner in lookup(project.settings, "runners", []) :
      "${project.namespace}-${project.name}-${runner.runner_id}" => {
        project_name      = project.name
        project_namespace = project.namespace
        runner_id         = runner.runner_id
      }
    }
  ]...)

  project   = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  runner_id = each.value.runner_id
}

resource "gitlab_project_share_group" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for sg in lookup(project.settings, "share_groups", []) :
      "${project.namespace}-${project.name}-${sg.group}" => {
        project_name      = project.name
        project_namespace = project.namespace
        group_name        = sg.group
        group_access      = lookup(sg, "group_access", null)
      }
    }
  ]...)

  project      = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  group_id     = contains(keys(local.exists_groups), each.value.group_name) ? local.exists_groups[each.value.group_name][0].group_id : null
  group_access = lookup(each.value, "group_access", "guest")
}

resource "gitlab_project_variable" "this_sensitive" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for variable in lookup(project.settings, "variables", []) :
      "${project.namespace}-${project.name}-${variable.key}" => {
        project_name      = project.name
        project_namespace = project.namespace
        variable          = variable
      } if lookup(variable, "masked", false) == true # Only sensitive ones
    }
  ]...)

  project           = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  key               = each.value.variable.key
  value             = sensitive(each.value.variable.value)
  protected         = lookup(each.value.variable, "protected", false)
  masked            = lookup(each.value.variable, "masked", false)
  environment_scope = lookup(each.value.variable, "environment_scope", "*")
  description       = lookup(each.value.variable, "description", null)
  raw               = lookup(each.value.variable, "raw", false)
  variable_type     = lookup(each.value.variable, "variable_type", "env_var")
}


resource "gitlab_project_variable" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for variable in lookup(project.settings, "variables", []) :
      "${project.namespace}-${project.name}-${variable.key}" => {
        project_name      = project.name
        project_namespace = project.namespace
        variable          = variable
      } if lookup(variable, "masked", false) == false # Only non-sensitive ones
    }
  ]...)

  project           = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  key               = each.value.variable.key
  value             = each.value.variable.value
  protected         = lookup(each.value.variable, "protected", false)
  masked            = lookup(each.value.variable, "masked", false)
  environment_scope = lookup(each.value.variable, "environment_scope", "*")
  description       = lookup(each.value.variable, "description", null)
  raw               = lookup(each.value.variable, "raw", false)
  variable_type     = lookup(each.value.variable, "variable_type", "env_var")
}

resource "gitlab_deploy_key" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for key in lookup(project.settings, "deploy_keys", []) :
      "${project.namespace}-${project.name}-${key.title}" => {
        project_name      = project.name
        project_namespace = project.namespace
        deploy_key        = key
      }
    }
  ]...)

  project  = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  title    = each.value.deploy_key.title
  key      = each.value.deploy_key.key
  can_push = lookup(each.value.deploy_key, "can_push", false)
}

resource "gitlab_pages_domain" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for domain in lookup(project.settings, "pages_domains", []) :
      "${project.namespace}-${project.name}-${domain.domain}" => {
        project_name      = project.name
        project_namespace = project.namespace
        domain_data       = domain
      }
    }
  ]...)

  project          = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  domain           = each.value.domain_data.domain
  key              = each.value.domain_data.key
  certificate      = lookup(each.value.domain_data, "auto_ssl_enabled", false) == true ? null : each.value.domain_data.certificate
  auto_ssl_enabled = lookup(each.value.domain_data, "auto_ssl_enabled", false)
  expired          = lookup(each.value.domain_data, "expired", false)
}

resource "gitlab_pipeline_schedule" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for pipeline in lookup(project.settings, "pipeline_schedules", []) :
      "${project.namespace}-${project.name}-${pipeline.ref}-${pipeline.description}" => {
        project_name      = project.name
        project_namespace = project.namespace
        pipeline_schedule = pipeline
      }
    }
  ]...)

  project        = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  description    = each.value.pipeline_schedule.description
  ref            = each.value.pipeline_schedule.ref
  cron           = each.value.pipeline_schedule.cron
  active         = lookup(each.value.pipeline_schedule, "active", false)
  cron_timezone  = lookup(each.value.pipeline_schedule, "cron_timezone", "UTC")
  take_ownership = lookup(each.value.pipeline_schedule, "take_ownership", false)
}

# Create the map for 'for_each' by flattening the project, pipeline, and variable structure
locals {
  pipeline_variables = flatten([
    for project in var.gitlab_projects : [
      for pipeline in lookup(project.settings, "pipeline_schedules", []) : [
        for variable in lookup(pipeline, "variables", []) : {
          project_name      = project.name
          project_namespace = project.namespace
          pipeline_schedule = pipeline
          variable          = variable
          unique_key        = "${project.namespace}-${project.name}-${pipeline.ref}-${pipeline.description}-${variable.key}"
        }
      ]
    ]
  ])
}

# Convert the flattened list to a map for 'for_each'
resource "gitlab_pipeline_schedule_variable" "variables" {
  for_each = {
    for item in local.pipeline_variables : item.unique_key => item
  }

  project              = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  pipeline_schedule_id = gitlab_pipeline_schedule.this["${each.value.project_namespace}-${each.value.project_name}-${each.value.pipeline_schedule.ref}-${each.value.pipeline_schedule.description}"].pipeline_schedule_id
  key                  = each.value.variable.key
  value                = each.value.variable.value
}

resource "gitlab_pipeline_trigger" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for trigger in lookup(project.settings, "pipeline_triggers", []) :
      "${project.namespace}-${project.name}-${trigger.description}" => {
        project_name      = project.name
        project_namespace = project.namespace
        trigger           = trigger
      }
    }
  ]...)

  project     = tostring(gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id)
  description = each.value.trigger.description
}

resource "gitlab_release_link" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for release in lookup(project.settings, "release_links", []) :
      "${project.namespace}-${project.name}-${release.name}" => {
        project_name      = project.name
        project_namespace = project.namespace
        release_link      = release
      }
    }
  ]...)

  project   = tostring(gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id)
  tag_name  = each.value.release_link.tag_name
  name      = each.value.release_link.name
  url       = each.value.release_link.url
  filepath  = lookup(each.value.release_link, "filepath", null)
  link_type = lookup(each.value.release_link, "link_type", "other")
}

resource "gitlab_branch" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for branch in lookup(project.settings, "branches", []) :
      "${project.namespace}-${project.name}-${branch.name}" => {
        project_name      = project.name
        project_namespace = project.namespace
        branch            = branch
      }
    }
  ]...)

  name    = each.value.branch.name
  project = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  ref     = each.value.branch.ref
}

# Create GitLab Branch Protection for Protected Branches
resource "gitlab_branch_protection" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for branch in lookup(project.settings, "branches", []) :
      "${project.namespace}-${project.name}-${branch.name}" => {
        project_name      = project.name
        project_namespace = project.namespace
        branch            = branch
      } if lookup(branch, "protected", false) == true # Only create protection if `protected` is set to true
    }
  ]...)

  project                      = gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id
  branch                       = each.value.branch.name
  push_access_level            = lookup(each.value.branch, "push_access_level", "maintainer")
  merge_access_level           = lookup(each.value.branch, "merge_access_level", "maintainer")
  unprotect_access_level       = lookup(each.value.branch, "unprotect_access_level", "admin")
  allow_force_push             = lookup(each.value.branch, "allow_force_push", false)
  code_owner_approval_required = lookup(each.value.branch, "code_owner_approval_required", true)

  # Dynamic blocks for allowed_to_push
  dynamic "allowed_to_push" {
    for_each = lookup(each.value.branch, "allowed_to_push", [])
    content {
      user_id  = contains(keys(local.exists_users), lookup(allowed_to_push.value, "user_email", "")) ? local.exists_users[allowed_to_push.value.user_email].id : null
      group_id = contains(keys(local.exists_groups), lookup(allowed_to_push.value, "group", "")) ? local.exists_groups[allowed_to_push.value.group][0].group_id : null
    }
  }

  # Dynamic blocks for allowed_to_merge
  dynamic "allowed_to_merge" {
    for_each = lookup(each.value.branch, "allowed_to_merge", [])
    content {
      user_id  = contains(keys(local.exists_users), lookup(allowed_to_merge.value, "user_email", "")) ? local.exists_users[allowed_to_merge.value.user_email].id : null
      group_id = contains(keys(local.exists_groups), lookup(allowed_to_merge.value, "group", "")) ? local.exists_groups[allowed_to_merge.value.group][0].group_id : null
    }
  }

  # Dynamic blocks for allowed_to_unprotect
  dynamic "allowed_to_unprotect" {
    for_each = lookup(each.value.branch, "allowed_to_unprotect", [])
    content {
      user_id  = contains(keys(local.exists_users), lookup(allowed_to_unprotect.value, "user_email", "")) ? local.exists_users[allowed_to_unprotect.value.user_email].id : null
      group_id = contains(keys(local.exists_groups), lookup(allowed_to_unprotect.value, "group", "")) ? local.exists_groups[allowed_to_unprotect.value.group][0].group_id : null
    }
  }
}

resource "gitlab_repository_file" "this" {
  for_each = merge([
    for project in var.gitlab_projects : {
      for file in lookup(project.settings, "repository_files", []) :
      "${project.namespace}-${project.name}-${file.file_path}" => {
        project_name      = project.name
        project_namespace = project.namespace
        file              = file
      }
    }
  ]...)

  project               = tostring(gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id)
  file_path             = each.value.file.file_path
  branch                = each.value.file.branch
  content               = each.value.file.content
  author_email          = each.value.file.author_email
  author_name           = each.value.file.author_name
  commit_message        = lookup(each.value.file, "commit_message", null)
  create_commit_message = lookup(each.value.file, "create_commit_message", null)
  delete_commit_message = lookup(each.value.file, "delete_commit_message", null)
  update_commit_message = lookup(each.value.file, "update_commit_message", null)
  encoding              = lookup(each.value.file, "encoding", "text")
  execute_filemode      = lookup(each.value.file, "execute_filemode", false)
  overwrite_on_create   = lookup(each.value.file, "overwrite_on_create", false)
  start_branch          = lookup(each.value.file, "start_branch", null)

  dynamic "timeouts" {
    for_each = each.value.file.timeouts != null ? [each.value.file.timeouts] : []
    iterator = item
    content {
      create = try(item.value.create, null)
      delete = try(item.value.delete, null)
      update = try(item.value.update, null)
    }
  }
}

##integrations
resource "gitlab_integration_emails_on_push" "this" {
  for_each = {
    for project in var.gitlab_projects :
    "${project.namespace}-${project.name}-${lookup(project.settings.integration_emails_on_push, "recipients", "no-recipient")}" => {
      project_name      = project.name
      project_namespace = project.namespace
      integration       = lookup(project.settings, "integration_emails_on_push", null)
    }
    if lookup(project.settings, "integration_emails_on_push", null) != null
  }

  project                   = contains(keys(gitlab_project.this), "${each.value.project_namespace}/${each.value.project_name}") ? gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id : one(gitlab_project.this[*].id)
  recipients                = each.value.integration.recipients
  branches_to_be_notified   = each.value.integration.branches_to_be_notified
  disable_diffs             = each.value.integration.disable_diffs
  push_events               = each.value.integration.push_events
  send_from_committer_email = each.value.integration.send_from_committer_email
  tag_push_events           = each.value.integration.tag_push_events
}

resource "gitlab_integration_external_wiki" "this" {
  for_each = {
    for project in var.gitlab_projects :
    "${project.namespace}-${project.name}-${lookup(project.settings.integration_external_wiki, "external_wiki_url", "no-url")}" => {
      project_name      = project.name
      project_namespace = project.namespace
      integration       = lookup(project.settings, "integration_external_wiki", null)
    }
    if lookup(project.settings, "integration_external_wiki", null) != null
  }

  project           = contains(keys(gitlab_project.this), "${each.value.project_namespace}/${each.value.project_name}") ? gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id : one(gitlab_project.this[*].id)
  external_wiki_url = each.value.integration.external_wiki_url
}

resource "gitlab_integration_github" "this" {
  for_each = {
    for project in var.gitlab_projects :
    "${project.namespace}-${project.name}-${lookup(project.settings.integration_github, "repository_url", "no-url")}" => {
      project_name      = project.name
      project_namespace = project.namespace
      integration       = lookup(project.settings, "integration_github", null)
    }
    if lookup(project.settings, "integration_github", null) != null
  }

  project        = contains(keys(gitlab_project.this), "${each.value.project_namespace}/${each.value.project_name}") ? gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id : one(gitlab_project.this[*].id)
  token          = each.value.integration.token
  repository_url = each.value.integration.repository_url
  static_context = lookup(each.value.integration, "static_context", false)
}

resource "gitlab_integration_jira" "this" {
  for_each = {
    for project in var.gitlab_projects :
    "${project.namespace}-${project.name}-${lookup(project.settings.integration_jira, "url", "no-url")}" => {
      project_name      = project.name
      project_namespace = project.namespace
      integration       = lookup(project.settings, "integration_jira", null)
    }
    if lookup(project.settings, "integration_jira", null) != null
  }

  project                         = contains(keys(gitlab_project.this), "${each.value.project_namespace}/${each.value.project_name}") ? gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id : one(gitlab_project.this[*].id)
  url                             = each.value.integration.url
  username                        = each.value.integration.username
  password                        = each.value.integration.password
  api_url                         = each.value.integration.api_url
  comment_on_event_enabled        = each.value.integration.comment_on_event_enabled
  commit_events                   = each.value.integration.commit_events
  issues_enabled                  = each.value.integration.issues_enabled
  jira_auth_type                  = each.value.integration.jira_auth_type
  jira_issue_prefix               = each.value.integration.jira_issue_prefix
  jira_issue_regex                = each.value.integration.jira_issue_regex
  jira_issue_transition_automatic = each.value.integration.jira_issue_transition_automatic
  jira_issue_transition_id        = each.value.integration.jira_issue_transition_id
  merge_requests_events           = each.value.integration.merge_requests_events
  project_key                     = each.value.integration.project_key
  project_keys                    = each.value.integration.project_keys
  use_inherited_settings          = each.value.integration.use_inherited_settings
}

resource "gitlab_integration_microsoft_teams" "this" {
  for_each = {
    for project in var.gitlab_projects :
    "${project.namespace}-${project.name}-${lookup(project.settings.integration_microsoft_teams, "webhook", "no-webhook")}" => {
      project_name      = project.name
      project_namespace = project.namespace
      integration       = lookup(project.settings, "integration_microsoft_teams", null)
    }
    if lookup(project.settings, "integration_microsoft_teams", null) != null
  }

  project                      = contains(keys(gitlab_project.this), "${each.value.project_namespace}/${each.value.project_name}") ? gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id : one(gitlab_project.this[*].id)
  webhook                      = each.value.integration.webhook
  branches_to_be_notified      = each.value.integration.branches_to_be_notified
  confidential_issues_events   = each.value.integration.confidential_issues_events
  confidential_note_events     = each.value.integration.confidential_note_events
  issues_events                = each.value.integration.issues_events
  merge_requests_events        = each.value.integration.merge_requests_events
  note_events                  = each.value.integration.note_events
  notify_only_broken_pipelines = each.value.integration.notify_only_broken_pipelines
  pipeline_events              = each.value.integration.pipeline_events
  push_events                  = each.value.integration.push_events
  tag_push_events              = each.value.integration.tag_push_events
  wiki_page_events             = each.value.integration.wiki_page_events
}

resource "gitlab_integration_pipelines_email" "this" {
  for_each = {
    for project in var.gitlab_projects :
    "${project.namespace}-${project.name}-${join("-", lookup(project.settings.integration_pipelines_email, "recipients", ["no-recipients"]))}" => {
      project_name      = project.name
      project_namespace = project.namespace
      integration       = lookup(project.settings, "integration_pipelines_email", null)
    }
    if lookup(project.settings, "integration_pipelines_email", null) != null
  }

  project                      = contains(keys(gitlab_project.this), "${each.value.project_namespace}/${each.value.project_name}") ? gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id : one(gitlab_project.this[*].id)
  recipients                   = toset(each.value.integration.recipients)
  notify_only_broken_pipelines = each.value.integration.notify_only_broken_pipelines
  branches_to_be_notified      = each.value.integration.branches_to_be_notified
}

resource "gitlab_integration_slack" "this" {
  for_each = {
    for project in var.gitlab_projects :
    "${project.namespace}-${project.name}-${lookup(project.settings, "integration_slack", {}).webhook}" => {
      project_name      = project.name
      project_namespace = project.namespace
      integration       = lookup(project.settings, "integration_slack", null)
    }
    if lookup(project.settings, "integration_slack", null) != null
  }

  project                      = contains(keys(gitlab_project.this), "${each.value.project_namespace}/${each.value.project_name}") ? gitlab_project.this["${each.value.project_namespace}/${each.value.project_name}"].id : one(gitlab_project.this[*].id)
  webhook                      = each.value.integration.webhook
  branches_to_be_notified      = each.value.integration.branches_to_be_notified
  confidential_issue_channel   = each.value.integration.confidential_issue_channel
  confidential_issues_events   = each.value.integration.confidential_issues_events
  confidential_note_events     = each.value.integration.confidential_note_events
  issue_channel                = each.value.integration.issue_channel
  issues_events                = each.value.integration.issues_events
  merge_request_channel        = each.value.integration.merge_request_channel
  merge_requests_events        = each.value.integration.merge_requests_events
  note_channel                 = each.value.integration.note_channel
  note_events                  = each.value.integration.note_events
  notify_only_broken_pipelines = each.value.integration.notify_only_broken_pipelines
  pipeline_channel             = each.value.integration.pipeline_channel
  pipeline_events              = each.value.integration.pipeline_events
  push_channel                 = each.value.integration.push_channel
  push_events                  = each.value.integration.push_events
  tag_push_channel             = each.value.integration.tag_push_channel
  tag_push_events              = each.value.integration.tag_push_events
  username                     = each.value.integration.username
  wiki_page_channel            = each.value.integration.wiki_page_channel
  wiki_page_events             = each.value.integration.wiki_page_events
}

# Combine Project and Group Deploy Tokens
resource "gitlab_deploy_token" "this" {
  for_each = merge(
    merge([
      for project in var.gitlab_projects : {
        for token in lookup(project.settings, "deploy_tokens", []) :
        "project-${project.namespace}-${project.name}-${token.name}" => {
          type         = "project"
          name         = token.name
          namespace    = project.namespace
          entity_name  = project.name
          deploy_token = token
          entity_id    = gitlab_project.this["${project.namespace}/${project.name}"].id
        }
      }
    ]...),
    merge([
      for group in var.gitlab_groups : {
        for token in lookup(group.settings, "deploy_tokens", []) : (
          contains(keys(group), "parent")
          ? "group-${group.parent}/${group.name}-${token.name}" # Include parent in the key if it exists
          : "group-${group.name}-${token.name}"                 # Fallback to group name only if no parent
          ) => {
          type         = "group"
          parent       = lookup(group, "parent", null)
          name         = token.name
          entity_name  = contains(keys(group), "parent") ? "${group.parent}/${group.name}" : group.name
          deploy_token = token
          entity_id    = contains(keys(group), "parent") ? gitlab_group.subgroups["${group.parent}/${group.name}"].id : gitlab_group.parent_groups[group.name].id
        }
      }
    ]...)
  )

  # Conditional assignment for project or group
  project = each.value.type == "project" ? each.value.entity_id : null
  group   = each.value.type == "group" ? each.value.entity_id : null

  name       = each.value.deploy_token.name
  scopes     = each.value.deploy_token.scopes
  expires_at = lookup(each.value.deploy_token, "expires_at", null)
  username   = lookup(each.value.deploy_token, "username", null)
}

# Create GitLab Group Sharing
resource "gitlab_group_share_group" "this" {
  for_each = {
    for group in local.share_groups :
    group.parent != null ? "${group.parent}/${group.group_id}-${group.share_group_id}" : "${group.group_id}-${group.share_group_id}" => group
  }

  group_id = contains(keys(gitlab_group.parent_groups), each.value.group_id) ? gitlab_group.parent_groups[each.value.group_id].id : (
    contains(keys(gitlab_group.subgroups), each.value.group_id)
    ? gitlab_group.subgroups[each.value.group_id].id
    : gitlab_group.subgroups["${each.value.parent}/${each.value.group_id}"].id
  )
  share_group_id = contains(keys(gitlab_group.parent_groups), each.value.share_group_id) ? gitlab_group.parent_groups[each.value.share_group_id].id : (
    contains(keys(gitlab_group.subgroups), each.value.share_group_id)
    ? gitlab_group.subgroups[each.value.share_group_id].id
    : gitlab_group.subgroups["${each.value.parent}/${each.value.share_group_id}"].id
  )
  group_access = each.value.group_access
  expires_at   = lookup(each.value, "expires_at", null)
}
