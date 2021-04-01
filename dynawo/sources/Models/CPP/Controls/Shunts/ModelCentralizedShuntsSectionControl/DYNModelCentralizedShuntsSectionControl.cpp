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
  ModelCentralizedShuntsSectionControl::ModelCentralizedShuntsSectionControl() : Impl("CentralizedShuntsSectionControl"),
    nbShunts_(0),
    isSelf_(false),
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
    parameters.push_back(ParameterModeler("SectionMin", VAR_TYPE_INT, EXTERNAL_PARAMETER, "*", "nbShunts"));
    parameters.push_back(ParameterModeler("SectionMax", VAR_TYPE_INT, EXTERNAL_PARAMETER, "*", "nbShunts"));
    parameters.push_back(ParameterModeler("DeadbandUPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbShunts"));
    parameters.push_back(ParameterModeler("IsSelf", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("URef0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("tNext", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  }

  void
  ModelCentralizedShuntsSectionControl::setSubModelParameters() {
    try {
      nbShunts_ = findParameterDynamic("nbShunts").getValue<int>();
      isSelf_ = findParameterDynamic("IsSelf").getValue<bool>();
      URef0Pu_ = findParameterDynamic("URef0Pu").getValue<double>();
      tNext_ = findParameterDynamic("tNext").getValue<double>();
      std::stringstream section0Name;
      std::stringstream SectionMinName;
      std::stringstream SectionMaxName;
      std::stringstream DeadbandUPuName;
      for (int s = 0; s < nbShunts_; ++s) {
        section0Name.str(std::string());
        section0Name.clear();
        section0Name << "section0_" << s;
        sections0_.push_back(findParameterDynamic(section0Name.str()).getValue<int>());
        SectionMinName.str(std::string());
        SectionMinName.clear();
        SectionMinName << "SectionMin_" << s;
        SectionsMin_.push_back(findParameterDynamic(SectionMinName.str()).getValue<int>());
        SectionMaxName.str(std::string());
        SectionMaxName.clear();
        SectionMaxName << "SectionMax_" << s;
        SectionsMax_.push_back(findParameterDynamic(SectionMaxName.str()).getValue<int>());
        DeadbandUPuName.str(std::string());
        DeadbandUPuName.clear();
        DeadbandUPuName << "DeadbandUPu_" << s;
        DeadbandsUPu_.push_back(findParameterDynamic(DeadbandUPuName.str()).getValue<double>());
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
    std::stringstream URefPuName;
    for (int s = 0; s < nbShunts_; ++s) {
      URefPuName.str(std::string());
      URefPuName.clear();
      URefPuName << "URefPu_" << s << "_value";
      variables.push_back(VariableNativeFactory::createState(URefPuName.str(), DISCRETE));
    }
    std::stringstream sectionName;
    for (int s = 0; s < nbShunts_; ++s) {
      sectionName.str(std::string());
      sectionName.clear();
      sectionName << "section_" << s << "_value";
      variables.push_back(VariableNativeFactory::createState(sectionName.str(), DISCRETE));
    }
  }

  void
  ModelCentralizedShuntsSectionControl::init(const double /*t0*/) {
    /* not need */
  }

  void
  ModelCentralizedShuntsSectionControl::collectSilentZ(BitMask* /*silentZTable*/) {
    /* not need */
  }

  void
  ModelCentralizedShuntsSectionControl::getSize() {
    sizeF_ = 0;
    sizeY_ = 1;  // UMonitoredPu
    sizeZ_ = 2 * nbShunts_;  // URefPu values are stored at indexes [0, nbShunts[, sections are stored at [nbShunts, 2 * nbShunts[
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
  ModelCentralizedShuntsSectionControl::evalJt(const double /*t*/, const double /*cj*/, SparseMatrix& /*jt*/, const int /*rowOffset*/) {
    /* not need */
  }

  void
  ModelCentralizedShuntsSectionControl::evalG(const double t) {
    double UMonitoredPu = yLocal_[0];
    double minValue;
    double maxValue;
    if (!isSelf_) {
      for (int s = 0; s < nbShunts_; ++s) {
        minValue = zLocal_[s] - DeadbandsUPu_[s];
        maxValue = zLocal_[s] + DeadbandsUPu_[s];
        if (doubleNotEquals(UMonitoredPu, minValue) &&
          UMonitoredPu < minValue &&
          sections0_[s] < SectionsMax_[s]) {
          gLocal_[0] = ROOT_UP;
          gLocal_[1] = ROOT_DOWN;
          gLocal_[2] = ((t - whenUp_) > tNext_ || doubleEquals((t - whenUp_), tNext_)) ? ROOT_UP : ROOT_DOWN;
          gLocal_[3] = ROOT_DOWN;
          changingShunt = s;
          break;
        } else if (doubleNotEquals(UMonitoredPu, maxValue) &&
          UMonitoredPu > maxValue &&
          sections0_[s] > SectionsMin_[s]) {
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
        }
      }
    } else {
      for (int s = 0; s < nbShunts_; ++s) {
        minValue = zLocal_[s] - DeadbandsUPu_[s];
        maxValue = zLocal_[s] + DeadbandsUPu_[s];
        if (doubleNotEquals(UMonitoredPu, minValue) &&
          UMonitoredPu < minValue &&
          sections0_[s] > SectionsMin_[s]) {
          gLocal_[0] = ROOT_UP;
          gLocal_[1] = ROOT_DOWN;
          changingShunt = s;
          gLocal_[2] = ((t - whenDown_) > tNext_ || doubleEquals((t - whenDown_), tNext_)) ? ROOT_UP : ROOT_DOWN;
          gLocal_[3] = ROOT_DOWN;
        } else if (doubleNotEquals(UMonitoredPu, maxValue) &&
          UMonitoredPu > maxValue &&
          sections0_[s] < SectionsMax_[s]) {
          gLocal_[0] = ROOT_DOWN;
          gLocal_[1] = ROOT_UP;
          gLocal_[2] = ROOT_DOWN;
          gLocal_[3] = ((t - whenUp_) > tNext_ || doubleEquals((t - whenUp_), tNext_)) ? ROOT_UP : ROOT_DOWN;
          changingShunt = s;
        } else {
          gLocal_[0] = ROOT_DOWN;
          gLocal_[1] = ROOT_DOWN;
          gLocal_[2] = ROOT_DOWN;
          gLocal_[3] = ROOT_DOWN;
        }
      }
    }
  }

  void
  ModelCentralizedShuntsSectionControl::evalZ(const double t) {
    if (!isSelf_) {
      if (gLocal_[0] == ROOT_UP) {
        whenUp_ = t;
        whenDown_ = VALDEF;
      }
      if (gLocal_[1] == ROOT_UP) {
        whenDown_ = t;
        whenUp_ = VALDEF;
      }
      if (gLocal_[2] == ROOT_UP) {
        if (doubleNotEquals(lastTime_, t)) {
          zLocal_[changingShunt + nbShunts_] = sections0_[changingShunt] + 1;
          sections0_[changingShunt] += 1;
          changingShunt = -1;
          lastTime_ = t;
        }
      }
      if (gLocal_[3] == ROOT_UP) {
        if (doubleNotEquals(lastTime_, t)) {
          zLocal_[changingShunt + nbShunts_] = sections0_[changingShunt] - 1;
          sections0_[changingShunt] -= 1;
          changingShunt = -1;
          lastTime_ = t;
        }
      }
    } else {
      if (gLocal_[0] == ROOT_UP) {
        whenUp_ = VALDEF;
        whenDown_ = t;
      }
      if (gLocal_[1] == ROOT_UP) {
        whenDown_ = VALDEF;
        whenUp_ = t;
      }
      if (gLocal_[2] == ROOT_UP) {
        if (doubleNotEquals(lastTime_, t)) {
          zLocal_[changingShunt + nbShunts_] = sections0_[changingShunt] - 1;
          sections0_[changingShunt] -= 1;
          changingShunt = -1;
          lastTime_ = t;
        }
      }
      if (gLocal_[3] == ROOT_UP) {
        if (doubleNotEquals(lastTime_, t)) {
          zLocal_[changingShunt + nbShunts_] = sections0_[changingShunt] + 1;
          sections0_[changingShunt] += 1;
          changingShunt = -1;
          lastTime_ = t;
        }
      }
    }
  }

  void
  ModelCentralizedShuntsSectionControl::setGequations() {
    if (!isSelf_) {
      gEquationIndex_[0] = std::string("UMonitoredPu < (URefPu - DeadbandsUPu_) && sections0_ < SectionsMax_ ");
      gEquationIndex_[1] = std::string("UMonitoredPu > (URefPu + DeadbandsUPu_) && sections0_ > SectionsMin_ ");
      gEquationIndex_[2] = std::string("(t - whenUp_) >= tNext_ ");
      gEquationIndex_[3] = std::string("(t - whenDown_) >= tNext_ ");
    } else {
      gEquationIndex_[0] = std::string("UMonitoredPu > (URefPu + DeadbandsUPu_) && sections0_ > SectionsMin_ ");
      gEquationIndex_[1] = std::string("UMonitoredPu < (URefPu - DeadbandsUPu_) && sections0_ < SectionsMax_ ");
      gEquationIndex_[2] = std::string("(t - whenDown_) >= tNext_ ");
      gEquationIndex_[3] = std::string("(t - whenUp_) >= tNext_ ");
    }
  }

  void
  ModelCentralizedShuntsSectionControl::getY0() {
    for (int s = 0; s < nbShunts_; ++s) {
      zLocal_[s] = URef0Pu_;
      zLocal_[s + nbShunts_] = sections0_[s];
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
  ModelCentralizedShuntsSectionControl::evalJtPrim(const double /*t*/, const double /*cj*/, SparseMatrix& /*jt*/, const int /*rowOffset*/) {
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
    std::stringstream URefPuName;
    std::stringstream sectionName;
    for (int s = 0; s < nbShunts_; ++s) {
      URefPuName.str(std::string());
      URefPuName.clear();
      URefPuName << "URefPu_" << s;
      addElement(URefPuName.str(), Element::STRUCTURE, elements, mapElement);
      addSubElement("value", URefPuName.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
      sectionName.str(std::string());
      sectionName.clear();
      sectionName << "section_" << s;
      addElement(sectionName.str(), Element::STRUCTURE, elements, mapElement);
      addSubElement("value", sectionName.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
    }
  }

}  // namespace DYN
