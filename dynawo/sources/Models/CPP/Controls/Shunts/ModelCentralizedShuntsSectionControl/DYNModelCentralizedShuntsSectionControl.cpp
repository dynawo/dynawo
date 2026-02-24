//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  DYNModelCentralizedShuntsSectionControl.cpp
 *
 * @brief centralized model for shunt section control implementation
 *
 */

#include <sstream>
#include <vector>
#include <algorithm>

#include "PARParametersSet.h"

#include "DYNNumericalUtils.h"
#include "DYNModelCentralizedShuntsSectionControl.h"
#include "DYNModelCentralizedShuntsSectionControl.hpp"
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
  return (new DYN::ModelCentralizedShuntsSectionControlFactory());
}

extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

extern "C" DYN::SubModel* DYN::ModelCentralizedShuntsSectionControlFactory::create() const {
  DYN::SubModel* model(new DYN::ModelCentralizedShuntsSectionControl());
  return model;
}

extern "C" void DYN::ModelCentralizedShuntsSectionControlFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {
  constexpr unsigned int URefPuIndex = 0;  ///< local Z index for URefPu

  ModelCentralizedShuntsSectionControl::ModelCentralizedShuntsSectionControl() : ModelCPP("CentralizedShuntsSectionControl"),
    nbShunts_(0),
    URef0Pu_(0.),
    changingShunt(-1),
    whenUp_(VALDEF),
    whenDown_(VALDEF),
    tNext_(10.),
    lastTime_(VALDEF) {}

  void
  ModelCentralizedShuntsSectionControl::defineParameters(std::vector<ParameterModeler>& parameters) {
    parameters.push_back(ParameterModeler("nbShunts", VAR_TYPE_INT, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("section0", VAR_TYPE_INT, EXTERNAL_PARAMETER, "*", "nbShunts"));
    parameters.push_back(ParameterModeler("sectionMin", VAR_TYPE_INT, EXTERNAL_PARAMETER, "*", "nbShunts"));
    parameters.push_back(ParameterModeler("sectionMax", VAR_TYPE_INT, EXTERNAL_PARAMETER, "*", "nbShunts"));
    parameters.push_back(ParameterModeler("deadBandUPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbShunts"));
    parameters.push_back(ParameterModeler("isSelf", VAR_TYPE_BOOL, EXTERNAL_PARAMETER, "*", "nbShunts"));
    parameters.push_back(ParameterModeler("URef0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("tNext", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  }

  void
  ModelCentralizedShuntsSectionControl::setSubModelParameters() {
    try {
      nbShunts_ = findParameterDynamic("nbShunts").getValue<int>();
      URef0Pu_ = findParameterDynamic("URef0Pu").getValue<double>();
      tNext_ = findParameterDynamic("tNext").getValue<double>();
      std::stringstream section0Name;
      std::stringstream sectionMinName;
      std::stringstream sectionMaxName;
      std::stringstream deadBandUPuName;
      std::stringstream isSelfName;
      for (int s = 0; s < nbShunts_; ++s) {
        section0Name.str(std::string());
        section0Name.clear();
        section0Name << "section0_" << s;
        sections0_.push_back(findParameterDynamic(section0Name.str()).getValue<int>());
        sectionMinName.str(std::string());
        sectionMinName.clear();
        sectionMinName << "sectionMin_" << s;
        sectionsMin_.push_back(findParameterDynamic(sectionMinName.str()).getValue<int>());
        sectionMaxName.str(std::string());
        sectionMaxName.clear();
        sectionMaxName << "sectionMax_" << s;
        sectionsMax_.push_back(findParameterDynamic(sectionMaxName.str()).getValue<int>());
        deadBandUPuName.str(std::string());
        deadBandUPuName.clear();
        deadBandUPuName << "deadBandUPu_" << s;
        deadBandsUPu_.push_back(findParameterDynamic(deadBandUPuName.str()).getValue<double>());
        isSelfName.str(std::string());
        isSelfName.clear();
        isSelfName << "isSelf_" << s;
        isSelf_.push_back(findParameterDynamic(isSelfName.str()).getValue<bool>());
      }
    } catch (const DYN::Error& e) {
      Trace::error() << e.what() << Trace::endline;
      throw DYNError(Error::MODELER, NetworkParameterNotFoundFor, staticId());
    }
  }

  void
  ModelCentralizedShuntsSectionControl::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) {
    // only one UMonitoredPu variable shared among all shunts as all of them are regulating the same node
    variables.push_back(VariableNativeFactory::createState("UMonitoredPu_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState("URefPu_value", DISCRETE));
    std::stringstream sectionName;
    for (int s = 0; s < nbShunts_; ++s) {
      sectionName.str(std::string());
      sectionName.clear();
      sectionName << "section_" << s << "_value";
      variables.push_back(VariableNativeFactory::createState(sectionName.str(), DISCRETE));
    }
    for (int s = 0; s < nbShunts_; ++s) {
      sectionName.str(std::string());
      sectionName.clear();
      sectionName << "running_" << s << "_value";
      variables.push_back(VariableNativeFactory::createState(sectionName.str(), BOOLEAN));
    }
  }

  void
  ModelCentralizedShuntsSectionControl::init(const double /*t0*/) {
    /* not need */
  }

  void
  ModelCentralizedShuntsSectionControl::collectSilentZ(BitMask* silentZTable) {
    for (unsigned int s = 0; s < sizeZ_; ++s) {
      silentZTable[s].setFlags(NotUsedInContinuousEquations);
    }
  }

  void
  ModelCentralizedShuntsSectionControl::getSize() {
    sizeF_ = 0;
    sizeY_ = 1;  // UMonitoredPu
    sizeZ_ = 2*nbShunts_ + 1;  // URefPu value is stored at index 0,
    //  sections are stored at [1, nbShunts[, running status of shunts are stored at [nbShunts, 2*nbShunts [
    sizeG_ = 4;
    sizeMode_ = 0;
    calculatedVars_.assign(nbCalculatedVariables_, 0);
  }

  void
  ModelCentralizedShuntsSectionControl::evalStaticYType() {
    yType_[0] = EXTERNAL;
  }

  void
  ModelCentralizedShuntsSectionControl::evalF(double /*t*/, propertyF_t /*type*/) {
    /* not need */
  }

  void
  ModelCentralizedShuntsSectionControl::evalJt(const double /*t*/, const double /*cj*/, const int /*rowOffset*/,  SparseMatrix& /*jt*/) {
    /* not need */
  }

  void
  ModelCentralizedShuntsSectionControl::evalG(const double t) {
    const double UMonitoredPu = yLocal_[0];
    const double URefPu = zLocal_[URefPuIndex];
    for (int s = 0; s < nbShunts_; ++s) {
      if (zLocal_[nbShunts_ + s + 1] <= 0) {
        gLocal_[0] = ROOT_DOWN;
        gLocal_[1] = ROOT_DOWN;
        gLocal_[2] = ROOT_DOWN;
        gLocal_[3] = ROOT_DOWN;
        changingShunt = -1;
        continue;
      }
      const double minValue = URefPu - deadBandsUPu_[s];
      const double maxValue = URefPu + deadBandsUPu_[s];
      if (isSelf_[s]) {
          if (doubleNotEquals(UMonitoredPu, minValue) &&
            UMonitoredPu < minValue &&
            sections0_[s] > sectionsMin_[s]) {
            gLocal_[0] = ROOT_UP;
            gLocal_[1] = ROOT_DOWN;
            gLocal_[2] = ((t - whenDown_) > tNext_ || doubleEquals((t - whenDown_), tNext_)) ? ROOT_UP : ROOT_DOWN;
            gLocal_[3] = ROOT_DOWN;
            changingShunt = s;
            break;
          } else if (doubleNotEquals(UMonitoredPu, maxValue) &&
            UMonitoredPu > maxValue &&
            sections0_[s] < sectionsMax_[s]) {
            gLocal_[0] = ROOT_DOWN;
            gLocal_[1] = ROOT_UP;
            gLocal_[2] = ROOT_DOWN;
            gLocal_[3] = ((t - whenUp_) > tNext_ || doubleEquals((t - whenUp_), tNext_)) ? ROOT_UP : ROOT_DOWN;
            changingShunt = s;
            break;
          } else {
            gLocal_[0] = ROOT_DOWN;
            gLocal_[1] = ROOT_DOWN;
            gLocal_[2] = ROOT_DOWN;
            gLocal_[3] = ROOT_DOWN;
            changingShunt = -1;
          }
      } else {
          if (doubleNotEquals(UMonitoredPu, minValue) &&
            UMonitoredPu < minValue &&
            sections0_[s] < sectionsMax_[s]) {
            gLocal_[0] = ROOT_UP;
            gLocal_[1] = ROOT_DOWN;
            gLocal_[2] = ((t - whenUp_) > tNext_ || doubleEquals((t - whenUp_), tNext_)) ? ROOT_UP : ROOT_DOWN;
            gLocal_[3] = ROOT_DOWN;
            changingShunt = s;
            break;
          } else if (doubleNotEquals(UMonitoredPu, maxValue) &&
            UMonitoredPu > maxValue &&
            sections0_[s] > sectionsMin_[s]) {
            gLocal_[0] = ROOT_DOWN;
            gLocal_[1] = ROOT_UP;
            gLocal_[2] = ROOT_DOWN;
            gLocal_[3] = ((t - whenDown_) > tNext_ || doubleEquals((t - whenDown_), tNext_)) ? ROOT_UP : ROOT_DOWN;
            changingShunt = s;
            break;
          } else {
            gLocal_[0] = ROOT_DOWN;
            gLocal_[1] = ROOT_DOWN;
            gLocal_[2] = ROOT_DOWN;
            gLocal_[3] = ROOT_DOWN;
            changingShunt = -1;
          }
      }
    }
  }

  void
  ModelCentralizedShuntsSectionControl::evalZ(const double t) {
    if (changingShunt >= 0) {
      if (isSelf_[changingShunt]) {
        if ((gLocal_[0] == ROOT_UP && doubleEquals(whenDown_, VALDEF)) ||
            (gLocal_[0] == ROOT_UP && gLocal_[2] == ROOT_UP)) {
          whenUp_ = VALDEF;
          whenDown_ = t;
        } else if ((gLocal_[1] == ROOT_UP && doubleEquals(whenUp_, VALDEF)) ||
                   (gLocal_[1] == ROOT_UP && gLocal_[3] == ROOT_UP)) {
          whenUp_ = t;
          whenDown_ = VALDEF;
        }
        if (gLocal_[2] == ROOT_UP && doubleNotEquals(lastTime_, t)) {
          zLocal_[changingShunt + 1] = sections0_[changingShunt] - 1;
          sections0_[changingShunt] -= 1;
          DYNAddTimelineEvent(this, name(), CSSCSectionDown, changingShunt);
          changingShunt = -1;
          lastTime_ = t;
        } else if (gLocal_[3] == ROOT_UP && doubleNotEquals(lastTime_, t)) {
          zLocal_[changingShunt + 1] = sections0_[changingShunt] + 1;
          sections0_[changingShunt] += 1;
          DYNAddTimelineEvent(this, name(), CSSCSectionUp, changingShunt);
          changingShunt = -1;
          lastTime_ = t;
        }
      } else {
        if ((gLocal_[0] == ROOT_UP && doubleEquals(whenUp_, VALDEF)) ||
            (gLocal_[0] == ROOT_UP && gLocal_[2] == ROOT_UP)) {
          whenUp_ = t;
          whenDown_ = VALDEF;
        } else if ((gLocal_[1] == ROOT_UP && doubleEquals(whenDown_, VALDEF)) ||
                   (gLocal_[1] == ROOT_UP && gLocal_[3] == ROOT_UP)) {
          whenUp_ = VALDEF;
          whenDown_ = t;
        }
        if (gLocal_[2] == ROOT_UP && doubleNotEquals(lastTime_, t)) {
          zLocal_[changingShunt + 1] = sections0_[changingShunt] + 1;
          sections0_[changingShunt] += 1;
          DYNAddTimelineEvent(this, name(), CSSCSectionUp, changingShunt);
          changingShunt = -1;
          lastTime_ = t;
        } else if (gLocal_[3] == ROOT_UP && doubleNotEquals(lastTime_, t)) {
          zLocal_[changingShunt + 1] = sections0_[changingShunt] - 1;
          sections0_[changingShunt] -= 1;
          DYNAddTimelineEvent(this, name(), CSSCSectionDown, changingShunt);
          changingShunt = -1;
          lastTime_ = t;
        }
      }
    }
  }

  void
  ModelCentralizedShuntsSectionControl::setGequations() {
    gEquationIndex_[0] = std::string("if isSelf (UMonitoredPu > (URefPu - DeadbandsUPu_) && sections0_ > SectionsMin_)"
                                    "else (UMonitoredPu < (URefPu - DeadbandsUPu_) && sections0_ < SectionsMax_)");
    gEquationIndex_[1] = std::string("if (isSelf) {(UMonitoredPu > (URefPu + DeadbandsUPu_) && sections0_ < SectionsMax_)}"
                                    " else {(UMonitoredPu > (URefPu + DeadbandsUPu_) && sections0_ > SectionsMin_)}");
    gEquationIndex_[2] = std::string("if isSelf ((t - whenDown_) > tNext_) else ((t - whenUp_) > tNext_)");
    gEquationIndex_[3] = std::string("if isSelf ((t - whenUp_) > tNext_) else ((t - whenDown_) > tNext_)");
    assert(gEquationIndex_.size() == static_cast<size_t>(sizeG()) && "Model VoltageMeasurementsUtilities: gEquationIndex.size() != gLocal_.size()");
  }

  void
  ModelCentralizedShuntsSectionControl::getY0() {
    zLocal_[0] = URef0Pu_;
    for (int s = 0; s < nbShunts_; ++s) {
      zLocal_[s + 1] = sections0_[s];
    }
    for (int s = 0; s < nbShunts_; ++s) {
      zLocal_[nbShunts_ + s + 1] = 1.;
    }
  }

  void
  ModelCentralizedShuntsSectionControl::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
    /* not need */
  }

  void
  ModelCentralizedShuntsSectionControl::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<double>& /*res*/) const {
    /* not need */
  }

  void
  ModelCentralizedShuntsSectionControl::evalJtPrim(const double /*t*/, const double /*cj*/, const int /*rowOffset*/, SparseMatrix& /*jtPrim*/) {
    /* not need */
  }

  modeChangeType_t
  ModelCentralizedShuntsSectionControl::evalMode(const double /*t*/) {
    return NO_MODE;
  }

  void
  ModelCentralizedShuntsSectionControl::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
    /* not need */
  }

  double
  ModelCentralizedShuntsSectionControl::evalCalculatedVarI(unsigned /*iCalculatedVar*/) const {
    return 0.;
  }

  void
  ModelCentralizedShuntsSectionControl::defineElements(std::vector<Element>& elements, std::map<std::string, int >& mapElement) {
    addElement("UMonitoredPu", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "UMonitoredPu", Element::TERMINAL, name(), modelType(), elements, mapElement);
    addElement("URefPu", Element::STRUCTURE, elements, mapElement);
    addSubElement("value", "URefPu", Element::TERMINAL, name(), modelType(), elements, mapElement);
    std::stringstream sectionName;
    for (int s = 0; s < nbShunts_; ++s) {
      sectionName.str(std::string());
      sectionName.clear();
      sectionName << "section_" << s;
      addElement(sectionName.str(), Element::STRUCTURE, elements, mapElement);
      addSubElement("value", sectionName.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);

      sectionName.str(std::string());
      sectionName.clear();
      sectionName << "running_" << s;
      addElement(sectionName.str(), Element::STRUCTURE, elements, mapElement);
      addSubElement("value", sectionName.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
    }
  }

}  // namespace DYN
