terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 17.3.0"
    }
  }
  required_version = ">= 1.3.0"
}
