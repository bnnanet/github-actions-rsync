#!/bin/sh

set -eu

# Set deploy key
SSH_PATH="$HOME/.ssh"
SSH_CMDS=""
mkdir -p "$SSH_PATH"

# touch "$SSH_PATH/known_hosts"
touch "$SSH_PATH/deploy_key"

# PRIVATE_KEY=$SSH_PRIVATE_KEY
PRIVATE_KEY=$(echo "$SSH_PRIVATE_KEY" | base64 -d)

echo "$PRIVATE_KEY" > "$SSH_PATH/deploy_key"

if [ ! -z "$SSH_CONFIG" ]
then
  # CONFIG=$SSH_CONFIG
  CONFIG=$(echo "$SSH_CONFIG" | base64 -d)
  echo "$CONFIG" > "$SSH_PATH/config"
  chmod 600 "$SSH_PATH/config"
  SSH_CMDS="-F $SSH_PATH/config"
fi

chmod 700 "$SSH_PATH"
# chmod 600 "$SSH_PATH/known_hosts"
chmod 600 "$SSH_PATH/deploy_key"

SSH_CMDS="$SSH_CMDS -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# Do deployment
#shellcheck disable=SC2153
sh -c "rsync ${INPUT_RSYNC_OPTIONS} -e 'ssh $SSH_CMDS' ${GITHUB_WORKSPACE}${INPUT_RSYNC_SOURCE} ${SSH_USERNAME}@${SSH_HOSTNAME}:${INPUT_RSYNC_TARGET}"
