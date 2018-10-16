#!/usr/bin/env bash

###############################################################
# This script installs jupyter notebook and create profile to 
# integrate with pyspark on cluster edge nodes
###############################################################

CONDA_HOME=${CONDA_HOME:-${HOME}/.anaconda}
PYSPARK_JUPYTER_PROFILE=${HOME}/.pyspark_jupyter_profile
#PORT_NUM=${1:-5555}

MY_ID=$(whoami)

${CONDA_HOME}/bin/conda install -y jupyter

echo jupyter notebook has been installed and available using the following command
echo ------------------------------------------------------------------------
echo $HOME/.anaconda/bin/jupyter notebook --no-browser --ip='*' --port=5432
echo ------------------------------------------------------------------------

# Moved to a seperate file
#
## pyspark integration
#
#if [ ! -e "${PYSPARK_JUPYTER_PROFILE}" ]; then
#    cat  << __END_OF_CONFIG__ > "${PYSPARK_JUPYTER_PROFILE}" 
#export PYSPARK_PYTHON="$HOME/.anaconda/bin/python"
#export PYSPARK_DRIVER_PYTHON="$HOME/.anaconda/bin/jupyter"
#export PYSPARK_DRIVER_PYTHON_OPTS="notebook --no-browser --port=${PORT_NUM} --ip='*'"
#__END_OF_CONFIG__
#else
#    echo "${PYSPARK_JUPYTER_PROFILE}" exists, not creating new one
#fi
#
#echo Use the following command to start on your local laptop
#echo ssh -tL ${PORT_NUM}:localhost:${PORT_NUM} ${MY_ID}@edge.cluster \'source $HOME/.pyspark_jupyter_profile \&\& pyspark\'
#echo ssh -tL ${PORT_NUM}:localhost:${PORT_NUM} ${MY_ID}@edge.cluster \'source $HOME/.pyspark_jupyter_profile \&\& pyspark\'
