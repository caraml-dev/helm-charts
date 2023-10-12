{{- define "turing.renderedConfig" -}}
{{- $ := index . 0 }}
{{- $rendered := index . 2}}
{{- if $rendered }}
{{- $tag := $rendered.releasedVersion}}
{{- $ensemblerTag := $rendered.ensemblerTag }}
{{- $ensmblerJobPrefix := "ghcr.io/caraml-dev/turing/pyfunc-ensembler-job-py" -}}
{{- $servicePrefix := "ghcr.io/caraml-dev/turing/pyfunc-ensembler-service-py" -}}
# Now we have access to the "real" root and current contexts
# just as if we were outside of include/define:
{{ with index . 1 }}
{{- if $.Values.config.BatchEnsemblingConfig.Enabled }}
BatchEnsemblingConfig:
  ImageBuildingConfig:
    BaseImageRef:
      3.7.*: {{ printf "%s%s:%s" $ensmblerJobPrefix "3.7" $ensemblerTag }}
      3.8.*: {{ printf "%s%s:%s" $ensmblerJobPrefix "3.8" $ensemblerTag }}
      3.9.*: {{printf "%s%s:%s" $ensmblerJobPrefix "3.9" $ensemblerTag }}
      3.10.*: {{ printf "%s%s:%s" $ensmblerJobPrefix "3.10" $ensemblerTag }}
    KanikoConfig:
      BuildContextURI: {{ printf "%s/%s" "git://github.com/caraml-dev/turing.git#refs/tags" $tag }}
{{- end }}
EnsemblerServiceBuilderConfig:
  ImageBuildingConfig:
    BaseImageRef:
      3.7.*: {{ printf "%s%s:%s" $servicePrefix "3.7" $ensemblerTag }}
      3.8.*: {{ printf "%s%s:%s" $servicePrefix "3.8" $ensemblerTag }}
      3.9.*: {{printf "%s%s:%s" $servicePrefix "3.9" $ensemblerTag }}
      3.10.*: {{ printf "%s%s:%s" $servicePrefix "3.10" $ensemblerTag }}
    KanikoConfig: &kanikoConfig
      BuildContextURI: {{ printf "%s/%s" "git://github.com/caraml-dev/turing.git#refs/tags" $tag }}
RouterDefaults:
  Image: ghcr.io/caraml-dev/turing/turing-router:{{ printf "%s" $tag }}
{{- end }}
{{- end }}
{{- end }}
