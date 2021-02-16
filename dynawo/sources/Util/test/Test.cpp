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
#include "DYNFileSystemUtils.h"
#include "DYNError.h"
#include "DYNError_keys.h"
#include "DYNTrace.h"
#include "DYNTimer.h"

namespace DYN {

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

  TraceAppender app;
  app.setTag("MyTag");
  app.setFilePath("res/myLogFile.log");
  app.setLvlFilter(INFO);
  app.setShowLevelTag(true);
  app.setSeparator(" | ");
  app.setShowTimeStamp(true);
  app.setTimeStampFormat("");
  std::vector<TraceAppender> appenders;
  appenders.push_back(app);
  Trace::addAppenders(appenders);

  TRACE(error, "MyTag") << " MyErrorMessage" << Trace::endline;
  TraceStream str(TRACE(error, "MyTag"));
  str << " MyErrorMessage2" << Trace::endline;
  TRACE(warn, "MyTag") << " MyWarnMessage" << Trace::endline;
  TRACE(info, "MyTag") << " MyInfoMessage" << Trace::endline;
  TRACE(debug, "MyTag") << " MyDebugMessage" << Trace::endline;  // Filtered

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

TEST(CommonTest, testTimer) {
  Timer t("test");
}
}  // namespace DYN
