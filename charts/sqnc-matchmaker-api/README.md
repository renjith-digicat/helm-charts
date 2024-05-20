# sqnc-matchmaker-api

The sqnc-matchmaker-api is a component of the Sequence (SQNC) ledger-based system. The sqnc-matchmaker-api responsible for matching orders, and transactions as well as indexing blocks locally, it exposes API for this purpose. See [https://github.com/digicatapult/sqnc-documentation](https://github.com/digicatapult/sqnc-documentation) for details.

## TL;DR

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/sqnc-matchmaker-api
```

## Introduction

This chart bootstraps a [sqnc-matchmaker-api](https://github.com/digicatapult/sqnc-matchmaker-api/) deployment on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/sqnc-matchmaker-api
```

The command deploys sqnc-matchmaker-api on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

You will need to specify the `externalSqncIpfs` host and port as well as the `externalSqncIdentityService` host and port.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.name                                          | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |

### SQNC Identity Service config parameters

| Name                                              | Description                                                                                                                                                    | Value                              |
| ------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `logLevel`                                        | Allowed values: error, warn, info, debug                                                                                                                       | `info`                             |
| `userUri`                                         | The SS58 address for this services owner                                                                                                                       | `//Alice`                          |
| `enableIndexer`                                   | Enable the indexer                                                                                                                                             | `true`                             |
| `auth.clientId`                                   | OAuth2 client id to use when requesting tokens                                                                                                                 | `sequence`                         |
| `auth.publicUrlPrefix`                            | Internet accessible URL prefix for IDP routes                                                                                                                  | `""`                               |
| `auth.internalUrlPrefix`                          | Cluster accessible URL prefix for IDP routes                                                                                                                   | `""`                               |
| `auth.tokenPath`                                  | Path segment to append to the appropriate prefix to determine OAuth2 token endpoint                                                                            | `/token`                           |
| `auth.jwksPath`                                   | Path segment to append to the appropriate prefix to determine JWKS certificate endpoint                                                                        | `/certs`                           |
| `image.registry`                                  | sqnc-matchmaker-api image registry                                                                                                                             | `docker.io`                        |
| `image.repository`                                | sqnc-matchmaker-api image repository                                                                                                                           | `digicatapult/sqnc-matchmaker-api` |
| `image.tag`                                       | sqnc-matchmaker-api image tag (immutable tags are recommended)                                                                                                 | `v3.0.2`                           |
| `image.digest`                                    | sqnc-matchmaker-api image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                               |
| `image.pullPolicy`                                | sqnc-matchmaker-api image pull policy                                                                                                                          | `IfNotPresent`                     |
| `image.pullSecrets`                               | sqnc-matchmaker-api image pull secrets                                                                                                                         | `[]`                               |
| `image.debug`                                     | Enable sqnc-matchmaker-api image debug mode                                                                                                                    | `false`                            |
| `replicaCount`                                    | Number of sqnc-matchmaker-api replicas to deploy                                                                                                               | `1`                                |
| `containerPorts.http`                             | sqnc-matchmaker-api HTTP container port                                                                                                                        | `3000`                             |
| `livenessProbe.enabled`                           | Enable livenessProbe on sqnc-matchmaker-api containers                                                                                                         | `true`                             |
| `livenessProbe.path`                              | Path for to check for livenessProbe                                                                                                                            | `/health`                          |
| `livenessProbe.initialDelaySeconds`               | Initial delay seconds for livenessProbe                                                                                                                        | `10`                               |
| `livenessProbe.periodSeconds`                     | Period seconds for livenessProbe                                                                                                                               | `10`                               |
| `livenessProbe.timeoutSeconds`                    | Timeout seconds for livenessProbe                                                                                                                              | `5`                                |
| `livenessProbe.failureThreshold`                  | Failure threshold for livenessProbe                                                                                                                            | `3`                                |
| `livenessProbe.successThreshold`                  | Success threshold for livenessProbe                                                                                                                            | `1`                                |
| `readinessProbe.enabled`                          | Enable readinessProbe on sqnc-matchmaker-api containers                                                                                                        | `true`                             |
| `readinessProbe.path`                             | Path for to check for readinessProbe                                                                                                                           | `/health`                          |
| `readinessProbe.initialDelaySeconds`              | Initial delay seconds for readinessProbe                                                                                                                       | `5`                                |
| `readinessProbe.periodSeconds`                    | Period seconds for readinessProbe                                                                                                                              | `10`                               |
| `readinessProbe.timeoutSeconds`                   | Timeout seconds for readinessProbe                                                                                                                             | `5`                                |
| `readinessProbe.failureThreshold`                 | Failure threshold for readinessProbe                                                                                                                           | `5`                                |
| `readinessProbe.successThreshold`                 | Success threshold for readinessProbe                                                                                                                           | `1`                                |
| `startupProbe.enabled`                            | Enable startupProbe on sqnc-matchmaker-api containers                                                                                                          | `false`                            |
| `startupProbe.path`                               | Path for to check for startupProbe                                                                                                                             | `/health`                          |
| `startupProbe.initialDelaySeconds`                | Initial delay seconds for startupProbe                                                                                                                         | `30`                               |
| `startupProbe.periodSeconds`                      | Period seconds for startupProbe                                                                                                                                | `10`                               |
| `startupProbe.timeoutSeconds`                     | Timeout seconds for startupProbe                                                                                                                               | `5`                                |
| `startupProbe.failureThreshold`                   | Failure threshold for startupProbe                                                                                                                             | `10`                               |
| `startupProbe.successThreshold`                   | Success threshold for startupProbe                                                                                                                             | `1`                                |
| `customLivenessProbe`                             | Custom livenessProbe that overrides the default one                                                                                                            | `{}`                               |
| `customReadinessProbe`                            | Custom readinessProbe that overrides the default one                                                                                                           | `{}`                               |
| `customStartupProbe`                              | Custom startupProbe that overrides the default one                                                                                                             | `{}`                               |
| `resources.limits`                                | The resources limits for the sqnc-matchmaker-api containers                                                                                                    | `{}`                               |
| `resources.requests`                              | The requested resources for the sqnc-matchmaker-api containers                                                                                                 | `{}`                               |
| `podSecurityContext.enabled`                      | Enabled sqnc-matchmaker-api pods' Security Context                                                                                                             | `true`                             |
| `podSecurityContext.fsGroup`                      | Set sqnc-matchmaker-api pod's Security Context fsGroup                                                                                                         | `1001`                             |
| `containerSecurityContext.enabled`                | Enabled sqnc-matchmaker-api containers' Security Context                                                                                                       | `true`                             |
| `containerSecurityContext.runAsUser`              | Set sqnc-matchmaker-api containers' Security Context runAsUser                                                                                                 | `1001`                             |
| `containerSecurityContext.runAsNonRoot`           | Set sqnc-matchmaker-api containers' Security Context runAsNonRoot                                                                                              | `true`                             |
| `containerSecurityContext.readOnlyRootFilesystem` | Set sqnc-matchmaker-api containers' Security Context runAsNonRoot                                                                                              | `false`                            |
| `command`                                         | Override default container command (useful when using custom images)                                                                                           | `[]`                               |
| `args`                                            | Override default container args (useful when using custom images)                                                                                              | `[]`                               |
| `hostAliases`                                     | sqnc-matchmaker-api pods host aliases                                                                                                                          | `[]`                               |
| `podLabels`                                       | Extra labels for sqnc-matchmaker-api pods                                                                                                                      | `{}`                               |
| `podAnnotations`                                  | Annotations for sqnc-matchmaker-api pods                                                                                                                       | `{}`                               |
| `podAffinityPreset`                               | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                            | `""`                               |
| `podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                       | `soft`                             |
| `pdb.create`                                      | Enable/disable a Pod Disruption Budget creation                                                                                                                | `false`                            |
| `pdb.minAvailable`                                | Minimum number/percentage of pods that should remain scheduled                                                                                                 | `1`                                |
| `pdb.maxUnavailable`                              | Maximum number/percentage of pods that may be made unavailable                                                                                                 | `""`                               |
| `autoscaling.enabled`                             | Enable autoscaling for sqnc-matchmaker-api                                                                                                                     | `false`                            |
| `autoscaling.minReplicas`                         | Minimum number of sqnc-matchmaker-api replicas                                                                                                                 | `""`                               |
| `autoscaling.maxReplicas`                         | Maximum number of sqnc-matchmaker-api replicas                                                                                                                 | `""`                               |
| `autoscaling.targetCPU`                           | Target CPU utilization percentage                                                                                                                              | `""`                               |
| `autoscaling.targetMemory`                        | Target Memory utilization percentage                                                                                                                           | `""`                               |
| `nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                      | `""`                               |
| `nodeAffinityPreset.key`                          | Node label key to match. Ignored if `affinity` is set                                                                                                          | `""`                               |
| `nodeAffinityPreset.values`                       | Node label values to match. Ignored if `affinity` is set                                                                                                       | `[]`                               |
| `affinity`                                        | Affinity for sqnc-matchmaker-api pods assignment                                                                                                               | `{}`                               |
| `nodeSelector`                                    | Node labels for sqnc-matchmaker-api pods assignment                                                                                                            | `{}`                               |
| `tolerations`                                     | Tolerations for sqnc-matchmaker-api pods assignment                                                                                                            | `[]`                               |
| `updateStrategy.type`                             | sqnc-matchmaker-api statefulset strategy type                                                                                                                  | `RollingUpdate`                    |
| `priorityClassName`                               | sqnc-matchmaker-api pods' priorityClassName                                                                                                                    | `""`                               |
| `topologySpreadConstraints`                       | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                       | `[]`                               |
| `schedulerName`                                   | Name of the k8s scheduler (other than default) for sqnc-matchmaker-api pods                                                                                    | `""`                               |
| `terminationGracePeriodSeconds`                   | Seconds Redmine pod needs to terminate gracefully                                                                                                              | `""`                               |
| `lifecycleHooks`                                  | for the sqnc-matchmaker-api container(s) to automate configuration before or after startup                                                                     | `{}`                               |
| `extraEnvVars`                                    | Array with extra environment variables to add to sqnc-matchmaker-api nodes                                                                                     | `[]`                               |
| `extraEnvVarsCM`                                  | Name of existing ConfigMap containing extra env vars for sqnc-matchmaker-api nodes                                                                             | `""`                               |
| `extraEnvVarsSecret`                              | Name of existing Secret containing extra env vars for sqnc-matchmaker-api nodes                                                                                | `""`                               |
| `extraVolumes`                                    | Optionally specify extra list of additional volumes for the sqnc-matchmaker-api pod(s)                                                                         | `[]`                               |
| `extraVolumeMounts`                               | Optionally specify extra list of additional volumeMounts for the sqnc-matchmaker-api container(s)                                                              | `[]`                               |
| `sidecars`                                        | Add additional sidecar containers to the sqnc-matchmaker-api pod(s)                                                                                            | `[]`                               |
| `initContainers`                                  | Add additional init containers to the sqnc-matchmaker-api pod(s)                                                                                               | `[]`                               |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                       |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `service.type`                     | sqnc-matchmaker-api service type                                                                                                 | `ClusterIP`                 |
| `service.ports.http`               | sqnc-matchmaker-api service HTTP port                                                                                            | `3000`                      |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                        |
| `service.clusterIP`                | sqnc-matchmaker-api service Cluster IP                                                                                           | `""`                        |
| `service.loadBalancerIP`           | sqnc-matchmaker-api service Load Balancer IP                                                                                     | `""`                        |
| `service.loadBalancerSourceRanges` | sqnc-matchmaker-api service Load Balancer sources                                                                                | `[]`                        |
| `service.externalTrafficPolicy`    | sqnc-matchmaker-api service external traffic policy                                                                              | `Cluster`                   |
| `service.annotations`              | Additional custom annotations for sqnc-matchmaker-api service                                                                    | `{}`                        |
| `service.extraPorts`               | Extra ports to expose in sqnc-matchmaker-api service (normally used with the `sidecars` value)                                   | `[]`                        |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                      |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                        |
| `ingress.enabled`                  | Enable ingress record generation for sqnc-matchmaker-api                                                                         | `true`                      |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                        |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `sqnc-matchmaker-api.local` |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                        |
| `ingress.paths`                    | Default paths for the ingress record                                                                                             | `[]`                        |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                        |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                     |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                     |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                        |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                        |
| `ingress.extraAuthenticatedPaths`  | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                        |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                        |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                        |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                        |

### Init Container Parameters

| Name                             | Description                                                                                                                                                     | Value                                                        |
| -------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| `initDbCreate.image.registry`    | sqnc-routing-service image registry                                                                                                                             | `docker.io`                                                  |
| `initDbCreate.image.repository`  | sqnc-routing-service image repository                                                                                                                           | `postgres`                                                   |
| `initDbCreate.image.tag`         | sqnc-routing-service image tag (immutable tags are recommended)                                                                                                 | `15-alpine`                                                  |
| `initDbCreate.image.digest`      | sqnc-routing-service image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                                                         |
| `initDbCreate.image.pullPolicy`  | sqnc-routing-service image pull policy                                                                                                                          | `IfNotPresent`                                               |
| `initDbCreate.image.pullSecrets` | sqnc-routing-service image pull secrets                                                                                                                         | `[]`                                                         |
| `initDbMigrate.enable`           | Run database migration in an init container                                                                                                                     | `true`                                                       |
| `initDbMigrate.environment`      | Database configuration environment to run database into                                                                                                         | `production`                                                 |
| `initDbMigrate.args`             | Argument to pass to knex to migrate the database                                                                                                                | `["migrate:latest","--knexfile","build/lib/db/knexfile.js"]` |

### Other Parameters

| Name                                          | Description                                                      | Value  |
| --------------------------------------------- | ---------------------------------------------------------------- | ------ |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true` |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`   |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`   |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `true` |

### Database Parameters

| Name                                                 | Description                                                              | Value                |
| ---------------------------------------------------- | ------------------------------------------------------------------------ | -------------------- |
| `postgresql.enabled`                                 | Switch to enable or disable the PostgreSQL helm chart                    | `true`               |
| `postgresql.auth.username`                           | Name for a custom user to create                                         | `matchmaker_service` |
| `postgresql.auth.password`                           | Password for the custom user to create                                   | `""`                 |
| `postgresql.auth.database`                           | Name for a custom database to create                                     | `matchmaker`         |
| `postgresql.auth.existingSecret`                     | Name of existing secret to use for PostgreSQL credentials                | `""`                 |
| `postgresql.architecture`                            | PostgreSQL architecture (`standalone` or `replication`)                  | `standalone`         |
| `externalDatabase.host`                              | Database host                                                            | `""`                 |
| `externalDatabase.port`                              | Database port number                                                     | `5432`               |
| `externalDatabase.user`                              | Non-root username for sqnc-matchmaker-api                                | `matchmaker_service` |
| `externalDatabase.password`                          | Password for the non-root username for sqnc-matchmaker-api               | `""`                 |
| `externalDatabase.database`                          | sqnc-matchmaker-api database name                                        | `matchmaker`         |
| `externalDatabase.create`                            | Enable PostgreSQL user and database creation (when using an external db) | `true`               |
| `externalDatabase.postgresqlPostgresUser`            | External Database admin username                                         | `postgres`           |
| `externalDatabase.postgresqlPostgresPassword`        | External Database admin password                                         | `""`                 |
| `externalDatabase.existingSecret`                    | Name of an existing secret resource containing the database credentials  | `""`                 |
| `externalDatabase.existingSecretPasswordKey`         | Name of an existing secret key containing the non-root credentials       | `""`                 |
| `externalDatabase.existingSecretPostgresPasswordKey` | Name of an existing secret key containing the admin credentials          | `""`                 |

### SQNC-Node Parameters

| Name                    | Description                                                                               | Value  |
| ----------------------- | ----------------------------------------------------------------------------------------- | ------ |
| `node.enabled`          | Enable SQNC-Node subchart                                                                 | `true` |
| `node.nameOverride`     | String to partially override sqnc-node.fullname template (will maintain the release name) | `""`   |
| `node.fullnameOverride` | String to fully override sqnc-node.fullname template                                      | `""`   |
| `externalSqncNode.host` | External SQNC-Node hostname to query                                                      | `""`   |
| `externalSqncNode.port` | External SQNC-Node port to query                                                          | `""`   |

### SQNC-Ipfs parameters

| Name                    | Description                 | Value |
| ----------------------- | --------------------------- | ----- |
| `externalSqncIpfs.host` | External SQNC-Ipfs hostname | `""`  |
| `externalSqncIpfs.port` | External SQNC-Ipfs port     | `""`  |

### SQNC-Identity-Service parameters

| Name                        | Description                             | Value |
| --------------------------- | --------------------------------------- | ----- |
| `externalSqncIdentity.host` | External SQNC-Identity-Service hostname | `""`  |
| `externalSqncIdentity.port` | External SQNC-Identity-Service port     | `""`  |

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Digital Catapult will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/sqnc-matchmaker-api/configuration/configure-use-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/sqnc-matchmaker-api/administration/enable-tls/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as sqnc-matchmaker-api (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/sqnc-matchmaker-api/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## License

This chart is licensed under the Apache v2.0 license.

Copyright &copy; 2023 Digital Catapult

### Attribution

This chart is adapted from The [charts](<(https://github.com/bitnami/charts)>) provided by [Bitnami](https://bitnami.com/) which are licensed under the Apache v2.0 License which is reproduced here:

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
