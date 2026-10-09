//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file  MATMatrix.cpp
 *
 * @brief Sparse matrix to export : implementation file
 *
 */

#include "MATMatrix.h"

#include <cassert>
#include <utility>

namespace matrix {

Matrix::Matrix() :
Matrix(0, 0, Storage::BY_ROWS, {0}, {}, {}) {
}

Matrix::Matrix(const unsigned int nbRows, const unsigned int nbColumns, const Storage storage, std::vector<unsigned int> pointers,
               std::vector<unsigned int> indexes, std::vector<double> values) :
nbRows_(nbRows),
nbColumns_(nbColumns),
storage_(storage),
pointers_(std::move(pointers)),
indexes_(std::move(indexes)),
values_(std::move(values)) {
  assert(pointers_.size() == (storage_ == Storage::BY_ROWS ? nbRows_ : nbColumns_) + 1);
  assert(indexes_.size() == values_.size());
  assert(pointers_.back() == values_.size());
}

Matrix
Matrix::transposed() const {
  return Matrix(nbColumns_, nbRows_, storage_ == Storage::BY_ROWS ? Storage::BY_COLUMNS : Storage::BY_ROWS, pointers_, indexes_, values_);
}

}  // namespace matrix
