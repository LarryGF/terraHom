#!/bin/bash

for deployment in $(kubectl get deployments.apps $1 -o json | jq -r '.items[] | "\(.metadata.name),\(.metadata.namespace),\(.spec.replicas)"' | sort -u); do
  name=$(echo "$deployment" | cut -d',' -f1)
  namespace=$(echo "$deployment" | cut -d',' -f2)
  replicas=$(echo "$deployment" | cut -d',' -f3)
  echo "Processing deployment: $name in namespace: $namespace with replicas: $replicas -> $2"
  kubectl scale deployment --namespace "$namespace" "$name" --replicas=$2
done
