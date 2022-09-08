# Contributing Guidelines

Contributions are welcome via GitHub pull requests.

## Submitting Pull Requests

Ensure you submit the pull request with PR title adhering to [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standards.

### Immutability

All charts' releases must be immutable. All changes require version bump.

### Versioning

Chart's version must follow the SemVer

### Checks

Each PR should pass a set of checks including:

* Linting
* README.md must be up to date
* Installation to an empty environment

### Updating README.md

We use [helm-docs](https://github.com/norwoodj/helm-docs) tool to auto generate the documentations for helm-charts into markdown format. Use this tool to update the documentation for the chart changes that you do.

_[Pro Tip]_ Do add comments for your values to show up as descriptions in your generated docs.

```yaml
config:
  databases:
    # -- default database for storage of database metadata
    - postgres
```

Resulting in a resulting README section like so:

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config.databases[0] | string | `"postgresql"` | default database for storage of database metadata |

More info on this [here](https://github.com/norwoodj/helm-docs#helm-docs).

## Publishing Changes

Changes are automatically published whenever a commit is merged to main branch.
