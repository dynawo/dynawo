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

void
Criteria::printAllFailingCriteriaIntoLog(std::multimap<double, std::shared_ptr<FailingCriteria> >& distanceToFailingCriteriaMap,
                                          const boost::shared_ptr<timeline::Timeline>& timeline,
                                          double currentTime) const {
  // print all failing nodes into logs
  for (std::multimap<double, std::shared_ptr<FailingCriteria> >::const_reverse_iterator failingCriteriaIt = distanceToFailingCriteriaMap.crbegin();
        failingCriteriaIt != distanceToFailingCriteriaMap.crend();
        ++failingCriteriaIt) {
    failingCriteriaIt->second->printOneFailingCriteriaIntoLog();
  }

  // print the 5 worst nodes in the timeline
  if (timeline != nullptr) {
    constexpr size_t failingCriteriaNumber = 5;
    const size_t maxFailingCritArraySize = std::min(failingCriteriaNumber, distanceToFailingCriteriaMap.size());
    std::multimap<double, std::shared_ptr<FailingCriteria> >::const_reverse_iterator worstFailingCriteriaBound = distanceToFailingCriteriaMap.crbegin();
    std::advance(worstFailingCriteriaBound, maxFailingCritArraySize);
    for (std::multimap<double, std::shared_ptr<FailingCriteria> >::const_reverse_iterator failingCriteriaIt = distanceToFailingCriteriaMap.crbegin();
          failingCriteriaIt != worstFailingCriteriaBound;
          ++failingCriteriaIt) {
      failingCriteriaIt->second->printOneFailingCriteriaIntoTimeline(timeline, currentTime);
    }
  }
}

Criteria::FailingCriteria::FailingCriteria(Bound bound, std::string nodeId, const std::string& criteriaId) :
  bound_(bound),
  nodeId_(nodeId),
  criteriaId_(criteriaId) {}

BusCriteria::BusCriteria(const boost::shared_ptr<criteria::CriteriaParams>& params) :
            Criteria(params) {}

BusCriteria::~BusCriteria() {}

bool
BusCriteria::checkCriteria(double t, bool finalStep, const boost::shared_ptr<timeline::Timeline>& timeline) {
  failingCriteria_.clear();
  assert(params_->getType() != criteria::CriteriaParams::SUM);
  if (!finalStep && params_->getScope() == criteria::CriteriaParams::FINAL)
    return true;
  std::multimap<double, std::shared_ptr<FailingCriteria> > distanceToBusFailingCriteriaMap;
  for (std::vector<boost::shared_ptr<BusInterface> >::const_iterator it = buses_.begin(), itEnd = buses_.end();
      it != itEnd; ++it) {
    double v = (*it)->getStateVarV();
    if (doubleIsZero(v)) continue;
    assert(params_->hasVoltageLevels());
    assert(params_->getVoltageLevels().size() == 1);
    const criteria::CriteriaParamsVoltageLevel& vl = params_->getVoltageLevels()[0];
    double vNom = (*it)->getVNom();
    if (vl.hasUMaxPu() && v > vl.getUMaxPu()*vNom) {
      std::shared_ptr<FailingCriteria> busFailingCriteria(new BusFailingCriteria(Bound::MAX,
                                                                                  (*it)->getID(),
                                                                                  v,
                                                                                  v/vNom,
                                                                                  vl.getUMaxPu()*vNom,
                                                                                  vl.getUMaxPu(),
                                                                                  params_->getId()));
      distanceToBusFailingCriteriaMap.insert({busFailingCriteria->getDistance(), busFailingCriteria});
      Message mess = DYNLog(BusAboveVoltage, (*it)->getID(), v, v/vNom, vl.getUMaxPu()*vNom, vl.getUMaxPu(), params_->getId());
      failingCriteria_.push_back(std::make_pair(t, mess.str()));
    }
    if (vl.hasUMinPu() && v < vl.getUMinPu()*vNom) {
      std::shared_ptr<FailingCriteria> busFailingCriteria(new BusFailingCriteria(Bound::MIN,
                                                                                  (*it)->getID(),
                                                                                  v,
                                                                                  v/vNom,
                                                                                  vl.getUMinPu()*vNom,
                                                                                  vl.getUMinPu(),
                                                                                  params_->getId()));
      distanceToBusFailingCriteriaMap.insert({busFailingCriteria->getDistance(), busFailingCriteria});
      Message mess = DYNLog(BusUnderVoltage, (*it)->getID(), v, v/vNom, vl.getUMinPu()*vNom, vl.getUMinPu(), params_->getId());
      failingCriteria_.push_back(std::make_pair(t, mess.str()));
    }
  }
  if (!distanceToBusFailingCriteriaMap.empty()) {
    printAllFailingCriteriaIntoLog(distanceToBusFailingCriteriaMap, timeline, t);
  }
  return distanceToBusFailingCriteriaMap.empty();
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

BusCriteria::BusFailingCriteria::BusFailingCriteria(Bound bound,
                                                    std::string busId,
                                                    double v,
                                                    double vPu,
                                                    double vBound,
                                                    double vBoundPu,
                                                    const std::string& criteriaId) :
  FailingCriteria(bound, busId, criteriaId),
  v_(v),
  vPu_(vPu),
  vBound_(vBound),
  vBoundPu_(vBoundPu) {}

void
BusCriteria::BusFailingCriteria::printOneFailingCriteriaIntoLog() const {
  switch (bound_) {
    case DYN::Criteria::Bound::MAX:
      {
        Trace::debug() << DYNLog(BusAboveVoltage, nodeId_, v_, vPu_, vBound_, vBoundPu_, criteriaId_) << Trace::endline;
      }
      break;
    case DYN::Criteria::Bound::MIN:
      {
        Trace::debug() << DYNLog(BusUnderVoltage, nodeId_, v_, vPu_, vBound_, vBoundPu_, criteriaId_) << Trace::endline;
      }
      break;
  }
}

void
BusCriteria::BusFailingCriteria::printOneFailingCriteriaIntoTimeline(const boost::shared_ptr<timeline::Timeline>& timeline,
                                                                      double currentTime) const {
  if (timeline != nullptr) {
    const std::string name = "Simulation";
    switch (bound_) {
    case DYN::Criteria::Bound::MAX:
      {
        MessageTimeline messageTimeline = DYNTimeline(BusAboveVoltage, nodeId_, v_, vPu_, vBound_, vBoundPu_, criteriaId_);
        timeline->addEvent(currentTime, name, messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
      }
      break;
    case DYN::Criteria::Bound::MIN:
      {
        MessageTimeline messageTimeline = DYNTimeline(BusUnderVoltage, nodeId_, v_, vPu_, vBound_, vBoundPu_, criteriaId_);
        timeline->addEvent(currentTime, name, messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
      }
      break;
    }
  }
}

LoadCriteria::LoadCriteria(const boost::shared_ptr<criteria::CriteriaParams>& params) :
                Criteria(params) {}

LoadCriteria::~LoadCriteria() {}

bool
LoadCriteria::checkCriteria(double t, bool finalStep, const boost::shared_ptr<timeline::Timeline>& timeline) {
  failingCriteria_.clear();
  if (!finalStep && params_->getScope() == criteria::CriteriaParams::FINAL)
    return true;
  double sum = 0.;
  std::multimap<double, boost::shared_ptr<LoadInterface> > loadToSourcesAddedIntoSumMap;
  bool atLeastOneEligibleLoadWasFound = false;
  boost::unordered_set<std::string> alreadySummed;
  bool isCriteriaOk = true;
  std::multimap<double, std::shared_ptr<FailingCriteria> > distanceToLoadFailingCriteriaMap;
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
          std::shared_ptr<FailingCriteria> loadFailingCriteria(new LoadFailingCriteria(Bound::MAX,
                                                                (*it)->getID(),
                                                                p,
                                                                params_->getPMax(),
                                                                params_->getId()));
          distanceToLoadFailingCriteriaMap.insert({loadFailingCriteria->getDistance(), loadFailingCriteria});
          Message mess = DYNLog(SourceAbovePower, (*it)->getID(), p, params_->getPMax(), params_->getId());
          failingCriteria_.push_back(std::make_pair(t, mess.str()));
          isCriteriaOk &= false;
        }
        if (params_->hasPMin() && p < params_->getPMin()) {
          std::shared_ptr<FailingCriteria> loadFailingCriteria(new LoadFailingCriteria(Bound::MIN,
                                                                (*it)->getID(),
                                                                p,
                                                                params_->getPMin(),
                                                                params_->getId()));
          distanceToLoadFailingCriteriaMap.insert({loadFailingCriteria->getDistance(), loadFailingCriteria});
          Message mess = DYNLog(SourceUnderPower, (*it)->getID(), p, params_->getPMin(), params_->getId());
          failingCriteria_.push_back(std::make_pair(t, mess.str()));
          isCriteriaOk &= false;
        }
      } else {
        loadToSourcesAddedIntoSumMap.insert({p, *it});
        if (alreadySummed.find((*it)->getID()) != alreadySummed.end()) continue;
        alreadySummed.insert((*it)->getID());
        sum+=p;
        atLeastOneEligibleLoadWasFound = true;
      }
    }
  }

  if (params_->getType() == criteria::CriteriaParams::LOCAL_VALUE && !isCriteriaOk) {
    printAllFailingCriteriaIntoLog(distanceToLoadFailingCriteriaMap, timeline, t);
  } else if (params_->getType() == criteria::CriteriaParams::SUM && atLeastOneEligibleLoadWasFound) {
    if (params_->hasPMax() && sum > params_->getPMax()) {
      for (std::multimap<double, boost::shared_ptr<LoadInterface> >::const_reverse_iterator loadIt = loadToSourcesAddedIntoSumMap.crbegin();
            loadIt != loadToSourcesAddedIntoSumMap.crend();
            ++loadIt) {
        Trace::debug() << DYNLog(SourcePowerTakenIntoAccount, "load", loadIt->second->getID(), params_->getId(),
            loadIt->second->getP(), loadIt->second->getBusInterface()->getStateVarV()) << Trace::endline;
      }

      if (timeline != nullptr) {
        MessageTimeline messageTimeline = DYNTimeline(SourcePowerAboveMax, sum, params_->getPMax(), params_->getId());
        timeline->addEvent(t, "Simulation", messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
      }

      Message messageLog = DYNLog(SourcePowerAboveMax, sum, params_->getPMax(), params_->getId());
      Trace::info() << messageLog << Trace::endline;
      failingCriteria_.push_back(std::make_pair(t, messageLog.str()));
      isCriteriaOk &= false;
    }
    if (params_->hasPMin() && sum < params_->getPMin()) {
      for (std::multimap<double, boost::shared_ptr<LoadInterface> >::const_iterator loadIt = loadToSourcesAddedIntoSumMap.cbegin();
            loadIt != loadToSourcesAddedIntoSumMap.cend();
            ++loadIt) {
        Trace::debug() << DYNLog(SourcePowerTakenIntoAccount, "load", loadIt->second->getID(), params_->getId(),
            loadIt->second->getP(), loadIt->second->getBusInterface()->getStateVarV()) << Trace::endline;
      }

      if (timeline != nullptr) {
        MessageTimeline messageTimeline = DYNTimeline(SourcePowerBelowMin, sum, params_->getPMin(), params_->getId());
        timeline->addEvent(t, "Simulation", messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
      }

      Message messageLog = DYNLog(SourcePowerBelowMin, sum, params_->getPMin(), params_->getId());
      Trace::info() << messageLog << Trace::endline;
      failingCriteria_.push_back(std::make_pair(t, messageLog.str()));
      isCriteriaOk &= false;
    }
  }

  return isCriteriaOk;
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

LoadCriteria::LoadFailingCriteria::LoadFailingCriteria(Bound bound,
                                                        std::string loadId,
                                                        double p,
                                                        double pBound,
                                                        const std::string& criteriaId) :
  FailingCriteria(bound, loadId, criteriaId),
  p_(p),
  pBound_(pBound) {}

void
LoadCriteria::LoadFailingCriteria::printOneFailingCriteriaIntoLog() const {
  switch (bound_) {
    case DYN::Criteria::Bound::MAX:
      {
        Trace::debug() << DYNTimeline(SourceAbovePower, nodeId_, p_, pBound_, criteriaId_) << Trace::endline;
      }
      break;
    case DYN::Criteria::Bound::MIN:
      {
        Trace::debug() << DYNTimeline(SourceUnderPower, nodeId_, p_, pBound_, criteriaId_) << Trace::endline;
      }
      break;
  }
}

void
LoadCriteria::LoadFailingCriteria::printOneFailingCriteriaIntoTimeline(const boost::shared_ptr<timeline::Timeline>& timeline,
                                                                      double currentTime) const {
  if (timeline != nullptr) {
    const std::string name = "Simulation";
    switch (bound_) {
    case DYN::Criteria::Bound::MAX:
      {
        MessageTimeline messageTimeline = DYNTimeline(SourceAbovePower, nodeId_, p_, pBound_, criteriaId_);
        timeline->addEvent(currentTime, name, messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
      }
      break;
    case DYN::Criteria::Bound::MIN:
      {
        MessageTimeline messageTimeline = DYNTimeline(SourceUnderPower, nodeId_, p_, pBound_, criteriaId_);
        timeline->addEvent(currentTime, name, messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
      }
      break;
    }
  }
}

GeneratorCriteria::GeneratorCriteria(const boost::shared_ptr<criteria::CriteriaParams>& params) :
                Criteria(params) {}

GeneratorCriteria::~GeneratorCriteria() {}

bool
GeneratorCriteria::checkCriteria(double t, bool finalStep, const boost::shared_ptr<timeline::Timeline>& timeline) {
  failingCriteria_.clear();
  if (!finalStep && params_->getScope() == criteria::CriteriaParams::FINAL)
    return true;
  double sum = 0.;
  std::multimap<double, boost::shared_ptr<GeneratorInterface> > generatorToSourcesAddedIntoSumMap;
  bool atLeastOneEligibleGeneratorWasFound = false;
  boost::unordered_set<std::string> alreadySummed;
  bool isCriteriaOk = true;
  std::multimap<double, std::shared_ptr<FailingCriteria> > distanceToGeneratorFailingCriteriaMap;
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
          std::shared_ptr<FailingCriteria> generatorFailingCriteria(new LoadCriteria::LoadFailingCriteria(Bound::MAX,
                                                                                                          (*it)->getID(),
                                                                                                          p,
                                                                                                          params_->getPMax(),
                                                                                                          params_->getId()));
          distanceToGeneratorFailingCriteriaMap.insert({generatorFailingCriteria->getDistance(), generatorFailingCriteria});
          Message mess = DYNLog(SourceAbovePower, (*it)->getID(), p, params_->getPMax(), params_->getId());
          failingCriteria_.push_back(std::make_pair(t, mess.str()));
          isCriteriaOk &= false;
        }
        if (params_->hasPMin() && p < params_->getPMin()) {
          std::shared_ptr<FailingCriteria> generatorFailingCriteria(new LoadCriteria::LoadFailingCriteria(Bound::MIN,
                                                                                                          (*it)->getID(),
                                                                                                          p,
                                                                                                          params_->getPMin(),
                                                                                                          params_->getId()));
          distanceToGeneratorFailingCriteriaMap.insert({generatorFailingCriteria->getDistance(), generatorFailingCriteria});
          Message mess = DYNLog(SourceUnderPower, (*it)->getID(), p, params_->getPMin(), params_->getId());
          failingCriteria_.push_back(std::make_pair(t, mess.str()));
          isCriteriaOk &= false;
        }
      } else {
        generatorToSourcesAddedIntoSumMap.insert({p, *it});
        if (alreadySummed.find((*it)->getID()) != alreadySummed.end()) continue;
        alreadySummed.insert((*it)->getID());
        sum+=p;
        atLeastOneEligibleGeneratorWasFound = true;
      }
    }
  }

  if (params_->getType() == criteria::CriteriaParams::LOCAL_VALUE && !isCriteriaOk) {
    printAllFailingCriteriaIntoLog(distanceToGeneratorFailingCriteriaMap, timeline, t);
  } else if (params_->getType() == criteria::CriteriaParams::SUM && atLeastOneEligibleGeneratorWasFound) {
    if (params_->hasPMax() && sum > params_->getPMax()) {
      for (std::multimap<double, boost::shared_ptr<GeneratorInterface> >::const_reverse_iterator generatorIt = generatorToSourcesAddedIntoSumMap.crbegin();
            generatorIt != generatorToSourcesAddedIntoSumMap.crend();
            ++generatorIt) {
        Trace::info() << DYNLog(SourcePowerTakenIntoAccount, "generator", generatorIt->second->getID(), params_->getId(),
          generatorIt->second->getP(), generatorIt->second->getBusInterface()->getStateVarV()) << Trace::endline;
      }

      if (timeline != nullptr) {
        MessageTimeline messageTimeline = DYNTimeline(SourcePowerAboveMax, sum, params_->getPMax(), params_->getId());
        timeline->addEvent(t, "Simulation", messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
      }

      Message messageLog = DYNLog(SourcePowerAboveMax, sum, params_->getPMax(), params_->getId());
      Trace::info() << messageLog << Trace::endline;
      failingCriteria_.push_back(std::make_pair(t, messageLog.str()));
      isCriteriaOk &= false;
    }
    if (params_->hasPMin() && sum < params_->getPMin()) {
      for (std::multimap<double, boost::shared_ptr<GeneratorInterface> >::const_iterator generatorIt = generatorToSourcesAddedIntoSumMap.cbegin();
            generatorIt != generatorToSourcesAddedIntoSumMap.cend();
            ++generatorIt) {
        Trace::debug() << DYNLog(SourcePowerTakenIntoAccount, "generator", generatorIt->second->getID(), params_->getId(),
            generatorIt->second->getP(), generatorIt->second->getBusInterface()->getStateVarV()) << Trace::endline;
      }

      if (timeline != nullptr) {
        MessageTimeline messageTimeline = DYNTimeline(SourcePowerBelowMin, sum, params_->getPMin(), params_->getId());
        timeline->addEvent(t, "Simulation", messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
      }

      Message mess = DYNLog(SourcePowerBelowMin, sum, params_->getPMin(), params_->getId());
      Trace::info() << mess << Trace::endline;
      failingCriteria_.push_back(std::make_pair(t, mess.str()));
      isCriteriaOk &= false;
    }
  }

  return isCriteriaOk;
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
