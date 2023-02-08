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
cat <<EOF | yq e -P - > k8s_config.yaml
{
  "k8s_config": {
    "name": "dev",
    "cluster": {
      "server": "https://kubernetes.default.svc.cluster.local:443",
      "certificate-authority-data": "$(awk '{printf "%s\n", $0}' ~/.minikube/ca.crt | base64)"
    },
    "user": {
      "client-certificate-data": "$(awk '{printf "%s\n", $0}' ~/.minikube/profiles/minikube/client.crt | base64)",
      "client-key-data": "$(awk '{printf "%s\n", $0}' ~/.minikube/profiles/minikube/client.key | base64)"
    }
  }
}
EOF
  fi

  if [ "$CLUSTER_TYPE" == "k3d" ]; then
    k3d kubeconfig get $CLUSTER_NAME > kubeconfig.yaml
      cat <<EOF |  yq -P - > /tmp/temp_k8sconfig.yaml
    {
        "k8s_config": {
            "name": $(k3d kubeconfig get "$CLUSTER_NAME" | yq .clusters[0].name -o json -),
            "cluster": $(k3d kubeconfig get "$CLUSTER_NAME" | yq '.clusters[0].cluster | .server = "https://kubernetes.default.svc.cluster.local:443"' -o json -),
            "user": $(k3d kubeconfig get "$CLUSTER_NAME" | yq .users[0].user -o json - )
        }
    }
EOF
    rm kubeconfig.yaml
  fi

  if [ "$CLUSTER_TYPE" == "kind" ]; then
    kind get kubeconfig --name "$CLUSTER_NAME" > kubeconfig.yaml
    echo "Kind cluster name: $(yq .clusters[0].name kubeconfig.yaml)"
      cat <<EOF |  yq -P - > /tmp/temp_k8sconfig.yaml
    {
        "k8s_config": {
            "name": $(yq .clusters[0].name -o json kubeconfig.yaml),
            "cluster": $(yq '.clusters[0].cluster | .server = "https://kubernetes.default.svc.cluster.local:443"' -o json kubeconfig.yaml),
            "user": $(yq .users[0].user -o json kubeconfig.yaml)
        }
    }
EOF
    rm kubeconfig.yaml
  fi

  output=$(yq e -o json '.k8s_config' /tmp/temp_k8sconfig.yaml | jq -r -M -c .)
  echo "output=$output"
  output="$output" yq '.environmentConfigs[0] *= load("/tmp/temp_k8sconfig.yaml") | .imageBuilder.k8sConfig |= strenv(output)' -i "${SCRIPT_DIR}/../charts/merlin/values.yaml"
}

main "$@"
