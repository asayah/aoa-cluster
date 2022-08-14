#!/bin/bash
#set -e

kubectl apply --context ${cluster_context} -f- <<EOF

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: wave-${wave}-${cluster_name}
  namespace: argocd
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: gloo-mesh
  source:
    repoURL: ${repo}
    path: environment/wave-${wave}
    targetRevision: ${branch}
    helm:
      valueFiles:
        - values.yaml
      parameters:
        - name: cluster_name
          value: '${cluster_name}'
        - name: mgmt_addr
          value: '${mgmt_addr}'
        - name: gloo_mesh_version
          value: '${gloo_mesh_version}'                              
  syncPolicy:
    automated:
      prune: false
      selfHeal: false
    syncOptions:
    - Replace=true
    - ApplyOutOfSyncOnly=true
  project: default

EOF









