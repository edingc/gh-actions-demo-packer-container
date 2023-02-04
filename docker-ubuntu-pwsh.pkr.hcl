packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
}

variable  "docker_repo" {
  type = string
  sensitive = true
}

variable  "docker_username" {
  type = string
  sensitive = true
}

variable "docker_password" {
  type = string
  sensitive = true
}

variable "tag" {
  type = string
}

source "docker" "ubuntu" {
  image  = "mcr.microsoft.com/powershell:ubuntu-jammy"
  commit = true
}

build {
  name    = "gh-actions-demo"
  sources = [
    "source.docker.ubuntu"
  ]

  post-processors {
    post-processor "docker-tag" {
      repository = var.docker_repo
      tags       = ["1.0"]
    }

    post-processor "docker-push" {
      login=true
      login_username = var.docker_username
      login_password = var.docker_password
    }
  }
}
