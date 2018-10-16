#!/usr/bin/env bash

prog=$0
prog_dir=$(basename ${prog})

PYSPARK=pyspark

echo Starting ${PYSPARK} shell...
exec ${PYSPARK} --packages ch.cern.sparkmeasure:spark-measure_2.11:0.13 "$@"
