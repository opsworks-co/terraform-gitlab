# GitLab Terraform Module

This Terraform module provides resources to manage GitLab groups, projects, integrations, and other configurations. It supports creating and managing GitLab resources using a structured configuration approach with YAML files or direct variable definitions.

## Features

- Manage GitLab groups and projects.
- Configure integrations (e.g., custom issue tracker, Jira, Slack, etc.).
- Define custom project settings, approval rules, badges, and more.
- Easily extendable and customizable to fit various GitLab environments.

## Limitations

- Creation of local users is not supported at the moment, only via SAML

## Requirements

- Terraform 1.5.7 or higher.
- GitLab Provider for Terraform 17.3.0 or higher.

## Usage

### Step 1: Create Your Configuration Files

1. **Groups Configuration**

   Define your GitLab groups in YAML files located in the `groups` directory. Example `groups/groups.yaml`:

   ```yaml
   groups:
     - name: alpha
       create: true
       settings:
         visibility: private
         description: "Development top-level group"
         share_groups:
           - share_group_id: "roles_test/security-view"
             group_access: reporter
     - name: roles_test
       create: true
       settings:
         visibility: private
         description: "Parent group for user roles subgroups"
    ```

2. **Projects Configuration**

    Define your GitLab projects in YAML files located in the projects directory. Example projects/projects.yaml:

    ```yaml
    projects:
    - name: project-alpha
        create: true
        visibility: private
        description: "Alpha project description"
        settings: {}
    ```

### Step 2: Use the Module

Create a main.tf file and use the module to manage your GitLab resources:

    ```hcl
    module "gitlab_resources" {
    source = "../module/gitlab_module"

    gitlab_groups   = local.groups
    gitlab_projects = local.projects
    }
    ```

### Step 3: Initialize and Apply

1.	**Initialize Terraform:**

    ```sh
    terraform init
    ```

2.	**Apply the Terraform configuration:**

    ```sh
    terraform apply
    ```

### Step 4: Verify Outputs

The module will output the IDs and URLs of the created resources. You can check the created GitLab resources by visiting their URLs.

## Inputs

The module accepts the following inputs:

- gitlab_groups: List of GitLab groups to create and configure.
- gitlab_projects: List of GitLab projects to create and configure.
- gitlab_token: GitLab toke
- gitlab_base_url: Url of the GitLab instance API
- tier: Tier of your GitLab license

Refer to the variables.tf file for more details.

## Outputs

The module provides the following outputs:

- group_ids: List of IDs for the created GitLab groups.
- project_ids: List of IDs for the created GitLab projects.
- Other resource-specific outputs, such as integration settings and custom configurations.

## Examples

You can find examples in the examples/ directory for different use cases, such as managing multiple groups, configuring integrations, and using different YAML configurations.

- [terraform](https://github.com/opsworks-co/terraform-gitlab/tree/main/examples/terraform) - How to use module with terraform
- [terragrunt](https://github.com/opsworks-co/terraform-gitlab/tree/main/examples/terragrunt) - How to use module with terragrunt


## Authors

Module is maintained by [Serhii Kaidalov](https://github.com/wiseelf).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/opsworks-co/terraform-gitlab/tree/main/LICENSE) for full details.
