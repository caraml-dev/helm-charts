
"""
Simple python script that is used in github actions to
automatically bump chart dependencies using the updatecli CLI tool.
"""

from pathlib import Path
import subprocess
import yaml
import os
import traceback

# Add charts here where it is known that higher versions are not
# yet stable or that you would like to disable automatic upgrades for
EXCLUDED_CHARTS = str(os.environ.get("EXCLUDED_CHARTS", "")).split(',')

# Inject a BUMP_MAJOR env variable if you would like the script to automatically
# bump major chart versions too. Make sure you inspect the upgrade instructions before merging!
BUMP_MAJOR = os.environ.get("BUMP_MAJOR") == "true"
# Inject a BUMP_MINOR env variable if you would like the script to automatically
# bump minor chart versions too. Make sure you inspect the upgrade instructions before merging!
BUMP_MINOR = os.environ.get("BUMP_MINOR") == "true"


def update_gdi_dependency(chart_path: str, dependency: dict):
    with open(chart_path + "/values.yaml") as f:
        text = f.read()
    chart_values: dict = yaml.safe_load(text)

    # bump major or minor depending on set env variable
    chart_version = chart_values[dependency["alias"]]["helmChart"]["version"]
    version_major = f"{chart_version.split('.')[0]}" if not BUMP_MAJOR else "*"
    version_minor = f"{chart_version.split('.')[1]}" if not BUMP_MAJOR else "*"
    version = f"{version_major}.{version_minor}.*"
    manifest = f"""
sources:
    lastMinorRelease:
        kind: helmChart
        spec:
            url: "{chart_values[dependency["alias"]]["helmChart"]["repository"]}"
            name: "{chart_values[dependency["alias"]]["helmChart"]["chart"]}"
            version: "{version}"
conditions: {{}}
targets:
    chart:
        name: Bump Chart version
        kind: helmChart
        spec:
            Name: "{chart_path}"
            file: "Chart.yaml"
            versionIncrement: "patch"
    chartValues:
        name: Bump Chart dependencies
        kind: helmChart
        spec:
            Name: "{chart_path}"
            file: "values.yaml"
            key: "{chart_values[dependency["alias"]]}.helmChart.version"
            versionIncrement: "patch"
"""

    with open("manifest_gdi_dependant.yaml", "w") as f:
        f.write(manifest)
    subprocess.check_output(
        "updatecli apply --config manifest_gdi_dependant.yaml".split(" "))


def update_chart(chart_path: str):
    """
    Given a path to a helm chart. Bump the version of the dependencies of this chart
    if any newer versions exist.
    """
    print(f"Updating chart version for: {chart_path}")

    with open(chart_path + "/Chart.yaml") as f:
        text = f.read()

    chart: dict = yaml.safe_load(text)

    if not "dependencies" in chart:
        return

    for index, dependency in enumerate(chart["dependencies"]):

        if dependency["name"] in EXCLUDED_CHARTS:
            print(f"Skipping {dependency['name']} because it is excluded..")
            continue

        # bump major or minor depending on set env variable
        version_major = f"{dependency['version'].split('.')[0]}" if not BUMP_MAJOR else "*"
        version_minor = f"{dependency['version'].split('.')[1]}" if not BUMP_MAJOR else "*"
        version = f"{version_major}.{version_minor}.*"
        manifest = f"""
sources:
   lastMinorRelease:
       kind: helmChart
       spec:
           url: "{dependency["repository"]}"
           name: "{dependency["name"]}"
           version: "{version}"
conditions: {{}}
targets:
   chart:
       name: Bump Chart dependencies
       kind: helmChart
       spec:
           Name: "{chart_path}"
           file: "Chart.yaml"
           key: "dependencies[{index}].version"
           versionIncrement: "patch"
"""

        with open("manifest.yaml", "w") as f:
            f.write(manifest)

        subprocess.check_output(
            "updatecli apply --config manifest.yaml".split(" "))

        if dependency["name"] == "generic-dep-installer":
            update_gdi_dependency(chart_path, dependency)

    print(f"Updating helm dependencies for chart: {chart_path}")
    subprocess.check_output(
        f"helm dep update {chart_path}".split(" "))


if __name__ == "__main__":

    # loop through all the charts and use updatecli
    # to bump the chart versions if a newer version exists
    paths = Path("charts")
    for path in paths.iterdir():
        try:
            update_chart(str(path.absolute()))
        except Exception as e:
            print(f"Failed processing chart bumper for {path}")
            print(traceback.format_exc())
