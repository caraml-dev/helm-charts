{{/* vim: set filetype=mustache: */}}


{{/*
Generated names
*/}}

{{- define "caraml-authz.resource-prefix-with-release-name" -}}
    {{- $deployedChart := .Chart.Name -}}
    {{- $chartVersion := .Chart.Version | replace "." "-" -}}
    {{- $deployedReleaseName := .Release.Name -}}
    {{ printf "%s-%s-%s"  $deployedChart $chartVersion $deployedReleaseName }}
{{- end -}}

{{- define "caraml-authz.resource-prefix" -}}
    {{- $deployedChart := .Chart.Name -}}
    {{- $chartVersion := .Chart.Version | replace "." "-" -}}
    {{ printf "%s-%s"  $deployedChart $chartVersion }}
{{- end -}}


{{- define "caraml-authz.name" -}}
    {{- if .Values.nameOverride -}}
        {{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "caraml-authz.resource-prefix" .) | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
{{- end -}}

{{- define "caraml-authz.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version -}}
{{- end -}}

{{- define "caraml-authz.fullname" -}}
    {{- if .Values.fullnameOverride -}}
        {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "caraml-authz.resource-prefix-with-release-name" .) | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "caraml-authz.labels" -}}
app.kubernetes.io/name: {{ template "caraml-authz.name" . }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote}}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: caraml
{{- end }}


{{/*
CaraML Authz Postgres related
*/}}

{{- define "caraml-authz-postgresql.host" -}}
{{- if index .Values "caraml-authz-postgresql" "enabled" -}}
    {{- printf "%s-%s-postgresql.%s.svc.cluster.local" .Release.Name .Chart.Name .Release.Namespace -}}
{{- else if .Values.caramlAuthzExternalPostgresql.enabled -}}
    {{- .Values.caramlAuthzExternalPostgresql.address -}}
{{- else -}}
    {{- printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}


{{- define "caraml-authz-postgresql.username" -}}
    {{- if index .Values "caraml-authz-postgresql" "enabled" -}}
        {{- index .Values "caraml-authz-postgresql" "postgresqlUsername" -}}
    {{- else if .Values.caramlAuthzExternalPostgresql.enabled -}}
        {{- .Values.caramlAuthzExternalPostgresql.username -}}
    {{- else -}}
        {{- .Values.global.postgresqlUsername -}}
    {{- end -}}
{{- end -}}

{{- define "caraml-authz-postgresql.database" -}}
    {{- if index .Values "caraml-authz-postgresql" "enabled" -}}
        {{- index .Values "caraml-authz-postgresql" "postgresqlDatabase" -}}
    {{- else if .Values.caramlAuthzExternalPostgresql.enabled -}}
        {{- .Values.caramlAuthzExternalPostgresql.database -}}
    {{- else -}}
        {{- .Values.global.authz.postgresqlDatabase -}}
    {{- end -}}
{{- end -}}


{{- define "caraml-authz-postgresql.password-secret-name" -}}
    {{- if index .Values "caraml-authz-postgresql" "enabled" -}}
        {{- printf "%s-%s-postgresql" .Release.Name .Chart.Name -}}
    {{- else if .Values.caramlAuthzExternalPostgresql.enabled -}}
        {{- default (printf "%s-%s-external-postgresql" .Release.Name .Chart.Name ) .Values.caramlAuthzExternalPostgresql.secretName -}}
    {{- else -}}
        {{- printf "%s-postgresql" .Release.Name -}}
    {{- end -}}
{{- end -}}

{{- define "caraml-authz-postgresql.password-secret-key" -}}
    {{- if .Values.caramlAuthzExternalPostgresql.enabled -}}
        {{- default "postgresql-password" .Values.caramlAuthzExternalPostgresql.secretKey  -}}
    {{- else -}}
        {{- printf "postgresql-password" -}}
    {{- end -}}
{{- end -}}


{{- define "caraml-authz.postgresql.dsn" -}}
    {{- printf "postgres://%s:$(DATABASE_PASSWORD)@%s:5432/%s?sslmode=disable" (include "caraml-authz-postgresql.username" .) (include "caraml-authz-postgresql.host" .) (include "caraml-authz-postgresql.database" .) -}}
{{- end -}}
