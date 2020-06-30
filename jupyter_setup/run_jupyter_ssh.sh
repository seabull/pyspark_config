#!/usr/bin/env bash

prog=$0
prog_name=$(basename $0)
MY_ID=$(whoami)

RUN_ENV=${1:-prd}
REMOTE_WORKDIR=${2:-\$HOME}
SSH_USER=${3:-${MY_ID}}
PORT_NUM=${4:-7777}

usage() {
    cat << __EOF_USAGE__
${prog_name} [run_env] [remote work dir] [ssh user] [port] [pyspark argument]

DESCRIPTION:
    start jupyter from Hadoop edge server (ssh into the remote server)
PARAMETERS:
    run_env         : stg or prd, default prd
    remote work dir : working directory on the remote host, default user home dir
    ssh user        : user ID to ssh to remote, default current user
    port            : jupyter port number, default 7777
    pyspark argument: arguments passed on to pyspark shell

Examples:
    1. Start Jupyter on BR edge node, using user's home dir as the working dir
        ${prog_name}
    2. Start Jupyter in ~/my_notebooks 
        ${prog_name} prd my_notebooks
    3. Start Jupyter with a different user
        ${prog_name} prd my_notebooks svnuaid

__EOF_USAGE__
}

if [ "x${RUN_ENV}" == "x-h" -o "x${RUN_ENV}" == "xhelp" ]; then
    usage
    exit
fi

if [ "${RUN_ENV}" == "${1}" ]; then
    shift
fi

if [ "${REMOTE_WORKDIR}" == "${1}" ]; then
    shift
fi

if [ "${SSH_USER}" == "${1}" ]; then
    shift
fi

if [ "${PORT_NUM}" == "${1}" ]; then
    shift
fi

if [ "x${RUN_ENV}" == "xstg" ]; then
    echo connecting to hadoop...
    REMOTE_HOST=edge.hadoopcluster
else
    echo connecting to hadoop...
    REMOTE_HOST=edge.hadoopcluster
fi

#ssh -tL ${PORT_NUM}:localhost:${PORT_NUM} ${SSH_USER}@${REMOTE_HOST} \'source \$HOME/.pyspark_jupyter_profile \&\& pwd \&\& cd \"${REMOTE_WORKDIR}\"\; pwd \; pyspark "$@"\'

#################################################################################
#
# The keytab file needs to be created on the edge server in ${HOME}/config/USERID 
# e.g. ~/config/z013lgl
# on LR/BR edge node, use the following command
#
# mkdir ${HOME}/config && chmod 600 ${HOME}/config
# generate-keytab ${HOME}/config/$(whoami) $(whoami)@CORP.ABC.COM
#
#################################################################################

ssh -tL ${PORT_NUM}:localhost:${PORT_NUM} ${SSH_USER}@${REMOTE_HOST} <<- __END_OF_SSH__
    source .pyspark_jupyter_profile
    KERB_REALM=CORP.ABC.COM
    ME=\$(whoami)
    kinit -kt config/\${ME} \${ME}@\${KERB_REALM}
    cd ${REMOTE_WORKDIR}
    pwd
    pyspark $@
__END_OF_SSH__


#
# $ ktutil
#   ktutil: addent -password -p <USER>@CORP.ABC.COM -k 1 -e aes256-cts-hmac-sha1-96
#   ktutil: wkt .keytab
#   ktutil: q
#

#
# Use the following command to stop any orphaned jupyter servers
# echo ~/.anaconda/bin/jupyter notebook list
# echo ~/.anaconda/bin/jupyter notebook stop <port>
#
# echo ~/.anaconda/bin/jupyter notebook stop 7777
