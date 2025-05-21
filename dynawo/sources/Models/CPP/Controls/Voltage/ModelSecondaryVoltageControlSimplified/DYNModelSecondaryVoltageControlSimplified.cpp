//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  DYNModelSecondaryVoltageControlSimplified.cpp
 *
 * @brief Model for simplifed discrete secondary voltage control
 *
 */

#include <sstream>
#include <vector>
#include <algorithm>

#include "PARParametersSet.h"

#include "DYNNumericalUtils.h"
#include "DYNModelSecondaryVoltageControlSimplified.h"
#include "DYNModelSecondaryVoltageControlSimplified.hpp"
#include "DYNSparseMatrix.h"
#include "DYNMacrosMessage.h"
#include "DYNElement.h"
#include "DYNCommonModeler.h"
#include "DYNTrace.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"

using std::vector;
using std::string;
using std::map;
using std::stringstream;

using boost::shared_ptr;

using parameters::ParametersSet;

extern "C" DYN::SubModelFactory* getFactory() {
  return (new DYN::ModelSecondaryVoltageControlSimplifiedFactory());
}

extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

extern "C" DYN::SubModel* DYN::ModelSecondaryVoltageControlSimplifiedFactory::create() const {
  DYN::SubModel* model(new DYN::ModelSecondaryVoltageControlSimplified());
  return model;
}

extern "C" void DYN::ModelSecondaryVoltageControlSimplifiedFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

constexpr double ModelSecondaryVoltageControlSimplified::LEVEL_MAX;   ///< Maximal admissible level
constexpr double ModelSecondaryVoltageControlSimplified::LEVEL_MIN;  ///< Minimal admissible level

  ModelSecondaryVoltageControlSimplified::ModelSecondaryVoltageControlSimplified() : ModelCPP("SecondaryVoltageControlSimplified"),
    nbGenerators_(0),
    UDeadBandPu_(0.),
    alpha_(0.),
    beta_(0.),
    UpRef0Pu_(0.),
    tSample_(10.),
    iTerm_(0.),
    feedBackCorrection_(0.) {}

  void
  ModelSecondaryVoltageControlSimplified::defineParameters(std::vector<ParameterModeler>& parameters) {
    parameters.push_back(ParameterModeler("nbGenerators", VAR_TYPE_INT, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("UDeadBandPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("alpha", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("beta", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("UpRef0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("tSample", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("Qr", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbGenerators"));
    parameters.push_back(ParameterModeler("Q0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbGenerators"));
  }

  void
  ModelSecondaryVoltageControlSimplified::setSubModelParameters() {
    try {
      nbGenerators_ = findParameterDynamic("nbGenerators").getValue<int>();
      UDeadBandPu_ = findParameterDynamic("UDeadBandPu").getValue<double>();
      alpha_ = findParameterDynamic("alpha").getValue<double>();
      beta_ = findParameterDynamic("beta").getValue<double>();
      UpRef0Pu_ = findParameterDynamic("UpRef0Pu").getValue<double>();
      tSample_ = findParameterDynamic("tSample").getValue<double>();
      std::stringstream qrName;
      std::stringstream q0PuName;
      for (int s = 0; s < nbGenerators_; ++s) {
        qrName.str(std::string());
        qrName.clear();
        qrName << "Qr_" << s;
        Qr_.push_back(findParameterDynamic(qrName.str()).getValue<double>());
        q0PuName.str(std::string());
        q0PuName.clear();
        q0PuName << "Q0Pu_" << s;
        Q0Pu_.push_back(findParameterDynamic(q0PuName.str()).getValue<double>());
      }
    } catch (const DYN::Error& e) {
    Trace::error() << e.what() << Trace::endline;
    throw DYNError(Error::MODELER, NetworkParameterNotFoundFor, name());
    }
  }

  void
  ModelSecondaryVoltageControlSimplified::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) {
    variables.push_back(VariableNativeFactory::createState("UpPu_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState("UpRefPu_value", DISCRETE));
    variables.push_back(VariableNativeFactory::createState("tLastActivation_value", DISCRETE));
    variables.push_back(VariableNativeFactory::createState("levelVal_value", DISCRETE));
    std::stringstream blockerName;
    for (int s = 0; s < nbGenerators_; ++s) {
      blockerName.str(std::string());
      blockerName.clear();
      blockerName << "blocker_" << s << "_value";
      variables.push_back(VariableNativeFactory::createState(blockerName.str(), BOOLEAN));
    }
    variables.push_back(VariableNativeFactory::createCalculated("level_value", CONTINUOUS));
  }

  void
  ModelSecondaryVoltageControlSimplified::init(const double /*t0*/) {
    /* not need */
  }

  void
  ModelSecondaryVoltageControlSimplified::collectSilentZ(BitMask* silentZTable) {
    for (unsigned int s = 0; s < sizeZ_; ++s) {
      silentZTable[s].setFlags(NotUsedInContinuousEquations);
    }
  }

  void
  ModelSecondaryVoltageControlSimplified::getSize() {
    sizeF_ = 0;
    sizeY_ = 1;
    sizeZ_ = firstIndexBlockerNum_ + nbGenerators_;
    sizeG_ = 2;
    sizeMode_ = 0;
    calculatedVars_.assign(nbCalculatedVariables_, 0);
  }

  void
  ModelSecondaryVoltageControlSimplified::evalStaticYType() {
    yType_[0] = EXTERNAL;
  }

  void
  ModelSecondaryVoltageControlSimplified::evalF(double /*t*/, propertyF_t /*type*/) {
    /* not need */
  }

  void
  ModelSecondaryVoltageControlSimplified::evalJt(double /*t*/, double /*cj*/, int /*rowOffset*/, SparseMatrix &/*j*/) {
    /* not need */
  }

  void
  ModelSecondaryVoltageControlSimplified::evalG(const double t) {
    gLocal_[ActivationNum_] = (t - (zLocal_[tLastActivationNum_] + tSample_) > 0
                              || (doubleEquals(t, (zLocal_[tLastActivationNum_] + tSample_)) && !doubleIsZero(t))) ? ROOT_UP : ROOT_DOWN;
    if (gLocal_[ActivationNum_] == ROOT_UP) {
      auto notBlocked = std::find_if(&zLocal_[firstIndexBlockerNum_], &zLocal_[firstIndexBlockerNum_ + nbGenerators_],
          [](double b) { return b < 1; });
      gLocal_[BlockingNum_] = (notBlocked != &zLocal_[firstIndexBlockerNum_ + nbGenerators_]) ? ROOT_DOWN : ROOT_UP;
    } else {
      gLocal_[BlockingNum_] = ROOT_DOWN;
    }
  }

  void
  ModelSecondaryVoltageControlSimplified::antiWindUpCorrection() {
    if (doubleEquals(zLocal_[levelValNum_], LEVEL_MAX) || (zLocal_[levelValNum_] > LEVEL_MAX)) {
      feedBackCorrection_ = LEVEL_MAX - zLocal_[levelValNum_];
      zLocal_[levelValNum_] += feedBackCorrection_;
    } else if (doubleEquals(zLocal_[levelValNum_], LEVEL_MIN) || (zLocal_[levelValNum_] < LEVEL_MIN)) {
      feedBackCorrection_ = LEVEL_MIN - zLocal_[levelValNum_];
      zLocal_[levelValNum_] += feedBackCorrection_;
    }
  }

  void
  ModelSecondaryVoltageControlSimplified::evalZ(const double t) {
    if (gLocal_[ActivationNum_] == ROOT_UP && doubleNotEquals(t, zLocal_[tLastActivationNum_]) && gLocal_[BlockingNum_] == ROOT_DOWN) {
      double minValue = zLocal_[UpRefPuNum_] - UDeadBandPu_;
      double maxValue = zLocal_[UpRefPuNum_] + UDeadBandPu_;
      if (doubleLess(yLocal_[UpPuNum_], minValue) || doubleGreater(yLocal_[UpPuNum_], maxValue)) {
        double iTermTmp = iTerm_;
        iTermTmp += alpha_ * (zLocal_[UpRefPuNum_] - yLocal_[UpPuNum_]) * tSample_;
        zLocal_[levelValNum_] = iTermTmp + beta_ * (zLocal_[UpRefPuNum_] - yLocal_[UpPuNum_]);
        feedBackCorrection_ = 0;
        antiWindUpCorrection();
        iTerm_ = iTermTmp + feedBackCorrection_;
      }
      zLocal_[tLastActivationNum_] = t;
    }
  }

  void
  ModelSecondaryVoltageControlSimplified::setGequations() {
    gEquationIndex_[ActivationNum_] = std::string("t >= tLastUpdate_ + tSample");
    gEquationIndex_[BlockingNum_] = std::string("(t >= tLastUpdate_ + tSample) and all groups blocked");

    assert(gEquationIndex_.size() == static_cast<size_t>(sizeG()) && "Model VoltageMeasurementsUtilities: gEquationIndex.size() != gLocal_.size()");
  }

  void
  ModelSecondaryVoltageControlSimplified::getY0() {
    zLocal_[UpRefPuNum_] = UpRef0Pu_;
    if (!isStartingFromDump()) {
      zLocal_[tLastActivationNum_] = 0.;
      zLocal_[levelValNum_] = 0.;
      for (auto& q : Q0Pu_) {
        zLocal_[levelValNum_] += (-1.0 * q * SNREF);
      }
      double qrSum = 0;
      for (auto& qr : Qr_) {
        qrSum += qr;
      }
      zLocal_[levelValNum_] = zLocal_[levelValNum_] / qrSum;
      antiWindUpCorrection();
      iTerm_ = zLocal_[levelValNum_] + feedBackCorrection_;
      for (int i = firstIndexBlockerNum_; i < firstIndexBlockerNum_ + nbGenerators_ ; i++) {
        zLocal_[i] =  false;
      }
    }
  }

  void
  ModelSecondaryVoltageControlSimplified::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
    /* not need */
  }

  void
  ModelSecondaryVoltageControlSimplified::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<double>& /*res*/) const {
    /* not need */
  }

  void
  ModelSecondaryVoltageControlSimplified::evalJtPrim(double /*t*/, double /*cj*/, int /*rowOffset*/, SparseMatrix& /*jtPrim*/) {
    /* not need */
  }

  modeChangeType_t
  ModelSecondaryVoltageControlSimplified::evalMode(const double /*t*/) {
    return NO_MODE;
  }

  void
  ModelSecondaryVoltageControlSimplified::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
    /* not need */
  }

  double
  ModelSecondaryVoltageControlSimplified::evalCalculatedVarI(unsigned iCalculatedVar) const {
    double out = 0.;
    switch (iCalculatedVar) {
    case levelNum_:
      out = zLocal_[levelValNum_];
      break;
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
    }

    return out;
  }

  void
  ModelSecondaryVoltageControlSimplified::evalCalculatedVars() {
    calculatedVars_[levelNum_] = zLocal_[levelValNum_];
  }

  void
  ModelSecondaryVoltageControlSimplified::defineElements(std::vector<Element>& elements, std::map<std::string, int >& mapElement) {
    addElement("UpPu", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "UpPu", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("UpRefPu", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "UpRefPu", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("tLastActivation", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "tLastActivation", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("levelVal", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "levelVal", Element::TERMINAL, name(), modelType(), elements, mapElement);
    std::stringstream blockerName;
    for (int s = 0; s < nbGenerators_; ++s) {
      blockerName.str(std::string());
      blockerName.clear();
      blockerName << "blocker_" << s;
      addElement(blockerName.str(), Element::STRUCTURE, elements, mapElement);
      addSubElement("value", blockerName.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
    }
    addElement("level", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "level", Element::TERMINAL, name(), modelType(), elements, mapElement);
  }

  void
  ModelSecondaryVoltageControlSimplified::dumpInternalVariables(boost::archive::binary_oarchive& os) const {
    ModelCPP::dumpInStream(os, iTerm_);
    ModelCPP::dumpInStream(os, feedBackCorrection_);
  }

  void
  ModelSecondaryVoltageControlSimplified::loadInternalVariables(boost::archive::binary_iarchive& is) {
    char c;
    is >> c;
    is >> iTerm_;
    is >> c;
    is >> feedBackCorrection_;
  }

  void
  ModelSecondaryVoltageControlSimplified::dumpUserReadableElementList(const std::string& /*nameElement*/) const {
    Trace::info() << DYNLog(ElementNames, name(), modelType()) << Trace::endline;
    Trace::info() << "  ->" << "UpPu_value" << Trace::endline;
    Trace::info() << "  ->" << "UpRefPu_value" << Trace::endline;
    Trace::info() << "  ->" << "UpPu_value" << Trace::endline;
    Trace::info() << "  ->" << "levelVal_value" << Trace::endline;
    Trace::info() << "  ->" << "level_value" << Trace::endline;
    Trace::info() << "  ->" << "blocker_" << "<0-" << nbGenerators_ << ">_value" << Trace::endline;
  }

}  // namespace DYN
