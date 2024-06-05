# veritable-ui

The veritable-ui is an UI for Veritable that manages connections. Utilizing TSOA, HTMX and @kitajs/html for JSX templating.

## TL;DR

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/veritable-ui
```

## Introduction

This chart bootstraps a [veritable-ui](https://github.com/digicatapult/veritable-ui/) deployment on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/veritable-ui
```

The command deploys veritable-ui on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

### veritable UI config parameters

| Name                                    | Description                                                    | Value                                                            |
| --------------------------------------- | -------------------------------------------------------------- | ---------------------------------------------------------------- |
| `label`                                 | veritable-ui label                                             | `veritable ui`                                                   |
| `companysHouseApiKey.enabled`           | Enable companys house secret                                   | `true`                                                           |
| `companysHouseApiKey.secret`            | veritable-ui secret value                                      | `companysHouseApiKey`                                            |
| `companysHouseApiKey.existingSecret`    | veritable-ui existing secret                                   | `""`                                                             |
| `companysHouseApiKey.existingSecretKey` | veritable-ui existing secret key                               | `""`                                                             |
| `companysHouseApiUrl`                   | companys house api URL for retrieving company's details        | `https://api.company-information.service.gov.uk`                 |
| `logLevel`                              | veritable-ui logging level                                     | `debug`                                                          |
| `cookieSessionKeys.enabled`             | Enable cookies session keys secret                             | `true`                                                           |
| `cookieSessionKeys.secret`              | veritable-ui secret vaapiSwaggerBgColorlue                     | `["secret"]`                                                     |
| `cookieSessionKeys.existingSecret`      | veritable-ui existing secret                                   | `""`                                                             |
| `cookieSessionKeys.existingSecretKey`   | veritable-ui existing secret key                               | `""`                                                             |
| `publicUrl`                             | veritable-ui external URL                                      | `http://localhost:3080`                                          |
| `apiSwaggerBgColor`                     | veritable-ui swagger ackground color                           | `#fafafa`                                                        |
| `apiSwaggerTitle`                       | veritable-ui swagger title                                     | `Veritable`                                                      |
| `apiSwaggerHeading`                     | veritable-ui swagger heading                                   | `Veritable`                                                      |
| `idpClientId`                           | veritable-ui                                                   | `veritable-ui`                                                   |
| `idpPublicURLPrefix`                    | veritable-ui public realm                                      | `http://localhost:3080/realms/veritable/protocol/openid-connect` |
| `idpInternalURLPrefix`                  | veritable-ui private/internal realm                            | `http://localhost:3080/realms/veritable/protocol/openid-connect` |
| `idpAuthPath`                           | veritable-ui IDP authentication path                           | `/auth`                                                          |
| `idpTokenPath`                          | veritable-ui IDP token path                                    | `/token`                                                         |
| `idpJWKSPath`                           | veritable-ui IDP certs path                                    | `/certs`                                                         |
| `emailTransport`                        | The email transport method to use, current options only STREAM | `STREAM`                                                         |
| `emailFromAddress`                      | veritable-ui email from address                                | `hello@veritable.com`                                            |
| `emailAdminAddress`                     | veritable-ui email admin address                               | `admin@veritable.com`                                            |
| `cloudagentAdminOrigin`                 | veritable-ui cloudagent admin origin URL                       | `http://localhost:3080`                                          |
| `invitationPin.enabled`                 | Enable Invitation pin secret                                   | `true`                                                           |
| `invitationPin.secret`                  | the secret value                                               | `""`                                                             |
| `invitationPin.existingSecret`          | If there is an existing secret for the invitationPin           | `""`                                                             |
| `invitationPin.existingSecretKey`       | the key to use within the existing secret                      | `""`                                                             |

### veritable-ui deployment parameters

| Name                                              | Description                                                                                                                                             | Value                       |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `image.registry`                                  | veritable-ui image registry                                                                                                                             | `docker.io`                 |
| `image.repository`                                | veritable-ui image repository                                                                                                                           | `digicatapult/veritable-ui` |
| `image.tag`                                       | veritable-ui image tag (immutable tags are recommended)                                                                                                 | `v0.3.17`                   |
| `image.digest`                                    | veritable-ui image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                        |
| `image.pullPolicy`                                | veritable-ui image pull policy                                                                                                                          | `IfNotPresent`              |
| `image.pullSecrets`                               | veritable-ui image pull secrets                                                                                                                         | `[]`                        |
| `image.debug`                                     | Enable veritable-ui image debug mode                                                                                                                    | `false`                     |
| `replicaCount`                                    | Number of veritable-ui replicas to deploy                                                                                                               | `1`                         |
| `containerPorts.http`                             | veritable-ui HTTP container port                                                                                                                        | `3000`                      |
| `livenessProbe.enabled`                           | Enable livenessProbe on veritable-ui containers                                                                                                         | `true`                      |
| `livenessProbe.path`                              | Path for to check for livenessProbe                                                                                                                     | `/connection`               |
| `livenessProbe.initialDelaySeconds`               | Initial delay seconds for livenessProbe                                                                                                                 | `10`                        |
| `livenessProbe.periodSeconds`                     | Period seconds for livenessProbe                                                                                                                        | `10`                        |
| `livenessProbe.timeoutSeconds`                    | Timeout seconds for livenessProbe                                                                                                                       | `5`                         |
| `livenessProbe.failureThreshold`                  | Failure threshold for livenessProbe                                                                                                                     | `3`                         |
| `livenessProbe.successThreshold`                  | Success threshold for livenessProbe                                                                                                                     | `1`                         |
| `readinessProbe.enabled`                          | Enable readinessProbe on veritable-ui containers                                                                                                        | `true`                      |
| `readinessProbe.path`                             | Path for to check for readinessProbe                                                                                                                    | `/connection`               |
| `readinessProbe.initialDelaySeconds`              | Initial delay seconds for readinessProbe                                                                                                                | `5`                         |
| `readinessProbe.periodSeconds`                    | Period seconds for readinessProbe                                                                                                                       | `10`                        |
| `readinessProbe.timeoutSeconds`                   | Timeout seconds for readinessProbe                                                                                                                      | `5`                         |
| `readinessProbe.failureThreshold`                 | Failure threshold for readinessProbe                                                                                                                    | `5`                         |
| `readinessProbe.successThreshold`                 | Success threshold for readinessProbe                                                                                                                    | `1`                         |
| `startupProbe.enabled`                            | Enable startupProbe on veritable-ui containers                                                                                                          | `true`                      |
| `startupProbe.path`                               | Path for to check for startupProbe                                                                                                                      | `/connection`               |
| `startupProbe.initialDelaySeconds`                | Initial delay seconds for startupProbe                                                                                                                  | `30`                        |
| `startupProbe.periodSeconds`                      | Period seconds for startupProbe                                                                                                                         | `10`                        |
| `startupProbe.timeoutSeconds`                     | Timeout seconds for startupProbe                                                                                                                        | `5`                         |
| `startupProbe.failureThreshold`                   | Failure threshold for startupProbe                                                                                                                      | `10`                        |
| `startupProbe.successThreshold`                   | Success threshold for startupProbe                                                                                                                      | `1`                         |
| `customLivenessProbe`                             | Custom livenessProbe that overrides the default one                                                                                                     | `{}`                        |
| `customReadinessProbe`                            | Custom readinessProbe that overrides the default one                                                                                                    | `{}`                        |
| `customStartupProbe`                              | Custom startupProbe that overrides the default one                                                                                                      | `{}`                        |
| `resources.limits`                                | The resources limits for the veritable-ui containers                                                                                                    | `{}`                        |
| `resources.requests`                              | The requested resources for the veritable-ui containers                                                                                                 | `{}`                        |
| `podSecurityContext.enabled`                      | Enabled veritable-ui pods' Security Context                                                                                                             | `true`                      |
| `podSecurityContext.fsGroup`                      | Set veritable-ui pod's Security Context fsGroup                                                                                                         | `1001`                      |
| `containerSecurityContext.enabled`                | Enabled veritable-ui containers' Security Context                                                                                                       | `true`                      |
| `containerSecurityContext.runAsUser`              | Set veritable-ui containers' Security Context runAsUser                                                                                                 | `1001`                      |
| `containerSecurityContext.runAsNonRoot`           | Set veritable-ui containers' Security Context runAsNonRoot                                                                                              | `true`                      |
| `containerSecurityContext.readOnlyRootFilesystem` | Set veritable-ui containers' Security Context runAsNonRoot                                                                                              | `false`                     |
| `command`                                         | Override default container command (useful when using custom images)                                                                                    | `[]`                        |
| `args`                                            | Override default container args (useful when using custom images)                                                                                       | `[]`                        |
| `hostAliases`                                     | veritable-ui pods host aliases                                                                                                                          | `[]`                        |
| `podLabels`                                       | Extra labels for veritable-ui pods                                                                                                                      | `{}`                        |
| `podAnnotations`                                  | Annotations for veritable-ui pods                                                                                                                       | `{}`                        |
| `podAffinityPreset`                               | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                     | `""`                        |
| `podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                | `soft`                      |
| `pdb.create`                                      | Enable/disable a Pod Disruption Budget creation                                                                                                         | `false`                     |
| `pdb.minAvailable`                                | Minimum number/percentage of pods that should remain scheduled                                                                                          | `1`                         |
| `pdb.maxUnavailable`                              | Maximum number/percentage of pods that may be made unavailable                                                                                          | `""`                        |
| `autoscaling.enabled`                             | Enable autoscaling for veritable-ui                                                                                                                     | `false`                     |
| `autoscaling.minReplicas`                         | Minimum number of veritable-ui replicas                                                                                                                 | `""`                        |
| `autoscaling.maxReplicas`                         | Maximum number of veritable-ui replicas                                                                                                                 | `""`                        |
| `autoscaling.targetCPU`                           | Target CPU utilization percentage                                                                                                                       | `""`                        |
| `autoscaling.targetMemory`                        | Target Memory utilization percentage                                                                                                                    | `""`                        |
| `nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                               | `""`                        |
| `nodeAffinityPreset.key`                          | Node label key to match. Ignored if `affinity` is set                                                                                                   | `""`                        |
| `nodeAffinityPreset.values`                       | Node label values to match. Ignored if `affinity` is set                                                                                                | `[]`                        |
| `affinity`                                        | Affinity for veritable-ui pods assignment                                                                                                               | `{}`                        |
| `nodeSelector`                                    | Node labels for veritable-ui pods assignment                                                                                                            | `{}`                        |
| `tolerations`                                     | Tolerations for veritable-ui pods assignment                                                                                                            | `[]`                        |
| `updateStrategy.type`                             | veritable-ui statefulset strategy type                                                                                                                  | `RollingUpdate`             |
| `priorityClassName`                               | veritable-ui pods' priorityClassName                                                                                                                    | `""`                        |
| `topologySpreadConstraints`                       | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                | `[]`                        |
| `schedulerName`                                   | Name of the k8s scheduler (other than default) for veritable-ui pods                                                                                    | `""`                        |
| `terminationGracePeriodSeconds`                   | Seconds Redmine pod needs to terminate gracefully                                                                                                       | `""`                        |
| `lifecycleHooks`                                  | for the veritable-ui container(s) to automate configuration before or after startup                                                                     | `{}`                        |
| `extraEnvVars`                                    | Array with extra environment variables to add to veritable-ui nodes                                                                                     | `[]`                        |
| `extraEnvVarsCM`                                  | Name of existing ConfigMap containing extra env vars for veritable-ui nodes                                                                             | `""`                        |
| `extraEnvVarsSecret`                              | Name of existing Secret containing extra env vars for veritable-ui nodes                                                                                | `""`                        |
| `extraVolumes`                                    | Optionally specify extra list of additional volumes for the veritable-ui pod(s)                                                                         | `[]`                        |
| `extraVolumeMounts`                               | Optionally specify extra list of additional volumeMounts for the veritable-ui container(s)                                                              | `[]`                        |
| `sidecars`                                        | Add additional sidecar containers to the veritable-ui pod(s)                                                                                            | `[]`                        |
| `initContainers`                                  | Add additional init containers to the veritable-ui pod(s)                                                                                               | `[]`                        |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | -------------------- |
| `service.type`                     | veritable-ui service type                                                                                                        | `ClusterIP`          |
| `service.ports.http`               | veritable-ui service HTTP port                                                                                                   | `3000`               |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                 |
| `service.clusterIP`                | veritable-ui service Cluster IP                                                                                                  | `""`                 |
| `service.loadBalancerIP`           | veritable-ui service Load Balancer IP                                                                                            | `""`                 |
| `service.loadBalancerSourceRanges` | veritable-ui service Load Balancer sources                                                                                       | `[]`                 |
| `service.externalTrafficPolicy`    | veritable-ui service external traffic policy                                                                                     | `Cluster`            |
| `service.annotations`              | Additional custom annotations for veritable-ui service                                                                           | `{}`                 |
| `service.extraPorts`               | Extra ports to expose in veritable-ui service (normally used with the `sidecars` value)                                          | `[]`                 |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`               |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                 |
| `ingress.enabled`                  | Enable ingress record generation for veritable-ui                                                                                | `true`               |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                 |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `veritable-ui.local` |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                 |
| `ingress.paths`                    | Default paths for the ingress record                                                                                             | `[]`                 |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                 |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`              |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`              |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                 |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                 |
| `ingress.extraAuthenticatedPaths`  | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                 |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                 |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                 |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                 |

### Init Container Parameters

| Name                                          | Description                                                                                                                                         | Value                                                           |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| `initDbCreate.image.registry`                 | Postgres image registry                                                                                                                             | `docker.io`                                                     |
| `initDbCreate.image.repository`               | postgres image repository                                                                                                                           | `postgres`                                                      |
| `initDbCreate.image.tag`                      | postgres image tag (immutable tags are recommended)                                                                                                 | `16-alpine`                                                     |
| `initDbCreate.image.digest`                   | postgres image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                                                            |
| `initDbCreate.image.pullPolicy`               | postgres image pull policy                                                                                                                          | `IfNotPresent`                                                  |
| `initDbCreate.image.pullSecrets`              | postgres image pull secrets                                                                                                                         | `[]`                                                            |
| `initDbMigrate.enable`                        | Run database migration in an init container                                                                                                         | `true`                                                          |
| `initDbMigrate.environment`                   | Database configuration environment to run database into                                                                                             | `production`                                                    |
| `initDbMigrate.args`                          | Argument to pass to knex to migrate the database                                                                                                    | `["migrate:latest","--knexfile","build/models/db/knexfile.js"]` |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                                                | `true`                                                          |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                                                              | `""`                                                            |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template)                                                                                    | `{}`                                                            |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                                                      | `true`                                                          |

### Database Parameters

| Name                                                 | Description                                                              | Value          |
| ---------------------------------------------------- | ------------------------------------------------------------------------ | -------------- |
| `postgresql.enabled`                                 | Switch to enable or disable the PostgreSQL helm chart                    | `true`         |
| `postgresql.auth.username`                           | Name for a custom user to create                                         | `veritable-ui` |
| `postgresql.auth.password`                           | Password for the custom user to create                                   | `""`           |
| `postgresql.auth.database`                           | Name for a custom database to create                                     | `veritable-ui` |
| `postgresql.auth.existingSecret`                     | Name of existing secret to use for PostgreSQL credentials                | `""`           |
| `postgresql.architecture`                            | PostgreSQL architecture (`standalone` or `replication`)                  | `standalone`   |
| `externalDatabase.host`                              | Database host                                                            | `""`           |
| `externalDatabase.port`                              | Database port number                                                     | `5432`         |
| `externalDatabase.user`                              | Non-root username for veritable-ui                                       | `veritable-ui` |
| `externalDatabase.password`                          | Password for the non-root username for veritable-ui                      | `""`           |
| `externalDatabase.database`                          | veritable-ui database name                                               | `veritable-ui` |
| `externalDatabase.create`                            | Enable PostgreSQL user and database creation (when using an external db) | `true`         |
| `externalDatabase.postgresqlPostgresUser`            | External Database admin username                                         | `postgres`     |
| `externalDatabase.postgresqlPostgresPassword`        | External Database admin password                                         | `""`           |
| `externalDatabase.existingSecret`                    | Name of an existing secret resource containing the database credentials  | `""`           |
| `externalDatabase.existingSecretPasswordKey`         | Name of an existing secret key containing the non-root credentials       | `""`           |
| `externalDatabase.existingSecretPostgresPasswordKey` | Name of an existing secret key containing the admin credentials          | `""`           |

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Digital Catapult will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/veritable-ui/configuration/configure-use-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/veritable-ui/administration/enable-tls/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as veritable-ui (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/veritable-ui/administration/configure-use-sidecars/).

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
