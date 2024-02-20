
{{/*
Return the proper sqnc-ipfs image name
*/}}
{{- define "sqnc-ipfs.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "sqnc-ipfs.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "sqnc-ipfs.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "sqnc-ipfs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the keys secret.
*/}}
{{- define "sqnc-ipfs.secretName" -}}
{{- if .Values.ipfs.existingSecret -}}
    {{- printf "%s" (tpl .Values.ipfs.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the ipfs publicKey key.
*/}}
{{- define "sqnc-ipfs.publicKeyKey" -}}
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
{{- define "sqnc-ipfs.privateKeyKey" -}}
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
Create a default fully qualified app name for sqnc-node subchart
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "sqnc-ipfs.sqncNode.fullname" -}}
{{- if .Values.sqncNode.fullnameOverride -}}
{{- .Values.sqncNode.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "sqncnode-0" .Values.sqncNode.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{/*
Return the sqnc-node api hostname
*/}}
{{- define "sqnc-ipfs.sqncNodeHost" -}}
{{- ternary (include "sqnc-ipfs.sqncNode.fullname" .) .Values.externalSqncNode.host .Values.sqncNode.enabled | quote -}}
{{- end -}}

{{/*
Return the sqnc-node API port
*/}}
{{- define "sqnc-ipfs.sqncNodePort" -}}
{{- ternary "9944" .Values.externalSqncNode.port .Values.sqncNode.enabled | quote -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "sqnc-ipfs.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}
