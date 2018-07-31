#!/bin/bash

virtualenv my_env
. my_env/bin/activate
pip install molecule ansible docker-py

molecule init role -r httpd -d docker
cd httpd
molecule test
