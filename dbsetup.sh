#!/bin/bash

mysql --user=root --password=password123 --host=172.17.0.2 -e "CREATE DATABASE dbSample"; &> /dev/null

if [[ $? == 0 ]]; then
  echo "The database called \"dbSample\" has been successfully created."
  echo ""
else
  echo "There was a problem creating the database for our use. Please retry the \"dbsetup.sh\" script."
  echo "If this process persists, try to restart your lab or contact support." 
  exit 6
fi

echo "Creating the tables and fields in the database and populating them with sample records..."
echo ""

mysql --user=root --password=password123 --host=172.17.0.2 < createscript.sql &> /dev/null

if [[ $? == 0 ]]; then
  echo "The database called \"dbSample\" has been successfully updated with tables and records."
  echo ""
else
  echo "There was a problem populating the database for our use. Please retry the script."
  echo "If this process persists, try to restart your lab or contact support." 
  exit 7
fi

