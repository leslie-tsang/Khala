#!/bin/bash
set -e

# init ssh-agent service
eval `ssh-agent -s`

# try to load default private key
if [[ -e ${ANSIBLE_REMOTE_PRIVATE_KEY} ]]; then
	ssh-add ${ANSIBLE_REMOTE_PRIVATE_KEY}
fi

exec "$@"
