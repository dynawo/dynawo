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
 * @file API/MAT/test/TestTxtExporter.cpp
 * @brief Unit tests for API_MAT TXT exporter
 *
 */

#include <fstream>
#include <sstream>
#include <string>

#include "DYNFileSystemUtils.h"
#include "DYNSparseMatrix.h"
#include "MATLinearizedSystem.h"
#include "MATMatrix.h"
#include "MATSparseMatrixConversion.h"
#include "MATTxtExporter.h"
#include "gtest_dynawo.h"

namespace matrix {

static const char outputDirectory[] = "matrices";

static std::string
readFile(const std::string& fileName) {
  std::ifstream file(createAbsolutePath(fileName, outputDirectory));
  std::stringstream content;
  content << file.rdbuf();
  return content.str();
}

static void
createOutputDirectory() {
  if (!isDirectory(outputDirectory))
    createDirectory(outputDirectory);
}

// 2x3 matrix
// | 1 0 3   |
// | 0 2 4.5 |

// stored by columns: the values of column j are values[k] for k in [pointers[j], pointers[j + 1]), in row indexes[k]
// - column 0: k in [0, 1) -> 1 in row 0
// - column 1: k in [1, 2) -> 2 in row 1
// - column 2: k in [2, 4) -> 3 in row 0, 4.5 in row 1
static Matrix
matrixByColumns() {
  return Matrix(2, 3, Matrix::Storage::BY_COLUMNS, {0, 1, 2, 4}, {0, 1, 0, 1}, {1., 2., 3., 4.5});
}

// stored by rows: the values of row i are values[k] for k in [pointers[i], pointers[i + 1]), in column indexes[k]
// - row 0: k in [0, 2) -> 1 in column 0, 3 in column 2
// - row 1: k in [2, 4) -> 2 in column 1, 4.5 in column 2
static Matrix
matrixByRows() {
  return Matrix(2, 3, Matrix::Storage::BY_ROWS, {0, 2, 4}, {0, 2, 1, 2}, {1., 3., 2., 4.5});
}

TEST(APIMATTest, TxtExporterMatrixByColumns) {
  createOutputDirectory();
  TxtExporter exporter;
  exporter.exportMatrix(matrixByColumns(), outputDirectory, "byColumns");

  ASSERT_EQ(readFile("byColumns.txt"), "0;0;1\n1;1;2\n0;2;3\n1;2;4.5\n");
  ASSERT_EQ(readFile("byColumns_Ap.txt"), "0\n1\n2\n4\n");
  ASSERT_EQ(readFile("byColumns_Ai.txt"), "0\n1\n0\n1\n");
  ASSERT_EQ(readFile("byColumns_Ax.txt"), "1\n2\n3\n4.5\n");
}

TEST(APIMATTest, TxtExporterMatrixByRows) {
  createOutputDirectory();
  TxtExporter exporter;
  exporter.exportMatrix(matrixByRows(), outputDirectory, "byRows");

  // same (row;column;value) as the matrix stored by columns, ordered by rows
  ASSERT_EQ(readFile("byRows.txt"), "0;0;1\n0;2;3\n1;1;2\n1;2;4.5\n");
  ASSERT_EQ(readFile("byRows_Ap.txt"), "0\n2\n4\n");
  ASSERT_EQ(readFile("byRows_Ai.txt"), "0\n2\n1\n2\n");
  ASSERT_EQ(readFile("byRows_Ax.txt"), "1\n3\n2\n4.5\n");
}

TEST(APIMATTest, TxtExporterMatrixPrecision) {
  createOutputDirectory();
  TxtExporter exporter;
  exporter.exportMatrix(Matrix(1, 1, Matrix::Storage::BY_ROWS, {0, 1}, {0}, {0.1234567890123456789}), outputDirectory, "precision");

  ASSERT_EQ(readFile("precision.txt"), "0;0;0.1234567890123457\n");
  ASSERT_EQ(readFile("precision_Ax.txt"), "0.1234567890123457\n");
}

TEST(APIMATTest, TxtExporterLinearizedSystem) {
  createOutputDirectory();
  LinearizedSystem linearizedSystem(2.5);
  linearizedSystem.setJacobian(matrixByRows());
  // 2x3 prim jacobian stored by rows, row 0 has the value k in [0, 1), -1 in column 0, row 1 is empty (k in [1, 1))
  // | -1 0 0 |
  // |  0 0 0 |
  linearizedSystem.setJacobianPrim(Matrix(2, 3, Matrix::Storage::BY_ROWS, {0, 1, 1}, {0}, {-1.}));
  linearizedSystem.addVariable("x", "model1", "DIFFERENTIAL");
  linearizedSystem.addVariable("y", "model1", "ALGEBRAIC");
  linearizedSystem.addVariable("z", "model2", "ALGEBRAIC");
  linearizedSystem.addEquation("DIFFERENTIAL");
  linearizedSystem.addEquation("ALGEBRAIC");

  TxtExporter exporter;
  exporter.exportLinearizedSystem(linearizedSystem, outputDirectory);

  ASSERT_EQ(readFile("linearization_2.5.txt"), "0;0;1\n0;2;3\n1;1;2\n1;2;4.5\n");
  ASSERT_EQ(readFile("linearization_2.5_Ap.txt"), "0\n2\n4\n");
  ASSERT_EQ(readFile("linearization_2.5_Ai.txt"), "0\n2\n1\n2\n");
  ASSERT_EQ(readFile("linearization_2.5_Ax.txt"), "1\n3\n2\n4.5\n");
  ASSERT_EQ(readFile("linearization_prim_2.5.txt"), "0;0;-1\n");
  ASSERT_EQ(readFile("linearization_prim_2.5_Ap.txt"), "0\n1\n1\n");
  ASSERT_EQ(readFile("linearization_prim_2.5_Ai.txt"), "0\n");
  ASSERT_EQ(readFile("linearization_prim_2.5_Ax.txt"), "-1\n");
  ASSERT_EQ(readFile("linearization_variables_name_2.5.txt"), "0;model1_x;model1\n1;model1_y;model1\n2;model2_z;model2\n");
  ASSERT_EQ(readFile("linearization_variables_type_2.5.txt"), "0;DIFFERENTIAL\n1;ALGEBRAIC\n2;ALGEBRAIC\n");
  ASSERT_EQ(readFile("linearization_equations_type_2.5.txt"), "0;DIFFERENTIAL\n1;ALGEBRAIC\n");
}

TEST(APIMATTest, TxtExporterDenseMatrixByColumns) {
  createOutputDirectory();
  TxtExporter exporter(TxtExporter::MatrixFormat::DENSE);
  exporter.exportMatrix(matrixByColumns(), outputDirectory, "denseByColumns");

  ASSERT_EQ(readFile("denseByColumns.txt"), "1;0;3;\n0;2;4.5;\n");
  ASSERT_FALSE(exists(createAbsolutePath("denseByColumns_Ap.txt", outputDirectory)));
}

TEST(APIMATTest, TxtExporterDenseMatrixByRows) {
  createOutputDirectory();
  TxtExporter exporter(TxtExporter::MatrixFormat::DENSE);
  exporter.exportMatrix(matrixByRows(), outputDirectory, "denseByRows");

  ASSERT_EQ(readFile("denseByRows.txt"), "1;0;3;\n0;2;4.5;\n");
}

TEST(APIMATTest, TxtExporterDenseMatrixPrecision) {
  createOutputDirectory();
  TxtExporter exporter(TxtExporter::MatrixFormat::DENSE);
  exporter.exportMatrix(Matrix(1, 1, Matrix::Storage::BY_ROWS, {0, 1}, {0}, {0.1234567890123456789}), outputDirectory, "densePrecision");

  ASSERT_EQ(readFile("densePrecision.txt"), "0.12346;\n");
}

TEST(APIMATTest, TxtExporterSparseMatrix) {
  // 3x3 dynawo sparse matrix
  // | 0 2 0 |
  // | 1 0 4 |
  // | 0 3 0 |
  DYN::SparseMatrix sparseMatrix;
  sparseMatrix.init(3, 3);
  sparseMatrix.changeCol();
  sparseMatrix.addTerm(1, 1.);
  sparseMatrix.changeCol();
  sparseMatrix.addTerm(0, 2.);
  sparseMatrix.addTerm(2, 3.);
  sparseMatrix.changeCol();
  sparseMatrix.addTerm(1, 4.);

  createOutputDirectory();
  TxtExporter().exportMatrix(fromSparseMatrix(sparseMatrix), outputDirectory, "sparse");
  ASSERT_EQ(readFile("sparse.txt"), "1;0;1\n0;1;2\n2;1;3\n1;2;4\n");

  TxtExporter(TxtExporter::MatrixFormat::DENSE).exportMatrix(fromSparseMatrix(sparseMatrix), outputDirectory, "dense");
  ASSERT_EQ(readFile("dense.txt"), "0;2;0;\n1;0;4;\n0;3;0;\n");
}

TEST(APIMATTest, TxtExporterLinearizedSystemAlwaysSparse) {
  createOutputDirectory();
  LinearizedSystem linearizedSystem(7.);
  linearizedSystem.setJacobian(matrixByRows());

  TxtExporter exporter(TxtExporter::MatrixFormat::DENSE);
  exporter.exportLinearizedSystem(linearizedSystem, outputDirectory);

  ASSERT_EQ(readFile("linearization_7.txt"), "0;0;1\n0;2;3\n1;1;2\n1;2;4.5\n");
  ASSERT_EQ(readFile("linearization_7_Ap.txt"), "0\n2\n4\n");
}

TEST(APIMATTest, TxtExporterMissingDirectory) {
  TxtExporter exporter;
  ASSERT_THROW_DYNAWO(exporter.exportMatrix(matrixByRows(), "missingDirectory", "matrix"), DYN::Error::API, DYN::KeyError_t::FileGenerationFailed);
}

}  // namespace matrix
