# sqnc-ipfs

The sqnc-ipfs is a component of the Sequence (SQNC) ledger-based system. The sqnc-ipfs service is responsible for rotating IPFS swarm keys and storing data, it exposes an IPFS API for this purpose. See [https://github.com/digicatapult/sqnc-documentation](https://github.com/digicatapult/sqnc-documentation) for details.

## TL;DR

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/sqnc-ipfs
```

## Introduction

This chart bootstraps a [sqnc-ipfs](https://github.com/digicatapult/sqnc-ipfs/) deployment on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/sqnc-ipfs
```

The command deploys sqnc-ipfs on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-releases
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

### IPFS subsystem parameters

| Name                         | Description                                                                                                                                                   | Value                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `ipfs.logLevel`              | logLevel for IPFS subsystem, Allowed values: error, warn, info, debug                                                                                         | `info`                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `ipfs.initConfig.enabled`    | Enable init container to initialize IPFS configuration                                                                                                        | `true`                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `ipfs.initKeys.enabled`      | Enable init container to insert IPFS keys into the IPFS subsystem, this will not run if either ipfs.publicKey, ipfs.privateKey or ipfs.existingSecret are set | `true`                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `ipfs.swarmAddrFilters`      | List of IPFS swarm address filters to apply to the IPFS subsystem                                                                                             | `["/ip4/100.64.0.0/ipcidr/10","/ip4/169.254.0.0/ipcidr/16","/ip4/172.16.0.0/ipcidr/12","/ip4/192.0.0.0/ipcidr/24","/ip4/192.0.2.0/ipcidr/24","/ip4/192.168.0.0/ipcidr/16","/ip4/198.18.0.0/ipcidr/15","/ip4/198.51.100.0/ipcidr/24","/ip4/203.0.113.0/ipcidr/24","/ip4/240.0.0.0/ipcidr/4","/ip6/100::/ipcidr/64","/ip6/2001:2::/ipcidr/48","/ip6/2001:db8::/ipcidr/32","/ip6/fc00::/ipcidr/7","/ip6/fe80::/ipcidr/10"]` |
| `ipfs.bootNodeAddress`       | IPFS boot node addresses in MultiAddress format for the IPFS subsystem                                                                                        | `""`                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `ipfs.routingType`           | IPFS routing type for the IPFS subsystem, Allowed values: "auto", "autoclient", "none", "dht", "dhtclient", and "custom".                                     | `dht`                                                                                                                                                                                                                                                                                                                                                                                                                    |
| `ipfs.binary`                | Location of the ipfs binary in the container for the IPFS subsystem                                                                                           | `/usr/local/bin/ipfs`                                                                                                                                                                                                                                                                                                                                                                                                    |
| `ipfs.command`               | command to pass to customize the configuration init container for the IPFS subsystem                                                                          | `[]`                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `ipfs.args`                  | Arguments to pass to customize the configuration init container for the IPFS subsystem                                                                        | `[]`                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `ipfs.runtimeArgs`           | Arguments to pass to the wasp-ipfs service to spawn the IPFS subsystem                                                                                        | `["daemon","--migrate"]`                                                                                                                                                                                                                                                                                                                                                                                                 |
| `ipfs.keyCommand`            | command to pass to customize the key init container for the IPFS subsystem                                                                                    | `[]`                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `ipfs.keyArgs`               | Arguments to pass to customize the key init container for the IPFS subsystem                                                                                  | `[]`                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `ipfs.publicKey`             | Public key for the IPFS subsystem                                                                                                                             | `""`                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `ipfs.privateKey`            | Private key for the IPFS subsystem                                                                                                                            | `""`                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `ipfs.existingSecret`        | Name of an existing secret containing the IPFS private and public keys                                                                                        | `""`                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `ipfs.secretKeys.publicKey`  | Key of the public key in the existing secret                                                                                                                  | `publicKey`                                                                                                                                                                                                                                                                                                                                                                                                              |
| `ipfs.secretKeys.privateKey` | Key of the private key in the existing secret                                                                                                                 | `privateKey`                                                                                                                                                                                                                                                                                                                                                                                                             |

### SQNC IPFS Service config parameters

| Name                                              | Description                                                                                                                                          | Value                    |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `logLevel`                                        | logLevel for nodeJS service Allowed values: error, warn, info, debug                                                                                 | `info`                   |
| `healthCheckPollPeriod`                           | Health check poll period in milliseconds                                                                                                             | `30000`                  |
| `healthCheckTimeout`                              | Health check timeout in milliseconds                                                                                                                 | `2000`                   |
| `image.registry`                                  | sqnc-ipfs image registry                                                                                                                             | `docker.io`              |
| `image.repository`                                | sqnc-ipfs image repository                                                                                                                           | `digicatapult/sqnc-ipfs` |
| `image.tag`                                       | sqnc-ipfs image tag (immutable tags are recommended)                                                                                                 | `v2.10.2`                |
| `image.digest`                                    | sqnc-ipfs image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                     |
| `image.pullPolicy`                                | sqnc-ipfs image pull policy                                                                                                                          | `IfNotPresent`           |
| `image.pullSecrets`                               | sqnc-ipfs image pull secrets                                                                                                                         | `[]`                     |
| `image.debug`                                     | Enable sqnc-ipfs image debug mode                                                                                                                    | `false`                  |
| `replicaCount`                                    | Number of sqnc-ipfs replicas to deploy                                                                                                               | `1`                      |
| `containerPorts.http`                             | sqnc-ipfs HTTP container port                                                                                                                        | `3000`                   |
| `containerPorts.swarm`                            | sqnc-ipfs IPFS subsystem Swarm container port                                                                                                        | `4001`                   |
| `containerPorts.api`                              | sqnc-ipfs IPFS subsystem api container port                                                                                                          | `5001`                   |
| `livenessProbe.enabled`                           | Enable livenessProbe on sqnc-ipfs containers                                                                                                         | `true`                   |
| `livenessProbe.httpGet.path`                      | Path for to check for livenessProbe                                                                                                                  | `/health`                |
| `livenessProbe.httpGet.port`                      | Port for to check for livenessProbe                                                                                                                  | `http`                   |
| `livenessProbe.initialDelaySeconds`               | Initial delay seconds for livenessProbe                                                                                                              | `10`                     |
| `livenessProbe.periodSeconds`                     | Period seconds for livenessProbe                                                                                                                     | `10`                     |
| `livenessProbe.timeoutSeconds`                    | Timeout seconds for livenessProbe                                                                                                                    | `5`                      |
| `livenessProbe.failureThreshold`                  | Failure threshold for livenessProbe                                                                                                                  | `3`                      |
| `livenessProbe.successThreshold`                  | Success threshold for livenessProbe                                                                                                                  | `1`                      |
| `readinessProbe.enabled`                          | Enable readinessProbe on sqnc-ipfs containers                                                                                                        | `true`                   |
| `readinessProbe.httpGet.path`                     | Path for to check for readinessProbe                                                                                                                 | `/health`                |
| `readinessProbe.httpGet.port`                     | Port for to check for readinessProbe                                                                                                                 | `http`                   |
| `readinessProbe.initialDelaySeconds`              | Initial delay seconds for readinessProbe                                                                                                             | `5`                      |
| `readinessProbe.periodSeconds`                    | Period seconds for readinessProbe                                                                                                                    | `10`                     |
| `readinessProbe.timeoutSeconds`                   | Timeout seconds for readinessProbe                                                                                                                   | `5`                      |
| `readinessProbe.failureThreshold`                 | Failure threshold for readinessProbe                                                                                                                 | `5`                      |
| `readinessProbe.successThreshold`                 | Success threshold for readinessProbe                                                                                                                 | `1`                      |
| `startupProbe.enabled`                            | Enable startupProbe on sqnc-ipfs containers                                                                                                          | `false`                  |
| `startupProbe.httpGet.path`                       | Path for to check for startupProbe                                                                                                                   | `/health`                |
| `startupProbe.httpGet.port`                       | Port for to check for startupProbe                                                                                                                   | `http`                   |
| `startupProbe.initialDelaySeconds`                | Initial delay seconds for startupProbe                                                                                                               | `30`                     |
| `startupProbe.periodSeconds`                      | Period seconds for startupProbe                                                                                                                      | `10`                     |
| `startupProbe.timeoutSeconds`                     | Timeout seconds for startupProbe                                                                                                                     | `5`                      |
| `startupProbe.failureThreshold`                   | Failure threshold for startupProbe                                                                                                                   | `10`                     |
| `startupProbe.successThreshold`                   | Success threshold for startupProbe                                                                                                                   | `1`                      |
| `customLivenessProbe`                             | Custom livenessProbe that overrides the default one                                                                                                  | `{}`                     |
| `customReadinessProbe`                            | Custom readinessProbe that overrides the default one                                                                                                 | `{}`                     |
| `customStartupProbe`                              | Custom startupProbe that overrides the default one                                                                                                   | `{}`                     |
| `resources.limits`                                | The resources limits for the sqnc-ipfs containers                                                                                                    | `{}`                     |
| `resources.requests`                              | The requested resources for the sqnc-ipfs containers                                                                                                 | `{}`                     |
| `podSecurityContext.enabled`                      | Enabled sqnc-ipfs pods' Security Context                                                                                                             | `true`                   |
| `podSecurityContext.fsGroup`                      | Set sqnc-ipfs pod's Security Context fsGroup                                                                                                         | `1001`                   |
| `containerSecurityContext.enabled`                | Enabled sqnc-ipfs containers' Security Context                                                                                                       | `true`                   |
| `containerSecurityContext.runAsUser`              | Set sqnc-ipfs containers' Security Context runAsUser                                                                                                 | `1001`                   |
| `containerSecurityContext.runAsNonRoot`           | Set sqnc-ipfs containers' Security Context runAsNonRoot                                                                                              | `true`                   |
| `containerSecurityContext.readOnlyRootFilesystem` | Set sqnc-ipfs containers' Security Context runAsNonRoot                                                                                              | `false`                  |
| `command`                                         | Override default container command (useful when using custom images)                                                                                 | `["./app/index.js"]`     |
| `args`                                            | Override default container args (useful when using custom images)                                                                                    | `[]`                     |
| `hostAliases`                                     | sqnc-ipfs pods host aliases                                                                                                                          | `[]`                     |
| `podLabels`                                       | Extra labels for sqnc-ipfs pods                                                                                                                      | `{}`                     |
| `podAnnotations`                                  | Annotations for sqnc-ipfs pods                                                                                                                       | `{}`                     |
| `podAffinityPreset`                               | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                  | `""`                     |
| `podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                             | `soft`                   |
| `pdb.create`                                      | Enable/disable a Pod Disruption Budget creation                                                                                                      | `false`                  |
| `pdb.minAvailable`                                | Minimum number/percentage of pods that should remain scheduled                                                                                       | `1`                      |
| `pdb.maxUnavailable`                              | Maximum number/percentage of pods that may be made unavailable                                                                                       | `""`                     |
| `autoscaling.enabled`                             | Enable autoscaling for sqnc-ipfs                                                                                                                     | `false`                  |
| `autoscaling.minReplicas`                         | Minimum number of sqnc-ipfs replicas                                                                                                                 | `""`                     |
| `autoscaling.maxReplicas`                         | Maximum number of sqnc-ipfs replicas                                                                                                                 | `""`                     |
| `autoscaling.targetCPU`                           | Target CPU utilization percentage                                                                                                                    | `""`                     |
| `autoscaling.targetMemory`                        | Target Memory utilization percentage                                                                                                                 | `""`                     |
| `nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                            | `""`                     |
| `nodeAffinityPreset.key`                          | Node label key to match. Ignored if `affinity` is set                                                                                                | `""`                     |
| `nodeAffinityPreset.values`                       | Node label values to match. Ignored if `affinity` is set                                                                                             | `[]`                     |
| `affinity`                                        | Affinity for sqnc-ipfs pods assignment                                                                                                               | `{}`                     |
| `nodeSelector`                                    | Node labels for sqnc-ipfs pods assignment                                                                                                            | `{}`                     |
| `tolerations`                                     | Tolerations for sqnc-ipfs pods assignment                                                                                                            | `[]`                     |
| `updateStrategy.type`                             | sqnc-ipfs statefulset strategy type                                                                                                                  | `RollingUpdate`          |
| `podManagementPolicy`                             | Statefulset Pod management policy, it needs to be Parallel to be able to complete the cluster join                                                   | `OrderedReady`           |
| `priorityClassName`                               | sqnc-ipfs pods' priorityClassName                                                                                                                    | `""`                     |
| `topologySpreadConstraints`                       | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                             | `[]`                     |
| `schedulerName`                                   | Name of the k8s scheduler (other than default) for sqnc-ipfs pods                                                                                    | `""`                     |
| `terminationGracePeriodSeconds`                   | Seconds Redmine pod needs to terminate gracefully                                                                                                    | `""`                     |
| `lifecycleHooks`                                  | for the sqnc-ipfs container(s) to automate configuration before or after startup                                                                     | `{}`                     |
| `extraEnvVars`                                    | Array with extra environment variables to add to sqnc-ipfs nodes                                                                                     | `[]`                     |
| `extraEnvVarsCM`                                  | Name of existing ConfigMap containing extra env vars for sqnc-ipfs nodes                                                                             | `""`                     |
| `extraEnvVarsSecret`                              | Name of existing Secret containing extra env vars for sqnc-ipfs nodes                                                                                | `""`                     |
| `extraVolumes`                                    | Optionally specify extra list of additional volumes for the sqnc-ipfs pod(s)                                                                         | `[]`                     |
| `extraVolumeMounts`                               | Optionally specify extra list of additional volumeMounts for the sqnc-ipfs container(s)                                                              | `[]`                     |
| `sidecars`                                        | Add additional sidecar containers to the sqnc-ipfs pod(s)                                                                                            | `[]`                     |
| `initContainers`                                  | Add additional init containers to the sqnc-ipfs pod(s)                                                                                               | `[]`                     |

### Traffic Exposure Parameters

| Name                                    | Description                                                                                | Value       |
| --------------------------------------- | ------------------------------------------------------------------------------------------ | ----------- |
| `service.type`                          | sqnc-ipfs service type                                                                     | `ClusterIP` |
| `service.ports.http`                    | sqnc-ipfs service HTTP port                                                                | `80`        |
| `service.nodePorts.http`                | Node port for HTTP                                                                         | `""`        |
| `service.clusterIP`                     | sqnc-ipfs service Cluster IP                                                               | `""`        |
| `service.loadBalancerIP`                | sqnc-ipfs service Load Balancer IP                                                         | `""`        |
| `service.loadBalancerSourceRanges`      | sqnc-ipfs service Load Balancer sources                                                    | `[]`        |
| `service.externalTrafficPolicy`         | sqnc-ipfs service external traffic policy                                                  | `Cluster`   |
| `service.annotations`                   | Additional custom annotations for sqnc-ipfs service                                        | `{}`        |
| `service.extraPorts`                    | Extra ports to expose in sqnc-ipfs service (normally used with the `sidecars` value)       | `[]`        |
| `service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                           | `None`      |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                | `{}`        |
| `swarmService.type`                     | sqnc-ipfs sqnc-ipfs swarm service type                                                     | `ClusterIP` |
| `swarmService.ports.swarm`              | sqnc-ipfs swarm service HTTP port                                                          | `4001`      |
| `swarmService.nodePorts.swarm`          | Node port for HTTP                                                                         | `""`        |
| `swarmService.clusterIP`                | sqnc-ipfs swarm service Cluster IP                                                         | `""`        |
| `swarmService.loadBalancerIP`           | sqnc-ipfs swarm service Load Balancer IP                                                   | `""`        |
| `swarmService.loadBalancerSourceRanges` | sqnc-ipfs service Load Balancer sources                                                    | `[]`        |
| `swarmService.externalTrafficPolicy`    | sqnc-ipfs swarm service external traffic policy                                            | `Cluster`   |
| `swarmService.annotations`              | Additional custom annotations for sqnc-ipfs swarm service                                  | `{}`        |
| `swarmService.extraPorts`               | Extra ports to expose in sqnc-ipfs swarm service (normally used with the `sidecars` value) | `[]`        |
| `swarmService.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                           | `None`      |
| `swarmService.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                | `{}`        |
| `apiService.type`                       | sqnc-ipfs sqnc-ipfs api service type                                                       | `ClusterIP` |
| `apiService.ports.api`                  | sqnc-ipfs api service HTTP port                                                            | `5001`      |
| `apiService.nodePorts.api`              | Node port for HTTP                                                                         | `""`        |
| `apiService.clusterIP`                  | sqnc-ipfs api service Cluster IP                                                           | `""`        |
| `apiService.loadBalancerIP`             | sqnc-ipfs api service Load Balancer IP                                                     | `""`        |
| `apiService.loadBalancerSourceRanges`   | sqnc-ipfs service Load Balancer sources                                                    | `[]`        |
| `apiService.externalTrafficPolicy`      | sqnc-ipfs api service external traffic policy                                              | `Cluster`   |
| `apiService.annotations`                | Additional custom annotations for sqnc-ipfs api service                                    | `{}`        |
| `apiService.extraPorts`                 | Extra ports to expose in sqnc-ipfs api service (normally used with the `sidecars` value)   | `[]`        |
| `apiService.sessionAffinity`            | Control where client requests go, to the same pod or round-robin                           | `None`      |
| `apiService.sessionAffinityConfig`      | Additional settings for the sessionAffinity                                                | `{}`        |

### Persistence Parameters

| Name                        | Description                                                                                             | Value               |
| --------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------- |
| `persistence.enabled`       | Enable persistence using Persistent Volume Claims                                                       | `true`              |
| `persistence.mountPath`     | Path to mount the volume at.                                                                            | `/ipfs`             |
| `persistence.subPath`       | The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services | `""`                |
| `persistence.storageClass`  | Storage class of backing PVC                                                                            | `""`                |
| `persistence.annotations`   | Persistent Volume Claim annotations                                                                     | `{}`                |
| `persistence.accessModes`   | Persistent Volume Access Modes                                                                          | `["ReadWriteOnce"]` |
| `persistence.size`          | Size of data volume                                                                                     | `1Gi`               |
| `persistence.existingClaim` | The name of an existing PVC to use for persistence                                                      | `""`                |
| `persistence.selector`      | Selector to match an existing Persistent Volume for WordPress data PVC                                  | `{}`                |
| `persistence.dataSource`    | Custom PVC data source                                                                                  | `{}`                |

### Init Container Parameters

| Name                                                   | Description                                                                                     | Value                   |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                    | `docker.io`             |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                        | `latest`                |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                 | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                | `[]`                    |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `{}`                    |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `{}`                    |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                     |

### Other Parameters

| Name                                          | Description                                                      | Value  |
| --------------------------------------------- | ---------------------------------------------------------------- | ------ |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true` |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`   |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`   |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `true` |

### SQNC-Node Parameters

| Name                        | Description                                                                               | Value  |
| --------------------------- | ----------------------------------------------------------------------------------------- | ------ |
| `sqncNode.enabled`          | Enable SQNC-Node subchart                                                                 | `true` |
| `sqncNode.nameOverride`     | String to partially override sqnc-node.fullname template (will maintain the release name) | `""`   |
| `sqncNode.fullnameOverride` | String to fully override sqnc-node.fullname template                                      | `""`   |
| `externalSqncNode.host`     | External SQNC-Node hostname to query                                                      | `""`   |
| `externalSqncNode.port`     | External SQNC-Node port to query                                                          | `""`   |

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
