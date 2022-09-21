#! /bin/sh

# This file is used to populate configmap templates/configmap.yaml

set -ex

which helm > /dev/null 2>&1|| { echo "Helm not installed"; exit 1; }
which kubectl > /dev/null 2>&1|| { echo "Kubectl not installed"; exit 1; }

show_help() {
  cat <<EOF
Usage: $(basename "$0") <repository> <chart name> <version> <release name> <namespace> <action>
    -h, --help               Display help
    action                   upgrade-install | delete
EOF
}

validate_parameters() {
  if [[ "$1" == '-h' || "$1" == '--help' ]]; then
    show_help
    exit 0
  fi
  if [[ "$#" -ne 6 ]]; then
    echo "Insufficient number of positional arguments"
    show_help
    exit 1
  fi
  if [[ $6 != "upgrade-install" ]] && [[ $6 != "delete" ]]; then
    echo "Action must be 'install' or 'delete', received $6"
    show_help
    exit 1
  fi
}

main() {
  VALUES_FILE_PATH=/tmp/chart_values_tmp.yaml
  validate_parameters "$@"
  REPO="$1"
  CHART_NAME="$2"
  VERSION="$3"
  RELEASE_NAME="$4"
  NAMESPACE="$5"
  ACTION="$6"
  REPO_NAME=local_repo
  # read extra values from  env file, decode it
  echo $CHART_VALUES | base64 -d > $VALUES_FILE_PATH
  helm repo add $REPO_NAME $REPO
  helm template $RELEASE_NAME $REPO_NAME/$CHART_NAME --namespace $NAMESPACE --version $VERSION --values $VALUES_FILE_PATH > /tmp/manifests.yaml
  if [[ $ACTION == "upgrade-install" ]]; then
    helm upgrade --install $RELEASE_NAME $REPO_NAME/$CHART_NAME --namespace $NAMESPACE --version $VERSION --atomic --debug --values $VALUES_FILE_PATH
    # kubectl apply -f /tmp/manifests.yaml
    # kubectl wait pods --all -n $NAMESPACE --for=condition=Ready --timeout=180s
  elif [[ $ACTION == "delete" ]]; then
    kubectl delete -f /tmp/manifests.yaml --ignore-not-found
    kubectl wait -f /tmp/manifests.yaml --for=delete --timeout=180s
    kubectl delete ns $NAMESPACE --ignore-not-found
  fi
}

main "$@"
