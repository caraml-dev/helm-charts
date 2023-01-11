{{/* vim: set filetype=mustache: */}}


{{/*
Generated names
*/}}

{{- define "merlin.resource-prefix-with-release-name" -}}
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

{{- define "merlin.resource-prefix" -}}
    {{- if .Values.nameOverride -}}
        {{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- $deployedChart := .Chart.Name -}}
        {{ printf "%s"  $deployedChart | trunc 63 | trimSuffix "-" }}
    {{- end -}}
{{- end -}}


{{- define "merlin.name" -}}
    {{- printf "%s" (include "merlin.resource-prefix" .) -}}
{{- end -}}

{{- define "merlin.fullname" -}}
    {{- printf "%s" (include "merlin.resource-prefix-with-release-name" .) -}}
{{- end -}}

{{- define "merlin.envs-cm-name" -}}
    {{- printf "%s-environments" (include "merlin.resource-prefix" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "merlin.scripts-cm-name" -}}
    {{- printf "%s-scripts" (include "merlin.resource-prefix" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "merlin.mlp-api-encryption-key-name" -}}
    {{- printf "%s-mlp-api-encryption-key" (include "merlin.resource-prefix" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "merlin.swagger-name" -}}
    {{- printf "%s-swagger" (include "merlin.resource-prefix" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "merlin.alerts-repo-secret-name" -}}
    {{- printf "%s-%s-token" (include "merlin.resource-prefix" .) .Values.alerts.alertsRepoPlatform | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "merlin.alerts-repo-secret-key-name" -}}
    {{- printf "%s-token" .Values.alerts.alertsRepoPlatform | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "merlin.chart" -}}
    {{- printf "%s-%s" .Chart.Name .Chart.Version -}}
{{- end -}}

{{- define "mlflow.fullname" -}}
    {{- if .Values.mlflow.fullnameOverride -}}
        {{- .Values.mlflow.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s-%s" (include "merlin.resource-prefix-with-release-name" .) .Values.mlflow.name | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "merlin.labels" -}}
app: {{ template "merlin.name" .}}
release: {{ .Release.Name }}
app.kubernetes.io/name: {{ template "merlin.name" . }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote}}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: caraml
{{- end }}


{{/*
MLflow Postgres related
*/}}

{{- define "mlflow-postgresql.host" -}}
{{- if index .Values "mlflow-postgresql" "enabled" -}}
    {{- printf "%s-mlflow-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- else if .Values.mlflowExternalPostgresql.enabled -}}
    {{- .Values.mlflowExternalPostgresql.address -}}
{{- else -}}
    {{- printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}


{{- define "mlflow-postgresql.username" -}}
    {{- if index .Values "mlflow-postgresql" "enabled" -}}
        {{- index .Values "mlflow-postgresql" "postgresqlUsername" -}}
    {{- else if .Values.mlflowExternalPostgresql.enabled -}}
        {{- .Values.mlflowExternalPostgresql.username -}}
    {{- else -}}
        {{- .Values.global.postgresqlUsername -}}
    {{- end -}}
{{- end -}}

{{- define "mlflow-postgresql.database" -}}
    {{- if index .Values "mlflow-postgresql" "enabled" -}}
        {{- index .Values "mlflow-postgresql" "postgresqlDatabase" -}}
    {{- else if .Values.mlflowExternalPostgresql.enabled -}}
        {{- .Values.mlflowExternalPostgresql.database -}}
    {{- else -}}
        {{- .Values.global.merlin.mlflow.postgresqlDatabase -}}
    {{- end -}}
{{- end -}}

{{- define "mlflow.backendStoreUri" -}}
    {{- if .Values.mlflow.backendStoreUri -}}
        {{- printf .Values.mlflow.backendStoreUri -}}
    {{- else -}}
        {{- printf "postgresql://%s:$(DATABASE_PASSWORD)@%s:5432/%s" (include "mlflow-postgresql.username" .) (include "mlflow-postgresql.host" .) (include "mlflow-postgresql.database" .) -}}
    {{- end -}}
{{- end -}}


{{- define "mlflow-postgresql.password-secret-name" -}}
    {{- if index .Values "mlflow-postgresql" "enabled" -}}
        {{- printf "%s-mlflow-postgresql" .Release.Name -}}
    {{- else if .Values.mlflowExternalPostgresql.enabled -}}
        {{- default (printf "%s-mlflow-external-postgresql" .Release.Name) .Values.mlflowExternalPostgresql.secretName -}}
    {{- else -}}
        {{- printf "%s-postgresql" .Release.Name -}}
    {{- end -}}
{{- end -}}

{{- define "mlflow-postgresql.password-secret-key" -}}
    {{- if and .Values.mlflowExternalPostgresql.enabled -}}
        {{- default "postgresql-password" .Values.mlflowExternalPostgresql.secretKey  -}}
    {{- else -}}
        {{- printf "postgresql-password" -}}
    {{- end -}}
{{- end -}}


{{- define "merlin.get-workload-host" }}
{{- $global := index . 0}}
{{- $relNs := index . 1}}
{{- $key := index . 2}}
{{- $values := get $global $key}}
{{- if not (hasKey $global $key) }}
  {{- printf "" }}
{{- else }}
  {{- $values := get $global $key}}
  {{- $host := "" }}
  {{- with $values }}
    {{- if .useServiceFqdn }}
      {{- $host = printf "http://%s.%s.svc.cluster.local:%s%s" .serviceName $relNs .externalPort .apiPrefix}}
    {{- else }}
      {{- $inClusterPrefix := printf "%s%s" .vsPrefix .apiPrefix }}
      {{- $host = printf "%s://%s%s" $global.protocol (include "common.get-external-hostname" $global) $inClusterPrefix }}
    {{- end }}
    {{- end }}
  {{- printf "%s" $host }}
  {{- end }}
{{- end }}


{{- define "merlin.get-feast-api-host"}}
{{- $protocol := (default "http" (get . "protocol")) }}
{{- $hostname := include "common.get-external-hostname" . }}
{{- if $hostname }}
{{- printf "%s://%s" $protocol $hostname}}
{{- else }}
{{- printf ""}}
{{- end }}
{{- end }}

{{- define "merlin.authorization.server.url" -}}
    {{- $protocol := (default "http" .Values.global.protocol ) }}
    {{- $globalAuthzUrl := "" }}
    {{- if and .Values.global (hasKey .Values.global "authz") }}
        {{- if .Values.global.authz.serviceName }}
            {{- $globalAuthzUrl = (printf "%s://%s" $protocol (include "common.get-component-value" (list .Values.global "authz" (list "serviceName")))) }}
        {{- end }}
    {{- end }}
    {{- printf "%s" (include "common.set-value" (list .Values.authorization.serverUrl $globalAuthzUrl)) -}}
{{- end -}}
