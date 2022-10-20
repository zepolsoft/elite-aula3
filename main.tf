terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "dop_v1_e0d5fd37b65cdeaeca715f34028bf6bca784a23a4706ef5d30fc04eded5f812d"
}

# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "jenkins" {
  image    = "ubuntu-22-04-x64"
  name     = "jenkins-vm"
  region   = "nyc1"
  size     = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.jornada.id]
}

data "digitalocean_ssh_key" "jornada" {
  name = "Jornada"
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name    = "k8s"
  region  = "nyc1"
  version = "1.24.4-do.0"

  node_pool {
    name       = "autoscale-worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}