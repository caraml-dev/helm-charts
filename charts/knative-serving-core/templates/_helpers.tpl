{{/* vim: set filetype=mustache: */}}

{{/*
Common labels
*/}}
{{- define "knative-serving-core.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
serving.knative.dev/release: {{ .Chart.AppVersion }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: knative-serving
{{- end }}

{{/*
Common annotations
*/}}
{{- define "knative-serving-core.annotations" -}}
meta.helm.sh/release-name: {{ .Release.Name }}
meta.helm.sh/release-namespace: {{ .Release.Namespace }}
{{- end }}

{{/*
autoscaling hpa labels
*/}}
{{- define "knative-serving-hpa.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
serving.knative.dev/release: {{ .Chart.AppVersion }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: knative-serving
{{- end }}

{{/*
Common annotations
*/}}
{{- define "knative-serving-hpa.annotations" -}}
meta.helm.sh/release-name: {{ .Release.Name }}
meta.helm.sh/release-namespace: {{ .Release.Namespace }}
{{- end }}
