#!/bin/bash

# This file is used to populate configmap templates/setup-configmap.yaml
# This will upload the cluster credentials to vault.

set -ex

which kubectl > /dev/null 2>&1|| { echo "Kubectl not installed"; exit 1; }

show_help() {
  cat <<EOF
Usage: $(basename "$0") <configMapName> <releaseNamespace>  <releaseName> <imageBuilderClusterName>
    -h, --help               Display help
EOF
}

validate_parameters() {
  if [[ "$1" == '-h' || "$1" == '--help' ]]; then
    show_help
    exit 0
  fi
  if [[ "$#" -ne 4 ]]; then
    echo "Insufficient number of positional arguments"
    show_help
    exit 1
  fi
}

main() {
  validate_parameters "$@"
  CONFIG_MAP_NAME="$1"
  RELEASE_NAMESPACE="$2"
  RELEASE_NAME="$3"
  CLUSTER_NAME="$4"

  echo "Waiting for vault pod(pod/$RELEASE_NAME-vault-0) to be ready.."
  sleep 5
  kubectl wait pod/$RELEASE_NAME-vault-0 --for=condition=ready --timeout=600s

  # Downgrade to Vault KV secrets engine version 1
  kubectl exec $RELEASE_NAME-vault-0 --namespace=$RELEASE_NAMESPACE -- vault secrets disable secret
  kubectl exec $RELEASE_NAME-vault-0 --namespace=$RELEASE_NAMESPACE -- vault secrets enable -version=1 -path=secret kv

  # Write cluster credential to be saved in Vault
  cat /scripts/cluster-credential.json > /tmp/cluster-credential.json
  kubectl cp /tmp/cluster-credential.json $RELEASE_NAME-vault-0:/tmp/cluster-credential.json
  kubectl exec $RELEASE_NAME-vault-0 --namespace=$RELEASE_NAMESPACE -- vault kv put secret/$CLUSTER_NAME @/tmp/cluster-credential.json
  kubectl exec $RELEASE_NAME-vault-0 --namespace=$RELEASE_NAMESPACE -- rm /tmp/cluster-credential.json
  kubectl delete configmap $CONFIG_MAP_NAME
  rm /tmp/cluster-credential.json


}

main "$@"
