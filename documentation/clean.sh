#!/bin/bash

# Except where otherwise noted, content in this documentation is Copyright (c)
# 2015-2019, RTE (http://www.rte-france.com) and licensed under a
# CC-BY-4.0 (https://creativecommons.org/licenses/by/4.0/)
# license. All rights reserved.

folders=(configuringDynawo functionalDoc installation introduction advancedDoc dynawoDocumentation
licenses/Adept licenses/OpenModelica licenses/cpplint licenses/dynawo licenses/dynawo-documentation
licenses/jQuery licenses/suitesparse licenses/sundials)

for folder in ${folders[*]}; do
  if [ -d "$folder" ]; then
    (cd $folder; rm -f *.toc *.aux *.bbl *.blg *.log *.out *.pdf *.gz *.mtc* *.maf *.lof)
  fi
done

rm -f dynawoDocumentation/DynawoDocumentation.tex
