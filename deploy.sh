#!/bin/bash
#set -e

echo "----------------------------------------"
echo "Usage: deploy.sh <cluster_name> <cluster_context> <mgmt_context>"
echo "----------------------------------------"

# vars
cluster_name="${1:-cluster1}"
cluster_context="${2:-cluster1}"
mgmt_context="${3:-mgmt}"
repo=$(git remote get-url origin)
branch=$(git branch --show-current)
environment_waves="3"
gloo_mesh_version="2.0.9"



# Checking if pending changes

pending_changes=`git status -s`
pending_commits=`git --no-pager log $branch --not --remotes --decorate=short --pretty=oneline -n1`


if [ "$pending_changes-$pending_commits" = "-" ]; then
  echo -e "\xE2\x9C\x94" "- Your local branch is in sync with the remote repository"
else 
  echo -e "\xE2\x9D\x8C" "- Your local branch is not in sync with the remote repository"
fi

echo "----------------------------------------"


SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )




echo "----------------------------------------"
echo  This configuration will be used to install: 
echo cluster_name=$cluster_name
echo cluster_context=$cluster_context
echo mgmt_context=$mgmt_context
echo repo=$repo
echo branch=$branch
gloo_mesh_version="2.0.9"
echo "----------------------------------------"

read -p "Do you want to continue [Y/N] ? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi


# check to see if defined contexts exist
if [[ $(kubectl config get-contexts | grep ${mgmt_context}) == "" ]] || [[ $(kubectl config get-contexts | grep ${cluster_context}) == "" ]]; then
  echo "Check Failed: Either ${mgmt_context} or ${cluster_context} context does not exist. Please check to see if you have the clusters available"
  echo "Run 'kubectl config get-contexts' to see currently available contexts. If the clusters are available, please make sure that they are named correctly. Default is ${cluster_context}"
  exit 1;
fi

# install argocd
cd bootstrap-argocd
./install-argocd.sh insecure-rootpath ${cluster_context}
cd ..

# wait for argo cluster rollout
./tools/wait-for-rollout.sh deployment argocd-server argocd 20 ${cluster_context}

# deploy cluster config aoa

until [ "${mgmt_addr}" != "" ]; do
  mgmt_addr=$(kubectl --context ${mgmt_context} -n gloo-mesh get svc gloo-mesh-mgmt-server -o jsonpath='{.status.loadBalancer.ingress[0].*}')
  echo waiting for gloo mesh management server LoadBalancer IP to be detected
  sleep 2
done

# deploy app of app waves
for i in $(seq ${environment_waves}); do 
  #echo $i;
  wave=$i cluster_name=$cluster_name cluster_context=$cluster_context mgmt_addr=$mgmt_addr gloo_mesh_version=$gloo_mesh_version repo=$repo branch=$branch  $SCRIPTDIR/tools/install-wave.sh ;
  #TODO: add test script if statement
  sleep 30; 
done



# echo port-forward commands
echo
echo "access gloo mesh dashboard:"
echo "kubectl port-forward -n gloo-mesh svc/gloo-mesh-ui 8090 --context ${cluster_context}"
echo 
echo "access argocd dashboard:"
echo "kubectl port-forward svc/argocd-server -n argocd 9999:443 --context ${cluster_context}"
echo
echo "navigate to http://localhost:8090 in your browser for the Gloo Mesh UI"
echo "navigate to http://localhost:9999/argo in your browser for argocd"
echo
echo "username: admin"
echo "password: solo.io"