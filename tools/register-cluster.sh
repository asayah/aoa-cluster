#!/bin/bash
#set -e

kubectl apply --context ${mgmt_context} -f- <<EOF

apiVersion: admin.gloo.solo.io/v2
kind: KubernetesCluster
metadata:
  name: ${cluster_name}
  namespace: gloo-mesh
spec:
  clusterDomain: cluster.local

EOF









