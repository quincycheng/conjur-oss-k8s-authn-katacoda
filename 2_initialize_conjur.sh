#!/bin/bash
set -euo pipefail

## inicializa conjur
## crea la cuenta definida en bootstrap.env
## almacena la llave de admin en el archivo admin.key

export SERVICE_IP=$(kubectl get svc --namespace conjur \
                                          conjur-oss-ingress \
                                          -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo -e " Service is exposed at ${SERVICE_IP}:443\n" \
              "Ensure that domain "conjur.demo.com" has an A record to ${SERVICE_IP}\n" \
              "and only use the DNS endpoint https://conjur.demo.com:443 to connect.\n"

export POD_NAME=$(kubectl get pods --namespace $CONJUR_NAMESPACE \
                                         -l "app=conjur-oss,release=conjur-oss" \
                                         -o jsonpath="{.items[0].metadata.name}")
                                         
API_KEY_ADMIN=$(kubectl exec $POD_NAME --container=$CONJUR_APP_NAME --namespace $CONJUR_NAMESPACE conjurctl account create "$CONJUR_ACCOUNT") \
    && API_KEY_ADMIN=${API_KEY_ADMIN##* }

echo 'admin key:' $API_KEY_ADMIN
echo $API_KEY_ADMIN > admin.key
#ejecutar manualmente
###
echo -e "\n+\n+ \n Agregar manualmente el siguiente registro al archivo /etc/hosts \n \
            $SERVICE_IP $CONJUR_HOSTNAME_SSL"