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
  
  ./test_backup.sh
EOF
