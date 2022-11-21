{{/* vim: set filetype=mustache: */}}

{{/*
Input argument: global object
Get domain to use in hosts based on domain or ingressIP. domain takes precedence over ingressIP
If both are unset, will try to lookup ingress IP address using istio's loadbalancer service, returning
"example" as ip address if not found
*/}}
{{- define "common.get-external-hostname" }}
{{- if .domain }}
{{- printf "%s" .domain }}
{{- else if .ingressIP }}
{{- printf "%s.nip.io" .ingressIP }}
{{- else }}
{{- $istioIp := include "common.istio-lookup" . }}
{{- ternary (printf "%s.nip.io" $istioIp) ("") (ne $istioIp "")}}
{{- end }}
{{- end }}

{{/*
Function to add nip.io to domain
Takes in 2 arguments:
subdomain, domain
*/}}
{{- define "common.localiseDomain" -}}
{{- $subdomain := index . 0 }}
{{- $domain := index . 1 }}
{{- ternary (printf "%s.%s" $subdomain $domain) (printf "%s" $subdomain) (ne $domain "") }}
{{- end }}

{{- define "common.istio-lookup" }}
{{- $istioLookupResult := "" }}
{{- $outer := .istioLookUp | default dict -}}
{{- if and (hasKey $outer "namespace") (hasKey $outer "name") }}
{{- $istioLookupResult = (lookup "v1" "Service" .istioLookUp.namespace .istioLookUp.name ) }}
{{- end }}
{{- if $istioLookupResult }}
{{- printf "%s" (index $istioLookupResult.status.loadBalancer.ingress 0).ip }}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}


{{- define "common.get-prefix-match" }}
{{- $value := default (dict) . }}
{{- if hasKey $value "vsPrefix"}}
{{- printf "%s/" $value.vsPrefix }}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}
