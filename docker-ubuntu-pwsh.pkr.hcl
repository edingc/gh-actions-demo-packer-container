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
  provisioner "shell" {
    inline = [
    "apt-get update",
    "apt-get install --no-install-recommends -y git",
    "git clone --depth 1 https://github.com/edingc/gh-actions-demo-files.git /opt",
    "apt-get dist-upgrade -y",
    "apt-get remove -y git",
    "apt-get autoremove",
    "apt-get clean",
    "rm -rf /var/lib/apt/lists/*"
    ]
  }
  post-processors {
    post-processor "docker-tag" {
      repository = var.docker_repo
      tags       = ["latest", var.tag]
    }
    post-processor "docker-push" {
      login=true
      login_username = var.docker_username
      login_password = var.docker_password
    }
  }
}
