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
 * @file  MATExporter.h
 *
 * @brief Matrices exporter : interface class
 *
 */

#ifndef API_MAT_MATEXPORTER_H_
#define API_MAT_MATEXPORTER_H_

#include "MATLinearizedSystem.h"
#include "MATMatrix.h"

#include <string>

namespace matrix {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class Exporter
 * @brief Exporter interface class
 *
 * Exporter class for matrices and the information attached to them, one implementation per export format
 */
class Exporter {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Exporter() = default;

  /**
   * @brief Export a matrix
   *
   * @param matrix matrix to export
   * @param directory existing directory where the file(s) are created
   * @param name name of the matrix, used to name the file(s)
   */
  virtual void exportMatrix(const Matrix& matrix, const std::string& directory, const std::string& name) const = 0;

  /**
   * @brief Export a linearized system: its jacobians and the description of its variables and equations
   *
   * @param linearizedSystem linearized system to export
   * @param directory existing directory where the files are created
   */
  virtual void exportLinearizedSystem(const LinearizedSystem& linearizedSystem, const std::string& directory) const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace matrix

#endif  // API_MAT_MATEXPORTER_H_
