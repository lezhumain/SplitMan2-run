#! /bin/bash

set -e

if [ -z "$DEBIAN_PATH" ]; then
  echo "Need to export DEBIAN path"
fi

#ssh -oBatchMode=yes "${DEBIAN_USER}@${DEBIAN_IP}" bash << EOF
ssh -oBatchMode=yes ovhVM_rel bash << EOF
  #ls -al
  cd "${DEBIAN_PATH}"
  #ls -al
  chmod +x ./*.sh
  
  #cd ../SplitMan2
  #zip -r "../SplitMan2_$(date +%s).zip"
  #cd ../SplitMan2-API
  #zip -r "../SplitMan2-API_$(date +%s).zip"
  #cd ../SplitMan2-nginx
  #zip -r "../SplitMan2-nginx_$(date +%s).zip"
  #cd ../SplitMan2-run
  #zip -r "../SplitMan2-run_$(date +%s).zip"
  
  mkdir -p backups
  rm -rf backups/*
  cd backups
  #docker save splitman2 -o splitman2.tar
  #docker save splitman2nginx -o splitman2nginx.tar
  #docker save splitman2api -o splitman2api.tar
  #docker save mongo -o mongo.tar
  
  ls -al
  docker images
  docker images | grep -Eo "^(splitman2\w*)|(mongo)"
  #IMAGE_LIST="$(docker images | grep -Eo "^(splitman2\w*)|(mongo)")"
  IMAGE_LIST=$(docker images | grep -Eo "^(splitman2\w*)|(mongo)")
  echo "IMAGE_LIST: $IMAGE_LIST"
  if [ -z "$IMAGE_LIST" ]; then
    echo "No image to backup"
    exit 0
  fi
  IFS=$'\n'
  for IMAGE in $IMAGE_LIST
  do
    echo "Saving image $IMAGE"
    docker save "$IMAGE" -o "$IMAGE.tar"
  done
  
  if [ -n "$(ls)" ]; then
    zip -r "../SplitMan2-images_$(date +%s).zip" ./
  fi
EOF
