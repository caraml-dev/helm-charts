{{/* vim: set filetype=mustache: */}}
{{/*
Receives 2 arguments,
Returns store if value supplied is ""
*/}}
{{- define "common.set-value"}}
{{- $store := index . 0 }}
{{- $value := index . 1 }}
{{- printf "%s" (ternary $value $store (ne $value ""))}}
{{- end }}


{{/*
Takes 3 arguments:
1) global object
2) field from values.yaml
3) key name in global object
4) list of fields in global.key to use
*/}}
{{- define "common.get-component-url" }}
{{- $store := index . 0 }}
{{- $val := index . 1 }}
{{- $key := index . 2 }}
{{- $fields := index . 3}}
{{- if and $store (hasKey $store $key) }}
{{- $component := get $store $key}}
{{- $result := "" }}
{{- range $fields }}
{{- $result = printf "%s%s" $result (get $component .)}}
{{- end }}
{{- include "common.set-value" (list $result $val)}}
{{- else }}
{{- printf "%s" $val}}
{{- end }}
{{- end }}

{{/*
1st arg is global map object, 2nd arg is value in values.yaml
*/}}
{{- define "common.get-oauth-client" }}
{{- $store := index . 0 }}
{{- $val := index . 1 }}
{{- if $store }}
{{- $temp := printf "%s" $store.oauthclient }}
{{- include "common.set-value" (list $temp $val)}}
{{- else }}
{{- printf "%s" $val}}
{{- end }}
{{- end }}

{{/*
Same as common.get-component-url, but global value takes priority over existing name in values
Set service name if key in globals is present, else use existing name
*/}}
{{- define "common.get-service-name" }}
{{- $store := index . 0 }}
{{- $val := index . 1 }}
{{- $key := index . 2 }}
{{- $fields := index . 3}}
{{- if and $store (hasKey $store $key) }}
{{- $component := get $store $key}}
{{- $result := "" }}
{{- range $fields }}
{{- $result = printf "%s%s" $result (get $component .)}}
{{- end }}
{{- include "common.set-value" (list $val $result)}}
{{- else }}
{{- printf "%s" $val}}
{{- end }}
{{- end }}
