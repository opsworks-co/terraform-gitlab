
# Variables for the GitLab module

variable "gitlab_groups" {
  description = "List of GitLab groups to manage."
  type        = any
}

variable "gitlab_projects" {
  description = "List of GitLab projects to manage."
  type        = any
}

variable "tier" {
  type        = string
  description = "Gitlab tier"
  default     = "free"
  validation {
    condition     = contains(["free", "premium", "ultimate"], lower(var.tier))
    error_message = "The tier value must be one of `free`, `premium`, `ultimate`."
  }
}

variable "gitlab_token" {
  description = "GitLab token for API access"
  type        = string
  default     = "xxxxx"
}

variable "gitlab_base_url" {
  description = "GitLab token for API access"
  type        = string
  default     = "https://gitlab.com/api/v4/"
}
