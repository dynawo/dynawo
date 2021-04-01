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
using std::stringstream;

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
  ModelLoadRestorativeWithLimits::ModelLoadRestorativeWithLimits() : Impl("LoadRestorativeWithLimits"),
  connectionState_(CLOSED),
  preConnectionState_(CLOSED),
  UfRawYNum_(0),
  UfYNum_(0),
  UrYNum_(0),
  UiYNum_(0),
  IrYNum_(0),
  IiYNum_(0),
  u0Pu_(0),
  UfRawprim0_(0),
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
    variables.push_back(VariableNativeFactory::createState("UfRawPu_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState("UfPu_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState("Ur_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState("Ui_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState("Ir_value", FLOW));
    variables.push_back(VariableNativeFactory::createState("Ii_value", FLOW));
    variables.push_back(VariableNativeFactory::createCalculated("PPu_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createCalculated("QPu_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createCalculated("state_value", INTEGER));
    variables.push_back(VariableNativeFactory::createState("switchOff1_value", BOOLEAN));
    variables.push_back(VariableNativeFactory::createState("switchOff2_value", BOOLEAN));
  }

  void
  ModelLoadRestorativeWithLimits::init(const double /*t0*/) {
    UfRawYNum_ = 0;
    UfYNum_ = 1;
    UrYNum_ = 2;
    UiYNum_ = 3;
    IrYNum_ = 4;
    IiYNum_ = 5;
  }

  void
  ModelLoadRestorativeWithLimits::collectSilentZ(BitMask* /*silentZTable*/) {
    /* not need */
  }

  void
  ModelLoadRestorativeWithLimits::getSize() {
    sizeF_ = 4;
    sizeY_ = 6;
    sizeZ_ = 2;
    sizeG_ = 2;
    sizeMode_ = 2;
    calculatedVars_.assign(nbCalculatedVariables_, 0);
  }

  void
  ModelLoadRestorativeWithLimits::evalStaticYType() {
    yType_[0] = DIFFERENTIAL;  // differential equation on ufRaw
    yType_[1] = ALGEBRAIC;  // uf
    yType_[2] = EXTERNAL;  // ur
    yType_[3] = EXTERNAL;  // ui
    yType_[4] = ALGEBRAIC;  // ir
    yType_[5] = ALGEBRAIC;  // ii
  }

  void
  ModelLoadRestorativeWithLimits::evalStaticFType() {
    fType_[0] = DIFFERENTIAL_EQ;
    fType_[1] = ALGEBRAIC_EQ;
    fType_[2] = ALGEBRAIC_EQ;
    fType_[3] = ALGEBRAIC_EQ;
  }

  void
  ModelLoadRestorativeWithLimits::evalF(double /*t*/, propertyF_t type) {
    if (isConnected()) {
      double UfRawValue = yLocal_[UfRawYNum_];
      double Ur = yLocal_[UrYNum_];
      double Ui = yLocal_[UiYNum_];
      double U2 = Ur * Ur + Ui * Ui;
      double U = sqrt(U2);
      double Uf = yLocal_[UfYNum_];
      double UfRawPrim = ypLocal_[UfRawYNum_];
      double Ir = yLocal_[IrYNum_];
      double Ii = yLocal_[IiYNum_];
      double alpha_pow = pow_dynawo(U/Uf, alpha_);
      double beta_pow = pow_dynawo(U/Uf, beta_);
      if (UMaxPuReached_) {
        UfRawValue = UMaxPu_;
      }
      if (UMinPuReached_) {
        UfRawValue = UMinPu_;
      }
      if (type != ALGEBRAIC_EQ) {
        fLocal_[0] = Tf_ * UfRawPrim - (U - yLocal_[UfRawYNum_]);
      }
      if (type != DIFFERENTIAL_EQ) {
        fLocal_[1] = Uf - UfRawValue;
        fLocal_[2] = Ir - (P0Pu_ * alpha_pow * Ur + Q0Pu_ * beta_pow * Ui) / (U * U);
        fLocal_[3] = Ii - (P0Pu_ * alpha_pow * Ui - Q0Pu_ * beta_pow * Ur) / (U * U);
      }
    } else {
      fLocal_[0] = ypLocal_[UfRawYNum_];
      fLocal_[1] = yLocal_[UfYNum_];
      fLocal_[2] = yLocal_[IrYNum_];
      fLocal_[3] = yLocal_[IiYNum_];
    }
  }

  void
  ModelLoadRestorativeWithLimits::setFequations() {
    if (isConnected()) {
      fEquationIndex_[0] = std::string("Tf_*UfRawPrim - (U - UfRaw ):");
      fEquationIndex_[1] = std::string("Uf - UfRaw:");
      fEquationIndex_[2] = std::string("Ir - (P * Ur + Q * Ui) / (U * U): ");
      fEquationIndex_[3] = std::string("Ii - (P * Ui - Q * Ur) / (U * U): ");
    } else {
      fEquationIndex_[0] = std::string("UfRawPrim = 0:");
      fEquationIndex_[1] = std::string("Uf = 0:");
      fEquationIndex_[2] = std::string("Ir = 0: ");
      fEquationIndex_[3] = std::string("Ii = 0: ");
    }
  }

  void
  ModelLoadRestorativeWithLimits::evalZ(const double /*t*/) {
    if ((zLocal_[0] > 0 || zLocal_[1] > 0) && getConnected() == CLOSED) {
      setConnected(OPEN);
    } else if ((zLocal_[0] <= 0 || zLocal_[1] <= 0) && getConnected() == OPEN) {
      setConnected(CLOSED);
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
      jt.changeCol();  //  ufRaw
      jt.addTerm(UfRawYNum_ + rowOffset, cj);
      jt.changeCol();  //  uf
      jt.addTerm(UfYNum_ + rowOffset, 1);
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
      jt.changeCol();  // ufRaw
      jt.addTerm(UfRawYNum_ + rowOffset, 1.0 + cj * Tf_);
      jt.addTerm(UrYNum_ + rowOffset, -Ur/U);
      jt.addTerm(UiYNum_ + rowOffset, -Ui/U);
      jt.changeCol();  // Uf
      jt.addTerm(UfYNum_ + rowOffset, 1);
      if (UMaxPuReached_ == false && UMinPuReached_ == false) {
        jt.addTerm(UfRawYNum_ + rowOffset, -1);
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
    gLocal_[0] = (doubleNotEquals(yLocal_[UfRawYNum_], UMaxPu_) && yLocal_[UfRawYNum_] > UMaxPu_) ? ROOT_UP : ROOT_DOWN;
    gLocal_[1] = (doubleNotEquals(yLocal_[UfRawYNum_], UMinPu_) && UMinPu_ - yLocal_[UfRawYNum_] > 0) ? ROOT_UP : ROOT_DOWN;
  }

  void
  ModelLoadRestorativeWithLimits::setGequations() {
    gEquationIndex_[0] = std::string("UfRawPu > UMaxPu ");
    gEquationIndex_[1] = std::string("UfRawPu < UMinPu ");
  }

  void
  ModelLoadRestorativeWithLimits::evalJtPrim(const double /*t*/, const double /*cj*/, SparseMatrix& jt, const int rowOffset) {
    jt.changeCol();
    if (isConnected())
      jt.addTerm(UfRawYNum_ + rowOffset, Tf_);
    else
      jt.addTerm(UfRawYNum_ + rowOffset, 1);
    jt.changeCol();
    jt.changeCol();
    jt.changeCol();
  }

  modeChangeType_t
  ModelLoadRestorativeWithLimits::evalMode(const double /*t*/) {
    if (gLocal_[0] == ROOT_UP || gLocal_[1] == ROOT_UP)
      return ALGEBRAIC_MODE;
    if (preConnectionState_ != getConnected()) {
      preConnectionState_ = getConnected();
      return ALGEBRAIC_J_UPDATE_MODE;
    }
    return NO_MODE;
  }

  void
  ModelLoadRestorativeWithLimits::getY0() {
    // ufRaw
    yLocal_[0] = u0Pu_;
    ypLocal_[0] = UfRawprim0_;
    // uf
    yLocal_[1] = u0Pu_;
    ypLocal_[1] = 0.;
    // Ir
    yLocal_[4] = (P0Pu_ * u0Pu_ * cos(angleO_) + Q0Pu_ * u0Pu_ * sin(angleO_)) / (u0Pu_ * u0Pu_);
    ypLocal_[4] = 0;
    // Ii
    yLocal_[5] = (P0Pu_ * u0Pu_ * sin(angleO_) - Q0Pu_ * u0Pu_ * cos(angleO_)) / (u0Pu_ * u0Pu_);
    ypLocal_[5] = 0;
    zLocal_[0] = false;
    zLocal_[1] = false;
  }

  void
  ModelLoadRestorativeWithLimits::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
    /* not need */
  }

  double
  ModelLoadRestorativeWithLimits::evalCalculatedVarI(unsigned iCalculatedVar) const {
    double output = 0;
    switch (iCalculatedVar) {
      case PNum_:
        if (isConnected()) {
          double U = sqrt(yLocal_[UrYNum_] * yLocal_[UrYNum_] + yLocal_[UiYNum_] * yLocal_[UiYNum_]);
          output = P0Pu_ * pow_dynawo(U/yLocal_[UfYNum_], alpha_);
        }
        break;
      case QNum_:
        if (isConnected()) {
          double U = sqrt(yLocal_[UrYNum_] * yLocal_[UrYNum_] + yLocal_[UiYNum_] * yLocal_[UiYNum_]);
          output = Q0Pu_ * pow_dynawo(U/yLocal_[UfYNum_], beta_);
        }
        break;
      case loadStateNum_:
        output = connectionState_;
        break;
      default:
        throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
    }
    return (output);
  }

  void
  ModelLoadRestorativeWithLimits::evalCalculatedVars() {
    calculatedVars_[PNum_] = 0.;
    calculatedVars_[QNum_] = 0.;
    calculatedVars_[loadStateNum_] = connectionState_;
    if (isConnected()) {
      double U = sqrt(yLocal_[UrYNum_] * yLocal_[UrYNum_] + yLocal_[UiYNum_] * yLocal_[UiYNum_]);
      calculatedVars_[PNum_] = P0Pu_ * pow_dynawo(U/yLocal_[UfYNum_], alpha_);
      calculatedVars_[QNum_] = Q0Pu_ * pow_dynawo(U/yLocal_[UfYNum_], beta_);
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
        break;
      default:
        throw DYNError(Error::MODELER, UndefJCalculatedVarI, iCalculatedVar);
    }
  }

  void
  ModelLoadRestorativeWithLimits::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, vector<int>& numVars) const {
    switch (numCalculatedVar) {
      case PNum_:
        if (isConnected()) {
          numVars.push_back(UrYNum_);
          numVars.push_back(UiYNum_);
          numVars.push_back(UfYNum_);
        }
        break;
      case QNum_:
        if (isConnected()) {
          numVars.push_back(UrYNum_);
          numVars.push_back(UiYNum_);
          numVars.push_back(UfYNum_);
        }
        break;
      case loadStateNum_:
        break;
      default:
        throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
    }
  }

  void
  ModelLoadRestorativeWithLimits::defineElements(std::vector<Element> &elements, std::map<std::string, int >& mapElement) {
    addElement("UfRawPu", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "UfRawPu", Element::TERMINAL, name(), modelType(), elements, mapElement);
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
    addElement("QPu", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "QPu", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("state", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "state", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("switchOff1", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "switchOff1", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("switchOff2", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "switchOff2", Element::TERMINAL, name(), modelType(), elements, mapElement);
  }
}  // namespace DYN
