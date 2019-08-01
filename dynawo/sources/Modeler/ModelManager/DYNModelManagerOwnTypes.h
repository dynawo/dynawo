//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNModelManagerOwnTypes.h
 *
 * @brief declaration of structure/type needed by dynawo (specific declaration)
 *
 */
#ifndef MODELER_MODELMANAGER_DYNMODELMANAGEROWNTYPES_H_
#define MODELER_MODELMANAGER_DYNMODELMANAGEROWNTYPES_H_


#ifndef DOXYGEN_SHOULD_SKIP_THIS

// redefine modelica_types like we want
/**
 * All Type defined below are copied from <OpenModelica Sources>/SimulationRuntime/c/openmodelica_types.h
 * They have to be defined for Dynawo models dynamic libraries compilation
 */
typedef void* modelica_complex;
typedef void* modelica_metatype;
typedef void* modelica_fnptr;
typedef char* modelica_string_t;
typedef const char* modelica_string_const;
typedef modelica_string_const modelica_string;
typedef double m_real;
typedef int m_integer;
typedef const char* m_string;
typedef signed char m_boolean;
typedef m_integer _index_t;

struct index_spec_s {
  _index_t ndims;  ///< number of indices/subscripts
  _index_t* dim_size;  ///< size for each subscript
  char* index_type;  ///< type of each subscript, any of 'S','A' or 'W'
  _index_t** index;  ///< all indices
};  ///< structure index_spec_s

typedef struct index_spec_s index_spec_t;

struct base_array_s {
  int ndims;  ///< number of array
  _index_t *dim_size;  ///< size for each array
  void *data;  ///< data for each array
};  ///< structure base_array_s

typedef struct base_array_s base_array_t;

typedef base_array_t string_array_t;

typedef signed char modelica_boolean;
typedef base_array_t boolean_array_t;

typedef double modelica_real;
typedef base_array_t real_array_t;

typedef m_integer modelica_integer;
typedef base_array_t integer_array_t;
typedef integer_array_t integer_array;

typedef real_array_t real_array;
typedef string_array_t string_array;

#ifdef _OMC_1_9_4
typedef enum {
  ERROR_UNKOWN = 0,
  ERROR_SIMULATION,
  ERROR_INTEGRATOR,
  ERROR_NONLINEARSOLVER,
  ERROR_EVENTSEARCH,
  ERROR_OPTIMIZE,
  ERROR_MAX
} errorStage;

#include <setjmp.h>

/* Thread-specific data passed around in most functions.
 * It is also possible to fetch it using pthread_getspecific (mostly for external functions that were not passed the pointer) */
enum {
  LOCAL_ROOT_USER_DEFINED_0,
  LOCAL_ROOT_USER_DEFINED_1,
  LOCAL_ROOT_USER_DEFINED_2,
  LOCAL_ROOT_USER_DEFINED_3,
  LOCAL_ROOT_USER_DEFINED_4,
  LOCAL_ROOT_USER_DEFINED_5,
  LOCAL_ROOT_USER_DEFINED_6,
  LOCAL_ROOT_USER_DEFINED_7,
  LOCAL_ROOT_USER_DEFINED_8,
  LOCAL_ROOT_ERROR_MO,
  LOCAL_ROOT_PRINT_MO,
  LOCAL_ROOT_SYSTEM_MO,
  MAX_LOCAL_ROOTS
};
#define MAX_LOCAL_ROOTS 16

/**
 * struct threadData_s
 */
typedef struct threadData_s {
  jmp_buf *mmc_jumper;  ///< ??
  jmp_buf *mmc_stack_overflow_jumper;  ///< ??
  jmp_buf *mmc_thread_work_exit;  ///< ??
  void *localRoots[MAX_LOCAL_ROOTS];  ///< ??
  /*
   * simulationJumpBufer:
   *  Jump-buffer to handle simulation error
   *  like asserts or divisions by zero.
   *
   * currentJumpStage:
   *   define which simulation jump buffer
   *   is currently used.
   */
  jmp_buf *globalJumpBuffer;  ///< ??
  jmp_buf *simulationJumpBuffer;  ///< ??
  errorStage currentErrorStage;  ///< ??
} threadData_t;
#endif  // _OMC_1_9_4

#endif  // DOXYGEN_SHOULD_SKIP_THIS

#endif  // MODELER_MODELMANAGER_DYNMODELMANAGEROWNTYPES_H_
