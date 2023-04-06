#! /bin/bash

if [ -z "$DEBIAN_PATH" ]; then
  echo "Need to export DEBIAN path"
fi

scp ./waitForServer.sh "ovhVM_rel:${DEBIAN_PATH}"

echo "MONGO CREDS: $MONGO_USER - $MONGO_PASS"
if [ -z "$MONGO_USER" ] || [ -z "$MONGO_PASS" ]; then
  echo "Need to export MONGO creds."
  exit 1
fi

COMPOSE_FILE="docker-compose.yml"
if [ ! -f "$COMPOSE_FILE" ]; then
  COMPOSE_FILE="../SplitMan2-run/docker-compose.yml"
fi
sed -i.bak -E "s|MONGO_INITDB_ROOT_USERNAME=.+$|MONGO_INITDB_ROOT_USERNAME=$MONGO_USER|" "$COMPOSE_FILE"
sed -i.bak -E "s|MONGO_INITDB_ROOT_PASSWORD=.+$|MONGO_INITDB_ROOT_PASSWORD=$MONGO_PASS|" "$COMPOSE_FILE"

scp "./$COMPOSE_FILE" "ovhVM_rel:${DEBIAN_PATH}"

ssh -oBatchMode=yes "ovhVM_rel" bash << EOF
  cd "${DEBIAN_PATH}"
  chmod +x ./*.sh
  docker-compose up -d

  #echo "Waiting for web server"
  #bash waitForServer.sh "127.0.0.1:8080"
  #bash waitForServer.sh "https://127.0.0.1:8081/api/version"
  #bash waitForServer.sh "https://127.0.0.1:8081/"

  sleep 10
  docker ps
EOF
