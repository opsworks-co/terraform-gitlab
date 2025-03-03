terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "= 17.9.0"
    }
  }
  required_version = ">= 1.4.0"
}
