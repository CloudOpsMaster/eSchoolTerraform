variable "region" {
    type = string
    default = "europe-west3"
}

variable "network_cidr" {
    type = string
    default = "10.127.0.0/24"
}

variable "loadbalancer_ip" {
    type = string
    default = "10.127.0.100"
}

variable "app2_ip" {
    type = string
    default = "10.127.0.110"
}

variable "app1_ip" {
    type = string
    default = "10.127.0.120"
}

variable "mysql_ip" {
    type = string
    default = "10.127.0.130"
}


variable "datasource_username" {
    type = string
    default = "eschool"
}

variable "datasource_password" {
    type = string
    default = "b1dnijpesvseshesre"
}

variable "mysql_root_password" {
    type = string
    default = "legme876FCTFEfg1"
}

variable "user" {
    type = string
    default = "rsa-key-20210903"
}

variable "publickeypath" {
    type = string
    default = "public.pub"
}