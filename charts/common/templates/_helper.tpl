{{/* vim: set filetype=mustache: */}}
{{/*
Pick value from store if value supplied is ""
*/}}
{{- define "common.set-value"}}
{{- $store := index . 0 }}
{{- $value := index . 1 }}
{{- printf "%s" (ternary $value $store (ne $value ""))}}
{{- end }}
