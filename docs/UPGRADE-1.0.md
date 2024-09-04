# Upgrade to 1.x

This update refactors the management of GitLab groups and access tokens in the Terraform configuration file (main.tf). The changes aim to simplify and improve the maintainability of the code by reducing redundancy and using more streamlined variables.

## Key Changes

1. Unified Variable for Group Management:
   - Replaced the use of separate local variables (local.parent_groups and local.subgroups) with a unified variable (var.gitlab_groups).
   - This change simplifies the group creation logic by using a single source of truth for group data.
2. Simplified Access Token Management:
   - Consolidated the creation of GitLab group access tokens into a single resource definition.
   - Removed redundant definitions and optimized the access token creation process.
3. Fixed projects update when new group is added.

## ⚠️ Important Update ⚠️

This version is not directly compatible with the previous one. You will need to rename resources in your state to ensure compatibility.

## List of backwards incompatible changes

- **Unified Resource Management**: Parent groups and subgroups previously had separate resources for tokens, hooks, etc. Now, everything is created and managed in a single location.
- **Resource Renaming**: All resources have been renamed. For example, the resource previously named `"gitlab_group_issue_board" "subgroup_issue_boards"` is now simply `resource "gitlab_group_issue_board" "this"`.
- **Streamlined Deploy Tokens**: There is now a single resource for managing deploy tokens across both groups and projects.
