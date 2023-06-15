#!/bin/bash

jenkinsPass=$(kubectl exec jenkins-deployment-b878f8674-np75t -- cat var/jenkins_home/secrets/initialAdminPassword)
echo -e "\n jenkins pass is: \n $jenkinsPass \n"

echo -e "\n port forward to jenkins on port 8080 ->\n"
k port-forward svc/jenkins-service 8080:8080