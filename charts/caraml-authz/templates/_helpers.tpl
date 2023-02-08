{{/* vim: set filetype=mustache: */}}


{{/*
Generated names
*/}}


{{- define "caraml-authz.resource-prefix-with-release-name" -}}
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

{{- define "caraml-authz.resource-prefix" -}}
    {{- if .Values.nameOverride -}}
        {{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- $deployedChart := .Chart.Name -}}
        {{ printf "%s"  $deployedChart | trunc 63 | trimSuffix "-" }}
    {{- end -}}
{{- end -}}


{{- define "caraml-authz.name" -}}
    {{- printf "%s" (include "caraml-authz.resource-prefix" .) -}}
{{- end -}}

{{- define "caraml-authz.fullname" -}}
    {{- printf "%s" (include "caraml-authz.resource-prefix-with-release-name" .) -}}
{{- end -}}

{{- define "caraml-authz.cm-name" -}}
    {{- printf "%s-bootstrap-config" (include "caraml-authz.resource-prefix-with-release-name" .) | trunc 63 | trimSuffix "-" -}}
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


{{- define "caraml-authz.postgresql.dsn" -}}
    {{- printf "postgres://%s:$(DATABASE_PASSWORD)@%s:5432/%s?sslmode=disable"
        (include "common.postgres-username" (list (index .Values "caraml-authz-postgresql") .Values.caramlAuthzExternalPostgresql .Values.global ))
        (include "common.postgres-host" (list (index .Values "caraml-authz-postgresql") .Values.caramlAuthzExternalPostgresql .Release .Chart ))
        (include "common.postgres-database" (list (index .Values "caraml-authz-postgresql") .Values.caramlAuthzExternalPostgresql .Values.global "authz" "postgresqlDatabase"))
    -}}
{{- end -}}
