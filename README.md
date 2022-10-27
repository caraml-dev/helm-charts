# helm-charts

CaraML Helm Charts

## Prerequisites

* [Helm](https://helm.sh) must be installed to use the charts.
* CaraML model layer uses the cluster information to create the images for Model Service, Prediction Job etc. More details [here](charts/merlin/local_development.md#generate-cluster-credentials). For quick install use `scripts/generate-cluster-creds.sh` script to generate credentials for minikube|k3d|kind clusters.

## Usage

When Helm is installed add repo and proceed with charts installation:

```console
helm repo add caraml https://caraml-dev.github.io/helm-charts
```

## License

<!-- Keep full URL links to repo files because this README syncs from main to gh-pages.  -->
[Apache 2.0 License](https://github.com/caraml-dev/helm-charts/blob/main/LICENSE).
