#! /bin/bash

# See https://kind.sigs.k8s.io/docs/user/loadbalancer/ for instructions to install metallb
# Use this script to load balancer tooling on bare-metal clusters including kind clusters
# Requires docker to be installed

set -ex
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.5/config/manifests/metallb-native.yaml
kubectl wait pods --all -n metallb-system --for=condition=Ready --timeout 500s

KIND_SUBNET=$(docker network inspect kind | jq '.[0].IPAM.Config[1].Subnet' | sed 's/"//g')
if [[ -z $KIND_SUBNET ]]; then
  echo "Could not find kind subnet. Please ensure a kind cluster named kind is present"
  exit 1
fi
docker run --rm troglobit/netcalc:v2.1.6 netcalc $KIND_SUBNET > /tmp/netcalc_output.txt
HOST_MIN=$(cat /tmp/netcalc_output.txt | grep 'HostMin' | awk '{print $3}')

# Default gateway is assumed to be *.*.*.1,
# we do not want the default gateway to be part of the IPAddressPool
# as this prevents requests with external ip addresses (eg to the internet) to be routed out
HOST_MIN=$(echo $HOST_MIN | awk -F '.' '{printf "%s.%s.%s.2", $1,$2,$3}')
HOST_MAX=$(cat /tmp/netcalc_output.txt | grep 'HostMax' | awk '{print $3}')
IP_ADDRESS_RANGE="${HOST_MIN}-${HOST_MAX}"

cat << EOF > /tmp/metallib_config.yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: example
  namespace: metallb-system
spec:
  addresses:
  - $IP_ADDRESS_RANGE
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: empty
  namespace: metallb-system
EOF

kubectl apply -f /tmp/metallib_config.yaml
