terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("calm-library.json")
  project = "calm-library-264211"
  region  = var.region
  zone    = "${var.region}-a"
}

resource "google_compute_network" "eschool_network" {
  name                    = "eschool-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "eschool_subnetwork" {
  name                     = "eschool-subnetwork"
  ip_cidr_range            = var.network_cidr
  network                  = google_compute_network.eschool_network.self_link
  region                   = var.region
  private_ip_google_access = true
}

resource "google_compute_firewall" "vpc_icmp" {
  name    = "terraform-icmp-allow"
  network = google_compute_network.eschool_network.name

  allow {
    protocol = "icmp"
  }

  target_tags   = ["icmp-allow"]
    
}

resource "google_compute_firewall" "vpc_http" {
  name    = "terraform-http-allow"
  network = google_compute_network.eschool_network.name
    
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  target_tags   = ["http-allow"]
      
}

resource "google_compute_firewall" "vpc_https" {
  name    = "terraform-https-allow"
  network = google_compute_network.eschool_network.name

  
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags   = ["https-allow"]
      
}

resource "google_compute_firewall" "vpc_ssh" {
  name    = "terraform-ssh-allow"
  network = google_compute_network.eschool_network.name

  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["ssh-allow"]
      
}

resource "google_compute_firewall" "vpc_internal" {
  name    = "internal-allow"
  network = google_compute_network.eschool_network.name
  source_ranges = [google_compute_subnetwork.eschool_subnetwork.ip_cidr_range]
  allow {
    protocol = "tcp"
  }
  target_tags = ["internal-allow"]
}





resource "google_compute_instance" "mysql" {
  name         = "mysqldb"
  machine_type = "e2-small"
  depends_on   = [google_compute_subnetwork.eschool_subnetwork]
  tags         = ["ssh-allow", "icmp-allow", "internal-allow"]

metadata_startup_script = templatefile("mysql.sh.tpl", 
{
  DATASOURCE_USERNAME = var.datasource_username,
  DATASOURCE_PASSWORD = var.datasource_password,
  MYSQL_ROOT_PASSWORD = var.mysql_root_password
})

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20210720"
    }
  }


 network_interface {
    subnetwork = google_compute_subnetwork.eschool_subnetwork.name
    network_ip = var.mysql_ip
    access_config {
    }
  }

metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"

  }

}

resource "google_compute_instance" "loadbalanser" {
  name         = "loadbalnser"
  machine_type = "e2-small"
  depends_on   = [google_compute_instance.app1, google_compute_instance.app2, google_compute_subnetwork.eschool_subnetwork]
  tags         = ["ssh-allow","http-allow","https-allow","icmp-allow", "https-server", "http-server" ]

 

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20210720"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.eschool_subnetwork.name
    network_ip = var.loadbalancer_ip
    access_config {
    }
  }
metadata_startup_script = templatefile("loadbalanser.sh.tpl", 
  {
    APACHE_LOG_DIR__="apache2"
  })

}



resource "google_compute_instance" "app2" {
  name         = "app2"
  machine_type = "e2-small"
  depends_on   = [google_compute_instance.mysql]
  tags         = ["ssh-allow","http-allow","https-allow","icmp-allow"]
  metadata_startup_script = templatefile("eschool.sh.tpl", 
  {
   DATASOURCE_USERNAME = var.datasource_username,
   DATASOURCE_PASSWORD = var.datasource_password,
   MYSQL_ROOT_PASSWORD = var.mysql_root_password
  })

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20210720"
    }
  }

 network_interface {
    subnetwork = google_compute_subnetwork.eschool_subnetwork.name
    network_ip = var.app2_ip
    access_config {
    }
  }
metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }

}


resource "google_compute_instance" "app1" {
  name         = "app1"
  machine_type = "e2-small"
  depends_on   = [google_compute_instance.mysql]
  tags         = ["ssh-allow","http-allow","https-allow","icmp-allow"]
  metadata_startup_script = templatefile("eschool.sh.tpl", 
  {
   DATASOURCE_USERNAME = var.datasource_username,
   DATASOURCE_PASSWORD = var.datasource_password,
   MYSQL_ROOT_PASSWORD = var.mysql_root_password
  })

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20210720"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.eschool_subnetwork.name
    network_ip = var.app1_ip
    access_config {
    }
  }
metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }
}


