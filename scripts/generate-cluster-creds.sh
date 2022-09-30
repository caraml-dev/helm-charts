#! /bin/sh

# This file is used to populate configmap templates/setup-configmap.yaml
# This will upload the cluster credentials to vault.

set -ex

which yq > /dev/null 2>&1|| { echo "yq not installed, Check https://github.com/mikefarah/yq/#install"; exit 1; }
which kubectl > /dev/null 2>&1|| { echo "Kubectl not installed"; exit 1; }

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
  if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
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
"name": "$(yq '.clusters[0].name' kubeconfig.yaml)",
"master_ip": "kubernetes.default:443",
"certs": "$(yq '.clusters[0].cluster."certificate-authority-data"' kubeconfig.yaml | base64 --decode | awk '{printf "%s\\n", $0}')",
"client_certificate": "$(yq '.users[0].user."client-certificate-data"' kubeconfig.yaml | base64 --decode | awk '{printf "%s\\n", $0}')",
"client_key": "$(yq '.users[0].user."client-key-data"' kubeconfig.yaml | base64 --decode | awk '{printf "%s\\n", $0}')"
}
EOF
    rm kubeconfig.yaml
  fi

  if [ "$CLUSTER_TYPE" == "kind" ]; then
    kind get kubeconfig > kubeconfig.yaml
    echo "Kind cluster name: $(yq '.clusters[0].name' kubeconfig.yaml)"
    cat > cluster-credential.json <<EOF
{
"name": "$(yq '.clusters[0].name' kubeconfig.yaml)",
"master_ip": "kubernetes.default:443",
"certs": "$(yq '.clusters[0].cluster."certificate-authority-data"' kubeconfig.yaml | base64 --decode | awk '{printf "%s\\n", $0}')",
"client_certificate": "$(yq '.users[0].user."client-certificate-data"' kubeconfig.yaml | base64 --decode | awk '{printf "%s\\n", $0}')",
"client_key": "$(yq '.users[0].user."client-key-data"' kubeconfig.yaml | base64 --decode | awk '{printf "%s\\n", $0}')"
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
