#!/bin/bash
set -euo pipefail

#cambia la contraseña  de admin por Cyberark1 a menos que se especifique algo diferente en bootstrap.env
#
export API_KEY_ADMIN=$(cat admin.key)


docker run --rm -it -v $(PWD)/mydata/:/root --entrypoint bash cyberark/conjur-cli:5 -c "yes yes | conjur init -a $CONJUR_ACCOUNT -u $CONJUR_URL"
docker run --rm -it -v $(PWD)/mydata/:/root cyberark/conjur-cli:5 authn login -u admin -p $API_KEY_ADMIN
docker run --rm -it -v $(PWD)/mydata/:/root cyberark/conjur-cli:5 user update_password -p $CONJUR_ADMIN_PASSWORD
docker run --rm -it -v $(PWD)/mydata/:/root cyberark/conjur-cli:5 authn logout


