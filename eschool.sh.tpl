#!/bin/bash

#ENVIRONMENT
DATASOURCE_USERNAME=eschool
DATASOURCE_PASSWORD=b1dnijpesvseshesre
MYSQL_ROOT_PASSWORD=legme876FCTFEfg1

#Updating OS
sudo apt update && sudo apt upgrade -y

#Installing Java
sudo apt install openjdk-8-jdk-headless maven -y
sudo update-java-alternatives -s java-1.8.0-openjdk-amd64

sudo apt install git -y

#Clonning eschool repository
git clone https://github.com/Maks0123/eSchool.git

#Set current year in ScheduleControllerIntegrationTest
sudo sed -i 's/2019/'`date +%Y`'/g' ./eSchool/src/test/java/academy/softserve/eschool/controller/ScheduleControllerIntegrationTest.java

#Set application default login and pass to admin:admin
sudo sed -i 's/administrator/admin/g' ./eSchool/src/main/resources/application.properties
sudo sed -i 's/OFKFvBCMnyZ012NSNzzFmw==/admin/g' ./eSchool/src/main/resources/application.properties

# replace ip from localhost
sudo sed -i 's/localhost/10.127.0.130/g' ./eSchool/src/main/resources/application.properties


#Set application database credentials
sudo sed -i 's/DATASOURCE_USERNAME:root/DATASOURCE_USERNAME:'${DATASOURCE_USERNAME}'/g' ./eSchool/src/main/resources/application.properties
sudo sed -i 's/DATASOURCE_PASSWORD:root/DATASOURCE_PASSWORD:'${DATASOURCE_PASSWORD}'/g' ./eSchool/src/main/resources/application.properties


#Building eschool application
cd ./eSchool
sudo mvn clean
sudo mvn package -DskipTests
cd ..



#Starting eschool application
sudo java -jar ./eSchool/target/eschool.jar 
