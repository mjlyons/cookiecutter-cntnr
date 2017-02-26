#!/bin/bash

# THIS FILE IS AUTO-GENERATED WITH COOKIECUTTER. DO NOT MODIFY DIRECTLY, YOU MAY LOSE CHANGES.

export {{cookiecutter.envvar_prefix|upper}}_ROOT_DOMAIN="{{cookiecutter.root_domain}}"
export {{cookiecutter.envvar_prefix|upper}}_PROD_USER="{{cookiecutter.prod_user}}"
export {{cookiecutter.envvar_prefix|upper}}_SSH_PRIVATE_KEY="{{cookiecutter.prod_ssh_private_key_path}}"

export {{cookiecutter.envvar_prefix|upper}}_PROD_IP="$(dig +tcp +short ${{cookiecutter.envvar_prefix|upper}}_ROOT_DOMAIN | grep -E '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' )"
export {{cookiecutter.envvar_prefix|upper}}_MACHINE="{{cookiecutter.machine_prefix}}-prod"
export {{cookiecutter.envvar_prefix|upper}}_MACHINE_DRIVER="--driver {{cookiecutter.prod_docker_driver}} --generic-ip-address ${{cookiecutter.envvar_prefix|upper}}_PROD_IP --generic-ssh-user ${{cookiecutter.envvar_prefix|upper}}_PROD_USER --generic-ssh-key ${{cookiecutter.envvar_prefix|upper}}_SSH_PRIVATE_KEY"
export {{cookiecutter.envvar_prefix|upper}}_DOCKER_COMPOSE_OVERRIDE_FILENAME="docker-compose-production.yml"
export {{cookiecutter.envvar_prefix|upper}}_MACHINE_ENGINE_OPT="--engine-opt=\"bip={{cookiecutter.bridge_ip_cidr}}\""

unset {{cookiecutter.envvar_prefix|upper}}_DEV

. $(dirname $BASH_SOURCE)/setup-env-common.sh
