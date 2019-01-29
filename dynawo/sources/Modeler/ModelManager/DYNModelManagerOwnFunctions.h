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
void array_alloc_scalar_real_array(real_array_t* dest, int n, modelica_real first, ...);
void array_alloc_string_array(string_array_t* dest, int n, string_array_t first, ...);
void alloc_string_array(string_array_t *dest, int ndims, ...);
void check_base_array_dim_sizes(const base_array_t *elts, int n);
void array_alloc_scalar_string_array(string_array_t* dest, int n, modelica_string first, ...);
void put_string_element(modelica_string value, int i1, string_array_t* dest);
void simple_alloc_1d_string_array(string_array_t* dest, int n);
void put_real_element(modelica_real value, int i1, real_array_t *dest);
void simple_alloc_1d_real_array(real_array_t* dest, int n);
void alloc_real_array(real_array_t *dest, int ndims, ...);
size_t alloc_base_array(base_array_t *dest, int ndims, va_list ap);
void copy_real_array_data_mem(const real_array_t source, modelica_real *dest);
void array_alloc_scalar_real_array(real_array_t* dest, int n, modelica_real first, ...);
void simple_alloc_1d_base_array(base_array_t *dest, int n, void *data);
const char** data_of_string_c89_array(const string_array_t *a);

static inline int ndims_real_array(const real_array_t * a) { return a->ndims; }
static inline modelica_real *data_of_real_array(const real_array_t *a) { return reinterpret_cast<modelica_real *>(a->data); }
static inline modelica_real *data_of_real_c89_array(const real_array_t *a) { return reinterpret_cast<modelica_real *>(a->data); }
static inline modelica_real *data_of_real_f77_array(const real_array_t *a) { return reinterpret_cast<modelica_real *>(a->data); }
#endif  // DOXYGEN_SHOULD_SKIP_THIS

#endif  // MODELER_MODELMANAGER_DYNMODELMANAGEROWNFUNCTIONS_H_
