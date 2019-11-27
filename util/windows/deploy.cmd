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
set deploy_dir=%script_dir%..\..\deploy
set dynawo_source_dir=%~DP0..\..

for %%i in ("%deploy_dir%") do set "deploy_dir_abs=%%~fi"
for %%i in ("%dynawo_source_dir%") do set "dynawo_source_dir_abs=%%~fi"

if exist %deploy_dir% rd /s /q %deploy_dir%
md %deploy_dir%

:: Dynawo
xcopy %DYNAWO_INSTALL_DIR%\bin %deploy_dir%\bin /E /i
xcopy %DYNAWO_INSTALL_DIR%\include %deploy_dir%\include /E /i
xcopy %DYNAWO_INSTALL_DIR%\lib %deploy_dir%\lib /E /i
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

pushd %dynawo_source_dir%

:: Copy sources
SETLOCAL ENABLEDELAYEDEXPANSION
for /f %%i in ('git ls-files') do (
  SET FILE=%%i
  set FILE_DIR=%%~dpi
  set FILE_INTERMEDIATE_DIR=!FILE_DIR:%dynawo_source_dir_abs%=!
  xcopy !FILE:/=\! %deploy_dir_abs%\sources!FILE_INTERMEDIATE_DIR! /i /y
  )
ENDLOCAL

popd

xcopy %deploy_dir_abs%\sources\nrt\data %deploy_dir%\testcases /E /i
forfiles /p %deploy_dir%\testcases /m *.py /s /c "cmd /c del @path /s /f /q"

:: Third parties
xcopy %thirdPartyInstallPath%\adept\cmake %deploy_dir%\cmake /E /i
xcopy %thirdPartyInstallPath%\adept\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\adept\lib %deploy_dir%\lib /E /i
xcopy %thirdPartyInstallPath%\adept\bin %deploy_dir%\bin /E /i

xcopy %thirdPartyInstallPath%\boost\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\boost\lib %deploy_dir%\lib /E /i

xcopy %thirdPartyInstallPath%\dlfcnwin32\bin %deploy_dir%\bin /E /i
xcopy %thirdPartyInstallPath%\dlfcnwin32\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\dlfcnwin32\lib %deploy_dir%\lib /E /i
xcopy %thirdPartyInstallPath%\dlfcnwin32\share %deploy_dir%\share /E /i

xcopy %thirdPartyInstallPath%\libarchive\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\libarchive\lib %deploy_dir%\lib /E /i
xcopy %thirdPartyInstallPath%\libarchive\bin\archive* %deploy_dir%\bin /E /i

xcopy %thirdPartyInstallPath%\libiidm\bin %deploy_dir%\bin /E /i
xcopy %thirdPartyInstallPath%\libiidm\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\libiidm\lib %deploy_dir%\lib /E /i
xcopy %thirdPartyInstallPath%\libiidm\share %deploy_dir%\share /E /i
xcopy %thirdPartyInstallPath%\libiidm\cmake %deploy_dir%\cmake /E /i

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
xcopy %thirdPartyInstallPath%\sundials\lib %deploy_dir%\lib /E /i

xcopy %thirdPartyInstallPath%\xerces-c\bin %deploy_dir%\bin /E /i
xcopy %thirdPartyInstallPath%\xerces-c\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\xerces-c\lib\xerces*.lib %deploy_dir%\lib /E /i
xcopy %thirdPartyInstallPath%\xerces-c\cmake %deploy_dir%\cmake /E /i

xcopy %thirdPartyInstallPath%\zlib\include %deploy_dir%\include /E /i
xcopy %thirdPartyInstallPath%\zlib\lib %deploy_dir%\lib /E /i
xcopy %thirdPartyInstallPath%\zlib\bin\zlib* %deploy_dir%\bin /E /i

:: OpenModelica
xcopy %OPENMODELICA_HOME%\bin %deploy_dir%\OpenModelica\bin /E /i
xcopy %OPENMODELICA_HOME%\include %deploy_dir%\OpenModelica\include /E /i
xcopy %OPENMODELICA_HOME%\lib %deploy_dir%\OpenModelica\lib /E /i
xcopy %OPENMODELICA_HOME%\share %deploy_dir%\OpenModelica\share /E /i
xcopy %OPENMODELICA_HOME%\tools %deploy_dir%\OpenModelica\tools /E /i
forfiles /p %deploy_dir%\OpenModelica /m *.la /s /c "cmd /c del @path /s /f /q"

:: Create dynawo.cmd
echo @echo off> %deploy_dir%\dynawo.cmd
echo.>> %deploy_dir%\dynawo.cmd
echo :: Copyright (c) 2015-2019, RTE (http://www.rte-france.com)>> %deploy_dir%\dynawo.cmd
echo :: See AUTHORS.txt>> %deploy_dir%\dynawo.cmd
echo :: All rights reserved.>> %deploy_dir%\dynawo.cmd
echo :: This Source Code Form is subject to the terms of the Mozilla Public>> %deploy_dir%\dynawo.cmd
echo :: License, v. 2.0. If a copy of the MPL was not distributed with this>> %deploy_dir%\dynawo.cmd
echo :: file, you can obtain one at http://mozilla.org/MPL/2.0/.>> %deploy_dir%\dynawo.cmd
echo :: SPDX-License-Identifier: MPL-2.0>> %deploy_dir%\dynawo.cmd
echo ::>> %deploy_dir%\dynawo.cmd
echo :: This file is part of Dynawo, an hybrid C++/Modelica open source time domain>> %deploy_dir%\dynawo.cmd
echo :: simulation tool for power systems.>> %deploy_dir%\dynawo.cmd
echo.>> %deploy_dir%\dynawo.cmd
echo set DYNAWO_INSTALL_DIR=%%~DP0>> %deploy_dir%\dynawo.cmd
echo.>> %deploy_dir%\dynawo.cmd
echo :: Dynawo environment variables for runtime>> %deploy_dir%\dynawo.cmd
echo set DYNAWO_DDB_DIR=%%DYNAWO_INSTALL_DIR%%ddb>> %deploy_dir%\dynawo.cmd
echo set DYNAWO_DICTIONARIES=dictionaries_mapping>> %deploy_dir%\dynawo.cmd
echo set DYNAWO_LOCALE=en_GB>> %deploy_dir%\dynawo.cmd
echo set DYNAWO_RESOURCES_DIR=%%DYNAWO_INSTALL_DIR%%share\>> %deploy_dir%\dynawo.cmd
echo set DYNAWO_SCRIPTS_DIR=%%DYNAWO_INSTALL_DIR%%sbin>> %deploy_dir%\dynawo.cmd
echo set DYNAWO_USE_XSD_VALIDATION=true>> %deploy_dir%\dynawo.cmd
echo set DYNAWO_XSD_DIR=%%DYNAWO_RESOURCES_DIR%%xsd\>> %deploy_dir%\dynawo.cmd
echo.>> %deploy_dir%\dynawo.cmd
echo set thirdPartyInstallPath=%%DYNAWO_INSTALL_DIR%%>> %deploy_dir%\dynawo.cmd
echo set LIBIIDM_HOME=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo set IIDM_XML_XSD_PATH=%%LIBIIDM_HOME%%\share\iidm\xsd\>> %deploy_dir%\dynawo.cmd
echo.>> %deploy_dir%\dynawo.cmd
echo :: For DLL runtime>> %deploy_dir%\dynawo.cmd
echo set DLFCNWIN32_ROOT=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo set LIBXML_HOME=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo set BOOST_PATH=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo set LIBARCHIVE_HOME=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo set ZLIB_ROOT=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo set LIBZIP_HOME=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo set ADEPT_HOME=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo set SUITESPARSE_HOME=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo set SUNDIALS_HOME=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo set XERCESC_HOME=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo.>> %deploy_dir%\dynawo.cmd
echo set OPENMODELICA_HOME=%%DYNAWO_INSTALL_DIR%%OpenModelica>> %deploy_dir%\dynawo.cmd
echo.>> %deploy_dir%\dynawo.cmd
echo set oldpath=%%path%%>> %deploy_dir%\dynawo.cmd
echo.>> %deploy_dir%\dynawo.cmd
echo PATH=%%OPENMODELICA_HOME%%\bin;%%DYNAWO_INSTALL_DIR%%ddb;%%DYNAWO_INSTALL_DIR%%lib;%%PATH%%>> %deploy_dir%\dynawo.cmd
echo PATH=%%DLFCNWIN32_ROOT%%\bin;%%LIBXML_HOME%%\bin,%%PATH%%>> %deploy_dir%\dynawo.cmd
echo PATH=%%BOOST_PATH%%\lib;%%LIBARCHIVE_HOME%%\bin;%%ZLIB_ROOT%%\bin;%%LIBIIDM_HOME%%\bin;%%LIBZIP_HOME%%\bin;%%ADEPT_HOME%%\bin;%%SUITESPARSE_HOME%%\bin;%%SUNDIALS_HOME%%\lib;%%XERCESC_HOME%%\bin;%%PATH%%>> %deploy_dir%\dynawo.cmd
echo.>> %deploy_dir%\dynawo.cmd
echo :: To compile Modelica models>> %deploy_dir%\dynawo.cmd
echo set DYNAWO_ADEPT_INSTALL_DIR=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo set DYNAWO_INSTALL_OPENMODELICA=%%OPENMODELICA_HOME%%>> %deploy_dir%\dynawo.cmd
echo set DYNAWO_XERCESC_INSTALL_DIR=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo set DYNAWO_SUITESPARSE_INSTALL_DIR=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo set DYNAWO_SUNDIALS_INSTALL_DIR=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo set DYNAWO_BOOST_HOME=%%thirdPartyInstallPath%%>> %deploy_dir%\dynawo.cmd
echo.>> %deploy_dir%\dynawo.cmd
echo "%%DYNAWO_INSTALL_DIR%%"bin\dynawo %%*>> %deploy_dir%\dynawo.cmd
echo.>> %deploy_dir%\dynawo.cmd
echo PATH=%%oldpath%%>> %deploy_dir%\dynawo.cmd

:: Create zip
for /f %%i in ('%deploy_dir_abs%\dynawo.cmd + "--version"') do set dynawo_version=%%i
if exist %dynawo_source_dir_abs%\Dynawo_Windows_v%dynawo_version%.zip del %dynawo_source_dir_abs%\Dynawo_Windows_v%dynawo_version%.zip /s /f /q
7z a %dynawo_source_dir_abs%\Dynawo_Windows_v%dynawo_version%.zip -r %deploy_dir_abs%\*