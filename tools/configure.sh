#!/bin/bash
#set -e

# comma separated list
cluster_contexts="mgmt"

# sed commands to replace target_branch variable
for i in $(echo ${cluster_contexts} | sed "s/,/ /g"); do
  kubectl apply -f ../platform-owners/$i/$i-apps.yaml --context $i
  kubectl apply -f ../platform-owners/$i/$i-cluster-config.yaml --context $i
  kubectl apply -f ../platform-owners/$i/$i-infra.yaml --context $i
  kubectl apply -f ../platform-owners/$i/$i-mesh-config.yaml --context $i
done