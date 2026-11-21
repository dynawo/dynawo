#!/bin/bash
#
# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain
# simulation tool for power systems.
#

for file in $(find ../data -name "*.tex"); do
  (cd $(dirname  $file) ; sed -i'' '14i\\usepackage{nopageno}\' $(basename $file) ; pdflatex --jobname=$(basename ${file%.tex})-no-numbering -halt-on-error -interaction=nonstopmode $(basename $file) > /dev/null)
  ret=$?
  sed -i'' '/\usepackage{nopageno}/d' $file
  if [[ $ret > 0 ]]; then
    echo "There was an error compiling a description Latex file: $file"
    echo -e "You need to verify if you have all Latex packages (for example tikz, pgfplots, hyperref...). See ${file%.tex}-no-numbering.log for more information.\n"
    if [ -f ${file%.tex}-no-numbering.log ]; then
      sed -n -e '/\(Error\|Undefined control sequence\)/,$p' ${file%.tex}-no-numbering.log | sed -e '/Here is how much of TeX'\''s memory you used:/,$d'
      tail -1 ${file%.tex}-no-numbering.log
    fi
    exit 1
  fi
done

echo "\documentclass{report}

\usepackage{pdfpages}

\usepackage[hidelinks, linktoc=all]{hyperref}

\begin{document}

\chapter*{Non Regression tests Documentation}

Dynawo Non-Regression Tests documentation.

\tableofcontents
" > nrt_doc.tex

num=0
for file in $(find ../data -name "*-no-numbering.pdf"); do
  title=$(grep chapter ${file%-no-numbering.pdf}.tex | cut -d "{" -f 2 | tr -d '}' | tr -d '"' | tr -d '`')
  echo "\includepdf[pages=-,addtotoc={1,chapter,$num,$title,chap:samplepdfone$num},pagecommand={}]{$file}" >> nrt_doc.tex
  num=$(($num + 1))
done

echo "\end{document}"  >> nrt_doc.tex

pdflatex -halt-on-error -interaction=nonstopmode nrt_doc.tex > /dev/null
ret=$?
if [[ $ret > 0 ]]; then
  echo "There was an error compiling the nrt description file."
  echo -e "You need to verify if you have all Latex packages (pdfpages and hyperref at least...). See nrt_doc.log file.\n"
  if [ -f nrt_doc.log ]; then
    sed -n -e '/\(Error\|Undefined control sequence\)/,$p' nrt_doc.log | sed -e '/Here is how much of TeX'\''s memory you used:/,$d'
    tail -1 nrt_doc.log
  fi
  exit 1
fi
pdflatex -halt-on-error -interaction=nonstopmode nrt_doc.tex > /dev/null
