# dscp-ipfs

The dscp-ipfs is a component of the DSCP (Digital-Supply-Chain-Platform), a blockchain platform. The dscp-ipfs service is responsible for rotating IPFS swarm keys and storing data, it exposes an IPFS API for this purpose. See [https://github.com/digicatapult/dscp-documentation](https://github.com/digicatapult/dscp-documentation) for details.

## TL;DR

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/dscp-ipfs
```

## Introduction

This chart bootstraps a [dscp-ipfs](https://github.com/digicatapult/dscp-ipfs/) deployment on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/dscp-ipfs
```

The command deploys dscp-ipfs on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

### DSCP IPFS Service config parameters

| Name                                              | Description                                                                                                                                          | Value                    |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `logLevel`                                        | logLevel for nodeJS service Allowed values: error, warn, info, debug                                                                                 | `info`                   |
| `healthCheckPollPeriod`                           | Health check poll period in milliseconds                                                                                                             | `30000`                  |
| `healthCheckTimeout`                              | Health check timeout in milliseconds                                                                                                                 | `2000`                   |
| `image.registry`                                  | dscp-ipfs image registry                                                                                                                             | `docker.io`              |
| `image.repository`                                | dscp-ipfs image repository                                                                                                                           | `digicatapult/dscp-ipfs` |
| `image.tag`                                       | dscp-ipfs image tag (immutable tags are recommended)                                                                                                 | `v2.9.3`                 |
| `image.digest`                                    | dscp-ipfs image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                     |
| `image.pullPolicy`                                | dscp-ipfs image pull policy                                                                                                                          | `IfNotPresent`           |
| `image.pullSecrets`                               | dscp-ipfs image pull secrets                                                                                                                         | `[]`                     |
| `image.debug`                                     | Enable dscp-ipfs image debug mode                                                                                                                    | `false`                  |
| `replicaCount`                                    | Number of dscp-ipfs replicas to deploy                                                                                                               | `1`                      |
| `containerPorts.http`                             | dscp-ipfs HTTP container port                                                                                                                        | `3000`                   |
| `containerPorts.swarm`                            | dscp-ipfs IPFS subsystem Swarm container port                                                                                                        | `4001`                   |
| `containerPorts.api`                              | dscp-ipfs IPFS subsystem api container port                                                                                                          | `5001`                   |
| `livenessProbe.enabled`                           | Enable livenessProbe on dscp-ipfs containers                                                                                                         | `true`                   |
| `livenessProbe.httpGet.path`                      | Path for to check for livenessProbe                                                                                                                  | `/health`                |
| `livenessProbe.httpGet.port`                      | Port for to check for livenessProbe                                                                                                                  | `http`                   |
| `livenessProbe.initialDelaySeconds`               | Initial delay seconds for livenessProbe                                                                                                              | `10`                     |
| `livenessProbe.periodSeconds`                     | Period seconds for livenessProbe                                                                                                                     | `10`                     |
| `livenessProbe.timeoutSeconds`                    | Timeout seconds for livenessProbe                                                                                                                    | `5`                      |
| `livenessProbe.failureThreshold`                  | Failure threshold for livenessProbe                                                                                                                  | `3`                      |
| `livenessProbe.successThreshold`                  | Success threshold for livenessProbe                                                                                                                  | `1`                      |
| `readinessProbe.enabled`                          | Enable readinessProbe on dscp-ipfs containers                                                                                                        | `true`                   |
| `readinessProbe.httpGet.path`                     | Path for to check for readinessProbe                                                                                                                 | `/health`                |
| `readinessProbe.httpGet.port`                     | Port for to check for readinessProbe                                                                                                                 | `http`                   |
| `readinessProbe.initialDelaySeconds`              | Initial delay seconds for readinessProbe                                                                                                             | `5`                      |
| `readinessProbe.periodSeconds`                    | Period seconds for readinessProbe                                                                                                                    | `10`                     |
| `readinessProbe.timeoutSeconds`                   | Timeout seconds for readinessProbe                                                                                                                   | `5`                      |
| `readinessProbe.failureThreshold`                 | Failure threshold for readinessProbe                                                                                                                 | `5`                      |
| `readinessProbe.successThreshold`                 | Success threshold for readinessProbe                                                                                                                 | `1`                      |
| `startupProbe.enabled`                            | Enable startupProbe on dscp-ipfs containers                                                                                                          | `false`                  |
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
| `resources.limits`                                | The resources limits for the dscp-ipfs containers                                                                                                    | `{}`                     |
| `resources.requests`                              | The requested resources for the dscp-ipfs containers                                                                                                 | `{}`                     |
| `podSecurityContext.enabled`                      | Enabled dscp-ipfs pods' Security Context                                                                                                             | `true`                   |
| `podSecurityContext.fsGroup`                      | Set dscp-ipfs pod's Security Context fsGroup                                                                                                         | `1001`                   |
| `containerSecurityContext.enabled`                | Enabled dscp-ipfs containers' Security Context                                                                                                       | `true`                   |
| `containerSecurityContext.runAsUser`              | Set dscp-ipfs containers' Security Context runAsUser                                                                                                 | `1001`                   |
| `containerSecurityContext.runAsNonRoot`           | Set dscp-ipfs containers' Security Context runAsNonRoot                                                                                              | `true`                   |
| `containerSecurityContext.readOnlyRootFilesystem` | Set dscp-ipfs containers' Security Context runAsNonRoot                                                                                              | `false`                  |
| `command`                                         | Override default container command (useful when using custom images)                                                                                 | `["./app/index.js"]`     |
| `args`                                            | Override default container args (useful when using custom images)                                                                                    | `[]`                     |
| `hostAliases`                                     | dscp-ipfs pods host aliases                                                                                                                          | `[]`                     |
| `podLabels`                                       | Extra labels for dscp-ipfs pods                                                                                                                      | `{}`                     |
| `podAnnotations`                                  | Annotations for dscp-ipfs pods                                                                                                                       | `{}`                     |
| `podAffinityPreset`                               | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                  | `""`                     |
| `podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                             | `soft`                   |
| `pdb.create`                                      | Enable/disable a Pod Disruption Budget creation                                                                                                      | `false`                  |
| `pdb.minAvailable`                                | Minimum number/percentage of pods that should remain scheduled                                                                                       | `1`                      |
| `pdb.maxUnavailable`                              | Maximum number/percentage of pods that may be made unavailable                                                                                       | `""`                     |
| `autoscaling.enabled`                             | Enable autoscaling for dscp-ipfs                                                                                                                     | `false`                  |
| `autoscaling.minReplicas`                         | Minimum number of dscp-ipfs replicas                                                                                                                 | `""`                     |
| `autoscaling.maxReplicas`                         | Maximum number of dscp-ipfs replicas                                                                                                                 | `""`                     |
| `autoscaling.targetCPU`                           | Target CPU utilization percentage                                                                                                                    | `""`                     |
| `autoscaling.targetMemory`                        | Target Memory utilization percentage                                                                                                                 | `""`                     |
| `nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                            | `""`                     |
| `nodeAffinityPreset.key`                          | Node label key to match. Ignored if `affinity` is set                                                                                                | `""`                     |
| `nodeAffinityPreset.values`                       | Node label values to match. Ignored if `affinity` is set                                                                                             | `[]`                     |
| `affinity`                                        | Affinity for dscp-ipfs pods assignment                                                                                                               | `{}`                     |
| `nodeSelector`                                    | Node labels for dscp-ipfs pods assignment                                                                                                            | `{}`                     |
| `tolerations`                                     | Tolerations for dscp-ipfs pods assignment                                                                                                            | `[]`                     |
| `updateStrategy.type`                             | dscp-ipfs statefulset strategy type                                                                                                                  | `RollingUpdate`          |
| `podManagementPolicy`                             | Statefulset Pod management policy, it needs to be Parallel to be able to complete the cluster join                                                   | `OrderedReady`           |
| `priorityClassName`                               | dscp-ipfs pods' priorityClassName                                                                                                                    | `""`                     |
| `topologySpreadConstraints`                       | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                             | `[]`                     |
| `schedulerName`                                   | Name of the k8s scheduler (other than default) for dscp-ipfs pods                                                                                    | `""`                     |
| `terminationGracePeriodSeconds`                   | Seconds Redmine pod needs to terminate gracefully                                                                                                    | `""`                     |
| `lifecycleHooks`                                  | for the dscp-ipfs container(s) to automate configuration before or after startup                                                                     | `{}`                     |
| `extraEnvVars`                                    | Array with extra environment variables to add to dscp-ipfs nodes                                                                                     | `[]`                     |
| `extraEnvVarsCM`                                  | Name of existing ConfigMap containing extra env vars for dscp-ipfs nodes                                                                             | `""`                     |
| `extraEnvVarsSecret`                              | Name of existing Secret containing extra env vars for dscp-ipfs nodes                                                                                | `""`                     |
| `extraVolumes`                                    | Optionally specify extra list of additional volumes for the dscp-ipfs pod(s)                                                                         | `[]`                     |
| `extraVolumeMounts`                               | Optionally specify extra list of additional volumeMounts for the dscp-ipfs container(s)                                                              | `[]`                     |
| `sidecars`                                        | Add additional sidecar containers to the dscp-ipfs pod(s)                                                                                            | `[]`                     |
| `initContainers`                                  | Add additional init containers to the dscp-ipfs pod(s)                                                                                               | `[]`                     |

### Traffic Exposure Parameters

| Name                                    | Description                                                                                | Value       |
| --------------------------------------- | ------------------------------------------------------------------------------------------ | ----------- |
| `service.type`                          | dscp-ipfs service type                                                                     | `ClusterIP` |
| `service.ports.http`                    | dscp-ipfs service HTTP port                                                                | `80`        |
| `service.nodePorts.http`                | Node port for HTTP                                                                         | `""`        |
| `service.clusterIP`                     | dscp-ipfs service Cluster IP                                                               | `""`        |
| `service.loadBalancerIP`                | dscp-ipfs service Load Balancer IP                                                         | `""`        |
| `service.loadBalancerSourceRanges`      | dscp-ipfs service Load Balancer sources                                                    | `[]`        |
| `service.externalTrafficPolicy`         | dscp-ipfs service external traffic policy                                                  | `Cluster`   |
| `service.annotations`                   | Additional custom annotations for dscp-ipfs service                                        | `{}`        |
| `service.extraPorts`                    | Extra ports to expose in dscp-ipfs service (normally used with the `sidecars` value)       | `[]`        |
| `service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                           | `None`      |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                | `{}`        |
| `swarmService.type`                     | dscp-ipfs dscp-ipfs swarm service type                                                     | `ClusterIP` |
| `swarmService.ports.swarm`              | dscp-ipfs swarm service HTTP port                                                          | `4001`      |
| `swarmService.nodePorts.swarm`          | Node port for HTTP                                                                         | `""`        |
| `swarmService.clusterIP`                | dscp-ipfs swarm service Cluster IP                                                         | `""`        |
| `swarmService.loadBalancerIP`           | dscp-ipfs swarm service Load Balancer IP                                                   | `""`        |
| `swarmService.loadBalancerSourceRanges` | dscp-ipfs service Load Balancer sources                                                    | `[]`        |
| `swarmService.externalTrafficPolicy`    | dscp-ipfs swarm service external traffic policy                                            | `Cluster`   |
| `swarmService.annotations`              | Additional custom annotations for dscp-ipfs swarm service                                  | `{}`        |
| `swarmService.extraPorts`               | Extra ports to expose in dscp-ipfs swarm service (normally used with the `sidecars` value) | `[]`        |
| `swarmService.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                           | `None`      |
| `swarmService.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                | `{}`        |
| `apiService.type`                       | dscp-ipfs dscp-ipfs api service type                                                       | `ClusterIP` |
| `apiService.ports.api`                  | dscp-ipfs api service HTTP port                                                            | `5001`      |
| `apiService.nodePorts.api`              | Node port for HTTP                                                                         | `""`        |
| `apiService.clusterIP`                  | dscp-ipfs api service Cluster IP                                                           | `""`        |
| `apiService.loadBalancerIP`             | dscp-ipfs api service Load Balancer IP                                                     | `""`        |
| `apiService.loadBalancerSourceRanges`   | dscp-ipfs service Load Balancer sources                                                    | `[]`        |
| `apiService.externalTrafficPolicy`      | dscp-ipfs api service external traffic policy                                              | `Cluster`   |
| `apiService.annotations`                | Additional custom annotations for dscp-ipfs api service                                    | `{}`        |
| `apiService.extraPorts`                 | Extra ports to expose in dscp-ipfs api service (normally used with the `sidecars` value)   | `[]`        |
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

### DSCP-Node Parameters

| Name                        | Description                                                                               | Value  |
| --------------------------- | ----------------------------------------------------------------------------------------- | ------ |
| `dscpNode.enabled`          | Enable DSCP-Node subchart                                                                 | `true` |
| `dscpNode.nameOverride`     | String to partially override dscp-node.fullname template (will maintain the release name) | `""`   |
| `dscpNode.fullnameOverride` | String to fully override dscp-node.fullname template                                      | `""`   |
| `externalDscpNode.host`     | External DSCP-Node hostname to query                                                      | `""`   |
| `externalDscpNode.port`     | External DSCP-Node port to query                                                          | `""`   |

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## License

This chart is licensed under the Apache v2.0 license.

Copyright &copy; 2023 Digital Catapult

### Attribution

This chart is adapted from The [charts]((https://github.com/bitnami/charts)) provided by [Bitnami](https://bitnami.com/) which are licensed under the Apache v2.0 License which is reproduced here:

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
