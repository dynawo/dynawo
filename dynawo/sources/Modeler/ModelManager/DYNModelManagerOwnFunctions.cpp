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
 * @file  DYNModelManagerOwnFunctions.cpp
 *
 * @brief implementation of functions needed by dynawo (specific implementation)
 *
 */
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
# endif  // __clang__

#include <cstdlib>
#include <cstdarg>
#include <cassert>
#include "DYNModelManagerOwnFunctions.h"

static inline void real_set_(real_array_t *a, size_t i, modelica_real r) {
  (reinterpret_cast<modelica_real *> (a->data))[i] = r;
}

static inline modelica_real real_get(const real_array_t a, size_t i) {
  return (reinterpret_cast<modelica_real *> (a.data))[i];
}

static inline modelica_string *string_ptrget(const string_array_t *a, size_t i) {
  return (reinterpret_cast<modelica_string *> (a->data)) + i;
}

static inline void string_set(string_array_t *a, size_t i, modelica_string r) {
  (reinterpret_cast<modelica_string *> (a->data))[i] = r;
}

static modelica_string string_get(const string_array_t a, size_t i) {
  return (reinterpret_cast<modelica_string *> (a.data))[i];
}

static inline size_t base_array_nr_of_elements(const base_array_t a) {
  size_t nr_of_elements = 1;
  for (int i = 0; i < a.ndims; ++i) {
    nr_of_elements *= a.dim_size[i];
  }
  return nr_of_elements;
}

const char** data_of_string_c89_array(const string_array_t *a) {
  size_t sz = base_array_nr_of_elements(*a);
  const char **res = new const char*[sz]();
  for (unsigned int i=0; i< sz; ++i) {
    res[i] = (reinterpret_cast<modelica_string *> (a->data))[i];
  }
  return res;
}

void put_real_element(modelica_real value, int i1, real_array_t *dest) {
  /* Assert that dest has correct dimension */
  /* Assert that i1 is a valid index */
  real_set_(dest, i1, value);
}

void simple_alloc_1d_real_array(real_array_t* dest, int n) {
  simple_alloc_1d_base_array(dest, n, new modelica_real[n]());
}

void array_alloc_scalar_string_array(string_array_t* dest, int n, modelica_string first, ...) {
  va_list ap;
  simple_alloc_1d_string_array(dest, n);
  va_start(ap, first);
  put_string_element(first, 0, dest);
  for (int i = 1; i < n; ++i) {
    put_string_element(va_arg(ap, modelica_string), i, dest);
  }
  va_end(ap);
}

void simple_alloc_1d_string_array(string_array_t* dest, int n) {
  simple_alloc_1d_base_array(dest, n, new m_string[n]());
}


void put_string_element(modelica_string value, int i1, string_array_t *dest) {
  /* Assert that dest has correct dimension */
  /* Assert that i1 is a valid index */
  string_set(dest, i1, value);
}

void array_alloc_string_array(string_array_t* dest, int n, string_array_t first, ...) {
  va_list ap;

  string_array_t *elts = reinterpret_cast<string_array_t*>(malloc(sizeof(string_array_t) * n));
  assert(elts);
  /* collect all array ptrs to simplify traversal.*/
  va_start(ap, first);
  elts[0] = first;
  for (int i = 1; i < n; ++i) {
    elts[i] = va_arg(ap, string_array_t);
  }
  va_end(ap);

  check_base_array_dim_sizes(elts, n);

  if (first.ndims == 1) {
    alloc_string_array(dest, 2, n, first.dim_size[0]);
  } else if (first.ndims == 2) {
    alloc_string_array(dest, 3, n, first.dim_size[0], first.dim_size[1]);
  } else if (first.ndims == 3) {
    alloc_string_array(dest, 4, n, first.dim_size[0], first.dim_size[1], first.dim_size[2]);
  } else if (first.ndims == 4) {
    alloc_string_array(dest, 5, n, first.dim_size[0], first.dim_size[1], first.dim_size[2], first.dim_size[3]);
  } else {
    assert(0 && "Dimension size > 4 not impl. yet");
  }

  int c = 0;
  for (int i = 0; i < n; ++i) {
    int m = base_array_nr_of_elements(elts[i]);
    for (int j = 0; j < m; ++j) {
      string_set(dest, c, string_get(elts[i], j));
      ++c;
    }
  }
  free(elts);
}

void alloc_string_array(string_array_t *dest, int ndims, ...) {
  size_t elements = 0;
  va_list ap;
  va_start(ap, ndims);
  elements = alloc_base_array(dest, ndims, ap);
  va_end(ap);
  dest->data = new m_string[elements]();
}

void check_base_array_dim_sizes(const base_array_t *elts, int n) {
  int ndims = elts[0].ndims;
  for (int i = 1; i < n; ++i) {
    assert(elts[i].ndims == ndims && "Not same number of dimensions");
  }
  for (int curdim = 0; curdim < ndims; ++curdim) {
    int dimsize = elts[0].dim_size[curdim];
    for (int i = 1; i < n; ++i) {
      assert(dimsize == elts[i].dim_size[curdim]
                                         && "Dimensions size not same");
    }
  }
}

void simple_alloc_1d_base_array(base_array_t *dest, int n, void *data) {
  dest->ndims = 1;
  dest->dim_size = new _index_t[1]();
  dest->dim_size[0] = n;
  dest->data = data;
}


void alloc_real_array(real_array_t *dest, int ndims, ...) {
  va_list ap;
  va_start(ap, ndims);
  size_t elements = alloc_base_array(dest, ndims, ap);
  va_end(ap);
  dest->data = new modelica_real[elements]();
}

size_t alloc_base_array(base_array_t *dest, int ndims, va_list ap) {
  size_t nr_of_elements = 1;

  dest->ndims = ndims;
  dest->dim_size = new _index_t[ndims]();

  for (int i = 0; i < ndims; ++i) {
    dest->dim_size[i] = va_arg(ap, _index_t);
    nr_of_elements *= dest->dim_size[i];
  }

  return nr_of_elements;
}

void copy_real_array_data_mem(const real_array_t source, modelica_real *dest) {
  size_t nr_of_elements = base_array_nr_of_elements(source);

  for (size_t i = 0; i < nr_of_elements; ++i) {
    dest[i] = real_get(source, i);
  }
}

void array_alloc_scalar_real_array(real_array_t* dest, int n, modelica_real first, ...) {
  va_list ap;
  simple_alloc_1d_real_array(dest, n);
  va_start(ap, first);
  put_real_element(first, 0, dest);
  for (int i = 1; i < n; ++i) {
    put_real_element(va_arg(ap, modelica_real), i, dest);
  }
  va_end(ap);
}

static inline void* generic_ptrget(const base_array_t *a, size_t sze, size_t i) {
  return (reinterpret_cast<char*>(a->data)) + (i*sze);
}

size_t calc_base_index_va(const base_array_t *source, int ndims, va_list ap) {
  int i;
  size_t index;

  index = 0;
  for (i = 0; i < ndims; ++i) {
    int sub_i = va_arg(ap, _index_t) - 1;
    if (sub_i < 0 || sub_i >= source->dim_size[i]) {
      assert(0 && "Dimension overflow");
    }
    index = (index * source->dim_size[i]) + sub_i;
  }

  return index;
}

void* generic_array_element_addr(const base_array_t* source, size_t sze, int ndims, ...) {
  va_list ap;
  void* tmp;
  va_start(ap, ndims);
  tmp = generic_ptrget(source, calc_base_index_va(source, ndims, ap), sze);
  va_end(ap);
  return tmp;
}

#ifdef __clang__
#pragma clang diagnostic pop
# endif  // __clang__
