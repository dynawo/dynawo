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
 * @file  DYNModalAnalysis.cpp
 *
 * @brief implementation file
 *
 */


#include "DYNModalAnalysis.h"
#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNTimer.h"

#include <iomanip>

using std::string;
using std::fixed;
using std::setprecision;


namespace DYN {

ModalAnalysis::ModalAnalysis() :
  numberCoupledModes_(0),
  numberInterAreaModes_(0),
  numberElectricalCouplingModes_(0),
  numberLocalModes_(0),
  numberOtherCouplingModes_(0),
  counter_(0) { }

ModalAnalysis::~ModalAnalysis() {
  free();
  freeVector();
}

void
ModalAnalysis::free() {
  numberCoupledModes_ = 0;
  numberInterAreaModes_ = 0;
  numberElectricalCouplingModes_ = 0;
  numberLocalModes_ = 0;
  numberOtherCouplingModes_ = 0;
  counter_ = 0;
}

void
ModalAnalysis::freeVector() {
  selectedParticipationsMode_.clear();
  indicesSelectedParticipation_.clear();
  selectedPhaseMode_.clear();
  indicesMostCoupledDevices_.clear();
}

Eigen::MatrixXd
ModalAnalysis::createParticipationMatrix(Eigen::MatrixXcd& rightEigenvectors) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::createParticipationMatrix");
#endif
  Eigen::MatrixXcd matParticipation(rightEigenvectors.rows(), rightEigenvectors.cols());
  matParticipation = (rightEigenvectors).cwiseProduct(rightEigenvectors.inverse().transpose());
  return matParticipation.cwiseAbs();
}

double
ModalAnalysis::getSubParticipation(const int& nbMode, std::vector<int>& indicesSelectedVarDiff, Eigen::MatrixXd& matParticipation) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::getSubParticipation");
#endif
  if (nbMode > matParticipation.cols()) {
    throw DYNError(Error::MODELER, ModelFuncError, "The mode number should be in this range [0, A.cols()]");
  } else {
    double var1 = 0.0;
    double var2 = 0.0;
    Eigen::VectorXd participationMode = matParticipation.col(nbMode); // column of participation factor associated to nbMode
    // start the compute of the sub-participation associated to nbMode
    if (!indicesSelectedVarDiff.empty()) {
      for (unsigned int i = 0; i < indicesSelectedVarDiff.size(); i++) {
        var1 = var1 + participationMode(indicesSelectedVarDiff[i]);
      }
      var2 = abs(var1);
      return var2;
    } else {
      var2 = 0.0;
      return var2;
    }
  }
}

Eigen::MatrixXd
ModalAnalysis::createPhaseMatrix(Eigen::MatrixXcd& rightEigenvectors) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::createPhaseMatrix");
#endif
  Eigen::MatrixXd matPhase(rightEigenvectors.rows(), rightEigenvectors.cols());
  for (unsigned int row = 0; row < rightEigenvectors.rows(); row++) {
    for (unsigned int col = 0; col < rightEigenvectors.cols(); col++) {
      matPhase(row, col) = (180 / M_PI) * arg(rightEigenvectors(row, col));
    }
  }
  return matPhase;
}

double
ModalAnalysis::computeDamping(double& realPart, double& imagPart) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::computeDamping");
#endif
  double damping;
  if (realPart != 0) {
    return damping = abs(100 * (realPart / sqrt((realPart * realPart) + (imagPart * imagPart))));
   } else {
    return 0;
  }
}

double
ModalAnalysis::computeFrequency(double& imagPart) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::computeFrequency");
#endif
   double frequency;
   return frequency = abs(imagPart) / (2 * M_PI);
}

void
ModalAnalysis::getNonzeroImagParts(Eigen::VectorXd& imagEigenvalues) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::getNonzeroImagParts");
#endif
  if (nonzeroImagParts_.empty()) {
  for (unsigned int i = 0; i < imagEigenvalues.size(); i++) {
    if (abs(imagEigenvalues[i]) != 0) {
      nonzeroImagParts_.push_back(abs(imagEigenvalues[i]));
    }
  }
  nonzeroImagParts_.erase(std::unique(nonzeroImagParts_.begin(), nonzeroImagParts_.end()), nonzeroImagParts_.end());
 }
}

std::vector<int>
ModalAnalysis::getIndicesNonzeroImagParts(Eigen::VectorXd& imagEigenvalues) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::getIndicesNonzeroImagParts");
#endif
  std::vector<int> indicesNonzeroImagParts;
  getNonzeroImagParts(imagEigenvalues);
  std::vector<double> imagParts(imagEigenvalues.data(), imagEigenvalues.data() + imagEigenvalues.size());
  for (unsigned int i = 0; i < nonzeroImagParts_.size(); i++) {
    auto it = find(imagParts.begin(), imagParts.end(), nonzeroImagParts_[i]);
    indicesNonzeroImagParts.push_back(distance(imagParts.begin(), it));
  }
  return indicesNonzeroImagParts;
}

std::vector<int>
ModalAnalysis::getIndicesStableModes(std::vector<int>& indicesNonzeroImagParts, Eigen::VectorXd& realEigenvalues) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::getIndicesStableModes");
#endif
  std::vector<int> indicesStableModes;
  for (unsigned int i = 0; i < indicesNonzeroImagParts.size(); i++) {
    if (realEigenvalues[indicesNonzeroImagParts[i]] <= 0) {
      indicesStableModes.push_back(indicesNonzeroImagParts[i]);
    }
  }
  return indicesStableModes;
}

std::vector<int>
ModalAnalysis::getIndicesRealModes(Eigen::VectorXd& imagEigenvalues) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::getIndicesRealModes");
#endif
  std::vector<int> indicesRealModes;
  for (unsigned int i = 0; i < imagEigenvalues.size(); i++) {
    if (abs(imagEigenvalues[i]) == 0) {
      indicesRealModes.push_back(i);
    }
  }
  return indicesRealModes;
}

std::vector<int>
ModalAnalysis::getIndicesUnstableModes(Eigen::VectorXd& imagEigenvalues, Eigen::VectorXd& realEigenvalues) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::getIndicesUnstableModes");
#endif
  std::vector<int> indicesUnstableModes;
  for (unsigned int i = 0; i < imagEigenvalues.size(); i++) {
    if (abs(imagEigenvalues[i]) != 0) {
      indicesNonzeroImagPartsRedundancy_.push_back(i);
    }
  }

  for (unsigned int j = 0; j < indicesNonzeroImagPartsRedundancy_.size(); j++) {
    if (realEigenvalues[indicesNonzeroImagPartsRedundancy_[j]] > 0) {
      indicesUnstableModes.push_back(indicesNonzeroImagPartsRedundancy_[j]);
    }
  }
  return indicesUnstableModes;
}

std::vector<int>
ModalAnalysis::getIndicesROT(std::vector<std::string>& varDiffNames) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::getIndicesROT");
#endif
  std::vector<int> indicesROT;
  for (unsigned int i = 0; i < varDiffNames.size(); i++) {
    if (varDiffNames[i].find("omega") != string::npos || varDiffNames[i].find("OMEGA") != string::npos) { // npos non-position
      indicesROT.push_back(i);
    } else {
      if (varDiffNames[i].find("theta") != string::npos) {
        indicesROT.push_back(i);
      }
    }
  }
  return indicesROT;
}

std::vector<int>
ModalAnalysis::getIndicesSMD(std::vector<std::string>& varDiffNames) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::getIndicesSMD");
#endif
  std::vector<int> indicesSMD;
  for (unsigned int i = 0; i < varDiffNames.size(); i++) {
    if (varDiffNames[i].find("lambdad") != string::npos || (varDiffNames[i].find("lambdaD") != string::npos)) {
      indicesSMD.push_back(i);
    } 
  }
  return indicesSMD;
}

std::vector<int>
ModalAnalysis::getIndicesSMQ(std::vector<std::string>& varDiffNames) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::getIndicesSMQ");
#endif
  std::vector<int> indicesSMQ;
  for (unsigned int i = 0; i < varDiffNames.size(); i++) {
    if (varDiffNames[i].find("lambdaq") != string::npos || varDiffNames[i].find("lambdaQ") != string::npos) {
      indicesSMQ.push_back(i);
    } 
  }
  return indicesSMQ;
}

std::vector<int>
ModalAnalysis::getIndicesAVR(std::vector<std::string> & varDiffNames) {
  std::vector<int> indicesAVR;
  for (unsigned int i = 0; i < varDiffNames.size(); i++) {
    if (varDiffNames[i].find("avr") != string::npos || varDiffNames[i].find("AVR") != string::npos) {
      indicesAVR.push_back(i);
    } else if (varDiffNames[i].find("voltageRegulator") != string::npos || varDiffNames[i].find("lambdaf") != string::npos) {
      indicesAVR.push_back(i);
    } else {
      if (varDiffNames[i].find("VR") != string::npos) {
        indicesAVR.push_back(i);
      }
    }
  }
  return indicesAVR;
}

std::vector<int>
ModalAnalysis::getIndicesGOV(std::vector < std::string > & varDiffNames) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::getIndicesGOV");
#endif
  std::vector<int> indicesGOV;
  for (unsigned int i = 0; i < varDiffNames.size(); i++) {
    if (varDiffNames[i].find("gover") != string::npos || varDiffNames[i].find("GOVER") != string::npos) {
      indicesGOV.push_back(i);
    } else {
      if (varDiffNames[i].find("Gover") != string::npos) {
        indicesGOV.push_back(i);
      }
    }
  }
  return indicesGOV;
}

std::vector<int>
ModalAnalysis::getIndicesINJ(std::vector<std::string>& varDiffNames) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::getIndicesINJ");
#endif
  std::vector<int> indicesINJ;
  for (unsigned int i = 0; i < varDiffNames.size(); i++) {
    if (varDiffNames[i].find("inj") != string::npos || varDiffNames[i].find("INJ") != string::npos) {
      indicesINJ.push_back(i);
    } else if (varDiffNames[i].find("HVDC") != string::npos || varDiffNames[i].find("hvdc") != string::npos) {
      indicesINJ.push_back(i);
    } else {
      if (varDiffNames[i].find("converter") != string::npos) {
        indicesINJ.push_back(i);
      }
    }
  }
  return indicesINJ;
}

std::vector<int>
ModalAnalysis::getIndicesOTH(std::vector<std::string>& varDiffNames, std::vector<int> fixedIndices) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModalAnalysis::getIndicesOTH");
#endif
  std::vector<int> indicesOTH;
  std::vector<int> indicesVarDiff;
  for (unsigned int i = 0; i < varDiffNames.size(); i++) {
    indicesVarDiff.push_back(i);
  }
  sort(fixedIndices.begin(), fixedIndices.end());
  std::set_difference(indicesVarDiff.begin(), indicesVarDiff.end(), fixedIndices.begin(), fixedIndices.end(), std::inserter(indicesOTH, indicesOTH.begin()));
  return indicesOTH;
}

std::vector<std::string>
ModalAnalysis::getNamesMostVarDiff(std::vector<std::string>& varDiffNames, std::vector<int>& indicesSelectedVarDiff) {
  std::vector<std::string> namesMostVarDiff;  // names of selected differential variables
  for (unsigned int i = 0; i < indicesSelectedVarDiff.size(); i++) {
    namesMostVarDiff.push_back(varDiffNames[indicesSelectedVarDiff[i]]);
  }
  return namesMostVarDiff;
}

void
ModalAnalysis::getIndicesMostCoupledDevices(std::vector<std::string>& varDiffNames, std::vector<int>& indicesSelectedVarDiff, std::vector<std::string>& namesDynamicDevices) {
  for (unsigned int i = 0; i < indicesSelectedVarDiff.size(); i++) {
    string varName = varDiffNames[indicesSelectedVarDiff[i]];
    for (unsigned int j = 0; j < indicesSelectedVarDiff.size(); j++) {
      if (varName.find(namesDynamicDevices[indicesSelectedVarDiff[j]]) != string::npos) {
        indicesDynamicDevices_.push_back(indicesSelectedVarDiff[j]);
      }
    }
    indicesMostCoupledDevices_.push_back(indicesDynamicDevices_[0]);  // push the index of the first dynamic device
    indicesDynamicDevices_.clear();
  }
  uniqueVector(indicesMostCoupledDevices_);
}

void
ModalAnalysis::printCoupledDevices(std::vector<int>& indicesNonzeroImagParts, Eigen::MatrixXd& matParticipation,
Eigen::MatrixXd& phaseMatrix, Eigen::VectorXcd& allEigenvalues, const double partFactor, std::vector<std::string>& varDiffNames, std::vector<std::string>& namesDiffDynamicDevices) {

  if (partFactor < 0) {
    throw DYNError(Error::MODELER, ModelFuncError, "The minimum value of relative participation factor should be positive");
  } else {
    Trace::debug(Trace::fullmodalanalysis()) << "--------------------------------" << Trace::endline;
    Trace::debug(Trace::fullmodalanalysis()) << "Coupled Devices: Dynamic Devices" << Trace::endline;
    Trace::debug(Trace::fullmodalanalysis()) << "With Participation Greatest Than" << Trace::endline;
    Trace::debug(Trace::fullmodalanalysis()) << "a Limit Including Mode Shape" << Trace::endline;
    Trace::debug(Trace::fullmodalanalysis()) << "Information" << Trace::endline;
    Trace::debug(Trace::fullmodalanalysis()) << "--------------------------------" << Trace::endline;

    Trace::debug(Trace::fullmodalanalysis()) <<  boost::format("%-8s%-15s%-15s%-12s%-15s")  % "index" % "Parti.(%)" % "Name" %
    "Phase(deg)" % "Type" << Trace::endline;

    free();

    int nbComplexModes = indicesNonzeroImagParts.size();  // number of complex modes

    Eigen::MatrixXd matRelativeParticipation(matParticipation.rows(), matParticipation.cols());
    for (unsigned int i = 0; i < matParticipation.cols(); i++) {
      matRelativeParticipation.col(i) = (matParticipation.col(i)) / (matParticipation.col(i).maxCoeff());
    }
    for (int nbMode = 0; nbMode < nbComplexModes; nbMode++) {
      Eigen::VectorXd participationsMode = 100 * matRelativeParticipation.col(indicesNonzeroImagParts[nbMode]); // relative participation factors of a mode
      Eigen::VectorXd phaseMode = phaseMatrix.col(indicesNonzeroImagParts[nbMode]); // phase of a mode

      // extract the participation factors (greatest to a given threshould) of a mode
      for (unsigned int i = 0; i < matRelativeParticipation.rows(); i++) {
        if (participationsMode(i) > partFactor) {
          selectedParticipationsMode_.push_back(participationsMode(i));
        }
      }
      sort(selectedParticipationsMode_.begin(), selectedParticipationsMode_.end(), std::greater<double>());

      std::vector<double> stdVectorParticipationMode_(participationsMode.data(), participationsMode.data() + participationsMode.size());  // VectorXd to std vector
      // indices that are associated to selected participation factors
      for (unsigned int i = 0; i < selectedParticipationsMode_.size(); i++) {
        std::vector<double> ::iterator it;
        it = find(stdVectorParticipationMode_.begin(), stdVectorParticipationMode_.end(), selectedParticipationsMode_[i]);
        indicesSelectedParticipation_.push_back(it - stdVectorParticipationMode_.begin());
      }

      // indices of coupled dynamic devices
      getIndicesMostCoupledDevices(varDiffNames, indicesSelectedParticipation_, namesDiffDynamicDevices);
      if (indicesMostCoupledDevices_.size() > 1) {
        ++numberCoupledModes_;
      }

      // classify modes according to these natures: Inter-Area, Electrical, Local or Other
      for (unsigned int i = 0; i < indicesMostCoupledDevices_.size(); i++) {
        selectedPhaseMode_.push_back(abs(phaseMode(indicesMostCoupledDevices_[i]))); // phase positions associated to most important participation
      }
      sort(selectedPhaseMode_.begin(), selectedPhaseMode_.end(), std::greater<double>());

      double phaseDifference = abs(selectedPhaseMode_.front() - selectedPhaseMode_.back()); // difference between min and max phase positions

      string modeType = getTypeMode(varDiffNames[indicesMostCoupledDevices_[0]]); // type of mode according to greatest participation
      if (indicesMostCoupledDevices_.size() > 1 && phaseDifference > 90 && modeType == "ROT") {
        ++numberInterAreaModes_; // inter area modes
        indicesInterAreaModes_.push_back(indicesNonzeroImagParts[nbMode]);
      } else if (indicesMostCoupledDevices_.size() >= 1 && phaseDifference < 90 && modeType == "ROT") {
        ++numberLocalModes_; // local modes
        indicesLocalModes_.push_back(indicesNonzeroImagParts[nbMode]);
      } else if (indicesMostCoupledDevices_.size() > 1 && modeType == "EXC" && modeType == "SMD" && modeType == "SMQ" && modeType == "INJ") {
        ++numberElectricalCouplingModes_; // elctrical modes
        indicesElectricalCouplingModes_.push_back(indicesNonzeroImagParts[nbMode]);
      } else {
        ++numberOtherCouplingModes_; // other type of modes
        indicesOtherCouplingModes_.push_back(indicesNonzeroImagParts[nbMode]);
      }

        Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;
        Trace::debug(Trace::fullmodalanalysis()) << "Nb :" << fixed << setprecision(0) << indicesNonzeroImagParts[nbMode] << "||"
        << "Mode : <" << fixed << setprecision(4) << allEigenvalues(indicesNonzeroImagParts[nbMode]) << ">" << Trace::endline;
        Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;

      for (unsigned int i = 0; i < indicesMostCoupledDevices_.size(); i++) {
        string modeType = getTypeMode(varDiffNames[indicesMostCoupledDevices_[i]]);
        Trace::debug(Trace::fullmodalanalysis()) <<  boost::format("%-8i%-15.4f%-15s%-12.4f%-15s")  % indicesMostCoupledDevices_[i]  %
          participationsMode(indicesMostCoupledDevices_[i]) % namesDiffDynamicDevices[indicesMostCoupledDevices_[i]] 
          % phaseMode(indicesMostCoupledDevices_[i]) % modeType << Trace::endline;
      }

      ++counter_;

      if (counter_ == nbComplexModes) {
        Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;
        Trace::debug(Trace::fullmodalanalysis()) << "Minimum Relative Participation (%):" << partFactor << Trace::endline;
        Trace::debug(Trace::fullmodalanalysis()) << "Number of coupled modes is:" << numberCoupledModes_ << Trace::endline;
        Trace::debug(Trace::fullmodalanalysis()) << "Number of Inter-Area Modes :" << numberInterAreaModes_ << Trace::endline;
        Trace::debug(Trace::fullmodalanalysis()) << "indices of Inter-Area Modes :" << Trace::endline;
        if (indicesInterAreaModes_.size() == 0) {
          Trace::debug(Trace::fullmodalanalysis()) << 0 << Trace::endline;
        } else {
          for (unsigned int i = 0; i < indicesInterAreaModes_.size(); i++) {
            Trace::debug(Trace::fullmodalanalysis()) << indicesInterAreaModes_[i] << Trace::endline;
          }
        }

        Trace::debug(Trace::fullmodalanalysis()) << "Number of Electrical Coupling Modes :" << numberElectricalCouplingModes_ << Trace::endline;
        Trace::debug(Trace::fullmodalanalysis()) << "indices of Electrical Coupling Modes :" << Trace::endline;
        if (indicesElectricalCouplingModes_.size() == 0) {
          Trace::debug(Trace::fullmodalanalysis()) << 0 << Trace::endline;
        } else {
          for (unsigned int i = 0; i < indicesElectricalCouplingModes_.size(); i++) {
            Trace::debug(Trace::fullmodalanalysis()) << indicesElectricalCouplingModes_[i] << Trace::endline;
          }
        }
        Trace::debug(Trace::fullmodalanalysis()) << "Number of complex Local Modes :" << numberLocalModes_ << Trace::endline;
        Trace::debug(Trace::fullmodalanalysis()) << "indices of complex Local Modes:" << Trace::endline;
        if (indicesLocalModes_.size() == 0) {
          Trace::debug(Trace::fullmodalanalysis()) << 0 << Trace::endline;;
        } else {
          for (unsigned int i = 0; i < indicesLocalModes_.size(); i++) {
            Trace::debug(Trace::fullmodalanalysis()) << indicesLocalModes_[i] << Trace::endline;
          }
        }

        Trace::debug(Trace::fullmodalanalysis()) << "Number of Other Coupling Modes :" << numberOtherCouplingModes_ << Trace::endline;
        Trace::debug(Trace::fullmodalanalysis()) << "indices of Other Coupling Modes :" << Trace::endline;
        if (indicesOtherCouplingModes_.size() == 0) {
          Trace::debug(Trace::fullmodalanalysis()) << 0 << Trace::endline;
        } else {
          for (unsigned int i = 0; i < indicesOtherCouplingModes_.size(); i++) {
            Trace::debug(Trace::fullmodalanalysis()) << indicesOtherCouplingModes_[i] << Trace::endline;
          }
        }
        Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;
      }
    freeVector();
    }
  }
}

}  // namespace DYN
