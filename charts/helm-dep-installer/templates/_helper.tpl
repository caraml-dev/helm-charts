{{/* vim: set filetype=mustache: */}}

{{/*
Common labels
*/}}
{{- define "generic-dep-installer.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
serving.knative.dev/release: {{ .Chart.AppVersion }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ .Release.Name }}
{{- end }}

{{/*
Hook annotations
*/}}
{{- define "generic-dep-installer.hook-annotations" -}}
"helm.sh/hook-weight": {{ .Values.hook.weight | default "-5" | quote }}
"helm.sh/hook": {{ .Values.hook.type | default "pre-install,pre-upgrade" | quote }}
{{- end }}

{{/*
Generated names
*/}}
{{- define "generic-dep-installer.generated-names" -}}
{{- $chartVersion := .Values.helmChart.version | replace "." "-" }}
{{- $serviceAccountName := printf "generic-runner-%s-%s-%s-sa" .Values.helmChart.chart $chartVersion .Release.Name }}
{{- end }}
