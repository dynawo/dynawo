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
 * @file  DYNModalAnalysis.h
 *
 * @brief Modal Analysis factory header
 *
 */
#ifndef MODELER_COMMON_DYNMODALANALYSIS_H_
#define MODELER_COMMON_DYNMODALANALYSIS_H_

#include "DYNCommonModalAnalysis.h"

namespace DYN {
class ModalAnalysis {

 public:
  /**
   * @brief Constructor
   */
  ModalAnalysis();

  /**
   * @brief destructor
   */
  ~ModalAnalysis();

 public:

  /**
   * @brief delete all allocated memory of the variable
   */
  void free();

  /**
   * @brief delete all allocated memory of the vector
   */
  void freeVector();

  /**
   * @brief create the matrix of participation factors
   *
   * @param rightEigenvectors matrix of right eigenvectors
   *
   * @return matrix of participation factors
   */
  Eigen::MatrixXd createParticipationMatrix(Eigen::MatrixXcd& rightEigenvectors);

  /**
   * @brief get the sub participation of a mode
   *
   * @param nbMode number of the mode
   * @param indicesSelectedVarDiff indices of selected differential variables associated to nbMode
   * @param matParticipation matrix of participation factors
   *
   * @return sub-participation
   */
  double getSubParticipation(const int &nbMode, std::vector<int> &indicesSelectedVarDiff, Eigen::MatrixXd &matParticipation);

  /**
   * @brief create a matrix of phase positions
   *
   * @param righteigenvectors matrix of right eigenvectors
   *
   * @return matrix of phase positions
   */
  Eigen::MatrixXd createPhaseMatrix(Eigen::MatrixXcd &rightEigenvectors);

  /**
   * @brief compute the damping of the mode
   *
   * @param realPart real part of the mode
   * @param imagPart imaginary part the mode
   *
   * @return damping
   */
  double computeDamping(double &realPart, double &imagPart);

  /**
   * @brief compute the frequency of the oscillatory mode
   *
   * @param imagPart imaginary part of the oscillatory mode
   *
   * @return frequency of the oscillatory mode
   */
  double computeFrequency(double &imagPart);
  
  /**
   * @brief get nonzero imaginary parts
   *
   * @param imagEigenvalues imaginary parts of eigenvalues
   *
   * @return nonzero imaginary parts 
   */
  void getNonzeroImagParts(Eigen::VectorXd &imagEigenvalues);

  /**
   * @brief get the indices of nonzero imaginary parts
   *
   * @param imagEigenvalues imaginary parts of eigenvalues
   *
   * @return indices of nonzero imaginary parts
   */
  std::vector<int> getIndicesNonzeroImagParts(Eigen::VectorXd &imagEigenvalues);

  /**
   * @brief get the indices of unstable modes
   *
   * @param indicesNonzeroImagParts indices of nonzero imaginary parts of eigenvalues
   * @param realEigenvalues real parts of eigenvalues
   *
   * @return indices of unstable modes
   */
  std::vector<int> getIndicesUnstableModes(Eigen::VectorXd& imagEigenvalues, Eigen::VectorXd& realEigenvalues);

  /**
   * @brief get the indices of real modes
   *
   * @param imagEigenvalues imaginary parts of eigenvalues
   *
   * @return indices of real modes
   */
  std::vector<int> getIndicesRealModes(Eigen::VectorXd &imagEigenvalues);

  /**
   * @brief get the indices of stable modes
   *
   * @param indicesNonzeroImagParts indices of nonzero imaginary parts
   * @param realEigenvalues real parts of eigenvalues
   *
   * @return indices of stable modes
   */
  std::vector<int> getIndicesStableModes(std::vector<int> &indicesNonzeroImagParts, Eigen::VectorXd &realEigenvalues);

  /**
   * @brief get the indices of the Rotational (elechromechanical) variables
   *
   * @param varDiffNames names of differential variables
   *
   * @return indices of elechromechanical variables 
   */
  std::vector<int> getIndicesROT(std::vector<std::string> &varDiffNames);

  /**
   * @brief get the indices of the SMD variables
   *
   * @param varDiffNames names of differential variables
   *
   * @return indices of SMD variables
   */
  std::vector<int> getIndicesSMD(std::vector<std::string> &varDiffNames);

  /**
   * @brief get the indices of the SMQ variables
   *
   * @param varDiffNames names of differential variables
   *
   * @return indices of SMQ variables
   */
  std::vector<int> getIndicesSMQ(std::vector<std::string> &varDiffNames);

  /**
   * @brief get the indices of the AVR variables from
   *
   * @param varDiffNames names of differential variables
   *
   * @return indices of AVR variables
   */
  std::vector<int> getIndicesAVR(std::vector<std::string> &varDiffNames);

  /**
   * @brief get the indices of the Governor variables
   *
   * @param varDiffNames names of differential variables
   *
   * @return indices of GOV variables
   */
  std::vector<int> getIndicesGOV(std::vector<std::string> &varDiffNames);

  /**
   * @brief get the indices of the OTH (other) variables
   *
   * @param varDiffNames names of differential variables
   * @param fixedIndices indices associated to predefined differential variables
   *
   * @return indices of OTH variables
   */
  std::vector<int> getIndicesOTH(std::vector<std::string>& varDiffNames, std::vector<int> fixedIndices);

  /**
   * @brief get the indices of the converter variables
   *
   * @param varDiffNames names of differential variables
   *
   * @return indices of converter variables
   */
  std::vector<int> getIndicesINJ(std::vector<std::string> &varDiffNames);


  /**
   * @brief get the names of differential variables associated to the most important participation factors of a mode
   *
   * @param varDiffNames names of differential variables
   * @param indicesSelectedVarDiff indices of selected differential varaibles
   *
   * @return names of differential variables associated to the most important participation factors
   */
  std::vector<std::string> getNamesMostVarDiff(std::vector<std::string>& varDiffNames, std::vector<int>& indicesSelectedVarDiff);

  /**
   * @brief get the indices of most coupled dynamic devices (without redundancy) involved in an oscillatory coupled mode
   *
   * @param varDiffNames names of differential variables
   * @param indicesSelectedVarDiff indices of selected differential varaibles
   * @param namesDynamicDevices names of dynamic devices associated to differential variables
   *
   */ 
  void getIndicesMostCoupledDevices(std::vector<std::string>& varDiffNames, std::vector<int>& indicesSelectedVarDiff, std::vector<std::string> &namesDynamicDevices);

  /**
   * @brief print the coupled devices of oscillatory coupled modes
   *
   * @param indicesNonzeroImagParts indices of nonzero imaginary parts
   * @param matParticipation matrix of participation factors
   * @param phaseMatrix matrix of phase positons
   * @param allEigenvalues eigenvalues of the matrix A
   * @param partFactor minimum participation factor (will be used to select the coupled dynamic devices)
   * @param varDiffNames names of differential variables
   * @param namesDynamicDevicesDiff names of dynamic devices associated to differential variables
   *
   */
  void printCoupledDevices(std::vector<int>& indicesNonzeroImagParts, Eigen::MatrixXd &matParticipation,
                           Eigen::MatrixXd &phaseMatrix, Eigen::VectorXcd &allEigenvalues,
                           const double partFactor, std::vector<std::string> &varDiffNames,
                           std::vector<std::string> &namesDiffDynamicDevices);

 private:
  std::vector<double> nonzeroImagParts_;  ///< nonzero imaginary parts
  std::vector<int> indicesNonzeroImagPartsRedundancy_; ///< indices of non zero imaginary parts with redundancy
  std::vector<int> indicesInterAreaModes_;  ///< indices of inter-area modes
  std::vector<int> indicesLocalModes_;  ///< indices of local modes
  std::vector<int> indicesElectricalCouplingModes_;  ///< indices of electrical couplibg modes
  std::vector<int> indicesOtherCouplingModes_;  ///< indices of other coupling modes
  std::vector<double> selectedPhaseMode_;  ///< selected phase positions of a mode
  std::vector<int> indicesSelectedParticipation_;  ///< indices associated to selected participation factors
  std::vector<int> indicesDynamicDevices_;  ///< indices of dynamic devices that are associated to selected differential variables
  std::vector<int> indicesMostCoupledDevices_;  ///< indices of most coupled dynamic devices
  std::vector<double> selectedParticipationsMode_;  /// selected participation factors of a mode
  std::vector<std::string> varDiffCoupledDevices_;  ///< differential variables associated to coupled dynamic devices
  int numberCoupledModes_;  ///< number of coupled modes
  int numberInterAreaModes_;  ///< number of inter-area modes
  int numberElectricalCouplingModes_;  ///< number of electrical coupling modes
  int numberLocalModes_;  ///< number of local modes
  int numberOtherCouplingModes_;  ///< number of other coupling modes
  int counter_;  ///< counts the number of modes
};  ///< Class for Modal Analysis

}  // namespace DYN

#endif  // MODELER_COMMON_DYNMODALANALYSIS_H_
