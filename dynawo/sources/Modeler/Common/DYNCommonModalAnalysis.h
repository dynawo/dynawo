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
 * @file  DYNCommonModalAnalysis.h
 *
 * @brief Definition of utilities functions to use in modal analysis : header file
 *
 */
#ifndef MODALANALYSIS_COMMON_DYNMAUTIL_H_
#define MODALANALYSIS_COMMON_DYNMAUTIL_H_

#include <string>
#include <cmath>
#include <vector>

#include <eigen3/Eigen/Eigenvalues>
#include <eigen3/Eigen/Dense>
#include <eigen3/Eigen/Core>


namespace DYN {

  /**
   * @brief get the indices of the greatest value of each column inside a matrix
   *
   * @param mat dynamic double matrix
   *
   * @return indices of the greatest value of each column inside a matrix
   */
  std::vector<int> getIndicesMax(Eigen::MatrixXd &mat);

  /**
   * @brief get the indices of a string from a vector of string
   *
   * @param varNames vector of string
   * @param inoutVariable string to be identified from a vector of string
   *
   * @return indices of a string from a vector of string
   */
  std::vector<int> getIndicesString(std::vector<std::string>& varNames, std::string inoutVariable);

  /**
   * @brief get the indices of maximum participations associated to selected modes
   *
   * @param indicesMaxParticipation indices of maximum participation factors associated to all modes
   * @param indicesSelectedEigenvalues indices of selected modes
   *
   * @return indices of maximum participations associated to selected modes
   */
  std::vector<int> getIndicesMaxParticipationModes(std::vector<int> &indicesMaxParticipation, std::vector<int> &indicesSelectedEigenvalues);

  /**
   * @brief get the value from a matrix thanks to its two indices
   *
   * @param mat dynamic double matrix
   * @param indices1/indices2 indices of required values (exemple indices of selected Modes and indcies of max particpation factors)
   *
   * @return value from a matrix thanks to its two indices
   */
  std::vector<double> getValuesIndices(Eigen::MatrixXd &mat, std::vector<int> &indices1, std::vector<int> &indices2);

  /**
   * @brief eliminate the redundancy in std vector
   *
   * @param vec vector of integer
   */
  void uniqueVector(std::vector<int> &vec);

  /**
   * @brief construct a submatrix from another matrix
   *
   * @param mat dynamic double matrix
   * @param indices1/ indices2 indices of differential/algebraic varaibles/equations
   *
   * @return submatrix from another matrix
   */
  Eigen::MatrixXd contructSubMatrix(Eigen::MatrixXd mat, std::vector<int> &indices1, std::vector<int> &indices2);

  /**
   * @brief get the type of the mode (ROT, Electrical, ....)
   *
   * @param varDiff selected differential varaible from differential variables names
   *
   * @return type of the mode
   */
  std::string getTypeMode(std::string varDiff);

}  // namespace DYN

#endif  // MODALANALYSIS_COMMON_DYNMAUTIL_H_
