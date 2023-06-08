#!/bin/bash

set -e

if [ -f .env ];
then
  export $(cat .env | xargs);
fi


SERVER=$DOCKER_SERVER
USERNAME=$DOCKER_DOCKER_USERNAME
PASSWORD=$DOCKER_PASSWORD
EMAIL=$DOCKER_EMAIL
STAGE=$1
TEMP_FILENAME=secret-temp.yaml

if [[ "$STAGE" =~ ^("dev"|"prod")$ ]]; then echo $STAGE ; 
else 
    echo "Invalid Stage Set: '${STAGE}'"
    exit
fi

kubectl create secret docker-registry image-pull-secret-${STAGE} \
--docker-server=${SERVER} \
--docker-username=${USERNAME} \
--docker-password=${PASSWORD} \
--docker-email=${EMAIL} \
--dry-run=client -o yaml > ${TEMP_FILENAME}
kubeseal -n bering-server-${STAGE} -o yaml < ${TEMP_FILENAME} > ./bering-backend/sealed-image-pull-${STAGE}-secret.yaml

rm ${TEMP_FILENAME}