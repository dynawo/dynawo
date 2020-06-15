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
 * @file  DYNModelManagerOwnFunctions.h
 *
 * @brief declaration of functions needed by dynawo (specific declaration)
 *
 */
#ifndef MODELER_MODELMANAGER_DYNMODELMANAGEROWNFUNCTIONS_H_
#define MODELER_MODELMANAGER_DYNMODELMANAGEROWNFUNCTIONS_H_

#include "DYNModelManagerOwnTypes.h"

#ifndef DOXYGEN_SHOULD_SKIP_THIS
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void array_alloc_scalar_real_array(real_array_t* dest, int n, modelica_real first, ...);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/string_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void array_alloc_string_array(string_array_t* dest, int n, string_array_t first, ...);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/string_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void alloc_string_array(string_array_t *dest, int ndims, ...);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/base_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void check_base_array_dim_sizes(const base_array_t *elts, int n);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/string_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void array_alloc_scalar_string_array(string_array_t* dest, int n, modelica_string first, ...);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/string_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void put_string_element(modelica_string value, int i1, string_array_t* dest);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/string_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void simple_alloc_1d_string_array(string_array_t* dest, int n);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/modelica_string.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void* mmc_mk_scon(const char *s);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void put_real_element(modelica_real value, int i1, real_array_t *dest);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void simple_alloc_1d_real_array(real_array_t* dest, int n);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void alloc_real_array(real_array_t *dest, int ndims, ...);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/base_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
size_t alloc_base_array(base_array_t *dest, int ndims, va_list ap);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void copy_real_array_data_mem(const real_array_t source, modelica_real *dest);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void array_alloc_scalar_real_array(real_array_t* dest, int n, modelica_real first, ...);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/base_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void simple_alloc_1d_base_array(base_array_t *dest, int n, void *data);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/string_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
const char** data_of_string_c89_array(const string_array_t *a);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/generic_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void* generic_array_element_addr(const base_array_t* source, size_t sze, int dim1, ...);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/base_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
size_t calc_base_index_va(const base_array_t *source, int ndims, va_list ap);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
static inline int ndims_real_array(const real_array_t * a) { return a->ndims; }
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
static inline modelica_real *data_of_real_array(const real_array_t *a) { return reinterpret_cast<modelica_real *>(a->data); }
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
static inline modelica_real *data_of_real_c89_array(const real_array_t *a) { return reinterpret_cast<modelica_real *>(a->data); }
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
static inline modelica_real *data_of_real_f77_array(const real_array_t *a) { return reinterpret_cast<modelica_real *>(a->data); }

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
static inline modelica_integer integer_get(const integer_array_t a, size_t i) { return reinterpret_cast<modelica_integer *>(a.data)[i]; }

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
static inline int* data_of_integer_c89_array(const integer_array_t *a) { return reinterpret_cast<int *> (a->data); }

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
inline void real_set(real_array_t *a, size_t i, modelica_real r) {reinterpret_cast<modelica_real *>(a->data)[i] = r;}

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
static inline modelica_real real_get(const real_array_t a, size_t i) {return reinterpret_cast<modelica_real *> (a.data)[i];}

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
inline void integer_set(integer_array_t *a, size_t i, modelica_integer r) {reinterpret_cast<modelica_integer *>(a->data)[i] = r;}

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void pack_integer_array(integer_array_t *a);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/gc/memory_pool.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
inline m_integer* integer_alloc(int n) {return reinterpret_cast<modelica_integer *>(malloc(n*sizeof(m_integer)));}

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void put_integer_element(modelica_integer value, int i1, integer_array_t* dest);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void array_alloc_scalar_integer_array(integer_array_t* dest, int n, modelica_integer first, ...);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void simple_alloc_1d_integer_array(integer_array_t* dest, int n);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void put_real_matrix_element(modelica_real value, int r, int c, real_array_t* dest);

#endif  // DOXYGEN_SHOULD_SKIP_THIS

#endif  // MODELER_MODELMANAGER_DYNMODELMANAGEROWNFUNCTIONS_H_
