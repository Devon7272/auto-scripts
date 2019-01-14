#!/bin/bash

clear

echo "Installing Docker and the MySQL Client..."
echo ""
sleep 3
echo "This install will take a few moments, please stand by..."
echo ""

yum install -y mysql docker &> /dev/null

if [[ $? == 0 ]]; then
  echo "Installation is complete."
  echo ""
else
  echo "There was a problem installing packages. Please retry the script."
  echo "If this problem persists, try to restart your lab or contact support."
  exit 1
fi

echo "Attempting to start the Docker service..."
echo ""

systemctl start docker &> /dev/null
systemctl enable docker &> /dev/null

if [[ $? == 0 ]]; then
  echo "The Docker service is started."
  echo ""
else
  echo "There was a problem starting the Docker service. Please retry the script."
  echo "If this process persists, try to restart your lab or contact support." 
  exit 2
fi

echo "Pulling MySQL 5.7 Database Server Container from Docker Hub."
echo ""
sleep 3
echo "This may take a couple of minutes to download. Please stand by..."
echo ""

docker pull mysql:5.7 &> /dev/null

if [[ $? == 0 ]]; then
  echo "MySQL Database image has been installed from the Docker Hub."
  echo ""
else
  echo "There was a problem pulling the MySQL Server Container from Docker Hub. Please retry the script."
  echo "If this process persists, try to restart your lab or contact support." 
  exit 4
fi

echo "Starting the Docker MySQL Container from the image for use in this lab..."
echo ""

docker run --name my-dbtest -d -e MYSQL_ROOT_PASSWORD=password123 mysql:5.7 &> /dev/null

if [[ $? == 0 ]]; then
  echo "The Docker container called \"my-dbtest\" has been started successfully."
  echo ""
else
  echo "There was a problem starting a MySQL Server Container locally. Please retry the script."
  echo "If this process persists, try to restart your lab or contact support." 
  exit 5
fi

echo "Creating the database within the container for our lab..."
echo ""
echo "We need to give the database time to start, pausing for 30 seconds..."
echo ""
sleep 10
echo "20 seconds..."
echo ""
sleep 10
echo "10 seconds..."
echo ""
sleep 10
echo "Proceeding..."
echo ""

echo "Calling the database setup script..."
echo ""
bash ./dbsetup.sh

if [[ $? == 0 ]]; then
  echo "Writing credentials to a file..." 
  echo ""
  echo "Database IP Address: 172.17.0.2" > /root/creds.txt
  echo "Database User: root" >> /root/creds.txt
  echo "Database Password: password123" >> /root/creds.txt

  echo "===================================================================================="
  echo ""
  echo "The installation and setup of your lab environment is complete. Information you need to proceed:"
  echo "Database IP Address: 172.17.0.2"
  echo "Database User: root"
  echo "Database Password: password123"
  echo ""
  echo "You are now ready to complete your scenarios. If you need any of the access information,"
  echo "you will find it in a file called \"creds.txt\" in your /root directory."
  echo "Good luck!"
  echo ""
else
  echo "Oh no! We failed on the last step! You may need to restart the lab and try again."
  echo "If this error persists, please contact support!"
  echo ""
fi

