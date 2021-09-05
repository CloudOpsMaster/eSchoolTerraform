#!/bin/bash

#Updating OS
sudo apt update && sudo apt upgrade -y

sudo apt install apache2 -y
sudo ufw app list
sudo ufw status
sudo ufw allow 'Apache'
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod lbmethod_byrequests

sudo /etc/init.d/apache2 restart

sudo service apache2 restart

sudo > /etc/apache2/sites-available/000-default.conf
sudo printf "<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port >
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) th>
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog /error.log
        CustomLog /access.log combined


        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
        
<Proxy balancer://mycluster>
    BalancerMember http://10.127.0.110:8080
    BalancerMember http://10.127.0.120:8080

    ProxySet lbmethod=byrequests
    ProxySet stickysession=ROUTEID
</Proxy>
    ProxyPreserveHost On
    ProxyPass / balancer://mycluster/
    ProxyPassReverse / balancer://mycluster/

</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet

 " > /etc/apache2/sites-available/000-default.conf


