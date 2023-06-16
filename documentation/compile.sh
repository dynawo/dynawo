#!/bin/bash

# Except where otherwise noted, content in this documentation is Copyright (c)
# 2015-2019, RTE (http://www.rte-france.com) and licensed under a
# CC-BY-4.0 (https://creativecommons.org/licenses/by/4.0/)
# license. All rights reserved.

folders=(configuringDynawo functionalDoc installation introduction advancedDoc
licenses/Adept licenses/OpenModelica licenses/cpplint licenses/dynawo
licenses/dynawo-documentation licenses/jQuery licenses/suitesparse licenses/sundials licenses/libxml2 licenses/powsybl)
pdflatex_options="-halt-on-error -interaction=nonstopmode"

for folder in ${folders[*]}; do
  latex_files=$(find $folder -name "*.tex")
  for file in ${latex_files[*]}; do
    (cd $folder; pdflatex $pdflatex_options $(basename $file))
    if [ ! -z "$(grep bibliography $file)" ]; then
      (cd $folder; bibtex $(basename ${file%.tex}); pdflatex $pdflatex_options $(basename $file); pdflatex $pdflatex_options $(basename $file))
    else
      (cd $folder; pdflatex $pdflatex_options $(basename $file))
    fi
  done
done
