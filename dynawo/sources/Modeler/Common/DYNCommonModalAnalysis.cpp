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
 * @file  DYNCommonModalAnalysis.cpp
 *
 * @brief Definition of utilities functions to use modal analysis: implementation file
 *
 */


#include "DYNCommonModalAnalysis.h"
#include "DYNTimer.h"

#include <iostream>
#include <stdio.h>
#include <stdlib.h>

using std::string;
using std::vector;

namespace DYN {

std::vector<int> getIndicesMax(Eigen::MatrixXd& mat) {
  std::vector<int> indicesMax;
  for (unsigned int i = 0; i < mat.cols(); i++) {
    std::vector<double> stdVector(mat.col(i).data(), mat.col(i).data() + mat.col(i).size());
    indicesMax.push_back(distance(stdVector.begin(), max_element(stdVector.begin(), stdVector.end())));
  }
  return indicesMax;
}

std::vector<int> getIndicesString(std::vector<std::string>& varNames, std::string inoutVariable) {
  std::vector<int> indicesString;
  for (unsigned int i = 0; i < varNames.size(); i++) {
    size_t found = varNames[i].find(inoutVariable);
    if (found != string::npos) {
      indicesString.push_back(i);
    }
  }
  return indicesString;
}

std::vector<int> getIndicesMaxParticipationModes(std::vector<int>& indicesMaxParticipation, std::vector<int>& indicesSelectedModes) {
  std::vector<int> selectedIndices;
  for (unsigned int i = 0; i < indicesSelectedModes.size(); i++) {
    selectedIndices.push_back(indicesMaxParticipation[indicesSelectedModes[i]]);
  }
  return selectedIndices;
}

std::vector<double> getValuesIndices(Eigen::MatrixXd& mat, std::vector<int>& indices1, std::vector<int>& indices2) {
  std::vector<double> valuesIndices;
  for (unsigned int i = 0; i < indices1.size(); i++) {
    valuesIndices.push_back(mat(indices2[indices1[i]], indices1[i]));
  }
  return valuesIndices;
}

void
uniqueVector(std::vector<int>& vec) {
  TOP: for (unsigned int y = 0; y < vec.size(); ++y) {
    for (unsigned int z = 0; z < vec.size(); ++z) {
      if (y == z) {
        continue;
      }
      if (vec[y] == vec[z]) {
        vec.erase(vec.begin() + z);
        goto TOP;
      }
    }
  }
}

Eigen::MatrixXd contructSubMatrix(Eigen::MatrixXd mat, std::vector<int>& indices1, std::vector<int>& indices2) {
  Eigen::MatrixXd Aij(indices1.size(), indices2.size());
  for (unsigned int i = 0; i < indices1.size(); i++) {
    for (unsigned int j = 0; j < indices2.size(); j++) {
      Aij(i, j) = mat(indices1[i], indices2[j]);
    }
  }
  return Aij;
}

 // this function will change according to the possible cases of differential variables
string getTypeMode(string varDiff) {
  if (varDiff.find("theta") != string::npos)
    return "ROT";
  else if (varDiff.find("omega") != string::npos)
    return "ROT";
  else if (varDiff.find("OMEGA") != string::npos)
    return "ROT";
  else if (varDiff.find("lambdad") != string::npos)
    return "SMD";
  else if (varDiff.find("lambdaD") != string::npos)
    return "SMD";
  else if (varDiff.find("lambdaq") != string::npos)
    return "SMQ";
  else if (varDiff.find("lambdaQ") != string::npos)
    return "SMQ";
  else if (varDiff.find("VR") != string::npos)
    return "EXC";
  else if (varDiff.find("AVR") != string::npos)
    return "EXC";
  else if (varDiff.find("avr") != string::npos)
    return "EXC";
  else if (varDiff.find("voltageRegulator") != string::npos)
    return "EXC";
  else if (varDiff.find("lambdaf") != string::npos)
    return "EXC";
  else if (varDiff.find("gover") != string::npos)
    return "GOV";
  else if (varDiff.find("Gover") != string::npos)
    return "GOV";
  else if (varDiff.find("GOVER") != string::npos)
    return "GOV";
  else if (varDiff.find("inj") != string::npos)
    return "INJ";
  else if (varDiff.find("INJ") != string::npos)
    return "INJ";
  else if (varDiff.find("HVDC") != string::npos)
    return "INJ";
  else if (varDiff.find("hvdc") != string::npos)
    return "INJ";
  else if (varDiff.find("converter") != string::npos)
    return "INJ";
  else
    return "OTH";
}

}  // DYN
