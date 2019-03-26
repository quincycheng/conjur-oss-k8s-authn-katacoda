#!/bin/bash
set -euo pipefail

## instala conjur usando helm
##
if ! kubectl get namespace $CONJUR_NAMESPACE > /dev/null
then
    kubectl create namespace "$CONJUR_NAMESPACE"
fi


helm init
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --upgrade

helm repo add cyberark https://cyberark.github.io/helm-charts
helm repo update


export CONJUR_APP_NAME=conjur-oss

helm install cyberark/conjur-oss \
    --set ssl.hostname=$CONJUR_HOSTNAME_SSL,dataKey="$(docker run --rm cyberark/conjur data-key generate)",authenticators="authn-k8s/dev\,authn" \
    --namespace "$CONJUR_NAMESPACE" \
    --name "$CONJUR_APP_NAME"
