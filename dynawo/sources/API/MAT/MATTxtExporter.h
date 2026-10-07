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
 * @file  MATTxtExporter.h
 *
 * @brief Matrices TXT exporter : header file
 *
 */

#ifndef API_MAT_MATTXTEXPORTER_H_
#define API_MAT_MATTXTEXPORTER_H_

#include "MATExporter.h"

namespace matrix {

/**
 * @class TxtExporter
 * @brief TXT exporter class, values separated by ';'
 *
 * Sparse format: name.txt (row;column;value) and name_Ap/_Ai/_Ax.txt (compressed arrays). Dense format: name.txt (one line per row).
 * A linearized system is always exported in the sparse format, in files prefixed by linearization_t.
 */
class TxtExporter : public Exporter {
 public:
  /**
   * @brief format of the exported matrices
   */
  enum class MatrixFormat {
    SPARSE,  ///< non-zero values only, with full precision
    DENSE  ///< all the values, with 5 significant digits, to read small matrices
  };

  /**
   * @brief constructor
   *
   * @param matrixFormat format of the exported matrices
   */
  explicit TxtExporter(MatrixFormat matrixFormat = MatrixFormat::SPARSE);

  /**
   * @copydoc Exporter::exportMatrix
   */
  void exportMatrix(const Matrix& matrix, const std::string& directory, const std::string& name) const override;

  /**
   * @copydoc Exporter::exportLinearizedSystem
   */
  void exportLinearizedSystem(const LinearizedSystem& linearizedSystem, const std::string& directory) const override;

 private:
  /**
   * @brief export a matrix in the sparse format
   *
   * @param matrix matrix to export
   * @param directory existing directory where the files are created
   * @param name name of the matrix, used to name the files
   */
  void exportSparseMatrix(const Matrix& matrix, const std::string& directory, const std::string& name) const;

  /**
   * @brief export a matrix in the dense format
   *
   * @param matrix matrix to export
   * @param directory existing directory where the file is created
   * @param name name of the matrix, used to name the file
   */
  void exportDenseMatrix(const Matrix& matrix, const std::string& directory, const std::string& name) const;

  MatrixFormat matrixFormat_;  ///< format of the exported matrices
};

}  // namespace matrix

#endif  // API_MAT_MATTXTEXPORTER_H_
