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
ADD_CUSTOM_TARGET(models
                  DEPENDS
                    models-mo
                    models-cpp
                  COMMENT "Building models for Dynawo"
                 )

ADD_CUSTOM_TARGET(models-mo
                  DEPENDS
                      MODEL_FILES_INSTALL
                      PREASSEMBLED_MODEL_FILES_INSTALL
                  COMMENT "Building modelica models for Dynawo"
                 )

ADD_CUSTOM_TARGET(models-cpp
                  DEPENDS
                    CPP_FILES_INSTALL
                  COMMENT "Building cpp models for Dynawo"
                  )

#
# Target used to ensure that ddbdir directory is created
#
ADD_CUSTOM_TARGET(CREATE_DDBDIR
                  COMMAND ${CMAKE_COMMAND} -E make_directory ${ddbdir}
                 )
#
# Target used to install Modelica model files in ddbdir
# (.mo or .xml only)
#
ADD_CUSTOM_TARGET(MODEL_FILES_INSTALL
                  COMMENT "Installing Modelica models"
                 )

#
# Flatten external variable files (in order to process includes)
#
ADD_CUSTOM_TARGET (EXTERNAL_VARIABLES_FLATTENING
                   DEPENDS
                       MODEL_FILES_INSTALL
                   COMMENT "Flattening external variables files (processing includes)")


#
# Target used to install Modelica preassembled models files in ddbdir
# (.dylib and .desc.xml)
#
ADD_CUSTOM_TARGET(PREASSEMBLED_MODEL_FILES_INSTALL
                  COMMENT "Installing preassembled models"
                 )

#
# Target used to install C++ models files in ddbdir
# (.dylib and .desc.xml)
#
ADD_CUSTOM_TARGET(CPP_FILES_INSTALL
                  COMMENT "Installing C++ models"
                 )

#
# Macro called to install a .mo or .extvar file
# to ddbdir. Automatically adds the dependencies
# to the main targets.
#
MACRO(INSTALL_MODEL_FILE
          FILE_TO_INSTALL
     )
    file(RELATIVE_PATH RELATIVE_MODELICA_MODEL_DIR ${DYNAWO_MODELICA_MODELS_ROOT} ${CMAKE_CURRENT_SOURCE_DIR})

    # Generate a target name for the model
    string (REPLACE "/" "_" TARGET_NAME "${RELATIVE_MODELICA_MODEL_DIR}/${FILE_TO_INSTALL}")

    # Extract the (short) file extension
    string (FIND ${FILE_TO_INSTALL} "." SHORT_EXTENSION_INDEX REVERSE)
    string (SUBSTRING ${FILE_TO_INSTALL} ${SHORT_EXTENSION_INDEX} -1 SHORT_EXTENSION)

    SET (OUTPUT_FILE_NAME "${FILE_TO_INSTALL}")
    SET (OUTPUT_FILE_PATH ${ddbdir}/${RELATIVE_MODELICA_MODEL_DIR}/${OUTPUT_FILE_NAME})

    ADD_CUSTOM_TARGET(${TARGET_NAME}
                      DEPENDS CREATE_DDBDIR
                      COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${FILE_TO_INSTALL} ${OUTPUT_FILE_PATH}
                     )

    # Run xmllint on external variable files in order to include possible sub-model external variables
    string (TOLOWER ${SHORT_EXTENSION} SHORT_EXTENSION_LOWER)
    set (EXTERNAL_VARIABLES_EXTENSION ".extvar")
    if (${SHORT_EXTENSION_LOWER} STREQUAL ${EXTERNAL_VARIABLES_EXTENSION})
        SET (TARGET_PROCESSING_NAME "${TARGET_NAME}_EXTVAR_FLATTENING")
        ADD_CUSTOM_TARGET(${TARGET_PROCESSING_NAME}
                      DEPENDS MODEL_FILES_INSTALL
                      COMMENT "Processing external variable files for includes"
                     )

        SET (TMP_FILE_PATH ${OUTPUT_FILE_PATH}.tmp)
        add_custom_command (TARGET ${TARGET_PROCESSING_NAME}
                            PRE_BUILD
                            COMMAND xmllint --nofixup-base-uris --nowarning --xinclude "${OUTPUT_FILE_PATH}" --output "${TMP_FILE_PATH}" 2>&1 || ((echo "*** Failed to include external variable files") && exit -1)
                            COMMAND xmllint --format --noblanks "${TMP_FILE_PATH}" --output "${OUTPUT_FILE_PATH}"
                            COMMAND rm -rf "${TMP_FILE_PATH}")

        ADD_DEPENDENCIES(EXTERNAL_VARIABLES_FLATTENING ${TARGET_PROCESSING_NAME})
    endif()

    ADD_DEPENDENCIES(MODEL_FILES_INSTALL ${TARGET_NAME})

ENDMACRO(INSTALL_MODEL_FILE)

#
# Macro called to preassemble a modelica model with its description
# file into ddbdir. Automatically adds the dependencies
# to the main targets.
#

MACRO(COMPILE_PREASSEMBLED_MODEL
          PREASSEMBLED_MODEL
     )
    GET_FILENAME_COMPONENT(MODEL_NAME ${PREASSEMBLED_MODEL} NAME_WE)

    #
    # Generates .dep file for the preassembled model
    #
#    ADD_CUSTOM_TARGET(${MODEL_NAME}_DEPCHECKER
#                       COMMAND python ${CMAKE_CURRENT_SOURCE_DIR}/depChecker.py ${CMAKE_CURRENT_SOURCE_DIR}/${PREASSEMBLED_MODEL} ${MODEL_NAME}.dep
#                       COMMENT "Checking ${MODEL_NAME} dependencies"
#                      )

    #
    # Custom command used to deal with .dep generated file dependency
    #
#    ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}.dep
#                       DEPENDS
#                           ${MODEL_NAME}_DEPCHECKER
#                      )

    #
    # Builds the preassembled model if .dep file shows
    # it has been modified
    #
    ADD_CUSTOM_COMMAND(OUTPUT ${MODEL_NAME}.dylib
                       DEPENDS
                           ${PREASSEMBLED_MODEL}
#                           ${MODEL_NAME}_DEPCHECKER
#                           ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}.dep
                           dydLibGenerator
                           MODEL_FILES_INSTALL
                           EXTERNAL_VARIABLES_FLATTENING
                       COMMAND
                           python ${CMAKE_CURRENT_SOURCE_DIR}/buildChecker.py ${CMAKE_CURRENT_SOURCE_DIR}/${PREASSEMBLED_MODEL} > ${MODEL_NAME}.log 2>&1 ||
                           (echo "*** [${MODEL_NAME}] Error : for more information see file ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}.log" && exit -1)
                       COMMAND
                           ${bindir}/launcher --dydlib --model-list ${CMAKE_CURRENT_SOURCE_DIR}/${PREASSEMBLED_MODEL} --output-dir ${CMAKE_CURRENT_BINARY_DIR} --remove-model-files true >> ${MODEL_NAME}.log 2>&1 ||
                           (echo "*** [${MODEL_NAME}] Error : for more information please see file ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}.log" && exit -1)
                       COMMENT "Building ${MODEL_NAME}"
                      )

    #
    # Generates .desc.xml file for the preassembled model
    #
    ADD_CUSTOM_COMMAND(OUTPUT ${MODEL_NAME}.desc.xml
                       DEPENDS ${MODEL_NAME}.dylib dumpModel
                       WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                       COMMAND
                           ${bindir}/launcher --dump-model ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}.dylib ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}.desc.xml \;
                       COMMENT "Generating ${MODEL_NAME} description file"
                      )

    #
    # Install built library and generated .desc.xml file into bdddir
    #
    ADD_CUSTOM_TARGET(${MODEL_NAME}
                      DEPENDS
#                          ${MODEL_NAME}.dep
                          ${MODEL_NAME}.dylib
                          ${MODEL_NAME}.desc.xml
                          ${MODEL_NAME}.extvar
                          CREATE_DDBDIR
                      COMMAND
                        ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}.dylib ${ddbdir}/${MODEL_NAME}.dylib \;
                        ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}.desc.xml ${ddbdir}/${MODEL_NAME}.desc.xml
                     )

    ADD_CUSTOM_TARGET(${MODEL_NAME}.extvar
                      DEPENDS
                          ${MODEL_NAME}.dylib
                          CREATE_DDBDIR
                      COMMAND
                        test ! -e ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}.extvar || cp ${CMAKE_CURRENT_BINARY_DIR}/${MODEL_NAME}.extvar ${ddbdir}/${MODEL_NAME}.extvar
                      COMMENT "Install ${MODEL_NAME}.extvar external variables description file"
                     )

    ADD_DEPENDENCIES(PREASSEMBLED_MODEL_FILES_INSTALL ${MODEL_NAME})
    ADD_DEPENDENCIES(PREASSEMBLED_MODEL_FILES_INSTALL ${MODEL_NAME}.extvar)
ENDMACRO(COMPILE_PREASSEMBLED_MODEL)

#
# Macro called to install a C++ model and its description
# file into ddbdir. Automatically adds the dependencies
# to the main targets.
#
MACRO(COMPILE_CPP_MODEL
          CPP_MODEL
          CPP_SOURCES
          CPP_LINKED_LIBRARIES
     )

    ADD_CUSTOM_TARGET(${CPP_MODEL}_HPP
                       COMMAND
                         ${CMAKE_COMMAND} -E remove ${CMAKE_CURRENT_SOURCE_DIR}/${CPP_MODEL}.hpp \;
                         python ${CMAKE_CURRENT_SOURCE_DIR}/../../checkSum_ModelsCPP.py -m ${CMAKE_CURRENT_SOURCE_DIR}/${CPP_MODEL} 2>&1 ||
                         (echo "*** [${CPP_MODEL}] Error : for more information see previous log" && exit -1)
                       COMMENT "Creating checkSum for ${CPP_MODEL}"
                      )

    ADD_LIBRARY(${CPP_MODEL} SHARED EXCLUDE_FROM_ALL ${CPP_SOURCES})

    SET_TARGET_PROPERTIES(${CPP_MODEL} PROPERTIES PREFIX "")

    ADD_DEPENDENCIES(${CPP_MODEL} ${CPP_MODEL}_HPP)

    TARGET_LINK_LIBRARIES(${CPP_MODEL}
                          ${CPP_LINKED_LIBRARIES}
                          ${Boost_ATOMIC_LIBRARY}
                          ${Boost_DATE_TIME_LIBRARY}
                          ${Boost_REGEX_LIBRARY}
                          ${Boost_CHRONO_LIBRARY}
                         )
    IF(LIBRARY_TYPE STREQUAL "STATIC")
      TARGET_LINK_LIBRARIES(${CPP_MODEL} "-flat_namespace -undefined warning")
    ENDIF()

    IF(LIBRARY_TYPE STREQUAL "SHARED")
      TARGET_LINK_LIBRARIES(${CPP_MODEL} dynawo_Util)
    ENDIF()

    ADD_CUSTOM_COMMAND(OUTPUT ${CPP_MODEL}.desc.xml
                       DEPENDS ${CPP_MODEL} dumpModel
                       COMMAND
                           ${bindir}/launcher --dump-model ${CMAKE_CURRENT_BINARY_DIR}/${CPP_MODEL}.dylib ${CMAKE_CURRENT_BINARY_DIR}/${CPP_MODEL}.desc.xml \;
                       COMMENT "Building ${CPP_MODEL} description file"
                      )

    ADD_CUSTOM_TARGET(${CPP_MODEL}_INSTALL
                      DEPENDS
                          ${CPP_MODEL}
                          ${CPP_MODEL}.desc.xml
                          CREATE_DDBDIR
                      COMMAND
                          ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/${CPP_MODEL}.dylib ${ddbdir}/${CPP_MODEL}.dylib \;
                          ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/${CPP_MODEL}.desc.xml ${ddbdir}/${CPP_MODEL}.desc.xml
                     )

    ADD_DEPENDENCIES(CPP_FILES_INSTALL ${CPP_MODEL}_INSTALL)
ENDMACRO(COMPILE_CPP_MODEL)

# PYTHON scripts for models
SET(PYTHON_SCRIPTS_MODELS
  checkSum_ModelsCPP.py
  )

INSTALL(PROGRAMS ${PYTHON_SCRIPTS_MODELS} DESTINATION ${sbindir})

# List of model subdirectories
ADD_SUBDIRECTORY(CPP)
ADD_SUBDIRECTORY(Modelica)
