//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
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

#include <cstdarg>
#include <cstdlib>

#ifndef DOXYGEN_SHOULD_SKIP_THIS
/**
 * Variables declarations copied from <OpenModelica Sources>/SimulationRuntime/c/util/modelica_string_lit.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
extern void *mmc_emptystring;
extern void *mmc_strings_len1[256];

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
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/base_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void clone_base_array_spec(const base_array_t *source, base_array_t *dest);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/base_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
int base_array_ok(const base_array_t *a);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/base_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
int base_array_shape_eq(const base_array_t *a, const base_array_t *b);
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
modelica_real min_real_array(const real_array_t a);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
modelica_real max_real_array(const real_array_t a);

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
void integer_array_create(integer_array_t *dest, modelica_integer *data, int ndims, ...);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
static inline int* data_of_integer_c89_array(const integer_array_t *a) { return reinterpret_cast<modelica_integer *> (a->data); }

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
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/gc/memory_pool.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
inline m_real* real_alloc(int n) {return reinterpret_cast<m_real *>(malloc(n*sizeof(m_real)));}

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/gc/memory_pool.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
inline _index_t* size_alloc(int n) {return reinterpret_cast<_index_t *>(malloc(n*sizeof(_index_t)));}

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/memory_pool.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
inline _index_t** index_alloc(int n) {return reinterpret_cast<_index_t **>(malloc(n*sizeof(_index_t*)));}

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/memory_pool.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
inline void* generic_alloc(int n, size_t sze) {return reinterpret_cast<void *>(malloc(n*sze));}

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

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
modelica_real* real_array_element_addr1(const real_array_t * source, int ndims, int dim1);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
modelica_real* real_array_element_addr2(const real_array_t * source, int ndims, int dim1, int dim2);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void create_integer_array_from_range(integer_array_t *dest, modelica_integer start, modelica_integer step, modelica_integer stop);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
_index_t* integer_array_make_index_array(const integer_array_t *arr);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/gc/memory_pool.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
m_boolean* boolean_alloc(int n);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/boolean_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
inline modelica_boolean *boolean_ptrget(const boolean_array_t *a, size_t i) {
    return reinterpret_cast<modelica_boolean *>(a->data) + i;
}

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/boolean_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
m_boolean* boolean_array_element_addr1(const boolean_array_t* source, int ndims, int dim1);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/boolean_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
inline void boolean_set(boolean_array_t *a, size_t i, modelica_boolean r) {
    reinterpret_cast<modelica_boolean *> (a->data)[i] = r;
}

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/boolean_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
extern void simple_alloc_1d_boolean_array(boolean_array_t* dest, int n);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/boolean_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void put_boolean_element(m_boolean value, int i1, boolean_array_t* dest);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/boolean_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void array_alloc_scalar_boolean_array(boolean_array_t* dest, int n, ...);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/base_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void base_array_create(base_array_t *dest, void *data, int ndims, va_list ap);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/boolean_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void boolean_array_create(boolean_array_t *dest, modelica_boolean *data, int ndims, ...);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void fill_alloc_real_array(real_array_t* dest, modelica_real value, int ndims, ...);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
inline void clone_real_array_spec(const real_array_t *src, real_array_t* dst) { clone_base_array_spec(src, dst); }
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void indexed_assign_real_array(const real_array_t source, real_array_t* dest, const index_spec_t* dest_spec);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void alloc_real_array_data(real_array_t* a);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void alloc_integer_array_data(integer_array_t *a);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void alloc_integer_array(integer_array_t *dest, int ndims, ...);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void unpack_integer_array(integer_array_t *a);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void copy_integer_array(const integer_array_t source, integer_array_t* dest);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/integer_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void copy_integer_array_data(const integer_array_t source, integer_array_t* dest);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void real_array_create(real_array_t *dest, modelica_real *data, int ndims, ...);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
real_array_t sub_alloc_real_array(const real_array_t a, const real_array_t b);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void copy_real_array_data(const real_array_t source, real_array_t* dest);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/real_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void sub_real_array(const real_array_t * a, const real_array_t * b, real_array_t* dest);

/**
 * Method copied from <OpenModelica Sources>/OMCompiler/3rdParty/lpsolve/shared/commonlib.c
 * It is needed for Dynawo models dynamic libraries compilation
 */
inline int mod(int n, int d) {return(n % d);}

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/base_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
void indexed_assign_base_array_size_alloc(const base_array_t *source, base_array_t *dest,
    const index_spec_t *dest_spec, _index_t** _idx_vec1, _index_t** _idx_size);
/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/base_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
size_t calc_base_index_spec(int ndims, const _index_t* idx_vec,
                            const base_array_t *arr, const index_spec_t *spec);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/base_array.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
int index_spec_fit_base_array(const index_spec_t *s, const base_array_t *a);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/index_spec.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
int next_index(int ndims, _index_t* idx, const _index_t* size);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/index_spec.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
int index_spec_ok(const index_spec_t* s);

/**
 * Method copied from <OpenModelica Sources>/SimulationRuntime/c/util/index_spec.h
 * It is needed for Dynawo models dynamic libraries compilation
 */
inline void create_index_spec(index_spec_t* dest, int nridx, ...) {
  int i;
  va_list ap;
  va_start(ap, nridx);

  dest->ndims = nridx;
  dest->dim_size = size_alloc(nridx);
  dest->index = index_alloc(nridx);
  dest->index_type = reinterpret_cast<char*>(generic_alloc(nridx+1, sizeof(char)));
  for (i = 0; i < nridx; ++i) {
      dest->dim_size[i] = va_arg(ap, _index_t);
      dest->index[i] = va_arg(ap, _index_t*);
      dest->index_type[i] = static_cast<char>(va_arg(ap, _index_t)); /* char is cast to int by va_arg.*/
  }
  va_end(ap);
}

#endif  // DOXYGEN_SHOULD_SKIP_THIS

#endif  // MODELER_MODELMANAGER_DYNMODELMANAGEROWNFUNCTIONS_H_
