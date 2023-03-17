
{{/*
Return the proper dscp-ipfs image name
*/}}
{{- define "dscp-ipfs.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "dscp-ipfs.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "dscp-ipfs.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "dscp-ipfs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the keys secret.
*/}}
{{- define "dscp-ipfs.secretName" -}}
{{- if .Values.ipfs.existingSecret -}}
    {{- printf "%s" (tpl .Values.ipfs.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the ipfs publicKey key.
*/}}
{{- define "dscp-ipfs.publicKeyKey" -}}
{{- if .Values.ipfs.existingSecret }}
    {{- if .Values.ipfs.secretKeys.publicKey -}}
        {{- printf "%s" (tpl .Values.ipfs.secretKeys.publicKey $) -}}
    {{- else -}}
        {{- "publicKey" -}}
    {{- end -}}
{{- else -}}
    {{- "publicKey" -}}
{{- end -}}
{{- end -}}

{{/*
Get the ipfs privateKey key.
*/}}
{{- define "dscp-ipfs.privateKeyKey" -}}
{{- if .Values.ipfs.existingSecret }}
    {{- if .Values.ipfs.secretKeys.privateKey -}}
        {{- printf "%s" (tpl .Values.ipfs.secretKeys.privateKey $) -}}
    {{- else -}}
        {{- "privateKey" -}}
    {{- end -}}
{{- else -}}
    {{- "privateKey" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for dscp-node subchart
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dscp-ipfs.dscpNode.fullname" -}}
{{- if .Values.dscpNode.fullnameOverride -}}
{{- .Values.dscpNode.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "dscpnode-0" .Values.dscpNode.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{/*
Return the dscp-node api hostname
*/}}
{{- define "dscp-ipfs.dscpNodeHost" -}}
{{- ternary (include "dscp-ipfs.dscpNode.fullname" .) .Values.externalDscpNode.host .Values.dscpNode.enabled | quote -}}
{{- end -}}

{{/*
Return the dscp-node API port
*/}}
{{- define "dscp-ipfs.dscpNodePort" -}}
{{- ternary "9944" .Values.externalDscpNode.port .Values.dscpNode.enabled | quote -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "dscp-ipfs.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}
