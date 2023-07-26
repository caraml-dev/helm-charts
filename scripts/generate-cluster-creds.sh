#!/bin/bash

# This file is used to populate configmap templates/setup-configmap.yaml
# This will upload the cluster credentials to vault.

set -ex

show_help() {
  cat <<EOF
Usage: $(basename "$0") <clusterType> <clusterName>
  Positional arguments:
    clusterType - the type of the local cluster [minikube|k3d|kind]
    clusterName - the name of the cluster set in the CaraML app
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
    echo "Credentials generation is supported only for (minikube|k3d|kind). Given: $1"
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
cat <<EOF | yq e -P - > /tmp/temp_k8sconfig.yaml
{
  "k8s_config": {
    "name": "$CLUSTER_NAME",
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

  yaml_creds=$(yq '.k8s_config' /tmp/temp_k8sconfig.yaml)
  json_creds=$(yq e -o json '.k8s_config' /tmp/temp_k8sconfig.yaml | jq -r -M -c .)

  # NOTE: Write to ci/ files as these files will be used in ci tests! Consider looping through all files
  # in ci dir
  for APP in merlin turing
  do
    # Write to Merlin/ Turing image builder app chart values
    if [ $APP == "merlin" ]; then
      yaml_creds="$yaml_creds" yq ".imageBuilder.k8sConfig |= env(yaml_creds)" -i "${SCRIPT_DIR}/../charts/${APP}/ci/ci-values.yaml"
    else
      json_creds="$json_creds" yq ".imageBuilder.k8sConfig |= strenv(json_creds)" -i "${SCRIPT_DIR}/../charts/${APP}/ci/ci-values.yaml"
    fi
    # Write to Merlin/ Turing env configs app chart values
    yq ".environmentConfigs[0] *= load(\"/tmp/temp_k8sconfig.yaml\")" -i "${SCRIPT_DIR}/../charts/${APP}/ci/ci-values.yaml"

    # Write to Merlin/ Turing image builder app in the overarching CaraML chart
    if [ $APP == "merlin" ]; then
      yaml_creds="$yaml_creds" yq ".${APP}.environmentConfigs[0] *= load(\"/tmp/temp_k8sconfig.yaml\") | .${APP}.imageBuilder.k8sConfig |= env(yaml_creds)" -i "${SCRIPT_DIR}/../charts/caraml/ci/ci-values.yaml"
    else
      json_creds="$json_creds" yq ".${APP}.environmentConfigs[0] *= load(\"/tmp/temp_k8sconfig.yaml\") | .${APP}.imageBuilder.k8sConfig |= strenv(json_creds)" -i "${SCRIPT_DIR}/../charts/caraml/ci/ci-values.yaml"
    fi
  done
}

main "$@"
