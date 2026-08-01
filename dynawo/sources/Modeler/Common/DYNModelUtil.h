//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNModelUtil.h
 *
 * @brief Model util to print the matrix structure associated to a model into a file.
 *
 */
#ifndef MODELER_COMMON_DYNMODELUTIL_H_
#define MODELER_COMMON_DYNMODELUTIL_H_

#include "DYNModel.h"
#include "DYNSparseMatrix.h"

namespace DYN {
   /**
   * @brief print the structure of the matrix in a file.
   *
   * This function is for debug purposes but can be used release mode
   *
   * To use it you need to add \#include "DYNModelUtil.h" in DYNSolverIDA.cpp
   * and add dynawo_ModelerCommon to the target_link_libraries of dynawo_SolverIDA.
   * Then in evalJ you can use printStructureToFile(model, smj);
   *
   * @param model model to get the informations on equations and variables
   * @param matrix matrix which structure will be printed
   */
  void printStructureToFile(Model& model, const SparseMatrix& matrix);
}  // namespace DYN

#endif  // MODELER_COMMON_DYNMODELUTIL_H_
