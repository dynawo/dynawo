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
 * @file Common/Test.cpp
 * @brief Unit tests for Common lib
 *
 */

#include <boost/filesystem.hpp>
#include <fstream>
#include <cmath>

#include "gtest_dynawo.h"
#include "DYNCommon.h"
#include "DYNSparseMatrix.h"
#include "DYNEnumUtils.h"
#include "DYNFileSystemUtils.h"

namespace DYN {

TEST(CommonTest, testCommonVarC) {
  // typeVarC2Str
  ASSERT_EQ(typeVarC2Str(VAR_TYPE_DOUBLE), "DOUBLE");
  ASSERT_EQ(typeVarC2Str(VAR_TYPE_STRING), "STRING");
  ASSERT_EQ(typeVarC2Str(VAR_TYPE_INT), "INT");
  ASSERT_EQ(typeVarC2Str(VAR_TYPE_BOOL), "BOOL");

  // str2TypeVarC
  ASSERT_EQ(str2TypeVarC("DOUBLE"), VAR_TYPE_DOUBLE);
  ASSERT_EQ(str2TypeVarC("INT"), VAR_TYPE_INT);
  ASSERT_EQ(str2TypeVarC("BOOL"), VAR_TYPE_BOOL);
  ASSERT_EQ(str2TypeVarC("STRING"), VAR_TYPE_STRING);

  ASSERT_THROW_DYNAWO(str2TypeVarC("ABCDEF"), Error::MODELER, KeyError_t::TypeVarCUnableToConvert);


  ASSERT_EQ(sign(-1.), -1);
  ASSERT_EQ(sign(1.), 1);
  ASSERT_EQ(sign(0), 1);
}

TEST(CommonTest, testCommonDynawoDoublesEquality) {
  ASSERT_TRUE(doubleEquals(0.1, 0.10000001));
  ASSERT_TRUE(doubleEquals(0.1, 0.1000001));
  ASSERT_FALSE(doubleEquals(0.1, 0.100001));
  ASSERT_FALSE(doubleNotEquals(0.1, 0.10000001));
  ASSERT_FALSE(doubleNotEquals(0.1, 0.1000001));
  ASSERT_TRUE(doubleNotEquals(0.1, 0.100001));
  ASSERT_EQ(getPrecisionAsNbDecimal(), 6);
  ASSERT_EQ(getCurrentPrecision(), 1e-6);
  setCurrentPrecision(1e-7);
  ASSERT_EQ(getPrecisionAsNbDecimal(), 7);
  ASSERT_EQ(getCurrentPrecision(), 1e-7);
  ASSERT_TRUE(doubleEquals(0.1, 0.100000001));
  ASSERT_TRUE(doubleEquals(0.1, 0.10000001));
  ASSERT_FALSE(doubleEquals(0.1, 0.1000001));
  ASSERT_FALSE(doubleEquals(0.1, 0.100001));
  ASSERT_FALSE(doubleNotEquals(0.1, 0.100000001));
  ASSERT_FALSE(doubleNotEquals(0.1, 0.10000001));
  ASSERT_TRUE(doubleNotEquals(0.1, 0.1000001));
  ASSERT_TRUE(doubleNotEquals(0.1, 0.100001));
}

TEST(CommonTest, testCommonToNativeBool) {
  ASSERT_TRUE(toNativeBool(1.));
  ASSERT_FALSE(toNativeBool(0.));
  ASSERT_FALSE(toNativeBool(-1.));
}

TEST(CommonTest, testSparseMatrix) {
  // withoutNan
  SparseMatrix smj;
  smj.init(3, 3);
  smj.changeCol();
  double zero = 0.0;
  smj.addTerm(1, 1./zero);
  smj.changeCol();
  smj.addTerm(0, 2.);
  smj.addTerm(2, 3.);
  smj.changeCol();
  smj.addTerm(1, 4.);

  ASSERT_EQ(smj.withoutNan(), true);
  ASSERT_EQ(smj.withoutInf(), false);

  // withoutInf
  SparseMatrix smj2;
  smj2.init(3, 3);
  smj2.changeCol();
  smj2.addTerm(1, nan(""));
  smj2.changeCol();
  smj2.addTerm(0, 2.);
  smj2.addTerm(2, 3.);
  smj2.changeCol();
  smj2.addTerm(1, 4.);

  ASSERT_EQ(smj2.withoutNan(), false);
  ASSERT_EQ(smj2.withoutInf(), true);

  // reserve
  SparseMatrix smj3;
  smj3.init(3, 3);
  smj3.changeCol();
  smj3.addTerm(1, 1.);
  smj3.changeCol();
  smj3.addTerm(0, 2.);
  smj3.addTerm(2, 3.);
  smj3.changeCol();
  smj3.addTerm(1, 4.);
  ASSERT_EQ(smj3.nbCol(), 3);
  ASSERT_EQ(smj3.nbElem(), 4);

  // print
  smj3.print();
  smj3.printToFile(true);
  std::string line;
  std::ifstream myfile("tmpMat/mat-0.txt");
  unsigned index = 0;
  if (myfile.is_open()) {
    while (std::getline(myfile, line)) {
      if (index == 0) {
        ASSERT_EQ(line, "1;0;1");
      } else if (index == 1) {
        ASSERT_EQ(line, "0;1;2");
      } else if (index == 2) {
        ASSERT_EQ(line, "2;1;3");
      } else if (index == 3) {
        ASSERT_EQ(line, "1;2;4");
      } else {
        assert(0);
      }
      ++index;
    }
    ASSERT_EQ(index, 4);
    myfile.close();
  } else {
    assert(0);
  }
  smj3.printToFile(false);
  std::ifstream myfile2("tmpMat/mat-1.txt");
  index = 0;
  if (myfile2.is_open()) {
    while (std::getline(myfile2, line)) {
      if (index == 0) {
        ASSERT_EQ(line, "0;2;0;");
      } else if (index == 1) {
        ASSERT_EQ(line, "1;0;4;");
      } else if (index == 2) {
        ASSERT_EQ(line, "0;3;0;");
      } else {
        assert(0);
      }
      ++index;
    }
    ASSERT_EQ(index, 3);
    myfile2.close();
  } else {
    assert(0);
  }

  remove_all_in_directory("tmpMat");
  remove("tmpMat");

  // erase
  boost::unordered_set<int> rows;
  rows.insert(0);
  boost::unordered_set<int> columns;
  columns.insert(1);
  SparseMatrix M;
  M.init(2, 2);
  smj3.erase(rows, columns, M);
  ASSERT_EQ(M.nbCol(), 2);
  ASSERT_EQ(M.nbElem(), 2);
  ASSERT_EQ(M.Ap_[0], 0);
  ASSERT_EQ(M.Ap_[1], 1);
  ASSERT_EQ(M.Ap_[2], 2);
  ASSERT_EQ(M.Ai_[0], 0);
  ASSERT_EQ(M.Ai_[1], 0);
  ASSERT_EQ(M.Ax_[0], 1);
  ASSERT_EQ(M.Ax_[1], 4);

  // reserve
  smj3.reserve(2);
  ASSERT_EQ(smj3.nbCol(), 0);
  ASSERT_EQ(smj3.nbElem(), 0);

  // increaseReserve
  SparseMatrix smj4;
  smj4.init(55, 1);
  smj4.changeCol();
  for (unsigned i = 0; i < 55; ++i) {
    smj4.addTerm(i, i);
  }
  for (int icol = 0; icol < smj4.nbCol(); ++icol) {
    for (unsigned int ind = smj4.Ap_[icol]; ind < smj4.Ap_[icol + 1]; ++ind) {
      int ilig = smj4.Ai_[ind];
      double val = smj4.Ax_[ind];
      ASSERT_EQ(ilig, ind+1);
      ASSERT_EQ(val, ind+1);
    }
  }

  // Test on norms
  SparseMatrix mat;
  mat.init(6, 6);

  mat.changeCol();
  mat.addTerm(0, 10);
  mat.addTerm(1, 3);
  mat.addTerm(3, 3);
  mat.changeCol();
  mat.addTerm(1, 9);
  mat.addTerm(2, 7);
  mat.addTerm(4, 8);
  mat.addTerm(5, 4);
  mat.changeCol();
  mat.addTerm(2, 8);
  mat.addTerm(3, 8);
  mat.changeCol();
  mat.addTerm(2, 7);
  mat.addTerm(3, 7);
  mat.addTerm(4, 9);
  mat.changeCol();
  mat.addTerm(0, -2);
  mat.addTerm(3, 5);
  mat.addTerm(4, 9);
  mat.addTerm(5, 2);
  mat.changeCol();
  mat.addTerm(1, 3);
  mat.addTerm(4, 13);
  mat.addTerm(5, -1);

  double norm = std::sqrt(10*10 + 3*3 + 3*3 + 9*9 + 7*7 + 8*8 + 4*4 + 8*8 + 8*8 + 7*7 + 7*7 + 9*9 + 2*2 + 5*5 + 9*9 + 2*2 + 3*3 + 13*13 + 1);
  ASSERT_DOUBLE_EQ(mat.frobeniusNorm(), norm);  // 30.46309242345563461640
  ASSERT_EQ(mat.norm1(), 28.);
  ASSERT_EQ(mat.infinityNorm(), 39.);

  // check
  mat.init(3, 3);
  mat.changeCol();
  mat.addTerm(0, 1.);
  mat.changeCol();
  mat.addTerm(1, 1.);
  mat.addTerm(2, 1.);
  mat.changeCol();
  // no term

  SparseMatrix::CheckError check_status = mat.check();
  ASSERT_EQ(SparseMatrix::CHECK_ZERO_COLUMN, check_status.code);
  ASSERT_EQ(2, check_status.info);

  mat.init(3, 3);
  mat.changeCol();
  mat.addTerm(0, 1.);
  mat.changeCol();
  mat.addTerm(0, 1.);
  mat.changeCol();
  mat.addTerm(2, 1.);

  check_status = mat.check();
  ASSERT_EQ(SparseMatrix::CHECK_ZERO_ROW, check_status.code);
  ASSERT_EQ(1, check_status.info);
}


TEST(CommonTest, testEnumUtils) {
  ASSERT_EQ(modeChangeType2Str(NO_MODE), "No mode change");
  ASSERT_EQ(modeChangeType2Str(DIFFERENTIAL_MODE), "Differential mode change");
  ASSERT_EQ(modeChangeType2Str(ALGEBRAIC_MODE), "Algebraic mode change");
  ASSERT_EQ(modeChangeType2Str(ALGEBRAIC_J_UPDATE_MODE), "Algebraic mode (with J recalculation) change");

  ASSERT_EQ(propertyVar2Str(DIFFERENTIAL), "DIFFERENTIAL");
  ASSERT_EQ(propertyVar2Str(ALGEBRAIC), "ALGEBRAIC");
  ASSERT_EQ(propertyVar2Str(EXTERNAL), "EXTERNAL");
  ASSERT_EQ(propertyVar2Str(OPTIONAL_EXTERNAL), "OPTIONAL_EXTERNAL");
  ASSERT_EQ(propertyVar2Str(UNDEFINED_PROPERTY), "UNDEFINED");

  ASSERT_EQ(typeVar2Str(DISCRETE), "DISCRETE");
  ASSERT_EQ(typeVar2Str(CONTINUOUS), "CONTINUOUS");
  ASSERT_EQ(typeVar2Str(FLOW), "FLOW");
  ASSERT_EQ(typeVar2Str(INTEGER), "INTEGER");
  ASSERT_EQ(typeVar2Str(BOOLEAN), "BOOLEAN");
  ASSERT_EQ(typeVar2Str(UNDEFINED_TYPE), "UNDEFINED");

  ASSERT_EQ(toCTypeVar(DISCRETE), VAR_TYPE_DOUBLE);
  ASSERT_EQ(toCTypeVar(CONTINUOUS), VAR_TYPE_DOUBLE);
  ASSERT_EQ(toCTypeVar(FLOW), VAR_TYPE_DOUBLE);
  ASSERT_EQ(toCTypeVar(BOOLEAN), VAR_TYPE_BOOL);
  ASSERT_EQ(toCTypeVar(INTEGER), VAR_TYPE_INT);

  ASSERT_EQ(paramScope2Str(EXTERNAL_PARAMETER), "external parameter");
  ASSERT_EQ(paramScope2Str(SHARED_PARAMETER), "shared parameter");
  ASSERT_EQ(paramScope2Str(INTERNAL_PARAMETER), "internal parameter");
}

TEST(CommonTest, testLevensteinDistance) {
  ASSERT_EQ(LevensteinDistance("MyString", "MyStriag", 1 , 2 , 3), 3);
  ASSERT_EQ(LevensteinDistance("MyString", "MyStrinng", 1 , 2 , 3), 1);
  ASSERT_EQ(LevensteinDistance("MyString", "MyStrig", 1 , 2 , 3), 2);
}

TEST(CommonTest, testdouble2String) {
  ASSERT_EQ(double2String(123456789.123456789), "1.2345679e+08");
  ASSERT_EQ(double2String(1234.1234), "1234.1234000");
}
}  // namespace DYN
