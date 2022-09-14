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
{{- define "generic-dep-installer.chart-version" -}}
{{- $chartVersion := .Values.helmChart.version | replace "." "-" }}
{{- printf "%s" $chartVersion}}
{{- end }}

{{- define "generic-dep-installer.resource-prefix" -}}
{{- $deployedChart := .Values.helmChart.chart -}}
{{- $chartVersion := .Values.helmChart.version | replace "." "-" }}
{{- $deployedReleaseName := .Values.helmChart.release -}}
{{ printf "generic-runner-%s-%s-%s"  $deployedChart $chartVersion $deployedReleaseName }}
{{- end }}

{{- define "generic-dep-installer.global-resource-prefix" -}}
{{- $prefix := include "generic-dep-installer.resource-prefix" . }}
{{- printf "%s-%s" $prefix .Release.Namespace }}
{{- end }}

{{- define "generic-dep-installer.sa-name" -}}
{{- printf "%s-sa" (include "generic-dep-installer.resource-prefix" .) }}
{{- end }}

{{- define "generic-dep-installer.job-name" -}}
{{- printf "%s-job" (include "generic-dep-installer.resource-prefix" .) }}
{{- end }}

{{- define "generic-dep-installer.cm-name" -}}
{{- printf "%s-cm" (include "generic-dep-installer.resource-prefix" .) }}
{{- end }}

{{- define "generic-dep-installer.job-commands" -}}
- {{ .Values.helmChart.repository }}
- {{ .Values.helmChart.chart }}
- {{ .Values.helmChart.version }}
- {{ .Values.helmChart.release }}
- {{ .Values.helmChart.namespace }}
{{- end }}
