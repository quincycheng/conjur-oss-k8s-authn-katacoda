#!/bin/bash
set -euo pipefail

source bootstrap.env

  $cli create configmap test-app-secretless-config \
    --from-file=etc/secretless.yml

  sleep 5

  secretless_db_url="postgresql://localhost:5432/test_app"

  sed "s#{{ CONJUR_VERSION }}#$CONJUR_VERSION#g" ./$PLATFORM/test-app-secretless.yml |
    sed "s#{{ SECRETLESS_IMAGE }}#$secretless_image#g" |
    sed "s#{{ SECRETLESS_DB_URL }}#$secretless_db_url#g" |
    sed "s#{{ CONJUR_AUTHN_URL }}#$conjur_authenticator_url#g" |
    sed "s#{{ CONJUR_AUTHN_LOGIN_PREFIX }}#$conjur_authn_login_prefix#g" |
    sed "s#{{ CONFIG_MAP_NAME }}#$TEST_APP_NAMESPACE_NAME#g" |
    sed "s#{{ CONJUR_ACCOUNT }}#$CONJUR_ACCOUNT#g" |
    sed "s#{{ CONJUR_APPLIANCE_URL }}#$conjur_appliance_url#g" |
    $cli create -f -

  echo "Secretless test app deployed."
