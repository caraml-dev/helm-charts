{{/* vim: set filetype=mustache: */}}

{{/*
Get postgres host name in the following order of precendence: Chart specific postgresql > Chart external Postgresql > Global postgresql, Arguments:
1) postgresql object
2) external postgresql object
3) Release object
4) Chart object
*/}}
{{- define "common.postgres-host" -}}
{{- $postgresql := index . 0 -}}
{{- $externalPostgresql := index . 1 -}}
{{- $release := index . 2 -}}
{{- $chart := index . 3 -}}
{{- if $postgresql.enabled -}}
    {{- printf "%s-%s-postgresql.%s.svc.cluster.local" $release.Name $chart.Name $release.Namespace -}}
{{- else if $externalPostgresql.enabled -}}
    {{- $externalPostgresql.address -}}
{{- else -}}
    {{- printf "%s-postgresql.%s.svc.cluster.local" $release.Name $release.Namespace -}}
{{- end -}}
{{- end -}}


{{/*
Get postgres user name in the following order of precendence: Chart specific postgresql > Chart external Postgresql > Global postgresql, Arguments:
1) postgresql object
2) external postgresql object
3) global object
*/}}
{{- define "common.postgres-username" -}}
{{- $postgresql := index . 0 -}}
{{- $externalPostgresql := index . 1 -}}
{{- $global := index . 2 -}}
    {{- if $postgresql.enabled -}}
        {{- $postgresql.postgresqlUsername -}}
    {{- else if $externalPostgresql.enabled -}}
        {{- $externalPostgresql.username -}}
    {{- else -}}
        {{- $global.postgresqlUsername -}}
    {{- end -}}
{{- end -}}


{{/*
Get postgres database name in the following order of precendence: Chart specific postgresql > Chart external Postgresql > Global postgresql, Arguments:
1) postgresql object
2) external postgresql object
3) global object
*/}}
{{- define "common.postgres-database" -}}
{{- $postgresql := index . 0 -}}
{{- $externalPostgresql := index . 1 -}}
{{- $global := index . 2 -}}
{{- $service := index . 3 -}}
{{- $databaseNameKey := index . 4 -}}
    {{- if $postgresql.enabled -}}
        {{- $postgresql.postgresqlDatabase -}}
    {{- else if $externalPostgresql.enabled -}}
        {{- $externalPostgresql.database -}}
    {{- else -}}
        {{- include "common.get-component-value" (list $global $service (list $databaseNameKey)) }}
    {{- end -}}
{{- end -}}

{{/*
Get postgres database secret name in the following order of precendence: Chart specific postgresql > Chart external Postgresql > Umbrella chart postgresql (release name), Arguments:
1) postgresql object
2) external postgresql object
3) Release object
4) Chart object
*/}}
{{- define "common.postgres-password-secret-name" -}}
{{- $postgresql := index . 0 -}}
{{- $externalPostgresql := index . 1 -}}
{{- $release := index . 2 -}}
{{- $chart := index . 3 -}}
    {{- if $postgresql.enabled -}}
        {{- printf "%s-%s-postgresql" $release.Name $chart.Name -}}
    {{- else if $externalPostgresql.enabled -}}
        {{- default (printf "%s-%s-external-postgresql" $release.Name $chart.Name) $externalPostgresql.secretName -}}
    {{- else -}}
        {{- printf "%s-postgresql" $release.Name -}}
    {{- end -}}
{{- end -}}


{{/*
Get postgres secret key in the following order of precendence: Chart external Postgresql enabled and specific key mentioned > (default)"postgresql-password" , Arguments:
2) external postgresql object
*/}}
{{- define "common.postgres-password-secret-key" -}}
{{- $externalPostgresql := index . 0 -}}
    {{- if and $externalPostgresql.enabled -}}
        {{- default "postgresql-password" $externalPostgresql.secretKey  -}}
    {{- else -}}
        {{- printf "postgresql-password" -}}
    {{- end -}}
{{- end -}}
