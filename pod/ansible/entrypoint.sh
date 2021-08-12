#!/bin/bash
set -${ENTRYPOINT_MODE:-e}

# init ssh-agent service
eval $(ssh-agent -s)

# init container ownership
chown -R root:root ~/.ssh

# try to load default private key
REMOTE_PRIVATE_KEY=~/.ssh/${ANSIBLE_REMOTE_PRIVATE_KEY_ROOT}/${ANSIBLE_REMOTE_PRIVATE_KEY}
REMOTE_PRIVATE_KEY_PERMISSION_DST=600
if [ -f ${REMOTE_PRIVATE_KEY} ]; then
    printf '[\E[1;34m info \E[0m] try to load default private key : %s\n' "${REMOTE_PRIVATE_KEY}"
    # reset private key default permission
    REMOTE_PRIVATE_KEY_PERMISSION_CUR=$(stat -c %a ${REMOTE_PRIVATE_KEY})
    if [ ${REMOTE_PRIVATE_KEY_PERMISSION_CUR} -ne ${REMOTE_PRIVATE_KEY_PERMISSION_DST} ]; then
        chmod ${REMOTE_PRIVATE_KEY_PERMISSION_DST} ${REMOTE_PRIVATE_KEY}
    fi

    # load private key with different permission
    REMOTE_PRIVATE_KEY_PERMISSION_CUR=$(stat -c %a ${REMOTE_PRIVATE_KEY})
    if [ ${REMOTE_PRIVATE_KEY_PERMISSION_CUR} -ne ${REMOTE_PRIVATE_KEY_PERMISSION_DST} ]; then
        # load private key with pipeline mode, which work in windows container env
        cat ${REMOTE_PRIVATE_KEY} | ssh-add -k -
    else
        # load private key with ssh-agent daemon
        ssh-add ${REMOTE_PRIVATE_KEY}
    fi
    printf '[\E[1;34m info \E[0m] try to load default private key : success\n'
else
    printf '[\E[1;34m info \E[0m] try to load default private key failed: %s\n' "${REMOTE_PRIVATE_KEY}"
fi

# init ssh_config
SSH_CONFIG=~/.ssh/config
SSH_CONFIG_PERMISSION_DST=600
if [ -f ${SSH_CONFIG} ]; then
    SSH_CONFIG_PERMISSION_CUR=$(stat -c %a ${SSH_CONFIG})
    if [ ${SSH_CONFIG_PERMISSION_CUR} -ne ${SSH_CONFIG_PERMISSION_DST} ]; then
        chmod ${SSH_CONFIG_PERMISSION_DST} ${SSH_CONFIG}
    fi
fi

# extension function
function workbench_env() {
    printf '[\E[1;34m info \E[0m] pod env setting:\n'
    printf '%-25s: %s\n' 'default playbook dir' ${ANSIBLE_PLAYBOOK_DIR}
    printf '%-25s: %s\n' 'default inventory dir' ${ANSIBLE_INVENTORY}
    printf '%-25s: %s\n' 'default role dir'  ${ANSIBLE_ROLES_PATH}
    printf '%-25s: %s\n' 'default inventory' ${DEFAULT_PROJECT_INVENTORY:-hosts_local.ini}
    printf '%-25s: %s\n' 'default playbook'  ${DEFAULT_PROJECT_PLAYBOOK:-default.yml}
}

# export bash extension function
export -f workbench_env

# export
if [ ! -z ${ANSIBLE_INVENTORY_PROJECT} ]; then
    export ANSIBLE_INVENTORY=${ANSIBLE_INVENTORY_PROJECT}
fi

if [ ! -z ${ANSIBLE_PLAYBOOK_DIR_PROJECT} ]; then
    export ANSIBLE_PLAYBOOK_DIR=${ANSIBLE_PLAYBOOK_DIR_PROJECT}
fi


# print workbench env
workbench_env

exec "$@"
