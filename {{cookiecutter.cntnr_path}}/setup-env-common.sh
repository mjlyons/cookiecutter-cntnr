#!/bin/bash

# THIS FILE IS AUTO-GENERATED WITH COOKIECUTTER. DO NOT MODIFY DIRECTLY, YOU MAY LOSE CHANGES.

set +e

echo "Configuring {{cookiecutter.project_name}} environment..."

fail-abort-msg() {
    echo "FAILURE, ABORTING."
    return 0
}
# RUN THIS COMMAND TO ABORT ON ERROR:
[ "$?" -ne "0" ] && fail-abort-msg && return  # return-on-error

echo "- Check required environment variables"
: "${{"{"}}{{cookiecutter.envvar_prefix|upper}}_MACHINE:?Need to set {{cookiecutter.envvar_prefix|upper}}_MACHINE }"
[ "$?" -ne "0" ] && fail-abort-msg && return  # return-on-error

: "$${{"{"}}{{cookiecutter.envvar_prefix|upper}}_MACHINE_DRIVER:?Need to set {{cookiecutter.envvar_prefix|upper}}_MACHINE_DRIVER }"
[ "$?" -ne "0" ] && fail-abort-msg && return  # return-on-error

: "$${{"{"}}{{cookiecutter.envvar_prefix|upper}}_DOCKER_COMPOSE_OVERRIDE_FILENAME:?Need to set {{cookiecutter.envvar_prefix|upper}}_DOCKER_COMPOSE_OVERRIDE_FILENAME }"
[ "$?" -ne "0" ] && fail-abort-msg && return  # return-on-error


echo "- Define exported constants"
export {{cookiecutter.envvar_prefix|upper}}_ROOT_PATH=$(pwd)
export {{cookiecutter.envvar_prefix|upper}}_ROOT_DOMAIN="{{cookiecutter.root_domain}}"
export {{cookiecutter.envvar_prefix|upper}}_DEV_DOCKER_DRIVER="{{cookiecutter.dev_docker_driver}}"

echo "- Define local constants"
{{cookiecutter.envvar_prefix|lower}}_docker_compose_common_filename="docker-compose-common.yml"
{{cookiecutter.envvar_prefix|lower}}_container_prefix="$(basename `pwd`)_"

echo "- Build paths"
{{cookiecutter.envvar_prefix|lower}}_docker_compose_common_path="${{cookiecutter.envvar_prefix|upper}}_ROOT_PATH/${{cookiecutter.envvar_prefix|lower}}_docker_compose_common_filename"
{{cookiecutter.envvar_prefix|lower}}_docker_compose_override_path="${{cookiecutter.envvar_prefix|upper}}_ROOT_PATH/${{cookiecutter.envvar_prefix|upper}}_DOCKER_COMPOSE_OVERRIDE_FILENAME"

echo "- Creating {{cookiecutter.cmd_prefix}}-machine aliases"
alias {{cookiecutter.cmd_prefix}}-machine-create="docker-machine create ${{cookiecutter.envvar_prefix|upper}}_MACHINE_DRIVER $MACHINE_ENGINE_OPT ${{cookiecutter.envvar_prefix|upper}}_MACHINE"
alias {{cookiecutter.cmd_prefix}}-machine-start="docker-machine start ${{cookiecutter.envvar_prefix|upper}}_MACHINE"
alias {{cookiecutter.cmd_prefix}}-machine-stop="docker-machine stop ${{cookiecutter.envvar_prefix|upper}}_MACHINE"
alias {{cookiecutter.cmd_prefix}}-machine-destroy="docker-machine rm ${{cookiecutter.envvar_prefix|upper}}_MACHINE"
alias {{cookiecutter.cmd_prefix}}-machine-ip="docker-machine ip ${{cookiecutter.envvar_prefix|upper}}_MACHINE"

echo -n "- Check if {{cookiecutter.cmd_prefix}}-machine exists... "
docker-machine ls -q | grep -q "^${{cookiecutter.envvar_prefix|upper}}_MACHINE\$"
is_machine_missing=$?
if [ "$is_machine_missing" -ne "0" ]; then
    echo "machine doesn't exist, creating."
    echo ""
    {{cookiecutter.cmd_prefix}}-machine-create
    [ "$?" -ne "0" ] && fail-abort-msg && return  # return-on-error
    echo ""
else
    echo "machine already exists."
fi

echo -n "- Check if {{cookiecutter.cmd_prefix}}-machine stopped... "
docker_machine_status=$(docker-machine ls | grep "^${{cookiecutter.envvar_prefix|upper}}_MACHINE\s")
if [[ "$docker_machine_status" == *"Stopped"* ]]; then
    echo "machine stopped, so starting it now."
    echo ""
    {{cookiecutter.cmd_prefix}}-machine-start
    [ "$?" -ne "0" ] && fail-abort-msg && return  # return-on-error
    echo ""
elif [[ "$docker_machine_status" == *"Running"* ]]; then
    echo "already started."
else
    fail-abort-msg
    return
fi

echo "- Configure docker-machine environment"
eval $(docker-machine env ${{cookiecutter.envvar_prefix|upper}}_MACHINE)
[ "$?" -ne "0" ] && fail-abort-msg && return  # return-on-error

echo "- Define {{cookiecutter.cmd_prefix}} helper commands"
{{cookiecutter.cmd_prefix}}-run() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: {{cookiecutter.cmd_prefix}}-run container_name command"
        echo "  ...you can find container_name using '{{cookiecutter.cmd_prefix}}-containers'"
    else
        docker exec -it ${{cookiecutter.envvar_prefix|lower}}_container_prefix$1 $2
    fi
}

{{cookiecutter.cmd_prefix}}-term() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: {{cookiecutter.cmd_prefix}}-term container_name"
        echo "  ...you can find container_name using '{{cookiecutter.cmd_prefix}}-containers'"
    else
          {{cookiecutter.cmd_prefix}}-run $1 bash
    fi
}

{{cookiecutter.cmd_prefix}}-volume-rm() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: {{cookiecutter.cmd_prefix}}-term container_name"
        echo "  ...you can find container_name using '{{cookiecutter.cmd_prefix}}-containers'"
    else
          docker volume rm ${{cookiecutter.envvar_prefix|lower}}_container_prefix$1
    fi
}

{{cookiecutter.cmd_prefix}}-machine-host-add() {
  # clear existing docker.local entry from /etc/hosts
  # Called by itself, will add entry for root domain (ex: dev.clearhive.com)
  # For subdomains, use subdomain. as parameter:
  # ex: `ch-machine-host www.` would add an entry for www.dev.clearhive.com

  rootdomain={{cookiecutter.root_domain}}
  subdomain=$1
  fqdn="$subdomain$rootdomain"

  echo "Adding hostname: $fqdn"

  domain_regex=$(echo "/[[:space:]]$fqdn\$/d" | sed 's/\./\\\./g')
  sudo sed -i '' "$domain_regex" /etc/hosts

  # get ip of running machine
  host_ip="$({{cookiecutter.cmd_prefix}}-machine-ip)"

  # update /etc/hosts with docker machine ip
  [[ -n $host_ip ]] && sudo /bin/bash -c "echo \"$host_ip $fqdn\" >> /etc/hosts"
}

declare -a subdomains=()
# Run this command later to add subdomains:
#   `declare -a subdomains=("www." "mta.")`
{{cookiecutter.cmd_prefix}}-machine-host() {
    {{cookiecutter.cmd_prefix}}-machine-host-add
    for subdomain in ${subdomains[@]}; do
        {{cookiecutter.cmd_prefix}}-machine-host-add "$subdomain"
    done
}

{{cookiecutter.cmd_prefix}}-copy-into() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: {{cookiecutter.cmd_prefix}}-copy-into container_name host_path container_path"
        echo "  ...you can find container_name using 'ch-containers'"
    else
        docker container cp $2 ${{cookiecutter.envvar_prefix|lower}}_container_prefix$1:$3
    fi
}

{{cookiecutter.cmd_prefix}}-copy-out() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: {{cookiecutter.cmd_prefix}}-copy-out container_name container_path host_path"
        echo "  ...you can find container_name using '{{cookiecutter.cmd_prefix}}-containers'"
    else
        docker container cp ${{cookiecutter.envvar_prefix|lower}}_container_prefix$1:$2 $3
    fi
}

alias {{cookiecutter.cmd_prefix}}="docker-compose -f ${{cookiecutter.envvar_prefix|lower}}_docker_compose_common_path -f ${{cookiecutter.envvar_prefix|upper}}_DOCKER_COMPOSE_OVERRIDE_FILENAME"
alias {{cookiecutter.cmd_prefix}}-build="{{cookiecutter.cmd_prefix}} build"
alias {{cookiecutter.cmd_prefix}}-up="{{cookiecutter.cmd_prefix}} up -d"
alias {{cookiecutter.cmd_prefix}}-down="{{cookiecutter.cmd_prefix}} down"
alias {{cookiecutter.cmd_prefix}}-restart="{{cookiecutter.cmd_prefix}}-down && {{cookiecutter.cmd_prefix}}-build && {{cookiecutter.cmd_prefix}}-up"
alias {{cookiecutter.cmd_prefix}}-logs="{{cookiecutter.cmd_prefix}} logs"
alias {{cookiecutter.cmd_prefix}}-containers="docker ps --format "{{"{{"}}.Names{{"}}"}}" | grep "${{cookiecutter.envvar_prefix|lower}}_container_prefix" | sed s/${{cookiecutter.envvar_prefix|lower}}_container_prefix//"
alias {{cookiecutter.cmd_prefix}}-volume-ls="docker volume ls --quiet --filter name=${{cookiecutter.envvar_prefix|lower}}_container_prefix | sed s/${{cookiecutter.envvar_prefix|lower}}_container_prefix//"

echo "- Sourcing custom post-config script: {{cookiecutter.common_post_config_script}}"
source {{cookiecutter.common_post_config_script}}

echo "√ {{cookiecutter.project_name}} environment configured!"
