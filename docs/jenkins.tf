terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_volume" "jenkins-docker-certs" {
  name = "jenkins-docker-certs"
}

resource "docker_volume" "jenkins-data" {
  name = "jenkins-data"
}

resource "docker_image" "dind" {
  name         = "docker:dind"
  keep_locally = false
}

resource "docker_network" "network_jenkins" {
  name = "jenkins"
}

resource "docker_container" "jenkins-docker" {
  image = docker_image.dind.image_id
  name  = "jenkins-docker"
  volumes {
    volume_name    = docker_volume.jenkins-docker-certs.name
    container_path = "/certs/client"
  }
  volumes {
    volume_name    = docker_volume.jenkins-data.name
    container_path = "/var/jenkins_home"
  }
  networks_advanced {
    name    = docker_network.network_jenkins.name
    aliases = ["docker"]
  }
  ports {
    internal = 2376
    external = 2376
  }
  privileged = true
  rm         = true
  env = [
    "DOCKER_TLS_CERTDIR=/certs",
  ]
}

resource "docker_container" "jenkins-blueocean" {
  image = "myjenkins-blueocean"
  name  = "jenkins-blueocean"
  volumes {
    volume_name    = docker_volume.jenkins-docker-certs.name
    container_path = "/certs/client"
    read_only      = true
  }
  volumes {
    volume_name    = docker_volume.jenkins-data.name
    container_path = "/var/jenkins_home"
  }
  networks_advanced {
    name    = docker_network.network_jenkins.name
    aliases = ["jenkins-blueocean"]
  }
  ports {
    internal = 8080
    external = 8080
  }
  ports {
    internal = 50000
    external = 50000
  }
  env = [
    "DOCKER_HOST=tcp://docker:2376",
    "DOCKER_CERT_PATH=/certs/client",
    "DOCKER_TLS_VERIFY=1"
  ]
}