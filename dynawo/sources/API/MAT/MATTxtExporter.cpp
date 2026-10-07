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
 * @file  MATTxtExporter.cpp
 *
 * @brief Matrices TXT exporter : implementation file
 *
 */

#include "MATTxtExporter.h"

#include <fstream>
#include <iomanip>
#include <sstream>
#include <vector>

#include "DYNFileSystemUtils.h"
#include "DYNMacrosMessage.h"

namespace matrix {

static const char TXTEXPORTER_SEPARATOR = ';';  ///< separator to use in txt files
static const int TXTEXPORTER_PRECISION = 16;  ///< number of significant digits of the exported values
static const int TXTEXPORTER_DENSE_PRECISION = 5;  ///< number of significant digits of the values exported in the dense format

/**
 * @brief open a file to write in
 *
 * @param directory directory of the file
 * @param fileName name of the file
 * @param file stream to open
 */
static void
openFile(const std::string& directory, const std::string& fileName, std::ofstream& file) {
  const std::string filePath = createAbsolutePath(fileName, directory);
  file.open(filePath.c_str(), std::ofstream::out);
  if (!file.is_open())
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath);
  file << std::setprecision(TXTEXPORTER_PRECISION);
}

/**
 * @brief export a vector in a file, one line per element
 *
 * @param vector vector to export
 * @param directory directory of the file
 * @param fileName name of the file
 */
template<typename T>
static void
exportVector(const std::vector<T>& vector, const std::string& directory, const std::string& fileName) {
  std::ofstream file;
  openFile(directory, fileName, file);
  for (const auto& element : vector)
    file << element << "\n";
}

TxtExporter::TxtExporter(const MatrixFormat matrixFormat) :
matrixFormat_(matrixFormat) {
}

void
TxtExporter::exportMatrix(const Matrix& matrix, const std::string& directory, const std::string& name) const {
  if (matrixFormat_ == MatrixFormat::DENSE)
    exportDenseMatrix(matrix, directory, name);
  else
    exportSparseMatrix(matrix, directory, name);
}

void
TxtExporter::exportSparseMatrix(const Matrix& matrix, const std::string& directory, const std::string& name) const {
  std::ofstream file;
  openFile(directory, name + ".txt", file);
  const bool byRows = matrix.getStorage() == Matrix::Storage::BY_ROWS;
  const std::vector<unsigned int>& pointers = matrix.getPointers();
  const std::vector<unsigned int>& indexes = matrix.getIndexes();
  const std::vector<double>& values = matrix.getValues();
  for (unsigned int i = 0; i + 1 < pointers.size(); ++i) {
    for (unsigned int k = pointers[i]; k < pointers[i + 1]; ++k) {
      const unsigned int row = byRows ? i : indexes[k];
      const unsigned int column = byRows ? indexes[k] : i;
      file << row << TXTEXPORTER_SEPARATOR << column << TXTEXPORTER_SEPARATOR << values[k] << "\n";
    }
  }

  exportVector(pointers, directory, name + "_Ap.txt");
  exportVector(indexes, directory, name + "_Ai.txt");
  exportVector(values, directory, name + "_Ax.txt");
}

void
TxtExporter::exportDenseMatrix(const Matrix& matrix, const std::string& directory, const std::string& name) const {
  std::vector<std::vector<double> > denseMatrix(matrix.getNbRows(), std::vector<double>(matrix.getNbColumns(), 0.));
  const bool byRows = matrix.getStorage() == Matrix::Storage::BY_ROWS;
  const std::vector<unsigned int>& pointers = matrix.getPointers();
  const std::vector<unsigned int>& indexes = matrix.getIndexes();
  const std::vector<double>& values = matrix.getValues();
  for (unsigned int i = 0; i + 1 < pointers.size(); ++i) {
    for (unsigned int k = pointers[i]; k < pointers[i + 1]; ++k) {
      if (byRows)
        denseMatrix[i][indexes[k]] = values[k];
      else
        denseMatrix[indexes[k]][i] = values[k];
    }
  }

  std::ofstream file;
  openFile(directory, name + ".txt", file);
  file << std::setprecision(TXTEXPORTER_DENSE_PRECISION);
  for (const auto& row : denseMatrix) {
    for (const auto value : row)
      file << value << TXTEXPORTER_SEPARATOR;
    file << "\n";
  }
}

void
TxtExporter::exportLinearizedSystem(const LinearizedSystem& linearizedSystem, const std::string& directory) const {
  std::stringstream time;
  time << linearizedSystem.getTime();

  exportSparseMatrix(linearizedSystem.getJacobian(), directory, "linearization_" + time.str());
  exportSparseMatrix(linearizedSystem.getJacobianPrim(), directory, "linearization_prim_" + time.str());

  std::ofstream fileVariablesName;
  openFile(directory, "linearization_variables_name_" + time.str() + ".txt", fileVariablesName);
  std::ofstream fileVariablesType;
  openFile(directory, "linearization_variables_type_" + time.str() + ".txt", fileVariablesType);
  const std::vector<LinearizedSystem::Variable>& variables = linearizedSystem.getVariables();
  for (unsigned int i = 0; i < variables.size(); ++i) {
    fileVariablesName << i << TXTEXPORTER_SEPARATOR << variables[i].modelName << "_" << variables[i].name
                      << TXTEXPORTER_SEPARATOR << variables[i].modelName << "\n";
    fileVariablesType << i << TXTEXPORTER_SEPARATOR << variables[i].type << "\n";
  }

  std::ofstream fileEquationsType;
  openFile(directory, "linearization_equations_type_" + time.str() + ".txt", fileEquationsType);
  const std::vector<LinearizedSystem::Equation>& equations = linearizedSystem.getEquations();
  for (unsigned int i = 0; i < equations.size(); ++i)
    fileEquationsType << i << TXTEXPORTER_SEPARATOR << equations[i].type << "\n";
}

}  // namespace matrix
