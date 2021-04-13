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

/*
 * @file Modeler/Common/test/Test.cpp
 * @brief Unit tests for common Modeler methods
 *
 */
#include <boost/shared_ptr.hpp>
#include <boost/pointer_cast.hpp>
#include <eigen3/Eigen/Eigenvalues>
#include <eigen3/Eigen/Dense>
#include <eigen3/Eigen/Core>
#include <eigen3/Eigen/Sparse>
#include <eigen3/Eigen/SVD>
#include <eigen3/Eigen/QR>
#include <iostream>
#include <fstream>
#include <complex>
#include <vector>

#include "gtest_dynawo.h"
#include "DYNModalAnalysis.h"
#include "DYNCommonModalAnalysis.h"
#include "DYNTimer.h"


using Eigen::ArrayXd;
using Eigen::MatrixXd;
using Eigen::MatrixXcd;
using Eigen::VectorXd;
using Eigen::VectorXcd;
using Eigen::EigenSolver;
using Eigen::ArrayXcd;

using std::vector;

namespace DYN {
//-----------------------------------------------------
// TEST DYNModalAnalysis
//-----------------------------------------------------


TEST(ModelerCommonTest, ModalAnalysis) {
  boost::shared_ptr<ModalAnalysis> modalAnalysis(new ModalAnalysis());

  // computeFrequency
  Eigen::VectorXd imagParts(6);
  imagParts << 0, 0, 6.64882, -6.64882, 0, 0;
  Eigen::VectorXd realParts(6);
  realParts << -37.3596, -24.0503, 0.490716, 0.490716, -2.31685, 0;
  ASSERT_EQ(0, modalAnalysis->computeFrequency(imagParts[0]));
  ASSERT_EQ(0, modalAnalysis->computeFrequency(imagParts[1]));
  ASSERT_EQ(abs(imagParts[2])/(2*M_PI), modalAnalysis->computeFrequency(imagParts[2]));
  ASSERT_EQ(abs(imagParts[3])/(2*M_PI), modalAnalysis->computeFrequency(imagParts[3]));
  ASSERT_EQ(0, modalAnalysis->computeFrequency(imagParts[4]));
  ASSERT_EQ(0, modalAnalysis->computeFrequency(imagParts[5]));

  // computeDamping
  ASSERT_EQ(100, modalAnalysis->computeDamping(realParts[0], imagParts[0]));
  ASSERT_EQ(100, modalAnalysis->computeDamping(realParts[1], imagParts[1]));
  ASSERT_EQ(abs(100*(realParts[2]/sqrt((realParts[2]*realParts[2]) + (imagParts[2]*imagParts[2])))), modalAnalysis->computeDamping(realParts[2], imagParts[2]));
  ASSERT_EQ(abs(100*(realParts[3]/sqrt((realParts[3]*realParts[3]) + (imagParts[3]*imagParts[3])))), modalAnalysis->computeDamping(realParts[3], imagParts[3]));
  ASSERT_EQ(100, modalAnalysis->computeDamping(realParts[4], imagParts[4]));
  ASSERT_EQ(0, modalAnalysis->computeDamping(realParts[5], imagParts[5]));
 
  // getIndicesNonzeroImagParts
  std::vector<int> expectedIndicesNonzeroImagParts = {2};
  std::vector<int> actualIndicesNonzeroImagParts = modalAnalysis->getIndicesNonzeroImagParts(imagParts);
  ASSERT_EQ(expectedIndicesNonzeroImagParts, actualIndicesNonzeroImagParts);

  // getIndicesUnstableModes
  std::vector<int> expectedIndicesUnstableModes = {2, 3};
  ASSERT_EQ(expectedIndicesUnstableModes, modalAnalysis->getIndicesUnstableModes(imagParts, realParts));

  // getIndicesStableModes
  std::vector<int> expectedIndicesStableModes = {};
  ASSERT_EQ(expectedIndicesStableModes, modalAnalysis->getIndicesStableModes(actualIndicesNonzeroImagParts, realParts));

  // getIndicesRealModes
  std::vector<int> expectedIndicesRealModes = {0, 1, 4, 5};
  ASSERT_EQ(expectedIndicesRealModes, modalAnalysis->getIndicesRealModes(imagParts));

  // createPhaseMatrix
  Eigen::MatrixXcd matrixComplex(2,2);
  typedef std::complex<double> C2;
  matrixComplex << 
  C2(1, 0.0), C2(-0, 1),
  C2(0, -1.0), C2(-1, -0.0);

  Eigen::MatrixXd expectedPhaseMatrix(2,2);
  expectedPhaseMatrix(0, 0) = 0;
  expectedPhaseMatrix(0, 1) = 90;
  expectedPhaseMatrix(1, 0) = -90;
  expectedPhaseMatrix(1, 1) = -180;
  ASSERT_EQ(expectedPhaseMatrix, modalAnalysis->createPhaseMatrix(matrixComplex));

 // createParticipationMatrix
  Eigen::MatrixXd mat = MatrixXd::Zero(6, 6);
  mat << -37.5016,0.128, 0.7431, 25.988,-5.2197,-5.7627,
        0.0285,-2.8457,2.1711, 0.0297, 0.2701,-0.1553,
        0.6339,8.3012,-23.2664,0.659, 5.9925,-3.4464,
       -0.0761,0.1551,0.8998,-1.4625,-1.9636, 0.2456,
       -0.0776,-0.0093,-0.0542,-0.0807,-0.8039,-0.1596,
        0,0,0,0,314.159,0;

  Eigen::EigenSolver<Eigen::MatrixXd> s(mat);
  Eigen::MatrixXcd rightEigenvectors = s.eigenvectors();

  Eigen::MatrixXd expectedMatParticipation(mat.rows(), mat.cols());
  expectedMatParticipation << 1.00704, 0.000596206, 0.00749306, 0.00749306, 0.00456609, 0.00188591,
                              4.53844e-06, 0.0388046, 0.00707971, 0.00707971, 0.609139, 0.348352,
                              0.000584755, 0.965424, 0.00928014, 0.00928014, 0.0133869, 0.038095,
                              0.00264949, 0.0039138, 0.0100866, 0.0100866, 0.370682, 0.619635,
                              0.00241117, 0.00406675, 0.502516, 0.502516, 0.00806682, 0.00395756,
                              0.00256556, 0.00347894, 0.503947, 0.503947, 0.0032915, 0.00401005;

  Eigen::MatrixXd actualMatParticipation(mat.rows(), mat.cols());
  actualMatParticipation = modalAnalysis->createParticipationMatrix(rightEigenvectors);

  ASSERT_PRED2([](const MatrixXd &lhs, const MatrixXd &rhs) {
                  return lhs.isApprox(rhs, 1e-4); }, expectedMatParticipation, actualMatParticipation);

  // getSubParticipation
  std::vector<int> indicesSelectedVarDiff = {4, 5};
  double actualSubParticipation1 = modalAnalysis->getSubParticipation(2, indicesSelectedVarDiff, actualMatParticipation);
  ASSERT_DOUBLE_EQ(1.0064626059894679, actualSubParticipation1);

  std::vector<int> indicesSelectedVarDiffEmpty = {};
  double actualSubParticipation2 = modalAnalysis->getSubParticipation(2, indicesSelectedVarDiffEmpty, actualMatParticipation); 
  ASSERT_DOUBLE_EQ(0.0, actualSubParticipation2);

  // getIndicesROT
  vector<std::string> varDiffNames = {"omega", "theta", "lambdaD", "lambdaQ", "lambdaQ1", "voltageRegulator"};
  std::vector<int> expectedIndicesROT = {0, 1};
  ASSERT_EQ(expectedIndicesROT, modalAnalysis->getIndicesROT(varDiffNames));

  // getIndicesSMD
  std::vector<int> expectedIndicesSMD = {2};
  ASSERT_EQ(expectedIndicesSMD, modalAnalysis->getIndicesSMD(varDiffNames));

  // getIndicesSMQ
  std::vector<int> expectedIndicesSMQ = {3, 4};
  ASSERT_EQ(expectedIndicesSMQ, modalAnalysis->getIndicesSMQ(varDiffNames));

  // getIndicesAVR
  std::vector<int> expectedIndicesAVR = {5};
  ASSERT_EQ(expectedIndicesAVR, modalAnalysis->getIndicesAVR(varDiffNames));

  // getIndicesGOV
  std::vector<int> expectedIndicesGOV = {};
  ASSERT_EQ(expectedIndicesGOV, modalAnalysis->getIndicesGOV(varDiffNames));

  // getIndicesOTH
  std::vector<int> fixedIndices = {0, 1, 2, 3, 4, 5};
  std::vector<int> expectedIndicesOTH = {};
  ASSERT_EQ(expectedIndicesOTH, modalAnalysis->getIndicesOTH(varDiffNames, fixedIndices));
}

}  // namespace DYN
