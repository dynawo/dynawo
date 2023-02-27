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
 * @file  DYNCommon.cpp
 *
 * @brief  define common function that could be used
 *
 */
#include <string>
#include <cstdlib>
#include <stdio.h>
#include <cstring>
#include <cassert>
#include <cstdarg>
#include <sstream>
#include <iomanip>
#include "DYNCommon.h"
#include "DYNMacrosMessage.h"
#include "DYNExecUtils.h"

using std::string;

namespace DYN {

const char* sharedLibraryExtension() {
#ifdef _WIN32
static const char extension[] = ".dll";
#elif __linux__
static const char extension[] = ".so";
#elif __unix__  // all unices not caught above
static const char extension[] = ".so";
#else
#error "Unknown compiler"
#endif
  return extension;
}

static double MAXIMUM_VALUE_FIXED = 1000000;  ///< maximum precision
std::string double2String(const double& value) {
  std::stringstream ss("");
  if (value > MAXIMUM_VALUE_FIXED)
    ss << std::setprecision(getPrecisionAsNbDecimal()) << std::scientific << value;
  else
    ss << std::setprecision(getPrecisionAsNbDecimal()) << std::fixed << value;
  return ss.str();
}

string typeVarC2Str(const typeVarC_t& type) {
  string typeVarC;
  switch (type) {
    case VAR_TYPE_STRING:
      typeVarC = "STRING";
      break;
    case VAR_TYPE_DOUBLE:
      typeVarC = "DOUBLE";
      break;
    case VAR_TYPE_INT:
      typeVarC = "INT";
      break;
    case VAR_TYPE_BOOL:
      typeVarC = "BOOL";
      break;
  }
  return typeVarC;
}

typeVarC_t str2TypeVarC(const std::string& typeStr) {
  if (typeStr == "STRING")
    return VAR_TYPE_STRING;
  else if (typeStr == "DOUBLE")
    return VAR_TYPE_DOUBLE;
  else if (typeStr == "INT")
    return VAR_TYPE_INT;
  else if (typeStr == "BOOL")
    return VAR_TYPE_BOOL;
  else
    throw DYNError(Error::MODELER, TypeVarCUnableToConvert, typeStr);
}

int sign(const double& value) {
  return (value < 0.) ? -1 : 1;
}


static double MAXIMUM_PRECISION = 1e-6;  ///< maximum precision
static int MAXIMUM_PRECISION_AS_NB_DECIMAL = 6;  ///< maximum precision
double getCurrentPrecision() {
  return MAXIMUM_PRECISION;
}
void setCurrentPrecision(double precision) {
  MAXIMUM_PRECISION = std::abs(precision);
  MAXIMUM_PRECISION_AS_NB_DECIMAL = static_cast<int>(-std::log10(MAXIMUM_PRECISION));
  MAXIMUM_VALUE_FIXED = std::pow(10, MAXIMUM_PRECISION_AS_NB_DECIMAL);
}
int getPrecisionAsNbDecimal() {
  return MAXIMUM_PRECISION_AS_NB_DECIMAL;
}

boost::optional<boost::filesystem::path>
getLibraryPathFromName(const std::string& libName) {
  // local path
  boost::filesystem::path testPath(libName);
  if (boost::filesystem::exists(testPath)) {
    return boost::make_optional(testPath);
  }

  // system directories
  testPath = getMandatoryEnvVar("DYNAWO_INSTALL_DIR");
#ifdef _WIN32
  testPath.append("bin");
#else
  testPath.append("lib");
#endif
  testPath.append(libName);
  if (boost::filesystem::exists(testPath)) {
    return boost::make_optional(testPath);
  }

  return boost::none;
}

size_t
LevensteinDistance(const std::string& s1, const std::string& s2,
    size_t insertCost,
    size_t deleteCost,
    size_t replaceCost) {
  if (s1.size() > s2.size()) {
    return LevensteinDistance(s2, s1, deleteCost, insertCost, replaceCost);
  }

  const size_t minSize = s1.size();
  const size_t maxSize = s2.size();
  std::vector<size_t> levDist(minSize + 1);

  levDist[0] = 0;
  for (size_t i = 1; i <= minSize; ++i) {
    levDist[i] = levDist[i - 1] + deleteCost;
  }

  for (size_t j = 1; j <= maxSize; ++j) {
    size_t previousDiagonal = levDist[0];
    size_t previousDiagonalSave;
    levDist[0] += insertCost;

    for (size_t i = 1; i <= minSize; ++i) {
      previousDiagonalSave = levDist[i];
      if (s1[i - 1] == s2[j - 1]) {
        levDist[i] = previousDiagonal;
      } else {
        levDist[i] = std::min(std::min(levDist[i - 1] + deleteCost, levDist[i] + insertCost), previousDiagonal + replaceCost);
      }
      previousDiagonal = previousDiagonalSave;
    }
  }

  return levDist[minSize];
}

bool
str2Bool(std::string str) {
  if (str == "true") {
    return true;
  } else if (str == "false") {
    return false;
  } else {
    throw DYNError(DYN::Error::API, FailedBooleanConversion, str);
  }
}

}  // namespace DYN
