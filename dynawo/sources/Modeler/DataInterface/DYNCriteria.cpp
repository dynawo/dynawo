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
#include "CRTCriteriaParamsVoltageLevel.h"
#include <boost/unordered_set.hpp>

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
    assert(params_->hasVoltageLevels());
    assert(params_->getVoltageLevels().size() == 1);
    const criteria::CriteriaParamsVoltageLevel& vl = params_->getVoltageLevels()[0];
    double vNom = (*it)->getVNom();
    if (vl.hasUMaxPu() && v > vl.getUMaxPu()*vNom) {
      Message mess = DYNLog(BusAboveVoltage, (*it)->getID(), v, v/vNom, vl.getUMaxPu()*vNom, vl.getUMaxPu(), params_->getId());
      Trace::info() << mess << Trace::endline;
      failingCriteria_.push_back(std::make_pair(t, mess.str()));
      return false;
    }
    if (vl.hasUMinPu() && v < vl.getUMinPu()*vNom) {
      Message mess = DYNLog(BusUnderVoltage, (*it)->getID(), v, v/vNom, vl.getUMinPu()*vNom, vl.getUMinPu(), params_->getId());
      Trace::info() << mess << Trace::endline;
      failingCriteria_.push_back(std::make_pair(t, mess.str()));
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
  if (!params->hasVoltageLevels())
    return false;
  if (params->getVoltageLevels().size() != 1)
    return false;
  const criteria::CriteriaParamsVoltageLevel& vl = params->getVoltageLevels()[0];
  if (!vl.hasUMinPu() && !vl.hasUMaxPu())
    return false;
  if (params->hasPMax())
    Trace::warn() << DYNLog(PowerBusCriteriaIgnored) << Trace::endline;
  if (params->hasPMin())
    Trace::warn() << DYNLog(PowerBusCriteriaIgnored) << Trace::endline;
  return true;
}

void
BusCriteria::addBus(const boost::shared_ptr<BusInterface>& bus) {
  assert(params_->hasVoltageLevels());
  assert(params_->getVoltageLevels().size() == 1);
  const criteria::CriteriaParamsVoltageLevel& vl = params_->getVoltageLevels()[0];
  if (vl.hasUNomMin() &&
      bus->getVNom() < vl.getUNomMin()) return;
  if (vl.hasUNomMax() &&
      bus->getVNom() > vl.getUNomMax()) return;
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
#ifdef _DEBUG_
  std::vector<boost::shared_ptr<LoadInterface> > sourcesAddedIntoSum;
#endif
  bool atLeastOneEligibleLoadWasFound = false;
  boost::unordered_set<std::string> alreadySummed;
  for (std::vector<criteria::CriteriaParamsVoltageLevel>::const_iterator itVl = params_->getVoltageLevels().begin(),
      itVlEnd = params_->getVoltageLevels().end();
      itVl != itVlEnd; ++itVl) {
    const criteria::CriteriaParamsVoltageLevel& vl = *itVl;
    for (std::vector<boost::shared_ptr<LoadInterface> >::const_iterator it = loads_.begin(), itEnd = loads_.end();
        it != itEnd; ++it) {
      double p = (*it)->getP();
      if ((vl.hasUMaxPu() || vl.hasUMinPu()) && (*it)->getBusInterface()) {
        double v = (*it)->getBusInterface()->getStateVarV();
        double vNom = (*it)->getBusInterface()->getVNom();
        if (vl.hasUMaxPu() && v > vl.getUMaxPu()*vNom) continue;
        if (vl.hasUMinPu() && v < vl.getUMinPu()*vNom) continue;
      }
      if (params_->getType() == criteria::CriteriaParams::LOCAL_VALUE) {
        if (params_->hasPMax() && p > params_->getPMax()) {
          Message mess = DYNLog(SourceAbovePower, (*it)->getID(), p, params_->getPMax(), params_->getId());
          Trace::info() << mess << Trace::endline;
          failingCriteria_.push_back(std::make_pair(t, mess.str()));
          return false;
        }
        if (params_->hasPMin() && p < params_->getPMin()) {
          Message mess = DYNLog(SourceUnderPower, (*it)->getID(), p, params_->getPMin(), params_->getId());
          Trace::info() << mess << Trace::endline;
          failingCriteria_.push_back(std::make_pair(t, mess.str()));
          return false;
        }
      } else {
#ifdef _DEBUG_
        sourcesAddedIntoSum.push_back(*it);
#endif
        if (alreadySummed.find((*it)->getID()) != alreadySummed.end()) continue;
        alreadySummed.insert((*it)->getID());
        sum+=p;
        atLeastOneEligibleLoadWasFound = true;
      }
    }
  }

  if (atLeastOneEligibleLoadWasFound && params_->getType() == criteria::CriteriaParams::SUM) {
    if (params_->hasPMax() && sum > params_->getPMax()) {
#ifdef _DEBUG_
  for (size_t i = 0; i < sourcesAddedIntoSum.size(); ++i) {
    Trace::info() << DYNLog(SourcePowerTakenIntoAccount, "load", sourcesAddedIntoSum[i]->getID(), params_->getId(),
        sourcesAddedIntoSum[i]->getP(), sourcesAddedIntoSum[i]->getBusInterface()->getStateVarV()) << Trace::endline;
  }
#endif
      Message mess = DYNLog(SourcePowerAboveMax, sum, params_->getPMax(), params_->getId());
      Trace::info() << mess << Trace::endline;
      failingCriteria_.push_back(std::make_pair(t, mess.str()));
      return false;
    }
    if (params_->hasPMin() && sum < params_->getPMin()) {
#ifdef _DEBUG_
  for (size_t i = 0; i < sourcesAddedIntoSum.size(); ++i) {
    Trace::info() << DYNLog(SourcePowerTakenIntoAccount, "load", sourcesAddedIntoSum[i]->getID(), params_->getId(),
        sourcesAddedIntoSum[i]->getP(), sourcesAddedIntoSum[i]->getBusInterface()->getStateVarV()) << Trace::endline;
  }
#endif
      Message mess = DYNLog(SourcePowerBelowMin, sum, params_->getPMin(), params_->getId());
      Trace::info() << mess << Trace::endline;
      failingCriteria_.push_back(std::make_pair(t, mess.str()));
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
  for (std::vector<criteria::CriteriaParamsVoltageLevel>::const_iterator itVl = params_->getVoltageLevels().begin(),
      itVlEnd = params_->getVoltageLevels().end();
      itVl != itVlEnd; ++itVl) {
    const criteria::CriteriaParamsVoltageLevel& vl = *itVl;
    if (vl.hasUNomMin() &&
        load->getBusInterface() &&
        load->getBusInterface()->getVNom() < vl.getUNomMin()) continue;
    if (vl.hasUNomMax() &&
        load->getBusInterface() &&
        load->getBusInterface()->getVNom() > vl.getUNomMax()) continue;
    if (load->getBusInterface() && (doubleEquals(load->getBusInterface()->getV0(), defaultV0) || load->getBusInterface()->getV0() <  defaultV0)) continue;
    loads_.push_back(load);
    break;
  }
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
#ifdef _DEBUG_
  std::vector<boost::shared_ptr<GeneratorInterface> > sourcesAddedIntoSum;
#endif
  bool atLeastOneEligibleGeneratorWasFound = false;
  boost::unordered_set<std::string> alreadySummed;
  for (std::vector<criteria::CriteriaParamsVoltageLevel>::const_iterator itVl = params_->getVoltageLevels().begin(),
      itVlEnd = params_->getVoltageLevels().end();
      itVl != itVlEnd; ++itVl) {
    const criteria::CriteriaParamsVoltageLevel& vl = *itVl;
    for (std::vector<boost::shared_ptr<GeneratorInterface> >::const_iterator it = generators_.begin(), itEnd = generators_.end();
        it != itEnd; ++it) {
      double p = (*it)->getP();
      if ((vl.hasUMaxPu() || vl.hasUMinPu()) && (*it)->getBusInterface()) {
        double v = (*it)->getBusInterface()->getStateVarV();
        double vNom = (*it)->getBusInterface()->getVNom();
        if (vl.hasUMaxPu() && v > vl.getUMaxPu()*vNom) continue;
        if (vl.hasUMinPu() && v < vl.getUMinPu()*vNom) continue;
      }
      if (params_->getType() == criteria::CriteriaParams::LOCAL_VALUE) {
        if (params_->hasPMax() && p > params_->getPMax()) {
          Message mess = DYNLog(SourceAbovePower, (*it)->getID(), p, params_->getPMax(), params_->getId());
          Trace::info() << mess << Trace::endline;
          failingCriteria_.push_back(std::make_pair(t, mess.str()));
          return false;
        }
        if (params_->hasPMin() && p < params_->getPMin()) {
          Message mess = DYNLog(SourceUnderPower, (*it)->getID(), p, params_->getPMin(), params_->getId());
          Trace::info() << mess << Trace::endline;
          failingCriteria_.push_back(std::make_pair(t, mess.str()));
          return false;
        }
      } else {
#ifdef _DEBUG_
        sourcesAddedIntoSum.push_back(*it);
#endif
        if (alreadySummed.find((*it)->getID()) != alreadySummed.end()) continue;
        alreadySummed.insert((*it)->getID());
        sum+=p;
        atLeastOneEligibleGeneratorWasFound = true;
      }
    }
  }

  if (atLeastOneEligibleGeneratorWasFound && params_->getType() == criteria::CriteriaParams::SUM) {
    if (params_->hasPMax() && sum > params_->getPMax()) {
#ifdef _DEBUG_
  for (size_t i = 0; i < sourcesAddedIntoSum.size(); ++i) {
    Trace::info() << DYNLog(SourcePowerTakenIntoAccount, "generator", sourcesAddedIntoSum[i]->getID(), params_->getId(),
        sourcesAddedIntoSum[i]->getP(), sourcesAddedIntoSum[i]->getBusInterface()->getStateVarV()) << Trace::endline;
  }
#endif
      Message mess = DYNLog(SourcePowerAboveMax, sum, params_->getPMax(), params_->getId());
      Trace::info() << mess << Trace::endline;
      failingCriteria_.push_back(std::make_pair(t, mess.str()));
      return false;
    }
    if (params_->hasPMin() && sum < params_->getPMin()) {
#ifdef _DEBUG_
  for (size_t i = 0; i < sourcesAddedIntoSum.size(); ++i) {
    Trace::info() << DYNLog(SourcePowerTakenIntoAccount, "generator", sourcesAddedIntoSum[i]->getID(), params_->getId(),
        sourcesAddedIntoSum[i]->getP(), sourcesAddedIntoSum[i]->getBusInterface()->getStateVarV()) << Trace::endline;
  }
#endif
      Message mess = DYNLog(SourcePowerBelowMin, sum, params_->getPMin(), params_->getId());
      Trace::info() << mess << Trace::endline;
      failingCriteria_.push_back(std::make_pair(t, mess.str()));
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
  for (std::vector<criteria::CriteriaParamsVoltageLevel>::const_iterator itVl = params_->getVoltageLevels().begin(),
      itVlEnd = params_->getVoltageLevels().end();
      itVl != itVlEnd; ++itVl) {
    const criteria::CriteriaParamsVoltageLevel& vl = *itVl;
    if (vl.hasUNomMin() &&
        generator->getBusInterface() &&
        generator->getBusInterface()->getVNom() < vl.getUNomMin()) continue;
    if (vl.hasUNomMax() &&
        generator->getBusInterface() &&
        generator->getBusInterface()->getVNom() > vl.getUNomMax()) continue;
    if (generator->getBusInterface() &&
        (doubleEquals(generator->getBusInterface()->getV0(), defaultV0) || generator->getBusInterface()->getV0() <  defaultV0)) continue;
    generators_.push_back(generator);
    break;
  }
}

}  // namespace DYN
