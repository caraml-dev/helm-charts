#!/bin/bash

# This file is used to populate configmap templates/setup-configmap.yaml
# This will upload the cluster credentials to vault.

set -ex

which kubectl > /dev/null 2>&1|| { echo "Kubectl not installed"; exit 1; }

show_help() {
  cat <<EOF
Usage: $(basename "$0") <configMapName>  <imageBuilderClusterName>
    -h, --help               Display help
EOF
}

validate_parameters() {
  if [[ "$1" == '-h' || "$1" == '--help' ]]; then
    show_help
    exit 0
  fi
  if [[ "$#" -ne 2 ]]; then
    echo "Insufficient number of positional arguments"
    show_help
    exit 1
  fi
}

main() {
  validate_parameters "$@"
  CONFIG_MAP_NAME="$1"
  VAULT_RELEASE_NAMESPACE="vault"
  CLUSTER_NAME="$2"

  echo "Waiting for vault pod(pod/vault-0) to be ready.."
  sleep 5
  kubectl wait pod/vault-0 --namespace=$VAULT_RELEASE_NAMESPACE --for=condition=ready --timeout=600s

  # Downgrade to Vault KV secrets engine version 1
  kubectl exec vault-0 --namespace=$VAULT_RELEASE_NAMESPACE -- vault secrets disable secret
  kubectl exec vault-0 --namespace=$VAULT_RELEASE_NAMESPACE -- vault secrets enable -version=1 -path=secret kv

  # Write cluster credential to be saved in Vault
  cat /scripts/cluster-credential.json > /tmp/cluster-credential.json
  kubectl cp --namespace=$VAULT_RELEASE_NAMESPACE /tmp/cluster-credential.json vault-0:/tmp/cluster-credential.json
  kubectl exec vault-0 --namespace=$VAULT_RELEASE_NAMESPACE -- vault kv put secret/$CLUSTER_NAME @/tmp/cluster-credential.json
  kubectl exec vault-0 --namespace=$VAULT_RELEASE_NAMESPACE -- rm /tmp/cluster-credential.json
  kubectl delete configmap $CONFIG_MAP_NAME
  rm /tmp/cluster-credential.json


}

main "$@"
