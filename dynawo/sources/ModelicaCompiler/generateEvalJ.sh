#!/bin/bash

create_evalJ() {
  path=$1
  filename=$2
  model_name=$3
  model_type=$4

  if ! [ -v DYNAWO_INSTALL_DIR ]; then
    echo "DYNAWO_INSTALL_DIR environment variable should be defined."
    exit 1
  fi

  perl ${DYNAWO_INSTALL_DIR}/sbin/remove_comments.pl ${path}/${filename}_${model_type}.cpp > ${path}/${filename}_${model_type}.nocomment.cpp

  ${DYNAWO_PYTHON_COMMAND} ${DYNAWO_INSTALL_DIR}/sbin/extractEvalFAdept.py ${path}/${filename}_${model_type}.nocomment.cpp ${model_name} ${model_type}

  ${DYNAWO_PYTHON_COMMAND} ${DYNAWO_INSTALL_DIR}/sbin/computeJacobian.py ${path}/${filename}_${model_type}.nocomment.in.cpp ${model_name} ${model_type}
}

path=$1
filename=$2
model_name=$3
withInit=$4

model_type="Dyn"

create_evalJ ${path} ${filename} ${model_name} ${model_type}

if [ "$withInit" = "true" ]; then
  model_type="Init"
  create_evalJ ${path} ${filename} ${model_name} ${model_type}
fi
