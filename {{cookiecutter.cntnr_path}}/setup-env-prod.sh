#!/bin/bash

# THIS FILE IS AUTO-GENERATED WITH COOKIECUTTER. DO NOT MODIFY DIRECTLY, YOU MAY LOSE CHANGES.

export {{cookiecutter.envvar_prefix|upper}}_ROOT_DOMAIN="{{cookiecutter.root_domain}}"
export {{cookiecutter.envvar_prefix|upper}}_PROD_USER="{{cookiecutter.prod_user}}"
export {{cookiecutter.envvar_prefix|upper}}_SSH_PRIVATE_KEY="{{cookiecutter.prod_ssh_private_key_path}}"

export {{cookiecutter.envvar_prefix|upper}}_DIGITALOCEAN_ACCESS_TOKEN="{{cookiecutter.digitalocean_access_token}}"
export {{cookiecutter.envvar_prefix|upper}}_DIGITALOCEAN_SIZE="{{cookiecutter.digitalocean_size}}"
export {{cookiecutter.envvar_prefix|upper}}_DIGITALOCEAN_SSH_KEY_FINGERPRINT="{{cookiecutter.digitalocean_ssh_key_fingerprint}}"
export {{cookiecutter.envvar_prefix|upper}}_DIGITALOCEAN_IPV6="{{cookiecutter.digitalocean_ipv6}}"
export {{cookiecutter.envvar_prefix|upper}}_DIGITALOCEAN_PRIVATE_NET="{{cookiecutter.digitalocean_private_net}}"
export {{cookiecutter.envvar_prefix|upper}}_DIGITALOCEAN_BACKUPS="{{cookiecutter.digitalocean_backups}}"

export {{cookiecutter.envvar_prefix|upper}}_PROD_IP="$(dig +tcp +short ${{cookiecutter.envvar_prefix|upper}}_ROOT_DOMAIN | grep -E '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' )"
export {{cookiecutter.envvar_prefix|upper}}_MACHINE="{{cookiecutter.machine_prefix}}-prod"
export {{cookiecutter.envvar_prefix|upper}}_DOCKER_COMPOSE_OVERRIDE_FILENAME="docker-compose-production.yml"
export {{cookiecutter.envvar_prefix|upper}}_MACHINE_ENGINE_OPT="--engine-opt=\"bip={{cookiecutter.bridge_ip_cidr}}\""

if [ "{{cookiecutter.prod_docker_driver}}" = "digitalocean" ]; then
  export {{cookiecutter.envvar_prefix|upper}}_MACHINE_DRIVER="--driver digitalocean --digitalocean-access-token=${{cookiecutter.envvar_prefix|upper}}_DIGITALOCEAN_ACCESS_TOKEN --digitalocean-size=${{cookiecutter.envvar_prefix|upper}}_DIGITALOCEAN_SIZE --digitalocean-ipv6=${{cookiecutter.envvar_prefix|upper}}_DIGITALOCEAN_IPV6 --digitalocean-backups=${{cookiecutter.envvar_prefix|upper}}_DIGITALOCEAN_BACKUPS --digitalocean-private-networking=${{cookiecutter.envvar_prefix|upper}}_DIGITALOCEAN_PRIVATE_NET --digitalocean-ssh-key-fingerprint=${{cookiecutter.envvar_prefix|upper}}_DIGITALOCEAN_SSH_KEY_FINGERPRINT"
elif [ "{{cookiecutter.prod_docker_driver}}" = "generic" ]; then
  export {{cookiecutter.envvar_prefix|upper}}_MACHINE_DRIVER="--driver {{cookiecutter.prod_docker_driver}} --generic-ip-address ${{cookiecutter.envvar_prefix|upper}}_PROD_IP --generic-ssh-user ${{cookiecutter.envvar_prefix|upper}}_PROD_USER --generic-ssh-key ${{cookiecutter.envvar_prefix|upper}}_SSH_PRIVATE_KEY"
else
  >&2 echo "Unknown docker driver: ???"
  return 1
fi

unset {{cookiecutter.envvar_prefix|upper}}_DEV

. $(dirname $BASH_SOURCE)/setup-env-common.sh
