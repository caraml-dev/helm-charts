{{/*
Create a default fully qualified app name for registry service.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "caraml-store.registry.fullname" -}}
{{- if .Values.registry.fullnameOverride }}
{{- .Values.registry.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.registry.nameOverride }}
{{- if contains $name .Release.Name }}
{{- printf "%s-%s" .Release.Name .Values.registry.name | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- printf "%s-%s-%s" .Release.Name $name .Values.registry.name | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name for serving service.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "caraml-store.serving.fullname" -}}
{{- if .Values.serving.fullnameOverride }}
{{- .Values.serving.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.serving.nameOverride }}
{{- if contains $name .Release.Name }}
{{- printf "%s-%s" .Release.Name .Values.serving.name | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- printf "%s-%s-%s" .Release.Name $name .Values.serving.name | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "caraml-store.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "caraml-store.labels" -}}
helm.sh/chart: {{ include "caraml-store.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for registry
*/}}
{{- define "caraml-store.registry.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.registry.name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels for serving
*/}}
{{- define "caraml-store.serving.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.serving.name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Labels for registry
*/}}
{{- define "caraml-store.registry.labels" -}}
{{ include "caraml-store.registry.selectorLabels" . }}
{{ include "caraml-store.labels" . }}
{{- end -}}

{{/*
Labels for registry
*/}}
{{- define "caraml-store.serving.labels" -}}
{{ include "caraml-store.serving.selectorLabels" . }}
{{ include "caraml-store.labels" . }}
{{- end -}}
