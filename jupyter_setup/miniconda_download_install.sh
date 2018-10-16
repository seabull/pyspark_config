#!/usr/bin/env bash

# This is to install miniconda on BR/LR edge nodes or other Linux servers

INSTALL_DIR=${1:-${HOME}/.anaconda}

WORK_DIR=/tmp
#WORK_DIR=${HOME}/temp

#cd ${WORK_DIR}

curl https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda.sh

bash Miniconda.sh -b -p ${INSTALL_DIR}

rm Miniconda.sh
