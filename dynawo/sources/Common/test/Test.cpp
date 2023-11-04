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
#include "DYNFileSystemUtils.h"
#include "DYNError.h"
#include "DYNError_keys.h"
#include "DYNTrace.h"
#include "DYNSparseMatrix.h"
#include "DYNEnumUtils.h"
#include "DYNTimer.h"

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

TEST(CommonTest, testFileSystemUtilsSearchFileNonExistant) {
  ASSERT_THROW_DYNAWO(searchFile("myPath", "", true), DYN::Error::GENERAL, DYN::KeyError_t::FileSystemItemDoesNotExist);
}

TEST(CommonTest, testFileSystemUtilsSearchFileNotFound) {
  ASSERT_EQ(searchFile("myFile.txt", "res", false), "");
}

TEST(CommonTest, testFileSystemUtilsSearchExistingFile) {
  std::string res = searchFile("myFile.txt", "res", true);
  std::size_t pos = res.find("myFile.txt");
  ASSERT_EQ(res.substr(pos), "myFile.txt");
}

TEST(CommonTest, testFileSystemUtilsSearchModelicaModelsFileNonExistant) {
  std::vector<std::string> filesFound;
  ASSERT_THROW_DYNAWO(searchModelicaModels("myFolder", "mo", true, filesFound), DYN::Error::GENERAL, DYN::KeyError_t::FileSystemItemDoesNotExist);
}

TEST(CommonTest, testFileSystemUtilsSearchFilesAccordingToExtensionsFileNonExistant) {
  std::vector<std::string> fileExtensionsAllowed;
  std::vector<std::string> fileExtensionsForbidden;
  std::vector<std::string> filesFound;
  ASSERT_THROW_DYNAWO(searchFilesAccordingToExtensions("", fileExtensionsAllowed,
      fileExtensionsForbidden,  true, filesFound), DYN::Error::GENERAL, DYN::KeyError_t::FileSystemItemDoesNotExist);
}

TEST(CommonTest, testFileSystemUtilsSearchFilesAccordingToExtensionsExistingFile) {
  std::vector<std::string> fileExtensionsAllowed;
  fileExtensionsAllowed.push_back(".mo");
  std::vector<std::string> fileExtensionsForbidden;
  std::vector<std::string> filesFound;
  searchFilesAccordingToExtensions("res", fileExtensionsAllowed,
      fileExtensionsForbidden,  true, filesFound);
  ASSERT_EQ(filesFound.size(), 4);
}

TEST(CommonTest, testFileSystemUtilsSearchModelicaModelsFileNotFound) {
  std::vector<std::string> filesFound;
  searchModelicaModels("res", "mo", false, filesFound);
  ASSERT_EQ(filesFound.empty(), true);
}

TEST(CommonTest, testFileSystemUtilsSearchModelicaModelsExistingFile) {
  std::vector<std::string> filesFound;
  searchModelicaModels("res", "mo", true, filesFound);
  ASSERT_EQ(filesFound.size(), 3);
  unsigned found = 0;
  for (size_t i = 0; i < filesFound.size(); ++i) {
    std::size_t pos = filesFound[i].find("folder/MyModel.mo");
    if (pos != std::string::npos) {
      ASSERT_EQ(filesFound[i].substr(pos), "folder/MyModel.mo");
      ++found;
    }
  }
  ASSERT_EQ(found, 1);
  found = 0;
  for (size_t i = 0; i < filesFound.size(); ++i) {
    std::size_t pos = filesFound[i].find("folder/folder3/MyModel.mo");
    if (pos != std::string::npos) {
      ASSERT_EQ(filesFound[i].substr(pos), "folder/folder3/MyModel.mo");
      ++found;
    }
  }
  ASSERT_EQ(found, 1);
  found = 0;
  for (size_t i = 0; i < filesFound.size(); ++i) {
    std::size_t pos = filesFound[i].find("folder/folder2/package.mo");
    if (pos != std::string::npos) {
      ASSERT_EQ(filesFound[i].substr(pos), "folder/folder2/package.mo");
      ++found;
    }
  }
  ASSERT_EQ(found, 1);
}

TEST(CommonTest, testFileSystemUtilsSearchModelsFiles) {
  std::vector<std::string> fileExtensionsForbidden;
  std::map<std::string, std::string> filesFound;
  boost::unordered_set<boost::filesystem::path> pathsToIgnore;
  pathsToIgnore.insert(boost::filesystem::path("res/folder/folder3"));
  searchModelsFiles("res", ".mo", fileExtensionsForbidden, pathsToIgnore, true, true, false, filesFound);
  ASSERT_EQ(filesFound.size(), 3);
  assert(filesFound.find("MyModel") != filesFound.end());
  assert(filesFound.find("folder2") != filesFound.end());
  assert(filesFound.find("folder2.MyModel") != filesFound.end());
}

TEST(CommonTest, testFileSystemUtilsCanonical) {
  std::string res = canonical("folder", "res");
  std::size_t pos = res.find("res/folder");
  ASSERT_EQ(res.substr(pos), "res/folder");
}

TEST(CommonTest, testFileSystemUtilsCreateAbsolutePath) {
  ASSERT_EQ(createAbsolutePath("", "res"), "");
}

TEST(CommonTest, testFileSystemUtilsCreateAbsolutePath2) {
  std::string res = createAbsolutePath("folder", "res");
  std::size_t pos = res.find("res/folder");
  ASSERT_EQ(res.substr(pos), "res/folder");
}

TEST(CommonTest, testFileSystemUtilsCurrentPath) {
  std::string res = current_path();
  std::size_t pos = res.rfind("test");
  ASSERT_EQ(res.substr(pos), "test");
  ASSERT_EQ(res.size()-4, pos);
}

TEST(CommonTest, testFileSystemUtilsExtension) {
  ASSERT_EQ(extension("res/folder/MyModel.mo"), ".mo");
}

TEST(CommonTest, testFileSystemUtilsReplaceExtension) {
  std::string res = replace_extension("res/folder/MyModel.mo", "txt");
  std::size_t pos = res.find("MyModel.txt");
  ASSERT_EQ(res.substr(pos), "MyModel.txt");
}

TEST(CommonTest, testFileSystemUtilsExtensionEqualsFail) {
  ASSERT_EQ(extensionEquals("mo", "txt"), false);
}

TEST(CommonTest, testFileSystemUtilsCreateDirectoryAndThenDeleteIt) {
  ASSERT_EQ(is_directory("res/MyFolder"), false);
  create_directory("res/MyFolder");
  ASSERT_EQ(is_directory("res/MyFolder"), true);
  boost::filesystem::path fspath("res/MyFolder");
  ASSERT_EQ(boost::filesystem::remove(fspath), true);
  ASSERT_EQ(is_directory("res/MyFolder"), false);
}

TEST(CommonTest, testFileSystemUtilsExtensionListDirectory) {
  std::list<std::string> res = list_directory("res/folder/");
  ASSERT_EQ(res.size(), 4);
}

TEST(CommonTest, testFileSystemUtilsExtensionRemoveFileName) {
  ASSERT_EQ(remove_file_name("res/folder/MyModel.mo"), "res/folder");
}

TEST(CommonTest, testFileSystemUtilsExtensionRemoveAllInDirectory) {
  ASSERT_EQ(is_directory("res/MyFolder"), false);
  create_directory("res/MyFolder");
  create_directory("res/MyFolder/MyFolder");
  ASSERT_EQ(is_directory("res/MyFolder/MyFolder"), true);
  remove_all_in_directory("res/MyFolder");
  ASSERT_EQ(is_directory("res/MyFolder/MyFolder"), false);
  std::list<std::string> res = list_directory("res/MyFolder");
  ASSERT_EQ(res.empty(), true);
  boost::filesystem::path fspath("res/MyFolder");
  ASSERT_EQ(boost::filesystem::remove(fspath), true);
}

TEST(CommonTest, testTrace) {
  Trace::init();

  // typeVarC2Str
  ASSERT_EQ(Trace::stringFromSeverityLevel(DEBUG), "DEBUG");
  ASSERT_EQ(Trace::stringFromSeverityLevel(INFO), "INFO");
  ASSERT_EQ(Trace::stringFromSeverityLevel(WARN), "WARN");
  ASSERT_EQ(Trace::stringFromSeverityLevel(ERROR), "ERROR");

  // str2TypeVarC
  ASSERT_EQ(Trace::severityLevelFromString("DEBUG"), DEBUG);
  ASSERT_EQ(Trace::severityLevelFromString("INFO"), INFO);
  ASSERT_EQ(Trace::severityLevelFromString("WARN"), WARN);
  ASSERT_EQ(Trace::severityLevelFromString("ERROR"), ERROR);

  ASSERT_THROW_DYNAWO(Trace::severityLevelFromString("ABCDEF"), Error::GENERAL, KeyError_t::InvalidSeverityLevel);

  Trace::TraceAppender app;
  app.setTag("MyTag");
  app.setFilePath("res/myLogFile.log");
  app.setLvlFilter(INFO);
  app.setShowLevelTag(true);
  app.setSeparator(" | ");
  app.setShowTimeStamp(true);
  app.setTimeStampFormat("");
  std::vector<Trace::TraceAppender> appenders;
  appenders.push_back(app);
  Trace::addAppenders(appenders);

  Trace::error("MyTag") << " MyErrorMessage" << Trace::endline;
  TraceStream str(Trace::error("MyTag"));
  str << " MyErrorMessage2" << Trace::endline;
  Trace::warn("MyTag") << " MyWarnMessage" << Trace::endline;
  Trace::info("MyTag") << " MyInfoMessage" << Trace::endline;
  Trace::debug("MyTag") << " MyDebugMessage" << Trace::endline;  // Filtered

  // Force the dump
  Trace::resetCustomAppenders();

  std::string line;
  std::ifstream myfile("res/myLogFile.log");
  unsigned index = 0;
  if (myfile.is_open()) {
    while (std::getline(myfile, line)) {
      if (index == 0) {
        ASSERT_EQ(line, " | ERROR |  MyErrorMessage");
      } else if (index == 1) {
        ASSERT_EQ(line, " | ERROR |  MyErrorMessage2");
      } else if (index == 2) {
        ASSERT_EQ(line, " | WARN |  MyWarnMessage");
      } else if (index == 3) {
        ASSERT_EQ(line, " | INFO |  MyInfoMessage");
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
    boost::filesystem::path fspath("res/myLogFile.log");
    ASSERT_EQ(boost::filesystem::remove(fspath), true);
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
  ASSERT_EQ(M.getAp()[0], 0);
  ASSERT_EQ(M.getAp()[1], 1);
  ASSERT_EQ(M.getAp()[2], 2);
  ASSERT_EQ(M.getAi()[0], 0);
  ASSERT_EQ(M.getAi()[1], 0);
  ASSERT_EQ(M.getAx()[0], 1);
  ASSERT_EQ(M.getAx()[1], 4);

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
    for (unsigned int ind = smj4.getAp()[icol]; ind < smj4.getAp()[icol + 1]; ++ind) {
      int ilig = smj4.getAi()[ind];
      double val = smj4.getAx()[ind];
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
TEST(CommonTest, testTimer) {
  Timer t("test");
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
