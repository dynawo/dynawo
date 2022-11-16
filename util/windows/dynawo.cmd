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
  setlocal

  :: setup a default browser in case we fail
  set default_browser=C:\Program Files\Internet Explorer\iexplore.exe

  :: look in the HKEY_CLASSES_ROOT\htmlfile\shell\open\command registry for the default browser
  for /f "tokens=*" %%a in ('REG QUERY HKEY_CLASSES_ROOT\htmlfile\shell\open\command /ve ^| FIND /i "default"') do (
    set input=%%a
  )
  setlocal enableDelayedExpansion

  :: parse the input field looking for the second token
  for /f tokens^=^2^ eol^=^"^ delims^=^" %%a in ("!input!") do set DYNAWO_BROWSER=%%a

  setlocal disableDelayedExpansion

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

if /I "%~1"=="jobs" (
  "%DYNAWO_INSTALL_DIR%"bin\dynawo %2
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

PATH=%oldpath%

exit /B %ERRORLEVEL%

setlocal

:dynawo_help
echo Usage: %~n0 ^<option^>
echo.
echo   where option is:
echo     jobs ^<jobs-file^>                 launch Dynawo simulation
echo     jobs-with-curves ^<jobs-file^>     launch Dynawo simulation and open resulting curves in a browser
echo     version                            show dynawo version
echo     help                               show this message
exit /B 0

endlocal
