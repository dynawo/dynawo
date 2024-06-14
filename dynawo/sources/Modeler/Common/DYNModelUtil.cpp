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
 * @file  DYNModelUtil.cpp
 *
 * @brief Utility function to print the matrix structure of a model.
 *
 */

#include <fstream>
#include <sstream>

#include <boost/filesystem.hpp>

#include "DYNModelUtil.h"
#include "DYNFileSystemUtils.h"

using std::stringstream;

namespace fs = boost::filesystem;

namespace DYN {

void printStructureToFile(Model& model, const SparseMatrix& matrix) {
  static fs::path folder = "tmpMatStruct";
  static fs::path base = folder / "mat-struct-";
  static int nbPrintStruct = 0;
  stringstream fileName;
  fileName << base.string() << nbPrintStruct << ".txt";

  // If not in debug the infos on equations are not set.
#ifndef _DEBUG_
  if (nbPrintStruct == 0)
    model.setFequationsModel();  ///< set formula for modelica models' equations and Network models' equations
#endif

  if (!exists(folder.string())) {
    createDirectory(folder.string());
  }

  std::ofstream file;
  file.open(fileName.str().c_str(), std::ofstream::out);
  std::string subModelName("");
  std::string fEquation("");
  int subModelIndexF = 0;

  for (int jCol = 0; jCol < matrix.nbCol(); ++jCol) {
    for (unsigned ind = matrix.Ap_[jCol]; ind < matrix.Ap_[jCol + 1]; ++ind) {
      unsigned iRow = matrix.Ai_[ind];
      model.getFInfos(jCol, subModelName, subModelIndexF, fEquation);
      file << "(" << iRow << ", " << jCol << ") ";
      file << "F[" << jCol << "]" << " model:" << subModelName << " index: " << subModelIndexF << " equation: " << fEquation;
      file << " | Y[" << iRow << "] " << model.getVariableName(iRow) << "\n";
    }
  }

  ++nbPrintStruct;
  file.close();
}

}  // namespace DYN
