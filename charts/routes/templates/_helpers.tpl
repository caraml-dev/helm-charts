{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "caraml-routes.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "caraml-routes.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "caraml-routes.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "caraml-routes.labels" -}}
helm.sh/chart: {{ include "caraml-routes.chart" . }}
{{ include "caraml-routes.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "caraml-routes.selectorLabels" -}}
app.kubernetes.io/name: {{ include "caraml-routes.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
mlp gateway name
*/}}
{{- define "caraml-routes.mlp-gateway" }}
{{- printf "%s-%s" (include "caraml-routes.fullname" . ) "mlp-gateway" }}
{{- end }}

{{/*
Function to add nip.io to domain
Takes in 3 arguments:
subdomain, ingressIp, domain
Usage:
{{- include "caraml-routes.localiseDomain" (list $val1 $val2 $val3 ) }}
IngressIP takes precedence over domain
*/}}
{{- define "caraml-routes.localiseDomain" -}}
{{- $subdomain := index . 0 }}
{{- $ingressIP := index . 1 }}
{{- $domain := index . 2 }}
{{- if ne $ingressIP "" }}
{{- printf "%s.%s.nip.io" $subdomain $ingressIP }}
{{- else }}
{{- ternary (printf "%s.%s" $subdomain $domain) (printf "%s" $subdomain) (ne $domain "") }}
{{- end }}
{{- end }}


{{- define "caraml-routes.api-docs" }}
{{- $appName := index . 0 }}
{{- $redirectMatch := index . 1 }}
{{- $redirectUri := printf "%s/" $redirectMatch }}
{{- $rewriteUri := index . 2 }}
{{- $destHost := index . 3 }}
{{- $destPort := index . 4 | toString }}
- name: {{ printf "%s-api-docs-strict-slash-redirect" $appName }}
  match:
    - uri:
        exact: {{ $redirectMatch }}
  redirect:
    uri: {{ $redirectUri }}
- name: {{ printf "%s-api-docs" $appName }}
  match:
    - uri:
        prefix: {{ $redirectUri }}
  rewrite:
    uri: {{ $rewriteUri }}
  route:
    - destination:
        host: {{ $destHost }}
        port:
          number: {{ $destPort }}
{{- end }}
