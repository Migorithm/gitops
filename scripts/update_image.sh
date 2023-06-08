#!/bin/bash

set -e

if [ -f .env ];
then
  export $(cat .env | xargs);
fi

GHCR_TOKEN=$(echo $DOCKER_PASSWORD | base64)
REPOSITORY=$PACKAGE_REPOSITORY
STAGE=$1

if [[ "$STAGE" =~ ^("dev"|"prod")$ ]]; then echo $STAGE ; 
else 
    echo "Invalid Stage Set: '${STAGE}'"
    exit
fi


URL="https://ghcr.io/v2/$REPOSITORY/$IMAGE/tags/list"

IMAGE_TAG=$(curl -H "Authorization: Bearer ${GHCR_TOKEN}" ${URL} | python3 -c "import sys, json;print(json.load(sys.stdin)['tags'][-1])")


find ./backend*/${STAGE}-values.yaml -type f -exec sed -i "" "s#tag:.*#tag:\ \"${IMAGE_TAG}\"#g" {} +