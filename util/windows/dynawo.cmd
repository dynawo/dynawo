@echo off

:: Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
:: See AUTHORS.txt
:: All rights reserved.
:: This Source Code Form is subject to the terms of the Mozilla Public
:: License, v. 2.0. If a copy of the MPL was not distributed with this
:: file, you can obtain one at http://mozilla.org/MPL/2.0/.
:: SPDX-License-Identifier: MPL-2.0
::
:: This file is part of Dynawo, an hybrid C++/Modelica open source time domain
:: simulation tool for power systems.

setlocal enableDelayedExpansion

if /i "%~1"=="VERBOSE" (
  set _verbose=true
)

if not defined DYNAWO_HOME (
  if exist "%~dp0..\..\util\windows\%~nx0" (
    set DYNAWO_HOME=%~dp0..\..
  ) else (
    if exist "%~dp0..\dynawo\util\windows\%~nx0" (
      set DYNAWO_HOME=%~dp0..\dynawo
    ) else (
      if exist "%~dp0..\..\dynawo\util\windows\%~nx0" (
        set DYNAWO_HOME=%~dp0..\..\dynawo
      )
    )
  )
)
for %%G in ("%DYNAWO_HOME%") do set DYNAWO_HOME=%%~fG
if defined _verbose echo info: using DYNAWO_HOME=%DYNAWO_HOME% 1>&2

endlocal
exit /B 1

set DYNAWO_INSTALL_DIR=%~DP0

:: Dynawo environment variables for runtime
set DYNAWO_DDB_DIR=%DYNAWO_INSTALL_DIR%ddb
set DYNAWO_DICTIONARIES=dictionaries_mapping
set DYNAWO_LOCALE=en_GB
set DYNAWO_RESOURCES_DIR=%DYNAWO_INSTALL_DIR%share\
set DYNAWO_SCRIPTS_DIR=%DYNAWO_INSTALL_DIR%sbin
set DYNAWO_USE_XSD_VALIDATION=true
set DYNAWO_XSD_DIR=%DYNAWO_RESOURCES_DIR%xsd\

set LIBIIDM_HOME=%DYNAWO_INSTALL_DIR%
set IIDM_XML_XSD_PATH=%LIBIIDM_HOME%\share\iidm\xsd\

set DYNAWO_LIBIIDM_EXTENSIONS=%LIBIIDM_HOME%\bin

set OPENMODELICA_HOME=%DYNAWO_INSTALL_DIR%OpenModelica

if not defined DYNAWO_PYTHON_COMMAND (
  set DYNAWO_PYTHON_COMMAND=python
)

if not defined DYNAWO_BROWSER (
  :: setup a default browser in case we fail
  set default_browser=C:\Program Files\Internet Explorer\iexplore.exe

  :: look in the HKEY_CLASSES_ROOT\htmlfile\shell\open\command registry for the default browser
  for /f "tokens=*" %%a in ('REG QUERY HKEY_CLASSES_ROOT\htmlfile\shell\open\command /ve ^| FIND /i "default"') do (
    set input=%%a
  )

  :: parse the input field looking for the second token
  for /f tokens^=^2^ eol^=^"^ delims^=^" %%a in ("!input!") do set DYNAWO_BROWSER=%%a

  :: this may not be needed, check if reg returned a real file, if not unset browser
  if not "%DYNAWO_BROWSER%" == "" if not exist "%DYNAWO_BROWSER%" set DYNAWO_BROWSER=
  if "%DYNAWO_BROWSER%"=="" set "DYNAWO_BROWSER=%default_browser%"
  endlocal
)

set oldpath=%path%

PATH=%OPENMODELICA_HOME%\bin;%DYNAWO_INSTALL_DIR%ddb;%DYNAWO_INSTALL_DIR%bin;%PATH%

:: To compile Modelica models
set DYNAWO_ADEPT_INSTALL_DIR=%DYNAWO_INSTALL_DIR%
set DYNAWO_INSTALL_OPENMODELICA=%OPENMODELICA_HOME%
set DYNAWO_XERCESC_INSTALL_DIR=%DYNAWO_INSTALL_DIR%
set DYNAWO_SUITESPARSE_INSTALL_DIR=%DYNAWO_INSTALL_DIR%
set DYNAWO_SUNDIALS_INSTALL_DIR=%DYNAWO_INSTALL_DIR%
set DYNAWO_LIBXML_HOME=%DYNAWO_INSTALL_DIR%
set DYNAWO_BOOST_HOME=%DYNAWO_INSTALL_DIR%

set "pathCurves=%~dp2"
set tmpVar=%pathCurves%outputs\curves\curvesOutput\curves.html
for %%i in ("%tmpVar%") do set "curvesHtml=%%~fi"

if /I "%~1"=="build" (
  set DYNAWO_HOME=%~dp0..\..
  if not defined OPENMODELICA_INSTALL (
    set OPENMODELICA_INSTALL=!DYNAWO_HOME!\..\OpenModelica\Install
  )
  if not defined OPENMODELICA_SRC (
    set OPENMODELICA_SRC=!DYNAWO_HOME!\..\OpenModelica\Source
  )
  if not defined OMDEV_HOME (
    set OMDEV_HOME=!DYNAWO_HOME!\..\OMDev
  )
  cmake -S dynawo/3rdParty -B !DYNAWO_HOME!\..\b-3-p -DCMAKE_INSTALL_PREFIX=!DYNAWO_HOME!\..\d-3-p -DOPENMODELICA_INSTALL=!OPENMODELICA_INSTALL! -DOPENMODELICA_SRC=!OPENMODELICA_SRC! -DOMDEV_HOME=!OMDEV_HOME! -G "NMake Makefiles" || echo Error with 3rd parties configuration. && exit /B 0
  cmake --build !DYNAWO_HOME!\..\b-3-p || echo Error during 3rd parties installation. && exit /B 0
  cmake -S dynawo -B !DYNAWO_HOME!\..\b -DCMAKE_INSTALL_PREFIX=!DYNAWO_HOME!\..\d-i -DDYNAWO_HOME=!DYNAWO_HOME! -DINSTALL_OPENMODELICA=!OPENMODELICA_INSTALL! -DDYNAWO_THIRD_PARTY_DIR=!DYNAWO_HOME!\..\d-3-p -G "NMake Makefiles" || echo Error during Dynawo configuration. && exit /B 0
  cmake --build !DYNAWO_HOME!\..\b --target install || echo Error during Dynawo installation. && exit /B 0
  cmake --build !DYNAWO_HOME!\..\b --target models || echo Error during build models. && exit /B 0
  cmake --build !DYNAWO_HOME!\..\b --target solvers || echo Error during build solvers. && exit /B 0
) else (
  if /I "%~1"=="jobs" (
    "%DYNAWO_INSTALL_DIR%"bin\dynawo %2
  ) else (
    if /I "%~1"=="generate-preassembled" (
      for /f "tokens=1,* delims= " %%a in ("%*") do set GENERATE_PREASSEMBLED_ARGS=%%b
      "%DYNAWO_INSTALL_DIR%"sbin\generate-preassembled.exe !GENERATE_PREASSEMBLED_ARGS!
    ) else (
      if /I "%~1"=="jobs-with-curves" (
        "%DYNAWO_INSTALL_DIR%"bin\dynawo %2
        "%DYNAWO_PYTHON_COMMAND%" "%DYNAWO_INSTALL_DIR%\sbin\curvesToHtml\curvesToHtml.py" --jobsFile=%2 --withoutOffset --htmlBrowser="%DYNAWO_BROWSER%"
        "%DYNAWO_BROWSER%" "%curvesHtml%"
        echo.
        echo Open %curvesHtml% with your browser if it does not do it automatically.
        echo.
      ) else (
        if /I "%~1"=="version" (
          "%DYNAWO_INSTALL_DIR%"bin\dynawo --version
        ) else (
          if /I "%~1"=="help" (
            call :dynawo_help
          ) else (
            call :dynawo_help
          )
        )
      )
    )
  )
)

PATH=%oldpath%

exit /B %ERRORLEVEL%

:dynawo_help
echo Usage: %~n0 ^<option^>
echo.
echo   where option is:
echo     build                            Build and install Dynawo
echo     jobs ^<jobs-file^>                 launch Dynawo simulation
echo     jobs-with-curves ^<jobs-file^>     launch Dynawo simulation and open resulting curves in a browser
echo     generate-preassembled ^<options^>  generate a preassembled model (.dll) from a model description (.xml)
echo     version                          show dynawo version
echo     help                             show this message
exit /B 0
