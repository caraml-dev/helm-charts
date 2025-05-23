{{- define "turing.renderedConfig" -}}
{{- $ := index . 0 }}
{{- $rendered := index . 2}}
{{- if $rendered }}
{{- $tag := $rendered.releasedVersion}}
{{- $ensemblerTag := default $tag $rendered.ensemblerTag }}
{{- $ensemblerServiceTag := default $ensemblerTag $rendered.ensemblerServiceTag }}
{{- $ensemblerJobPrefix := printf "%s/caraml-dev/turing/pyfunc-ensembler-job" $.Values.deployment.image.registry -}}
{{- $servicePrefix := printf "%s/caraml-dev/turing/pyfunc-ensembler-service" $.Values.deployment.image.registry -}}
# Now we have access to the "real" root and current contexts
# just as if we were outside of include/define:
{{ with index . 1 }}
{{- if $.Values.config.BatchEnsemblingConfig.Enabled }}
BatchEnsemblingConfig:
  ImageBuildingConfig:
    KanikoConfig:
      BuildContextURI: {{ printf "%s/%s" "git://github.com/caraml-dev/turing.git#refs/tags" $tag }}
    BaseImage: {{ printf "%s:%s" $ensemblerJobPrefix $ensemblerTag }}
{{- end }}
EnsemblerServiceBuilderConfig:
  ImageBuildingConfig:
    KanikoConfig: &kanikoConfig
      BuildContextURI: {{ printf "%s/%s" "git://github.com/caraml-dev/turing.git#refs/tags" $tag }}
    BaseImage: {{ printf "%s:%s" $servicePrefix $ensemblerServiceTag }}
RouterDefaults:
  Image: {{ .Values.deployment.image.registry }}/caraml-dev/turing/turing-router:{{ printf "%s" $tag }}
{{- end }}
{{- end }}
{{- end }}
