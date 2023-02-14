
{{/*
Return the proper wasp-open-api image name
*/}}
{{- define "wasp-open-api.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "wasp-open-api.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.cronjob.initImage .Values.cronjob.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "wasp-open-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper cronjob init container image name
*/}}
{{- define "wasp-open-api.cronjob.initImage" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.cronjob.initImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper cronjob container image name
*/}}
{{- define "wasp-open-api.cronjob.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.cronjob.image "global" .Values.global) }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "wasp-open-api.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}
