#!/usr/bin/env python

import os
import sys
import urllib2

from pylib import base_template, motd_template, run_template
from pylib.ansible import AnsibleEnvironment
from pylib.docker import setup_docker
from pylib.vault import setup_vault

if __name__ == "__main__":
    env = AnsibleEnvironment()

    # setup vault and docker
    try:
        vault_template = setup_vault(env)
        docker_template = setup_docker(env)
    except urllib2.HTTPError as e:
        if e.getcode() == 500:
            print('echo "Vault seems to be having troubles, try to restart it and logout/login again"')
            sys.exit(0)

    # setup our templates
    templates = [
        base_template,
        vault_template,
        docker_template
    ]

    # show MOTD is running a shell
    if os.environ.get('COMMAND').startswith('bash'):
        templates.append(motd_template)

    # run run.sh if it exists
    run_file = os.path.join(
        os.environ.get('PROJECT_ENVIRONMENT_FILES_PATH'), 'run.sh')
    if os.path.exists(run_file):
        templates.append(run_template)

    # print all the templates
    print(env.template(*templates))
