{{/* vim: set filetype=mustache: */}}

{{/*
Common labels
*/}}
{{- define "knative-net-istio.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
serving.knative.dev/release: {{ .Chart.AppVersion }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: knative-serving
app.kubernetes.io/component: net-istio
networking.knative.dev/ingress-provider: istio
{{- end }}

{{/*
Common annotations
*/}}
{{- define "knative-net-istio.annotations" -}}
meta.helm.sh/release-name: {{ .Release.Name }}
meta.helm.sh/release-namespace: {{ .Release.Namespace }}
{{- end }}
