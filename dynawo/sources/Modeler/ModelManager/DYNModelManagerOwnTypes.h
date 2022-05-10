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
typedef unsigned long mmc_uint_t;
struct mmc_string {
    mmc_uint_t header;  /* MMC_STRINGHDR(bytes) */
    char data[1];  /* `bytes' elements + terminating '\0' */
};

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

typedef base_array_t boolean_array_t;
typedef boolean_array_t boolean_array;

#endif  // DOXYGEN_SHOULD_SKIP_THIS

#endif  // MODELER_MODELMANAGER_DYNMODELMANAGEROWNTYPES_H_
