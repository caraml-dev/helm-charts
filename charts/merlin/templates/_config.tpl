{{- define "merlin.renderedConfig" -}}
{{- $ := index . 0 }}
{{- $rendered := index . 2}}
{{- $tag := $rendered.releasedVersion}}
{{ with index . 1 }}
# Now we have access to the "real" root and current contexts
# just as if we were outside of include/define:
ImageBuilderConfig:
  BaseImages:
    3.7.*:
      ImageName: ghcr.io/caraml-dev/merlin/merlin-pyfunc-base-py37:{{ printf "%s" $tag }}
      DockerfilePath: "docker/Dockerfile"
      BuildContextURI: "git://github.com/caraml-dev/merlin.git#refs/tags/v{{ printf "%s" $tag }}"
    3.8.*:
      ImageName: ghcr.io/caraml-dev/merlin/merlin-pyfunc-base-py38:{{ printf "%s" $tag }}
      DockerfilePath: "docker/Dockerfile"
      BuildContextURI: "git://github.com/caraml-dev/merlin.git#refs/tags/v{{ printf "%s" $tag }}"
    3.9.*:
      ImageName: ghcr.io/caraml-dev/merlin/merlin-pyfunc-base-py39:{{ printf "%s" $tag }}
      DockerfilePath: "docker/Dockerfile"
      BuildContextURI: "git://github.com/caraml-dev/merlin.git#refs/tags/v{{ printf "%s" $tag }}"
    3.10.*:
      ImageName: ghcr.io/caraml-dev/merlin/merlin-pyfunc-base-py310:{{ printf "%s" $tag }}
      DockerfilePath: "docker/Dockerfile"
      BuildContextURI: "git://github.com/caraml-dev/merlin.git#refs/tags/v{{ printf "%s" $tag }}"
  PredictionJobBaseImages:
    3.7.*:
      ImageName: ghcr.io/caraml-dev/merlin/merlin-pyspark-base-py37:{{ printf "%s" $tag }}
      DockerfilePath: "docker/app.Dockerfile"
      BuildContextURI: "git://github.com/caraml-dev/merlin.git#refs/tags/v{{ printf "%s" $tag }}"
      MainAppPath: "/home/spark/merlin-spark-app/main.py"
    3.8.*:
      ImageName: ghcr.io/caraml-dev/merlin/merlin-pyspark-base-py38:{{ printf "%s" $tag }}
      DockerfilePath: "docker/app.Dockerfile"
      BuildContextURI: "git://github.com/caraml-dev/merlin.git#refs/tags/v{{ printf "%s" $tag }}"
      MainAppPath: "/home/spark/merlin-spark-app/main.py"
    3.9.*:
      ImageName: ghcr.io/caraml-dev/merlin/merlin-pyspark-base-py39:{{ printf "%s" $tag }}
      DockerfilePath: "docker/app.Dockerfile"
      BuildContextURI: "git://github.com/caraml-dev/merlin.git#refs/tags/v{{ printf "%s" $tag }}"
      MainAppPath: "/home/spark/merlin-spark-app/main.py"
    3.10.*:
      ImageName: ghcr.io/caraml-dev/merlin/merlin-pyspark-base-py310:{{ printf "%s" $tag }}
      DockerfilePath: "docker/app.Dockerfile"
      BuildContextURI: "git://github.com/caraml-dev/merlin.git#refs/tags/v{{ printf "%s" $tag }}"
      MainAppPath: "/home/spark/merlin-spark-app/main.py"
StandardTransformerConfig:
  ImageName: ghcr.io/caraml-dev/merlin-transformer:{{ printf "%s" $tag }}
{{- end -}}
{{- end -}}
