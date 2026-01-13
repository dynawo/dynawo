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
    Alpha_(0.),
    Beta_(0.),
    UpRef0Pu_(0.),
    tSample_(10.),
    iTerm_(0.),
    feedBackCorrection_(0.) {}

  void
  ModelSecondaryVoltageControlSimplified::defineParameters(std::vector<ParameterModeler>& parameters) {
    parameters.push_back(ParameterModeler("nbGenerators", VAR_TYPE_INT, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("UDeadBandPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("Alpha", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("Beta", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("UpRef0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("tSample", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("Qr", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbGenerators"));
    parameters.push_back(ParameterModeler("Q0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbGenerators"));
    parameters.push_back(ParameterModeler("P0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbGenerators"));
    parameters.push_back(ParameterModeler("U0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbGenerators"));
    parameters.push_back(ParameterModeler("SNom", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbGenerators"));
    parameters.push_back(ParameterModeler("XTfoPu", VAR_TYPE_DOUBLE, SHARED_PARAMETER, "*", "nbGenerators"));
  }

  void
  ModelSecondaryVoltageControlSimplified::setSubModelParameters() {
    try {
      nbGenerators_ = findParameterDynamic("nbGenerators").getValue<int>();
      UDeadBandPu_ = findParameterDynamic("UDeadBandPu").getValue<double>();
      Alpha_ = findParameterDynamic("Alpha").getValue<double>();
      Beta_ = findParameterDynamic("Beta").getValue<double>();
      UpRef0Pu_ = findParameterDynamic("UpRef0Pu").getValue<double>();
      tSample_ = findParameterDynamic("tSample").getValue<double>();
      std::stringstream qrName;
      std::stringstream q0PuName;
      std::stringstream p0PuName;
      std::stringstream u0PuName;
      std::stringstream sNomName;
      std::stringstream xTfoPuName;
      for (int s = 0; s < nbGenerators_; ++s) {
        qrName.str(std::string());
        qrName.clear();
        qrName << "Qr_" << s;
        Qr_.push_back(findParameterDynamic(qrName.str()).getValue<double>());
        q0PuName.str(std::string());
        q0PuName.clear();
        q0PuName << "Q0Pu_" << s;
        Q0Pu_.push_back(findParameterDynamic(q0PuName.str()).getValue<double>());
        p0PuName.str(std::string());
        p0PuName.clear();
        p0PuName << "P0Pu_" << s;
        P0Pu_.push_back(findParameterDynamic(p0PuName.str()).getValue<double>());
        u0PuName.str(std::string());
        u0PuName.clear();
        u0PuName << "U0Pu_" << s;
        U0Pu_.push_back(findParameterDynamic(u0PuName.str()).getValue<double>());
        sNomName.str(std::string());
        sNomName.clear();
        sNomName << "SNom_" << s;
        const auto& paramSNom = findParameterDynamic(sNomName.str());
        if (paramSNom.hasValue())
          SNom_.push_back(paramSNom.getValue<double>());
        else
          SNom_.push_back(SNREF);
        xTfoPuName.str(std::string());
        xTfoPuName.clear();
        xTfoPuName << "XTfoPu_" << s;
        const auto& paramXTfoPu = findParameterDynamic(xTfoPuName.str());
        if (paramXTfoPu.hasValue())
          XTfoPu_.push_back(paramXTfoPu.getValue<double>());
        else
          XTfoPu_.push_back(0.);
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
    std::stringstream Qs;
    for (int s = 0; s < nbGenerators_; ++s) {
      blockerName.str(std::string());
      blockerName.clear();
      blockerName << "blocker_" << s << "_value";
      variables.push_back(VariableNativeFactory::createState(blockerName.str(), BOOLEAN));

      Qs.str(std::string());
      Qs.clear();
      Qs << "QStator_" << s << "_value";
      variables.push_back(VariableNativeFactory::createState(Qs.str(), CONTINUOUS));
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
    sizeY_ = 1 + nbGenerators_;
    sizeZ_ = firstIndexBlockerNum_ + nbGenerators_;
    sizeG_ = 2;
    sizeMode_ = 0;
    calculatedVars_.assign(nbCalculatedVariables_, 0);
  }

  void
  ModelSecondaryVoltageControlSimplified::evalStaticYType() {
    yType_[0] = EXTERNAL;
    for (int s = 0; s < nbGenerators_; ++s) {
      yType_[s + 1] = EXTERNAL;
    }
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
      const bool blocked = (notBlocked == &zLocal_[firstIndexBlockerNum_ + nbGenerators_]);
      if (blocked && gLocal_[BlockingNum_] == ROOT_DOWN) {
        DYNAddTimelineEvent(this, name(), VRFrozen);
      } else if (!blocked && gLocal_[BlockingNum_] == ROOT_UP) {
        DYNAddTimelineEvent(this, name(), VRUnfrozen);
      }
      gLocal_[BlockingNum_] = (!blocked) ? ROOT_DOWN : ROOT_UP;
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
  ModelSecondaryVoltageControlSimplified::calculateInitialState() {
    zLocal_[levelValNum_] = 0.;
    for (int g = 0; g < nbGenerators_; g++) {
      zLocal_[levelValNum_] += yLocal_[g + 1];
     }
    double qrSum = 0;
    for (auto& qr : Qr_) {
      qrSum += qr;
    }
    zLocal_[levelValNum_] = zLocal_[levelValNum_] / qrSum;
    antiWindUpCorrection();
    iTerm_ = zLocal_[levelValNum_] + feedBackCorrection_;
  }

  void
  ModelSecondaryVoltageControlSimplified::evalZ(const double t) {
    if (!isStartingFromDump() && doubleIsZero(t) && doubleEquals(UpRef0Pu_, yLocal_[UpPuNum_])) {
      // Compute initial level from actual Qstator values at the beginning of the simulation
      // Do it as long as the voltage is constant to make sure that discrete status variables were taken into account in continuous equations
      calculateInitialState();
    }
    if (gLocal_[ActivationNum_] == ROOT_UP && doubleNotEquals(t, zLocal_[tLastActivationNum_]) && gLocal_[BlockingNum_] == ROOT_DOWN) {
      double minValue = zLocal_[UpRefPuNum_] - UDeadBandPu_;
      double maxValue = zLocal_[UpRefPuNum_] + UDeadBandPu_;
      if (doubleLess(yLocal_[UpPuNum_], minValue) || doubleGreater(yLocal_[UpPuNum_], maxValue)) {
        double iTermTmp = iTerm_;
        iTermTmp += Alpha_ * (zLocal_[UpRefPuNum_] - yLocal_[UpPuNum_]) * tSample_;
        double levelSave = zLocal_[levelValNum_];
        zLocal_[levelValNum_] = iTermTmp + Beta_ * (zLocal_[UpRefPuNum_] - yLocal_[UpPuNum_]);
        feedBackCorrection_ = 0;
        antiWindUpCorrection();
        iTerm_ = iTermTmp + feedBackCorrection_;
        if (doubleNotEquals(static_cast<int>(levelSave*100), static_cast<int>(zLocal_[levelValNum_]*100)))
          DYNAddTimelineEvent(this, name(), SVRLevelNew,  zLocal_[levelValNum_]);
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
      double iSquare0Pu = 0.;
      double QTfo0Pu = 0.;
      double QStator0Pu = 0.;
      for (int g = 0; g < nbGenerators_; g++) {
        iSquare0Pu = (P0Pu_[g] * P0Pu_[g] + Q0Pu_[g] * Q0Pu_[g]) / (U0Pu_[g] * U0Pu_[g]);
        QTfo0Pu = iSquare0Pu * XTfoPu_[g] * SNREF / SNom_[g];
        QStator0Pu = Q0Pu_[g] - QTfo0Pu;
        zLocal_[levelValNum_] += (-1.0 * QStator0Pu * SNREF);
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
      gLocal_[BlockingNum_] = ROOT_DOWN;
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
    std::stringstream Qs;
    for (int s = 0; s < nbGenerators_; ++s) {
      blockerName.str(std::string());
      blockerName.clear();
      blockerName << "blocker_" << s;
      addElement(blockerName.str(), Element::STRUCTURE, elements, mapElement);
      addSubElement("value", blockerName.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);

      Qs.str(std::string());
      Qs.clear();
      Qs << "QStator_" << s;
      addElement(Qs.str(), Element::STRUCTURE, elements, mapElement);
      addSubElement("value", Qs.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
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
    Trace::info() << "  ->" << "QStator_" << "<0-" << nbGenerators_ << ">_value" << Trace::endline;
  }

}  // namespace DYN
