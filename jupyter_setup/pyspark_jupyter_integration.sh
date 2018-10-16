#!/usr/bin/env bash

###############################################################
# This script create profile to integrate with pyspark on edge nodes
###############################################################

PORT_NUM=${1:-5555}

CONDA_HOME=${HOME}/.anaconda
PYSPARK_JUPYTER_PROFILE=${HOME}/.pyspark_jupyter_profile
JUPYTER_NOTEBOOK_CONF_DIR=${HOME}/.jupyter
JUPYTER_NOTEBOOK_CONF_FILE=${JUPYTER_NOTEBOOK_CONF_DIR}/jupyter_notebook_config.py

MY_ID=$(whoami)

#echo jupyter notebook could be started using the following command
#echo ------------------------------------------------------------------------
#echo $HOME/.anaconda/bin/jupyter notebook --no-browser --ip='*' --port=5432
#echo ------------------------------------------------------------------------

echo Using port ${PORT_NUM} for jupyter notebook

# pyspark integration

if [ ! -e "${PYSPARK_JUPYTER_PROFILE}" ]; then
    echo Creating pyspark profile file "${PYSPARK_JUPYTER_PROFILE}" to define environemnt variables...
    cat  << __END_OF_CONFIG__ > "${PYSPARK_JUPYTER_PROFILE}" 
export PYSPARK_PYTHON="$HOME/.anaconda/bin/python"
export PYSPARK_DRIVER_PYTHON="$HOME/.anaconda/bin/jupyter"
export PYSPARK_DRIVER_PYTHON_OPTS="notebook --no-browser --port=${PORT_NUM} --ip='*'"
__END_OF_CONFIG__
else
    echo "${PYSPARK_JUPYTER_PROFILE}" exists, not creating new one
fi

# fix remote access issue

if [ ! -d "${JUPYTER_NOTEBOOK_CONF_DIR}" ]; then
    echo Creating jupyter config directory "${JUPYTER_NOTEBOOK_CONF_DIR}"
    mkdir -p "${JUPYTER_NOTEBOOK_CONF_DIR}"
fi

if [ ! -e "${JUPYTER_NOTEBOOK_CONF_FILE}" ]; then
    echo Creating jupyter config file "${JUPYTER_NOTEBOOK_CONF_FILE}"
    cat << __END_OF_JUPYTER_CONF__ > "${JUPYTER_NOTEBOOK_CONF_FILE}"
c.NotebookApp.allow_remote_access = True
__END_OF_JUPYTER_CONF__ 
fi

echo Use the following command to start on your local laptop
echo ssh -tL ${PORT_NUM}:localhost:${PORT_NUM} ${MY_ID}@edge.cluster \'source $HOME/.pyspark_jupyter_profile \&\& pyspark\'
echo ssh -tL ${PORT_NUM}:localhost:${PORT_NUM} ${MY_ID}@edge.cluster \'source $HOME/.pyspark_jupyter_profile \&\& pyspark\'

