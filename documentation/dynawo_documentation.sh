#!/bin/bash

# Except where otherwise noted, content in this documentation is Copyright (c)
# 2015-2019, RTE (http://www.rte-france.com) and licensed under a
# CC-BY-4.0 (https://creativecommons.org/licenses/by/4.0/)
# license. All rights reserved.

mkdir -p dynawoDocumentation

folders=(introduction installation configuringDynawo functionalDoc advancedDoc)

pdflatex_options="-halt-on-error -interaction=nonstopmode"
output_file=DynawoDocumentation.tex

echo '%% Except where otherwise noted, content in this documentation is Copyright (c)
%% 2015-2020, RTE (http://www.rte-france.com) and licensed under a
%% CC-BY-4.0 (https://creativecommons.org/licenses/by/4.0/)
%% license. All rights reserved.

\documentclass[a4paper, 12pt]{report}
\usepackage{etex}

% Latex setup
\input{../latex_setup.tex}
\usepackage{minitoc}
\usepackage[titletoc]{appendix}
\usepackage{pdfpages}

\begin{document}

\title{\huge{\Dynawo Documentation} \\ \LARGE{v1.8.0} \\
\vspace{10mm}
\includegraphics[width=0.7\textwidth]{../resources/Dynawo-Logo-Color.png}}
\date\today

\maketitle
\dominitoc
\tableofcontents

\listoffigures \mtcaddchapter % Avoid problems with minitoc numbering' > dynawoDocumentation/$output_file

for folder in ${folders[*]}; do
  latex_files=$(find $folder -name "*.tex")
  for file in ${latex_files[*]}; do
    echo $file
    sed -n '/tableofcontents/,/end{document}/p' $file | tail -n +2 | head -n -1 >> dynawoDocumentation/$output_file
  done
done

sed -i '/chapter{/a\\\minitoc' dynawoDocumentation/$output_file
sed -i '/bibliography{/d' dynawoDocumentation/$output_file
sed -i '/bibliographystyle{/d' dynawoDocumentation/$output_file
sed -i '/vspace{0.6cm} % vspace only for DynawoInputFiles standalone doc/d' dynawoDocumentation/$output_file

echo "\bibliography{../resources/dynawoDocumentation}" >> dynawoDocumentation/$output_file
echo "\bibliographystyle{abbrv}" >> dynawoDocumentation/$output_file
echo "" >> dynawoDocumentation/$output_file

echo "\begin{appendices}" >> dynawoDocumentation/$output_file

licenses_folders=(licenses/dynawo licenses/dynawo-documentation licenses/OpenModelica licenses/sundials licenses/suitesparse licenses/Adept licenses/xerces-c licenses/libxml2 licenses/powsybl
licenses/jQuery licenses/cpplint licenses/zmqpp)

# Latex compile
for folder in ${licenses_folders[*]}; do
  latex_files=$(find $folder -name "*.tex")
  for file in ${latex_files[*]}; do
    #echo $(basename $file)
    (cd $folder; sed -i'' '2i\\usepackage{nopageno}\' $(basename $file); pdflatex --jobname=$(basename ${file%.tex})-no-numbering $pdflatex_options $(basename $file))
    sed -i'' '/\usepackage{nopageno}/d' $file
  done
done

license_name=('\Dynawo' '\Dynawo Documentation' 'OpenModelica' 'SUNDIALS' 'SuiteSparse' 'Adept' 'Xerces-C++' 'Libxml2' 'PowSyBl' 'jQuery MIT' 'jQuery GPL' 'cpplint' 'zmqpp')

i=0
j=1
for name in "${license_name[@]}"; do
  echo "\chapter[${name/\\/} License]{$name License}" >> dynawoDocumentation/$output_file
  if [ ! -z "$(echo "$name" | grep jQuery)" ]; then
    echo "\includepdf[pages=-,pagecommand=\thispagestyle{plain}]{../${licenses_folders[$i]}/license-$j-no-numbering.pdf}" >> dynawoDocumentation/$output_file
    if (( $j < 2 )); then
      (( j+=1 ))
    else
      (( i+=1 ))
    fi
  else
    echo "\includepdf[pages=-,pagecommand=\thispagestyle{plain}]{../${licenses_folders[$i]}/license-no-numbering.pdf}" >> dynawoDocumentation/$output_file
    (( i+=1 ))
  fi
  echo "" >> dynawoDocumentation/$output_file
done

echo "\end{appendices}" >> dynawoDocumentation/$output_file

echo "\end{document}" >> dynawoDocumentation/$output_file

(cd dynawoDocumentation; pdflatex $pdflatex_options $output_file; bibtex ${output_file%.tex}; pdflatex $pdflatex_options $output_file; pdflatex $pdflatex_options $output_file)
