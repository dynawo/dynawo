@echo off

:: Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
:: See AUTHORS.txt
:: All rights reserved.
:: This Source Code Form is subject to the terms of the Mozilla Public
:: License, v. 2.0. If a copy of the MPL was not distributed with this
:: file, you can obtain one at http://mozilla.org/MPL/2.0/.
:: SPDX-License-Identifier: MPL-2.0
::
:: This file is part of Dynawo, a hybrid C++/Modelica open source time domain
:: simulation tool for power systems.

if not "%~3"=="" if "%~4"=="" goto begin_script
echo This script requires the 3 parameters:
echo - Dynawo install path
echo - Third Parties install path
echo - OpenModelica install path
goto :EOF

:begin_script

set DYNAWO_INSTALL_DIR_arg=%1
set thirdPartyInstallPath_arg=%2
set OPENMODELICA_HOME_arg=%3

for %%i in ("%DYNAWO_INSTALL_DIR_arg%") do set "DYNAWO_INSTALL_DIR=%%~fi"
for %%i in ("%thirdPartyInstallPath_arg%") do set "thirdPartyInstallPath=%%~fi"
for %%i in ("%OPENMODELICA_HOME_arg%") do set "OPENMODELICA_HOME=%%~fi"

set script_dir=%~DP0
set deploy_dir=%script_dir%..\..\deploy\dynawo
set dynawo_source_dir=%~DP0..\..

for %%i in ("%deploy_dir%") do set "deploy_dir_abs=%%~fi"
for %%i in ("%dynawo_source_dir%") do set "dynawo_source_dir_abs=%%~fi"

if exist %deploy_dir% rd /s /q %deploy_dir%
md %deploy_dir%

:: Dynawo
xcopy %DYNAWO_INSTALL_DIR%\bin %deploy_dir%\bin /E /i
xcopy %DYNAWO_INSTALL_DIR%\include %deploy_dir%\include /E /i
xcopy %DYNAWO_INSTALL_DIR%\ddb %deploy_dir%\ddb /E /i
xcopy %DYNAWO_INSTALL_DIR%\share %deploy_dir%\share /E /i

xcopy %DYNAWO_INSTALL_DIR%\sbin\*.py %deploy_dir%\sbin /i
xcopy %DYNAWO_INSTALL_DIR%\sbin\compileCppModelicaModelInDynamicLib.cmake %deploy_dir%\sbin /i
xcopy %DYNAWO_INSTALL_DIR%\sbin\PreloadCache.cmake %deploy_dir%\sbin /i
xcopy %DYNAWO_INSTALL_DIR%\sbin\compileModelicaModel* %deploy_dir%\sbin /i
xcopy %DYNAWO_INSTALL_DIR%\sbin\dumpModel* %deploy_dir%\sbin /i
xcopy %DYNAWO_INSTALL_DIR%\sbin\generate-preassembled* %deploy_dir%\sbin /i
xcopy %DYNAWO_INSTALL_DIR%\sbin\dumpSolver* %deploy_dir%\sbin /i

xcopy %dynawo_source_dir%\util\curvesToHtml\*.py %deploy_dir%\sbin\curvesToHtml /i
xcopy %dynawo_source_dir%\util\curvesToHtml\resources %deploy_dir%\sbin\curvesToHtml\resources /i
xcopy %dynawo_source_dir%\util\curvesToHtml\csvToHtml\*.py %deploy_dir%\sbin\curvesToHtml\csvToHtml /i
xcopy %dynawo_source_dir%\util\curvesToHtml\xmlToHtml\*.py %deploy_dir%\sbin\curvesToHtml\xmlToHtml /i

xcopy %dynawo_source_dir%\util\nrt_diff\*.py %deploy_dir%\sbin\nrt\nrt_diff /i
xcopy %dynawo_source_dir%\nrt\nrt.py %deploy_dir%\sbin\nrt /i
xcopy %dynawo_source_dir%\nrt\resources %deploy_dir%\sbin\nrt /i

xcopy %dynawo_source_dir%\examples %deploy_dir%\examples /E /i
forfiles /p %deploy_dir%\examples /m *.py /s /c "cmd /c del @path /s /f /q"

:: Third parties
xcopy %thirdPartyInstallPath%\adept\cmake %deploy_dir%\cmake /E /i
xcopy %thirdPartyInstallPath%\adept\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\adept\lib %deploy_dir%\lib /E /i
xcopy %thirdPartyInstallPath%\adept\bin %deploy_dir%\bin /E /i

xcopy %thirdPartyInstallPath%\boost\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\boost\bin\*.dll %deploy_dir%\bin /E /i
xcopy %thirdPartyInstallPath%\boost\bin\*.lib %deploy_dir%\lib /E /i

xcopy %thirdPartyInstallPath%\libarchive\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\libarchive\lib %deploy_dir%\lib /E /i
xcopy %thirdPartyInstallPath%\libarchive\bin\archive* %deploy_dir%\bin /E /i

xcopy %thirdPartyInstallPath%\libiidm\bin %deploy_dir%\bin /E /i
xcopy %thirdPartyInstallPath%\libiidm\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\libiidm\lib %deploy_dir%\bin /E /i
xcopy %thirdPartyInstallPath%\libiidm\share %deploy_dir%\share /E /i
xcopy %thirdPartyInstallPath%\libiidm\cmake %deploy_dir%\cmake /E /i
xcopy %thirdPartyInstallPath%\libiidm\LibIIDM %deploy_dir%\LibIIDM /E /i

xcopy %thirdPartyInstallPath%\libxml\bin %deploy_dir%\bin /E /i
xcopy %thirdPartyInstallPath%\libxml\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\libxml\lib %deploy_dir%\lib /E /i
xcopy %thirdPartyInstallPath%\libxml\cmake %deploy_dir%\cmake /E /i

xcopy %thirdPartyInstallPath%\libzip\bin %deploy_dir%\bin /E /i
xcopy %thirdPartyInstallPath%\libzip\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\libzip\lib %deploy_dir%\lib /E /i

xcopy %thirdPartyInstallPath%\suitesparse\bin %deploy_dir%\bin /E /i
xcopy %thirdPartyInstallPath%\suitesparse\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\suitesparse\lib %deploy_dir%\lib /E /i
xcopy %thirdPartyInstallPath%\suitesparse\cmake %deploy_dir%\cmake /E /i

xcopy %thirdPartyInstallPath%\sundials\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\sundials\bin\*.dll %deploy_dir%\bin /E /i
xcopy %thirdPartyInstallPath%\sundials\bin\*.lib %deploy_dir%\lib /E /i

xcopy %thirdPartyInstallPath%\xerces-c\bin\*.dll %deploy_dir%\bin /E /i
xcopy %thirdPartyInstallPath%\xerces-c\bin\*.lib %deploy_dir%\bin /E /i
xcopy %thirdPartyInstallPath%\xerces-c\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\xerces-c\lib\xerces*.lib %deploy_dir%\lib /E /i
xcopy %thirdPartyInstallPath%\xerces-c\cmake %deploy_dir%\cmake /E /i

xcopy %thirdPartyInstallPath%\zlib\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\zlib\lib %deploy_dir%\lib /E /i
xcopy %thirdPartyInstallPath%\zlib\bin\zlib* %deploy_dir%\bin /E /i

xcopy %thirdPartyInstallPath%\libxml2\bin\*.dll %deploy_dir%\bin /E /i
xcopy %thirdPartyInstallPath%\libxml2\bin\xml*.exe %deploy_dir%\bin /E /i
xcopy %thirdPartyInstallPath%\libxml2\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\libxml2\lib %deploy_dir%\lib /E /i

:: OpenModelica
xcopy %OPENMODELICA_HOME%\bin %deploy_dir%\OpenModelica\bin /E /i
xcopy %OPENMODELICA_HOME%\include %deploy_dir%\OpenModelica\include /E /i
xcopy %OPENMODELICA_HOME%\lib %deploy_dir%\OpenModelica\lib /E /i
xcopy %OPENMODELICA_HOME%\share %deploy_dir%\OpenModelica\share /E /i
xcopy %OPENMODELICA_HOME%\tools %deploy_dir%\OpenModelica\tools /E /i
forfiles /p %deploy_dir%\OpenModelica /m *.la /s /c "cmd /c del @path /s /f /q"

:: Copy dynawo.cmd
xcopy %dynawo_source_dir_abs%\util\windows\dynawo.cmd %deploy_dir% /i

:: Create zip
for /f %%i in ('%deploy_dir_abs%\dynawo.cmd version') do set dynawo_version=%%i
if exist %dynawo_source_dir_abs%\Dynawo_Windows_v%dynawo_version%.zip del %dynawo_source_dir_abs%\Dynawo_Windows_v%dynawo_version%.zip /s /f /q
7z a %dynawo_source_dir_abs%\Dynawo_Windows_v%dynawo_version%.zip -r %deploy_dir_abs%\..\*
