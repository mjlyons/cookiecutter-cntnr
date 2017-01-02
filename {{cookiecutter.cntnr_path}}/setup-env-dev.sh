#!/bin/bash

# THIS FILE IS AUTO-GENERATED WITH COOKIECUTTER. DO NOT MODIFY DIRECTLY, YOU MAY LOSE CHANGES.

set -e

export {{cookiecutter.envvar_prefix|upper}}_MACHINE="{{cookiecutter.machine_prefix}}-dev"
export {{cookiecutter.envvar_prefix|upper}}_MACHINE_DRIVER="--driver {{cookiecutter.dev_docker_driver}}"
export {{cookiecutter.envvar_prefix|upper}}_DOCKER_COMPOSE_OVERRIDE_FILENAME="docker-compose-dev.yml"
export {{cookiecutter.envvar_prefix|upper}}_ENGINE_OPT="--engine-opt=\"bip={{cookiecutter.bridge_ip_cidr}}\""

. $(dirname $BASH_SOURCE)/setup-env-common.sh
