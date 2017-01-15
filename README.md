# cookiecutter-cntnr

`cookiecutter-cntnr` adds some commands that make it easier to:

1. Develop on a docker-compose system
2. Deploy it to production

## Who should use cookiecutter-cntnr?

cookiecutter-cntnr is useful for a couple audiences:

1. **you**: Manage your development environment and deploy to prod with easy to use (and autocomplete-friendly) commands.
2. **project collaborators**: Your collaborators don't need to understand the ins and outs of docker and docker-compose to get up and running quickly.

## What commands do you get?

Note that CMD will be whatever you pick for `cmd_prefix`. Here's the most commonly used ones:

* `CMD`: Alias for `docker` customized for your project.
* `CMD-machine-start`: Starts the docker-machine. It'll create the machine if it doesn't exist yet.
* `CMD-machine-ip`: Returns the IP of your machine is.
* `CMD-machine-host`: Points your FQDN to your machine's IP in /etc/hosts.
* `CMD-machine-stop`: Stops the docker-machine.
* `CMD-restart`: Stops all containers, rebuilds them, and starts them back up.
* `CMD-logs`: Shows the latest logs from all containers. Use `CMD-logs -f` to show new logs as they happen.
* `CMD-containers`: Shows a list of the running containers.
* `CMD-run CONTAINER COMMAND`: Runs a command on the container. 
* `CMD-term CONTAINER`: Opens a terminal on the container.
* `CMD-volume-ls`: Lists named volumes for your project.
* `CMD-volume-rm VOLUME`: Removes a named volume for your project.

## How does it work?

cookiecutter-cntnr is a template applied with `cookiecutter`. This lets you specify a few paramemters, and the scripts will be customized for your project.

You'll still need to write docker-compose configurations and implement docker containers. cookiecutter-cntnr makes it easier to use the containers.

## Using cookiecutter-cntnr

One-time setup:

1. [Install cookiecutter](https://cookiecutter.readthedocs.io/en/latest/installation.html)

2. Generate your version of cookiecutter-cntnr: `cookiecutter gh:mjlyons/cookiecutter-cntnr`

3. Cookiecutter will ask you to provide a few settings to populate the template.

Each time you open a new terminal:

1. Source the setup script (the locations will be different if you don't use the default location):
    * For development: `source scripts/cntnr/setup-env-dev.sh`
    * For production: `source scripts/cntnr/setup-env-prod.sh`

2. Use the comamnds!

## Template parameters:

* `cntnr_path`: Location to store the cntnr scripts
* `project_name`: Friendly name of your project
* `project_root_path`: Absolute path to root of your project.
* `cmd_prefix`: Start of all commands (what CMD is replaced with).
* `envvar_prefix`: All environment variables are prefixed with this.
* `machine_prefix`: Name all docker-machines start with.
* `bridge_ip_cidr`: IP range that can be used for network bridge between docker-machine and physical machine.
* `dev_docker_driver`: Docker driver used for development. Common settings include `vmwarefusion` or `virtualbox`.
* `prod_docker_driver`: Docker driver used for production. Only `generic` is supported.
* `fqdn`: Full domain name of machine (example: `example.org`)
* `prod_ssh_private_key_path`: Absolute path of SSH private key used to push to production.
* `prod_user`: SSH user on production for users.
* `common_post_config_script`: command to execute once config is done. `:` by default (no-op).

## Assumptions

cookiecutter-cntnr assumes you use a few docker-compose configuration files in your project root:

* `docker-compose-common.yml`: Base configuration used by development and production.
* `docker-compose-dev.yml`: Development-only overrides.
* `docker-compose-prod.yml`: Production-only overrides.

Also note cookiecutter-cntnr asusmes you're using the `generic` (SSH) driver for production deployemnt.

## License

cookiecutter-cntnr is released under the MIT License. See `LICENSE` in this repository for full info.

