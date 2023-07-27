//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
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
 * @file  DYNModelLoadRestorativeWithLimits.cpp
 *
 * @brief Load restorative with limits model implementation
 *
 */



#include <sstream>
#include <vector>
#include <algorithm>

#include "PARParametersSet.h"

#include "DYNNumericalUtils.h"
#include "DYNModelLoadRestorativeWithLimits.h"
#include "DYNModelLoadRestorativeWithLimits.hpp"
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

using boost::shared_ptr;

using parameters::ParametersSet;


extern "C" DYN::SubModelFactory* getFactory() {
  return (new DYN::ModelLoadRestorativeWithLimitsFactory());
}

extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

extern "C" DYN::SubModel* DYN::ModelLoadRestorativeWithLimitsFactory::create() const {
  DYN::SubModel* model(new DYN::ModelLoadRestorativeWithLimits());
  return model;
}

extern "C" void DYN::ModelLoadRestorativeWithLimitsFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {
  ModelLoadRestorativeWithLimits::ModelLoadRestorativeWithLimits() : ModelCPP("LoadRestorativeWithLimits"),
  UfYNum_(0),
  UrYNum_(1),
  UiYNum_(2),
  IrYNum_(3),
  IiYNum_(4),
  running_(RUNNING_FALSE),
  u0Pu_(0),
  Tf_(0),
  P0Pu_(0),
  Q0Pu_(0),
  alpha_(0),
  beta_(0),
  angleO_(0),
  UMinPu_(0),
  UMaxPu_(0),
  UMinPuReached_(false),
  UMaxPuReached_(false) {}

  void
  ModelLoadRestorativeWithLimits::defineParameters(vector<ParameterModeler>& parameters) {
    parameters.push_back(ParameterModeler("load_U0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("load_tFilter", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("load_P0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("load_Q0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("load_Alpha", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("load_Beta", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("load_UPhase0", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("load_UMin0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("load_UMax0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("load_UDeadBandPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  }

  void
  ModelLoadRestorativeWithLimits::setSubModelParameters() {
    try {
    u0Pu_ = findParameterDynamic("load_U0Pu").getValue<double>();
    Tf_ = findParameterDynamic("load_tFilter").getValue<double>();
    P0Pu_ = findParameterDynamic("load_P0Pu").getValue<double>();
    Q0Pu_ = findParameterDynamic("load_Q0Pu").getValue<double>();
    alpha_ = findParameterDynamic("load_Alpha").getValue<double>();
    beta_ = findParameterDynamic("load_Beta").getValue<double>();
    angleO_ = findParameterDynamic("load_UPhase0").getValue<double>();
    UMinPu_ = findParameterDynamic("load_UMin0Pu").getValue<double>();
    UMaxPu_ = findParameterDynamic("load_UMax0Pu").getValue<double>();
    double UDeadBandPu = findParameterDynamic("load_UDeadBandPu").getValue<double>();
    if ((u0Pu_ - UDeadBandPu) < UMinPu_)
      UMinPu_ = u0Pu_ - UDeadBandPu;
    if ((u0Pu_ + UDeadBandPu) > UMaxPu_)
      UMaxPu_ = u0Pu_ + UDeadBandPu;
    } catch (const DYN::Error& e) {
    Trace::error() << e.what() << Trace::endline;
    throw DYNError(Error::MODELER, NetworkParameterNotFoundFor, staticId());
    }
  }

  void
  ModelLoadRestorativeWithLimits::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) {
    variables.push_back(VariableNativeFactory::createState("UfPu_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState("Ur_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState("Ui_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState("Ir_value", FLOW));
    variables.push_back(VariableNativeFactory::createState("Ii_value", FLOW));
    variables.push_back(VariableNativeFactory::createCalculated("PPu_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createCalculated("P_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createCalculated("QPu_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createCalculated("state_value", INTEGER));
    variables.push_back(VariableNativeFactory::createCalculated("loadState_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState("switchOff1_value", BOOLEAN));
    variables.push_back(VariableNativeFactory::createState("switchOff2_value", BOOLEAN));
    variables.push_back(VariableNativeFactory::createState("running_value", BOOLEAN));
  }

  void
  ModelLoadRestorativeWithLimits::init(const double /*t0*/) {
    /* not needed */
  }

  void
  ModelLoadRestorativeWithLimits::collectSilentZ(BitMask* silentZTable) {
    silentZTable[switchOffSignal1].setFlags(NotUsedInContinuousEquations);
    silentZTable[switchOffSignal2].setFlags(NotUsedInContinuousEquations);
    silentZTable[running].setFlags(NotSilent);
  }

  void
  ModelLoadRestorativeWithLimits::getSize() {
    sizeF_ = 3;
    sizeY_ = 5;
    sizeZ_ = numZ;
    sizeG_ = 3;
    sizeMode_ = 2;
    calculatedVars_.assign(nbCalculatedVariables_, 0);
  }

  void
  ModelLoadRestorativeWithLimits::evalDynamicYType() {
    if (UMaxPuReached_ || UMinPuReached_) {
      yType_[UfYNum_] = ALGEBRAIC;  // uf
    } else {
      yType_[UfYNum_] = DIFFERENTIAL;  // uf
    }
  }
  void
  ModelLoadRestorativeWithLimits::evalStaticYType() {
    yType_[UrYNum_] = EXTERNAL;  // ur
    yType_[UiYNum_] = EXTERNAL;  // ui
    yType_[IrYNum_] = ALGEBRAIC;  // ir
    yType_[IiYNum_] = ALGEBRAIC;  // ii
  }

  void
  ModelLoadRestorativeWithLimits::evalDynamicFType() {
    if (UMaxPuReached_ || UMinPuReached_) {
      fType_[0] = ALGEBRAIC_EQ;
    } else {
      fType_[0] = DIFFERENTIAL_EQ;
    }
  }

  void
  ModelLoadRestorativeWithLimits::evalStaticFType() {
    fType_[1] = ALGEBRAIC_EQ;
    fType_[2] = ALGEBRAIC_EQ;
  }

  void
  ModelLoadRestorativeWithLimits::evalF(double /*t*/, propertyF_t type) {
    if (isConnected()) {
      double limitValue = 0;
      double Ur = yLocal_[UrYNum_];
      double Ui = yLocal_[UiYNum_];
      double U2 = Ur * Ur + Ui * Ui;
      double U = sqrt(U2);
      double Uf = yLocal_[UfYNum_];
      double Ir = yLocal_[IrYNum_];
      double Ii = yLocal_[IiYNum_];
      double alpha_pow = pow_dynawo(U/Uf, alpha_);
      double beta_pow = pow_dynawo(U/Uf, beta_);
      if (UMaxPuReached_) {
        limitValue = UMaxPu_;
      }
      if (UMinPuReached_) {
        limitValue = UMinPu_;
      }
      if (type != ALGEBRAIC_EQ && !UMaxPuReached_ && !UMinPuReached_) {
        fLocal_[0] = Tf_ * ypLocal_[UfYNum_] - (U - yLocal_[UfYNum_]);
      }
      if (type != DIFFERENTIAL_EQ) {
        if (UMinPuReached_ || UMaxPuReached_) {
          fLocal_[0] = yLocal_[UfYNum_] - limitValue;
        }
        fLocal_[1] = Ir - (P0Pu_ * alpha_pow * Ur + Q0Pu_ * beta_pow * Ui) / (U * U);
        fLocal_[2] = Ii - (P0Pu_ * alpha_pow * Ui - Q0Pu_ * beta_pow * Ur) / (U * U);
      }
    } else {
      fLocal_[0] = ypLocal_[UfYNum_];
      fLocal_[1] = yLocal_[IrYNum_];
      fLocal_[2] = yLocal_[IiYNum_];
    }
  }

  void
  ModelLoadRestorativeWithLimits::setFequations() {
    if (isConnected()) {
      if (!UMaxPuReached_ && !UMinPuReached_) {
        fEquationIndex_[0] = std::string("Tf_*UfPrim - (U - Uf ):");
      } else {
        fEquationIndex_[0] = std::string("Uf - limitValue:");
      }
      fEquationIndex_[1] = std::string("Ir - (P * Ur + Q * Ui) / (U * U): ");
      fEquationIndex_[2] = std::string("Ii - (P * Ui - Q * Ur) / (U * U): ");
    } else {
      fEquationIndex_[0] = std::string("UfPrim = 0:");
      fEquationIndex_[1] = std::string("Ir = 0: ");
      fEquationIndex_[2] = std::string("Ii = 0: ");
    }
  }

  void
  ModelLoadRestorativeWithLimits::evalZ(const double /*t*/) {
    if (gLocal_[2] == ROOT_UP) {
      if (isConnected()) {
        running_ = static_cast<int>(zLocal_[running]);
        zLocal_[running] = RUNNING_FALSE;
        DYNAddTimelineEvent(this, name(), LoadDisconnected);
      } else if (!isConnected()) {
        running_ = static_cast<int>(zLocal_[running]);
        zLocal_[running] = RUNNING_TRUE;
        DYNAddTimelineEvent(this, name(), LoadConnected);
      }
    }

    if (gLocal_[0] == ROOT_UP) {
      UMaxPuReached_ = true;
    } else {
      UMaxPuReached_ = false;
    }
    if (gLocal_[1] == ROOT_UP) {
      UMinPuReached_ = true;
    } else {
      UMinPuReached_ = false;
    }
    return;
  }

  void
  ModelLoadRestorativeWithLimits::evalJt(const double /*t*/, const double cj, SparseMatrix& jt, const int rowOffset) {
    if (!isConnected()) {
      jt.changeCol();  // uf
      jt.addTerm(UfYNum_ + rowOffset, cj);
      jt.changeCol();  //  Ir
      jt.addTerm(IrYNum_ + rowOffset, 1);
      jt.changeCol();  // Ii
      jt.addTerm(IiYNum_ + rowOffset, 1);
    } else {
      double Ur = yLocal_[UrYNum_];
      double Ui = yLocal_[UiYNum_];
      double U2 = Ur * Ur + Ui * Ui;
      double U = sqrt(U2);
      double Uf = yLocal_[UfYNum_];
      double alpha_pow = pow_dynawo(U/Uf, alpha_);
      double beta_pow = pow_dynawo(U/Uf, beta_);
      double P = P0Pu_ * alpha_pow;
      double Q = Q0Pu_ * beta_pow;
      double P_dUr = P0Pu_ * alpha_ * Ur * alpha_pow / U2;
      double P_dUi = P0Pu_ * alpha_ * Ui * alpha_pow / U2;
      double P_dUf = -1.0 * alpha_ * P0Pu_ * alpha_pow / Uf;
      double Q_dUr = Q0Pu_ * beta_ * Ur * beta_pow / U2;
      double Q_dUi = Q0Pu_ * beta_ * Ui * beta_pow / U2;
      double Q_dUf = -1.0 * beta_ * Q0Pu_ * beta_pow / Uf;
      jt.changeCol();  // uf
      if (!UMaxPuReached_ && !UMinPuReached_) {
        jt.addTerm(UfYNum_ + rowOffset, 1.0 + cj * Tf_);
        jt.addTerm(UrYNum_ + rowOffset, -Ur/U);
        jt.addTerm(UiYNum_ + rowOffset, -Ui/U);
      } else {
        jt.addTerm(UfYNum_ + rowOffset, 1);
      }
      jt.changeCol();  // Ir
      jt.addTerm(IrYNum_ + rowOffset, 1);
      jt.addTerm(UrYNum_ + rowOffset, - ((Ur * P_dUr + P + Ui * Q_dUr) * U2 - 2 * Ur * (P * Ur + Q * Ui)) / (U2 * U2));
      jt.addTerm(UiYNum_ + rowOffset, - ((Ur * P_dUi + Q + Ui * Q_dUi) * U2 - 2 * Ui * (P * Ur + Q * Ui)) / (U2 * U2));
      jt.addTerm(UfYNum_ + rowOffset, - (Ur * P_dUf + Ui * Q_dUf) / U2);
      jt.changeCol();  // Ii
      jt.addTerm(IiYNum_ + rowOffset, 1);
      jt.addTerm(UiYNum_ + rowOffset, - ((Ui * P_dUi + P - Ur * Q_dUi) * U2 - 2 * Ui * (P * Ui - Q * Ur)) / (U2 * U2));
      jt.addTerm(UrYNum_ + rowOffset, - ((Ui * P_dUr - Q - Ur * Q_dUr) * U2 - 2 * Ur * (P * Ui - Q * Ur)) / (U2 * U2));
      jt.addTerm(UfYNum_ + rowOffset, - (Ui * P_dUf - Ur * Q_dUf) / U2);
    }
  }

  void
  ModelLoadRestorativeWithLimits::evalG(const double /*t*/) {
    gLocal_[0] = (doubleEquals(yLocal_[UfYNum_], UMaxPu_) || yLocal_[UfYNum_] > UMaxPu_) ? ROOT_UP : ROOT_DOWN;
    gLocal_[1] = (doubleEquals(yLocal_[UfYNum_], UMinPu_) || UMinPu_ - yLocal_[UfYNum_] > 0) ? ROOT_UP : ROOT_DOWN;
    gLocal_[2] = (((zLocal_[switchOffSignal1] > 0 || zLocal_[switchOffSignal2] > 0) &&
      static_cast<int>(zLocal_[running]) == RUNNING_TRUE) || ((zLocal_[switchOffSignal1] < 0 && zLocal_[switchOffSignal2] < 0) &&
      static_cast<int>(zLocal_[running]) == RUNNING_FALSE)) ? ROOT_UP : ROOT_DOWN;
  }

  void
  ModelLoadRestorativeWithLimits::setGequations() {
    gEquationIndex_[0] = std::string("UfPu >= UMaxPu ");
    gEquationIndex_[1] = std::string("UfPu =< UMinPu ");
    gEquationIndex_[2] = "((switchoff_signal_1 = true or switchOffSignal2 = true) and running) || "
                       "((switchoff_signal_1 = false and switchOffSignal2 = false) && not(running))";
  }

  void
  ModelLoadRestorativeWithLimits::evalJtPrim(const double /*t*/, const double /*cj*/, SparseMatrix& jt, const int rowOffset) {
    jt.changeCol();
    if (isConnected()) {
      if (!UMaxPuReached_ && !UMinPuReached_) {
        jt.addTerm(UfYNum_ + rowOffset, Tf_);
      }
    } else {
      jt.addTerm(UfYNum_ + rowOffset, 1);
    }
    jt.changeCol();
    jt.changeCol();
  }

  modeChangeType_t
  ModelLoadRestorativeWithLimits::evalMode(const double /*t*/) {
    if (gLocal_[0] == ROOT_UP || gLocal_[1] == ROOT_UP)
      return ALGEBRAIC_MODE;
    if (running_ != static_cast<int>(zLocal_[running])) {
      running_ = static_cast<int>(zLocal_[running]);
      return ALGEBRAIC_J_UPDATE_MODE;
    }
    return NO_MODE;
  }

  void
  ModelLoadRestorativeWithLimits::getY0() {
    // uf
    yLocal_[UfYNum_] = u0Pu_;
    ypLocal_[UfYNum_] = 0.;
    // Ir
    yLocal_[IrYNum_] = (P0Pu_ * u0Pu_ * cos(angleO_) + Q0Pu_ * u0Pu_ * sin(angleO_)) / (u0Pu_ * u0Pu_);
    ypLocal_[IrYNum_] = 0;
    // Ii
    yLocal_[IiYNum_] = (P0Pu_ * u0Pu_ * sin(angleO_) - Q0Pu_ * u0Pu_ * cos(angleO_)) / (u0Pu_ * u0Pu_);
    ypLocal_[IiYNum_] = 0;
    running_ = RUNNING_TRUE;
    zLocal_[switchOffSignal1] = SWITCHOFF_FALSE;
    zLocal_[switchOffSignal2] = SWITCHOFF_FALSE;
    zLocal_[running] = running_;
  }

  void
  ModelLoadRestorativeWithLimits::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
    /* not need */
  }

  double
  ModelLoadRestorativeWithLimits::evalCalculatedVarI(unsigned iCalculatedVar) const {
    double output = 0;
    switch (iCalculatedVar) {
      case PPuNum_:
        if (isConnected()) {
          double U = sqrt(yLocal_[UrYNum_] * yLocal_[UrYNum_] + yLocal_[UiYNum_] * yLocal_[UiYNum_]);
          output = P0Pu_ * pow_dynawo(U/yLocal_[UfYNum_], alpha_);
        }
        break;
      case PNum_:
        if (isConnected()) {
          double U = sqrt(yLocal_[UrYNum_] * yLocal_[UrYNum_] + yLocal_[UiYNum_] * yLocal_[UiYNum_]);
          output = SNREF * P0Pu_ * pow_dynawo(U/yLocal_[UfYNum_], alpha_);
        }
        break;
      case QNum_:
        if (isConnected()) {
          double U = sqrt(yLocal_[UrYNum_] * yLocal_[UrYNum_] + yLocal_[UiYNum_] * yLocal_[UiYNum_]);
          output = Q0Pu_ * pow_dynawo(U/yLocal_[UfYNum_], beta_);
        }
        break;
      case loadStateNum_:
      case loadRealStateNum_:
        if (isConnected()) {
          output = CLOSED;
        } else if (!isConnected()) {
          output = OPEN;
        }
        break;
      default:
        throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
    }
    return output;
  }

  void
  ModelLoadRestorativeWithLimits::evalCalculatedVars() {
    calculatedVars_[PPuNum_] = 0.;
    calculatedVars_[PNum_] = 0.;
    calculatedVars_[QNum_] = 0.;
    calculatedVars_[loadStateNum_] = OPEN;
    calculatedVars_[loadRealStateNum_] = OPEN;
    if (isConnected()) {
      double U = sqrt(yLocal_[UrYNum_] * yLocal_[UrYNum_] + yLocal_[UiYNum_] * yLocal_[UiYNum_]);
      calculatedVars_[PNum_] = SNREF * P0Pu_ * pow_dynawo(U/yLocal_[UfYNum_], alpha_);
      calculatedVars_[PPuNum_] = P0Pu_ * pow_dynawo(U/yLocal_[UfYNum_], alpha_);
      calculatedVars_[QNum_] = Q0Pu_ * pow_dynawo(U/yLocal_[UfYNum_], beta_);
      calculatedVars_[loadStateNum_] = CLOSED;
      calculatedVars_[loadRealStateNum_] = CLOSED;
    }
  }

  void
  ModelLoadRestorativeWithLimits::evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const {
    switch (iCalculatedVar) {
      case PNum_:
        if (isConnected()) {
          double U2 = yLocal_[UrYNum_] * yLocal_[UrYNum_] + yLocal_[UiYNum_] * yLocal_[UiYNum_];
          double U = sqrt(U2);
          double alpha_pow = pow_dynawo(U/yLocal_[UfYNum_], alpha_);
          res[0] = SNREF *P0Pu_ * alpha_ * yLocal_[UrYNum_] * alpha_pow / U2;  // P_dUr
          res[1] = SNREF *P0Pu_ * alpha_ * yLocal_[UiYNum_] * alpha_pow / U2;  // P_dUi
          res[2] = -1.0 * alpha_ * SNREF *P0Pu_ * alpha_pow / yLocal_[UfYNum_];  // P_dUf
        }
        break;
      case PPuNum_:
        if (isConnected()) {
          double U2 = yLocal_[UrYNum_] * yLocal_[UrYNum_] + yLocal_[UiYNum_] * yLocal_[UiYNum_];
          double U = sqrt(U2);
          double alpha_pow = pow_dynawo(U/yLocal_[UfYNum_], alpha_);
          res[0] = P0Pu_ * alpha_ * yLocal_[UrYNum_] * alpha_pow / U2;  // P_dUr
          res[1] = P0Pu_ * alpha_ * yLocal_[UiYNum_] * alpha_pow / U2;  // P_dUi
          res[2] = -1.0 * alpha_ * P0Pu_ * alpha_pow / yLocal_[UfYNum_];  // P_dUf
        }
        break;
      case QNum_:
        if (isConnected()) {
          double U2 = yLocal_[UrYNum_] * yLocal_[UrYNum_] + yLocal_[UiYNum_] * yLocal_[UiYNum_];
          double U = sqrt(U2);
          double beta_pow = pow_dynawo(U/yLocal_[UfYNum_], beta_);
          res[0] = Q0Pu_ * beta_ * yLocal_[UrYNum_] * beta_pow / U2;  // Q_dUr
          res[1] = Q0Pu_ * beta_ * yLocal_[UiYNum_] * beta_pow / U2;  // Q_dUi
          res[2] = -1.0 * beta_ * Q0Pu_ * beta_pow / yLocal_[UfYNum_];  // Q_dUf
        }
        break;
      case loadStateNum_:
      case loadRealStateNum_:
        break;
      default:
        throw DYNError(Error::MODELER, UndefJCalculatedVarI, iCalculatedVar);
    }
  }

  void
  ModelLoadRestorativeWithLimits::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, vector<int>& numVars) const {
    switch (numCalculatedVar) {
      case PNum_:
      case PPuNum_:
        numVars.push_back(UrYNum_);
        numVars.push_back(UiYNum_);
        numVars.push_back(UfYNum_);
        break;
      case QNum_:
        numVars.push_back(UrYNum_);
        numVars.push_back(UiYNum_);
        numVars.push_back(UfYNum_);
        break;
      case loadStateNum_:
      case loadRealStateNum_:
        break;
      default:
        throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
    }
  }

  void
  ModelLoadRestorativeWithLimits::defineElements(std::vector<Element> &elements, std::map<std::string, int >& mapElement) {
    addElement("UfPu", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "UfPu", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("Ur", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "Ur", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("Ui", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "Ui", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("Ir", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "Ir", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("Ii", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "Ii", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("PPu", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "PPu", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("P", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "P", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("QPu", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "QPu", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("state", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "state", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("loadState", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "loadState", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("switchOff1", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "switchOff1", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("switchOff2", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "switchOff2", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("running", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "running", Element::TERMINAL, name(), modelType(), elements, mapElement);
  }
}  // namespace DYN
