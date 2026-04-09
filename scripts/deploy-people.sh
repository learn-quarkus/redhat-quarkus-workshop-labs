#!/bin/bash

USERXX=$1

if [ -z "$USERXX" -o "$USERXX" = "userXX" ]
  then
    echo "Usage: Input your username like deploy-people.sh <userid>"
    exit;
fi

echo "Your project name is ${USERXX}-quarkus"
echo Deploy people service........

oc project $USERXX-quarkus
oc delete dc,deployment,bc,build,svc,route,pod,is --all

echo "Waiting 30 seconds to finialize deletion of resources..."
sleep 30

mvn -q quarkus:add-extension -Dextensions="openshift"

cp $PROJECT_SOURCE/scripts/application.properties $PROJECT_SOURCE/src/main/resources/

sed -i "s/USERXX/${USERXX}/g" $PROJECT_SOURCE/src/main/resources/application.properties

mvn clean package -Pnative -DskipTests
