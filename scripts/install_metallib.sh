#! /bin/bash
set -ex
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.5/config/manifests/metallb-native.yaml
kubectl wait pods --all -n metallb-system --for=condition=Ready

KIND_SUBNET=$(docker network inspect kind | jq '.[0].IPAM.Config[0].Subnet' | sed 's/"//g')
docker run --rm troglobit/netcalc netcalc $KIND_SUBNET > /tmp/netcalc_output.txt
HOST_MIN=$(cat /tmp/netcalc_output.txt | grep 'HostMin' | awk '{print $3}')
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
