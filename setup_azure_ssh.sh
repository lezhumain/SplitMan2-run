#! /bin/bash

# add ssh in config
FILE="$HOME/.ssh/config"
tee -a "$FILE" > /dev/null <<EOT
Host ovhVM_rel
  HostName "$DEBIAN_IP"
  User "$DEBIAN_USER"
  IdentityFile "$HOME/.ssh/id_releaseUser"
  Port 22
  PreferredAuthentications publickey
EOT

# add key to agent ?
eval "$(ssh-agent -s)" && ssh-add "$HOME/.ssh/id_releaseUser"
echo "Added key to agent"

if [ ! -f "$HOME/.ssh/known_hosts" ]; then
  touch "$HOME/.ssh/known_hosts"
fi
ssh-keyscan -t rsa "$DEBIAN_IP" >> "$HOME/.ssh/known_hosts"
cat "$HOME/.ssh/known_hosts"
