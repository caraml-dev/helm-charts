#!/bin/bash

# This file is used to populate configmap templates/setup-configmap.yaml
# This will upload the cluster credentials to vault.

set -ex

show_help() {
  cat <<EOF
Usage: $(basename "$0") <clusterType> [clusterName: Caraml.Merlin.Values.ImageBuilder.ClusterName]
    -h, --help               Display help
EOF
}

validate_parameters() {
  if [[ "$1" == '-h' || "$1" == '--help' ]]; then
    show_help
    exit 0
  fi
  if [[ "$#" -ne 2 ]]; then
    echo "Incorrect number of positional arguments"
    show_help
    exit 1
  fi
  if [ "$1" != "minikube" ] && [ "$1" != "kind" ] && [ "$1" != "k3d" ]; then
    echo "Credentials generations is supported only for (minikube|k3d|kind). Given: $1"
    show_help
    exit 1
  fi
}

yaml() {
    python3 -c "import yaml;print(yaml.safe_load(open('$1'))$2)"
}

main() {
  validate_parameters "$@"
  CLUSTER_TYPE="$1"
  CLUSTER_NAME="$2"
  SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

  if [ "$CLUSTER_TYPE" == "minikube" ]; then
    cat > cluster-credential.json <<EOF
{
  "name": "$CLUSTER_NAME",
  "master_ip": "https://kubernetes.default.svc:443",
  "certs": "$(cat ~/.minikube/ca.crt | awk '{printf "%s\\n", $0}')",
  "client_certificate": "$(cat ~/.minikube/profiles/minikube/client.crt | awk '{printf "%s\\n", $0}'))",
  "client_key": "$(cat ~/.minikube/profiles/minikube/client.key | awk '{printf "%s\\n", $0}'))"
}
EOF
  fi

  if [ "$CLUSTER_TYPE" == "k3d" ]; then
    k3d kubeconfig get $CLUSTER_NAME > kubeconfig.yaml
    cat > cluster-credential.json <<EOF
{
"name": "$(yaml kubeconfig.yaml [\"clusters\"][0][\"name\"])",
"master_ip": "kubernetes.default:443",
"certs": "$(yaml kubeconfig.yaml [\"clusters\"][0][\"cluster\"][\"certificate-authority-data\"]) | base64 --decode | awk '{printf "%s\\n", $0}')",
"client_certificate": "$(yaml kubeconfig.yaml [\"users\"][0][\"user\"][\"client-certificate-data\"]) | base64 --decode | awk '{printf "%s\\n", $0}')",
"client_key": "$(yaml kubeconfig.yaml [\"users\"][0][\"user\"][\"client-key-data\"]) | base64 --decode | awk '{printf "%s\\n", $0}')"
}
EOF
    rm kubeconfig.yaml
  fi

  if [ "$CLUSTER_TYPE" == "kind" ]; then
    kind get kubeconfig --name $CLUSTER_NAME > kubeconfig.yaml
    echo "Kind cluster name: $(yaml kubeconfig.yaml [\"clusters\"][0][\"name\"])"
    cat > cluster-credential.json <<EOF
{
"name": "$(yaml kubeconfig.yaml [\"clusters\"][0][\"name\"])",
"master_ip": "kubernetes.default:443",
"certs": "$(yaml kubeconfig.yaml [\"clusters\"][0][\"cluster\"][\"certificate-authority-data\"]) | base64 --decode | awk '{printf "%s\\n", $0}')",
"client_certificate": "$(yaml kubeconfig.yaml [\"users\"][0][\"user\"][\"client-certificate-data\"]) | base64 --decode | awk '{printf "%s\\n", $0}')",
"client_key": "$(yaml kubeconfig.yaml [\"users\"][0][\"user\"][\"client-key-data\"]) | base64 --decode | awk '{printf "%s\\n", $0}')"
}
EOF
    rm kubeconfig.yaml
  fi

  if [ -f cluster-credential.json ]; then
    echo "moving geenrated creds to $SCRIPT_DIR/../charts/merlin/files"
    mv cluster-credential.json $SCRIPT_DIR/../charts/merlin/files
  fi

}

main "$@"
