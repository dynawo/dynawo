# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

#
# Custom target for installing Dynawo precompiled models
# Includes C++ models and Modelica models
#
add_custom_target(models
                  DEPENDS
                    models-mo
                    models-cpp
                  COMMENT "Building models for Dynawo"
                 )

add_custom_target(models-mo
                  DEPENDS
                    MODEL_FILES_INSTALL
                    PREASSEMBLED_MODEL_FILES_INSTALL
                  COMMENT "Building modelica models for Dynawo"
                 )

add_custom_target(models-cpp
                  DEPENDS
                    CPP_FILES_INSTALL
                  COMMENT "Building cpp models for Dynawo"
                  )

#
# Target used to install Modelica model files in ddbdir
# (.mo or .xml only)
#
add_custom_target(MODEL_FILES_INSTALL
                  COMMENT "Installing Modelica models"
                 )

#
# Target used to install Modelica preassembled models files in ddbdir
# (.so and .desc.xml)
#
add_custom_target(PREASSEMBLED_MODEL_FILES_INSTALL
                  COMMENT "Installing preassembled models"
                 )

#
# Target used to install C++ models files in ddbdir
# (.so and .desc.xml)
#
add_custom_target(CPP_FILES_INSTALL
                  COMMENT "Installing C++ models"
                 )

set(EXTERNAL_VARIABLES_EXTENSION ".extvar")
set(DESCRIPTION_XML_EXTENSION ".desc.xml")

#
# Macro called to install a .mo or .extvar file
# to ddbdir. Automatically adds the dependencies
# to the main targets.
#
macro(INSTALL_MODEL_FILE
  FILE_TO_INSTALL
)
  file(RELATIVE_PATH RELATIVE_MODELICA_MODEL_DIR ${DYNAWO_MODELICA_MODELS_ROOT} ${CMAKE_CURRENT_SOURCE_DIR})

  # Generate a target name for the model
  string(REPLACE "/" "_" TARGET_NAME "${RELATIVE_MODELICA_MODEL_DIR}/${FILE_TO_INSTALL}")

  set(OUTPUT_FILE_NAME "${FILE_TO_INSTALL}")
  set(OUTPUT_FILE_PATH ${ddbdir}/${RELATIVE_MODELICA_MODEL_DIR}/${OUTPUT_FILE_NAME})

  add_custom_command(
    OUTPUT ${OUTPUT_FILE_PATH}
    DEPENDS ${FILE_TO_INSTALL}
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/${FILE_TO_INSTALL} ${OUTPUT_FILE_PATH}
    )

  add_custom_target(${TARGET_NAME} DEPENDS ${OUTPUT_FILE_PATH})

  add_dependencies(MODEL_FILES_INSTALL ${TARGET_NAME})
endmacro(INSTALL_MODEL_FILE)

#
# Macro called to preassemble a modelica model with its description
# file into ddbdir. Automatically adds the dependencies
# to the main targets.
#
macro(COMPILE_PREASSEMBLED_MODEL
       PREASSEMBLED_MODEL
     )
  get_filename_component(MODEL_NAME ${PREASSEMBLED_MODEL} NAME_WE)

  #
  # Builds the preassembled model if .dep file shows
  # it has been modified
  #
  # We have to do a different command for Windows because of the limitation of numbers of characters on a command line...
  #
  if (MSVC)
    add_custom_command(
      OUTPUT ${MODEL_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}
      DEPENDS
        MODEL_FILES_INSTALL
        ${PREASSEMBLED_MODEL}
        dynawo_ModelManager
      COMMAND
        ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/buildChecker.py ${CMAKE_CURRENT_SOURCE_DIR}/${PREASSEMBLED_MODEL} > ${MODEL_NAME}.log 2>&1 ||
        (echo "*** [${MODEL_NAME}] Error : for more information see file ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}.log" && exit 1)
      COMMAND
        ${CMAKE_COMMAND} -E echo "@echo off" > ${CMAKE_CURRENT_BINARY_DIR}/wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "set DYNAWO_INSTALL_DIR=${installdir}" >> wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "set DYNAWO_DDB_DIR=${ddbdir}" >> wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "set DYNAWO_SCRIPTS_DIR=${sbindir}" >> wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "set DYNAWO_RESOURCES_DIR=${sharedir}" >> wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "set DYNAWO_DICTIONARIES=dictionaries_mapping" >> wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "set DYNAWO_XSD_DIR=${sharedir}/xsd/" >> wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "set DYNAWO_ADEPT_INSTALL_DIR=${ADEPT_HOME}" >> ${CMAKE_CURRENT_BINARY_DIR}/wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "set DYNAWO_INSTALL_OPENMODELICA=${INSTALL_OPENMODELICA}" >> ${CMAKE_CURRENT_BINARY_DIR}/wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "set DYNAWO_XERCESC_INSTALL_DIR=${XERCESC_HOME}" >> ${CMAKE_CURRENT_BINARY_DIR}/wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "set DYNAWO_SUITESPARSE_INSTALL_DIR=${SUITESPARSE_HOME}" >> ${CMAKE_CURRENT_BINARY_DIR}/wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "set DYNAWO_SUNDIALS_INSTALL_DIR=${SUNDIALS_HOME}" >> ${CMAKE_CURRENT_BINARY_DIR}/wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "set DYNAWO_BOOST_HOME=${BOOST_ROOT}" >> ${CMAKE_CURRENT_BINARY_DIR}/wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "set DYNAWO_LIBXML_HOME=${LIBXML_HOME}" >> ${CMAKE_CURRENT_BINARY_DIR}/wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "${runtime_PATH}" >> ${CMAKE_CURRENT_BINARY_DIR}/wrapper.bat
      COMMAND
        ${CMAKE_COMMAND} -E echo "%*" >> ${CMAKE_CURRENT_BINARY_DIR}/wrapper.bat
      COMMAND
          ${CMAKE_COMMAND} -E env
            cmd /c ${CMAKE_CURRENT_BINARY_DIR}/wrapper.bat $<TARGET_FILE:generate-preassembled> --model-list ${CMAKE_CURRENT_SOURCE_DIR}/${PREASSEMBLED_MODEL} --output-dir ${CMAKE_CURRENT_BINARY_DIR} --remove-model-files true >> ${MODEL_NAME}.log 2>&1 ||
            (echo "*** [${MODEL_NAME}] Error : for more information please see file ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}.log" && exit 1)
      COMMENT "Building ${MODEL_NAME}"
      )
  else()
    add_custom_command(
      OUTPUT ${MODEL_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}
      DEPENDS
        ${PREASSEMBLED_MODEL}
        MODEL_FILES_INSTALL
        dynawo_ModelManager
      COMMAND
        test -f ${CMAKE_INSTALL_PREFIX}/${SBINDIR_NAME}/scriptVerifyModelList.py || (echo "Target install was not completed, you need to launch it before compiling a Modelica model. For example with dynawo build-dynawo-core." && exit 1)
      COMMAND
        ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/buildChecker.py ${CMAKE_CURRENT_SOURCE_DIR}/${PREASSEMBLED_MODEL} > ${MODEL_NAME}.log 2>&1 ||
        (echo "*** [${MODEL_NAME}] Error : for more information see file ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}.log" && exit 1)
      COMMAND
        ${CMAKE_COMMAND} -E env
        "${runtime_PATH}"
        "${runtime_LD_LIBRARY_PATH}"
        "DYNAWO_INSTALL_DIR=${installdir}"
        "DYNAWO_DDB_DIR=${ddbdir}"
        "DYNAWO_SCRIPTS_DIR=${sbindir}"
        "DYNAWO_RESOURCES_DIR=${sharedir}"
        "DYNAWO_DICTIONARIES=dictionaries_mapping"
        "DYNAWO_XSD_DIR=${sharedir}/xsd/"
        "DYNAWO_ADEPT_INSTALL_DIR=${ADEPT_HOME}"
        "DYNAWO_INSTALL_OPENMODELICA=${INSTALL_OPENMODELICA}"
        "DYNAWO_XERCESC_INSTALL_DIR=${XERCESC_HOME}"
        "DYNAWO_SUITESPARSE_INSTALL_DIR=${SUITESPARSE_HOME}"
        "DYNAWO_SUNDIALS_INSTALL_DIR=${SUNDIALS_HOME}"
        "DYNAWO_BOOST_HOME=${BOOST_ROOT}"
        "DYNAWO_LIBXML_HOME=${LIBXML_HOME}"
        "DYNAWO_NICSLU_INSTALL_DIR=${NICSLU_HOME}"
        $<TARGET_FILE:generate-preassembled> --model-list ${CMAKE_CURRENT_SOURCE_DIR}/${PREASSEMBLED_MODEL} --output-dir ${CMAKE_CURRENT_BINARY_DIR} --remove-model-files true >> ${MODEL_NAME}.log 2>&1 ||
          (echo "*** [${MODEL_NAME}] Error : for more information please see file ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}.log" && exit 1)
      COMMENT "Building ${MODEL_NAME}"
    )
  endif()

  #
  # Generates .desc.xml file for the preassembled model
  #
  add_custom_command(
    OUTPUT ${MODEL_NAME}${DESCRIPTION_XML_EXTENSION}
    DEPENDS ${MODEL_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}
    COMMAND
        ${CMAKE_COMMAND} -E env
            "${runtime_PATH}"
            "${runtime_LD_LIBRARY_PATH}"
              $<TARGET_FILE:dumpModel> -m ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX} -o ${MODEL_NAME}${DESCRIPTION_XML_EXTENSION}
    COMMENT "Generating ${MODEL_NAME} description file"
    )

  #
  # Install built library and generated .desc.xml file into bdddir
  #
  add_custom_target(${MODEL_NAME}
      DEPENDS
        ${MODEL_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}
        ${MODEL_NAME}${DESCRIPTION_XML_EXTENSION}
      COMMAND
        ${CMAKE_COMMAND} -E copy ${MODEL_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX} ${ddbdir}/
      COMMAND
        ${CMAKE_COMMAND} -E copy_if_different ${MODEL_NAME}${DESCRIPTION_XML_EXTENSION} ${ddbdir}/
      COMMAND
        # First echo_append prevents cmake from changing ( to "(" that is an invalid bash command
        ${CMAKE_COMMAND} -E echo_append && (${CMAKE_COMMAND} -E copy_if_different ${MODEL_NAME}${EXTERNAL_VARIABLES_EXTENSION} ${ddbdir}/ || ${CMAKE_COMMAND} -E echo_append This is not an error !) >> ${MODEL_NAME}.log 2>&1
  )

  add_dependencies(PREASSEMBLED_MODEL_FILES_INSTALL ${MODEL_NAME})
endmacro(COMPILE_PREASSEMBLED_MODEL)

#
# Macro called to install a C++ model and its description
# file into ddbdir. Automatically adds the dependencies
# to the main targets.
#

set(CHECKSUM_SCRIPT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/checkSum_ModelsCPP.py")

macro(COMPILE_CPP_MODEL
          CPP_MODEL
          CPP_SOURCES
     )

    add_custom_target(${CPP_MODEL}_HPP
        COMMAND
            ${PYTHON_EXECUTABLE} ${CHECKSUM_SCRIPT_PATH} -m ${CMAKE_CURRENT_SOURCE_DIR}/${CPP_MODEL} 2>&1 ||
            (echo "*** [${CPP_MODEL}] Error : for more information see previous log" && exit 1)
        COMMENT "Creating checkSum for ${CPP_MODEL}"
        )

    add_library(${CPP_MODEL} SHARED EXCLUDE_FROM_ALL ${CPP_SOURCES})

    set_target_properties(${CPP_MODEL} PROPERTIES PREFIX "")
    set_target_properties(${CPP_MODEL} PROPERTIES SKIP_BUILD_RPATH True)

    add_dependencies(${CPP_MODEL} ${CPP_MODEL}_HPP)

    target_include_directories(${MODEL_NAME}
      PRIVATE
        $<TARGET_PROPERTY:dynawo_API_PAR,INTERFACE_INCLUDE_DIRECTORIES>
      )
    target_link_libraries(${CPP_MODEL}
      PRIVATE
        dynawo_Common
        dynawo_ModelerCommon
      PUBLIC
        dynawo_CPPModelsCommon
      )

    add_custom_command(
        OUTPUT ${CPP_MODEL}${DESCRIPTION_XML_EXTENSION}
        DEPENDS ${CPP_MODEL}
        COMMAND
            test -f ${CMAKE_INSTALL_PREFIX}/${LIBDIR_NAME}/$<TARGET_FILE_NAME:dynawo_CPPModelsCommon>  || (echo "Target install was not completed, you need to launch it before compiling a CPP model. For example with dynawo build-dynawo-core." && exit 1)
        COMMAND
            ${CMAKE_COMMAND} -E env
              "${runtime_PATH}"
              "${runtime_LD_LIBRARY_PATH}"
                  $<TARGET_FILE:dumpModel> -m $<TARGET_FILE:${CPP_MODEL}> -o ${CPP_MODEL}${DESCRIPTION_XML_EXTENSION}
        COMMENT "Building ${CPP_MODEL} description file"
        )

    add_custom_target(${CPP_MODEL}_INSTALL
        DEPENDS
            ${CPP_MODEL}
            ${CPP_MODEL}${DESCRIPTION_XML_EXTENSION}
        COMMAND
            ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${CPP_MODEL}> ${ddbdir}/
        COMMAND
            ${CMAKE_COMMAND} -E copy ${CPP_MODEL}${DESCRIPTION_XML_EXTENSION} ${ddbdir}/
        )

    add_dependencies(CPP_FILES_INSTALL ${CPP_MODEL}_INSTALL)
endmacro(COMPILE_CPP_MODEL)

# PYTHON scripts for models
set(PYTHON_SCRIPTS_MODELS
  checkSum_ModelsCPP.py
  )

install(PROGRAMS ${PYTHON_SCRIPTS_MODELS} DESTINATION ${SBINDIR_NAME})

# List of model subdirectories
add_subdirectory(CPP)
add_subdirectory(Modelica M)

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
