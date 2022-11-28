{{/* vim: set filetype=mustache: */}}


{{/*
Generated names
*/}}


{{/*
Expand the name of the chart.
*/}}
{{- define "mlp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mlp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mlp.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "mlp.resource-prefix-with-release-name" -}}
    {{- (include "mlp.fullname" .) -}}
{{- end -}}

{{- define "mlp.resource-prefix" -}}
    {{- (include "mlp.name" .) -}}
{{- end -}}

{{- define "mlp.config-cm-name" -}}
    {{- printf "%s-config" (include "mlp.resource-prefix-with-release-name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mlp.encryption-key-name" -}}
    {{- printf "%s-encryption-key" (include "mlp.resource-prefix-with-release-name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "mlp.labels" -}}
app.kubernetes.io/name: {{ template "mlp.name" . }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote}}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: caraml
{{- end }}


{{/*
Postgres related
*/}}
{{- define "postgres.host" -}}
{{- if .Values.postgresql.enabled -}}
    {{- printf "%s-%s-postgresql.%s.svc.cluster.local" .Release.Name .Chart.Name .Release.Namespace -}}
{{- else if .Values.externalPostgresql.enabled -}}
    {{- .Values.externalPostgresql.address -}}
{{- else -}}
    {{- printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{- define "postgres.username" -}}
    {{- if .Values.postgresql.enabled -}}
        {{- .Values.postgresql.postgresqlUsername -}}
    {{- else if .Values.externalPostgresql.enabled -}}
        {{- .Values.externalPostgresql.username -}}
    {{- else -}}
        {{- .Values.global.postgresqlUsername -}}
    {{- end -}}
{{- end -}}

{{- define "postgres.database" -}}
    {{- if .Values.postgresql.enabled -}}
        {{- .Values.postgresql.postgresqlDatabase -}}
    {{- else if .Values.externalPostgresql.enabled -}}
        {{- .Values.externalPostgresql.database -}}
    {{- else -}}
        {{- .Values.global.mlp.postgresqlDatabase -}}
    {{- end -}}
{{- end -}}

{{- define "postgres.password-secret-name" -}}
    {{- if .Values.postgresql.enabled -}}
        {{- printf "%s-%s-postgresql" .Release.Name .Chart.Name -}}
    {{- else if .Values.externalPostgresql.enabled -}}
        {{- default (printf "%s-%s-external-postgresql" .Release.Name .Chart.Name) .Values.externalPostgresql.secretName -}}
    {{- else -}}
        {{- printf "%s-postgresql" .Release.Name -}}
    {{- end -}}
{{- end -}}

{{- define "postgres.password-secret-key" -}}
    {{- if and .Values.externalPostgresql.enabled -}}
        {{- default "postgresql-password" .Values.externalPostgresql.secretKey  -}}
    {{- else -}}
        {{- printf "postgresql-password" -}}
    {{- end -}}
{{- end -}}