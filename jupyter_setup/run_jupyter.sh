#!/usr/bin/env bash

####################################################
# This script runs on the BR/LR edge nodes
####################################################

PORT_NUM=${1:-7777}

if [ "${PORT_NUM}" == "${1}" ]; then
    shift
fi

export PYSPARK_PYTHON="${HOME}/.anaconda/bin/python"
export PYSPARK_DRIVER_PYTHON="${HOME}/.anaconda/bin/jupyter"
export PYSPARK_DRIVER_PYTHON_OPTS="notebook --no-browser --port=${PORT_NUM} --ip='*'"

exec pyspark "$@"
