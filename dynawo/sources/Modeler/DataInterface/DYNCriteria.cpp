//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#include "DYNTrace.h"
#include "DYNCommon.h"
#include "DYNCriteria.h"
#include "DYNCommonConstants.h"

namespace DYN {

Criteria::Criteria(const boost::shared_ptr<criteria::CriteriaParams>& params) :
        params_(params) {}

Criteria::~Criteria() {}


BusCriteria::BusCriteria(const boost::shared_ptr<criteria::CriteriaParams>& params) :
            Criteria(params) {}

BusCriteria::~BusCriteria() {}

bool
BusCriteria::checkCriteria(double t, bool finalStep) {
  failingCriteria_.clear();
  assert(params_->getType() != criteria::CriteriaParams::SUM);
  if (!finalStep && params_->getScope() == criteria::CriteriaParams::FINAL)
    return true;
  for (std::vector<boost::shared_ptr<BusInterface> >::const_iterator it = buses_.begin(), itEnd = buses_.end();
      it != itEnd; ++it) {
    double v = (*it)->getStateVarV();
    if (doubleIsZero(v)) continue;
    double vNom = (*it)->getVNom();
    if (params_->hasUMaxPu() && v > params_->getUMaxPu()*vNom) {
      Message mess = DYNLog(BusAboveVoltage, (*it)->getID(), v, params_->getUMaxPu(), params_->getId(), t);
      Trace::info() << mess << Trace::endline;
      failingCriteria_.push_back(mess.str());
      return false;
    }
    if (params_->hasUMinPu() && v < params_->getUMinPu()*vNom) {
      Message mess = DYNLog(BusUnderVoltage, (*it)->getID(), v, params_->getUMinPu(), params_->getId(), t);
      Trace::info() << mess << Trace::endline;
      failingCriteria_.push_back(mess.str());
      return false;
    }
  }
  return true;
}

bool
BusCriteria::criteriaEligibleForBus(const boost::shared_ptr<criteria::CriteriaParams>& params) {
  if (params->getType() == criteria::CriteriaParams::SUM) {
    Trace::warn() << DYNLog(SumBusCriteriaIgnored) << Trace::endline;
    return false;
  }
  if (!params->hasUMinPu() && !params->hasUMaxPu())
    return false;
  if (params->hasPMax())
    Trace::warn() << DYNLog(PowerBusCriteriaIgnored) << Trace::endline;
  if (params->hasPMin())
    Trace::warn() << DYNLog(PowerBusCriteriaIgnored) << Trace::endline;
  return true;
}

void
BusCriteria::addBus(const boost::shared_ptr<BusInterface>& bus) {
  if (params_->hasUNomMin() &&
      bus->getVNom() < params_->getUNomMin()) return;
  if (params_->hasUNomMax() &&
      bus->getVNom() > params_->getUNomMax()) return;
  if (doubleEquals(bus->getV0(), defaultV0) || bus->getV0() <  defaultV0) return;
  buses_.push_back(bus);
}

LoadCriteria::LoadCriteria(const boost::shared_ptr<criteria::CriteriaParams>& params) :
                Criteria(params) {}

LoadCriteria::~LoadCriteria() {}

bool
LoadCriteria::checkCriteria(double t, bool finalStep) {
  failingCriteria_.clear();
  if (!finalStep && params_->getScope() == criteria::CriteriaParams::FINAL)
    return true;
  double sum = 0.;
  bool atLeastOneEligibleLoadWasFound = false;
  for (std::vector<boost::shared_ptr<LoadInterface> >::const_iterator it = loads_.begin(), itEnd = loads_.end();
      it != itEnd; ++it) {
    double p = (*it)->getP();
    if ((params_->hasUMaxPu() || params_->hasUMinPu()) && (*it)->getBusInterface()) {
      double v = (*it)->getBusInterface()->getStateVarV();
      double vNom = (*it)->getBusInterface()->getVNom();
      if (params_->hasUMaxPu() && v > params_->getUMaxPu()*vNom) continue;
      if (params_->hasUMinPu() && v < params_->getUMinPu()*vNom) continue;
    }
    if (params_->getType() == criteria::CriteriaParams::LOCAL_VALUE) {
      if (params_->hasPMax() && p > params_->getPMax()) {
        Message mess = DYNLog(SourceAbovePower, (*it)->getID(), p, params_->getPMax(), params_->getId(), t);
        Trace::info() << mess << Trace::endline;
        failingCriteria_.push_back(mess.str());
        return false;
      }
      if (params_->hasPMin() && p < params_->getPMin()) {
        Message mess = DYNLog(SourceUnderPower, (*it)->getID(), p, params_->getPMin(), params_->getId(), t);
        Trace::info() << mess << Trace::endline;
        failingCriteria_.push_back(mess.str());
        return false;
      }
    } else {
      sum+=p;
      atLeastOneEligibleLoadWasFound = true;
    }
  }

  if (atLeastOneEligibleLoadWasFound && params_->getType() == criteria::CriteriaParams::SUM) {
    if (params_->hasPMax() && sum > params_->getPMax()) {
      Message mess = DYNLog(SourcePowerAboveMax, sum, params_->getPMax(), params_->getId(), t);
      Trace::info() << mess << Trace::endline;
      failingCriteria_.push_back(mess.str());
      return false;
    }
    if (params_->hasPMin() && sum < params_->getPMin()) {
      Message mess = DYNLog(SourcePowerBelowMin, sum, params_->getPMin(), params_->getId(), t);
      Trace::info() << mess << Trace::endline;
      failingCriteria_.push_back(mess.str());
      return false;
    }
  }

  return true;
}

bool
LoadCriteria::criteriaEligibleForLoad(const boost::shared_ptr<criteria::CriteriaParams>& params) {
  if (!params->hasPMin() && !params->hasPMax())
    return false;
  return true;
}

void
LoadCriteria::addLoad(const boost::shared_ptr<LoadInterface>& load) {
  if (params_->hasUNomMin() &&
      load->getBusInterface() &&
      load->getBusInterface()->getVNom() < params_->getUNomMin()) return;
  if (params_->hasUNomMax() &&
      load->getBusInterface() &&
      load->getBusInterface()->getVNom() > params_->getUNomMax()) return;
  if (load->getBusInterface() && (doubleEquals(load->getBusInterface()->getV0(), defaultV0) || load->getBusInterface()->getV0() <  defaultV0)) return;
  loads_.push_back(load);
}

GeneratorCriteria::GeneratorCriteria(const boost::shared_ptr<criteria::CriteriaParams>& params) :
                Criteria(params) {}

GeneratorCriteria::~GeneratorCriteria() {}

bool
GeneratorCriteria::checkCriteria(double t, bool finalStep) {
  failingCriteria_.clear();
  if (!finalStep && params_->getScope() == criteria::CriteriaParams::FINAL)
    return true;
  double sum = 0.;
  bool atLeastOneEligibleGeneratorWasFound = false;
  for (std::vector<boost::shared_ptr<GeneratorInterface> >::const_iterator it = generators_.begin(), itEnd = generators_.end();
      it != itEnd; ++it) {
    double p = (*it)->getP();
    if ((params_->hasUMaxPu() || params_->hasUMinPu()) && (*it)->getBusInterface()) {
      double v = (*it)->getBusInterface()->getStateVarV();
      double vNom = (*it)->getBusInterface()->getVNom();
      if (params_->hasUMaxPu() && v > params_->getUMaxPu()*vNom) continue;
      if (params_->hasUMinPu() && v < params_->getUMinPu()*vNom) continue;
    }
    if (params_->getType() == criteria::CriteriaParams::LOCAL_VALUE) {
      if (params_->hasPMax() && p > params_->getPMax()) {
        Message mess = DYNLog(SourceAbovePower, (*it)->getID(), p, params_->getPMax(), params_->getId(), t);
        Trace::info() << mess << Trace::endline;
        failingCriteria_.push_back(mess.str());
        return false;
      }
      if (params_->hasPMin() && p < params_->getPMin()) {
        Message mess = DYNLog(SourceUnderPower, (*it)->getID(), p, params_->getPMin(), params_->getId(), t);
        Trace::info() << mess << Trace::endline;
        failingCriteria_.push_back(mess.str());
        return false;
      }
    } else {
      sum+=p;
      atLeastOneEligibleGeneratorWasFound = true;
    }
  }

  if (atLeastOneEligibleGeneratorWasFound && params_->getType() == criteria::CriteriaParams::SUM) {
    if (params_->hasPMax() && sum > params_->getPMax()) {
      Message mess = DYNLog(SourcePowerAboveMax, sum, params_->getPMax(), params_->getId(), t);
      Trace::info() << mess << Trace::endline;
      failingCriteria_.push_back(mess.str());
      return false;
    }
    if (params_->hasPMin() && sum < params_->getPMin()) {
      Message mess = DYNLog(SourcePowerBelowMin, sum, params_->getPMin(), params_->getId(), t);
      Trace::info() << mess << Trace::endline;
      failingCriteria_.push_back(mess.str());
      return false;
    }
  }

  return true;
}

bool
GeneratorCriteria::criteriaEligibleForGenerator(const boost::shared_ptr<criteria::CriteriaParams>& params) {
  if (!params->hasPMin() && !params->hasPMax())
    return false;
  return true;
}

void
GeneratorCriteria::addGenerator(const boost::shared_ptr<GeneratorInterface>& generator) {
  if (params_->hasUNomMin() &&
      generator->getBusInterface() &&
      generator->getBusInterface()->getVNom() < params_->getUNomMin()) return;
  if (params_->hasUNomMax() &&
      generator->getBusInterface() &&
      generator->getBusInterface()->getVNom() > params_->getUNomMax()) return;
  if (generator->getBusInterface() &&
      (doubleEquals(generator->getBusInterface()->getV0(), defaultV0) || generator->getBusInterface()->getV0() <  defaultV0)) return;
  generators_.push_back(generator);
}

}  // namespace DYN
