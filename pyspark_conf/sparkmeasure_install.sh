#!/usr/bin/env bash

# This is to install sparkmeasure on BR/LR edge nodes or other Linux servers

CONDA_HOME=${1:-${HOME}/.anaconda}
PIP=${CONDA_HOME}/bin/pip 

PYSPARK=pyspark


${PIP} install sparkmeasure

echo run pyspark shell with the package
echo ${PYSPARK} --packages ch.cern.sparkmeasure:spark-measure_2.11:0.13

echo << __END_OF_EXAMPLE__
from sparkmeasure import StageMetrics
stagemetrics = StageMetrics(spark)

stagemetrics.begin()
spark.sql("select count(*) from range(1000) cross join range(1000) cross join range(1000)").show()
stagemetrics.end()
stagemetrics.print_report()
# optionally run also this:
stagemetrics.print_accumulables()
__END_OF_EXAMPLE__
