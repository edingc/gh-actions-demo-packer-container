packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
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
}
