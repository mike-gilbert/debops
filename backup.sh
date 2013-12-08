#!/bin/sh

# Warning: this is not full backup script! It only backs up enough data to
# restore host to it's operational state (SSH host keys, monkeysphere GnuPG
# keys, autogenerated self-signed certificates).

# Data backed up is sensitive (host private keys) and should be treated as
# such. It will be backed up into "secret" Ansible directory, if configured in
# the inventory.

set -e

if [ -z "${TOO_MANY_SECRETS}" ] ; then
	ansible-playbook -i inventory playbooks/secret.yml --extra-vars="secret_mode=open"
	trap "ansible-playbook -i inventory playbooks/secret.yml" EXIT
fi

ansible-playbook -i inventory playbooks/system_backup.yml $@
