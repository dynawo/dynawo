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
#include "DYNModelConstants.h"
#include "CRTCriteriaParamsVoltageLevel.h"

#include "make_unique.hpp"

namespace DYN {

Criteria::Criteria(const std::shared_ptr<criteria::CriteriaParams>& params) :
        params_(params) {}

Criteria::~Criteria() {}

void
Criteria::printAllFailingCriteriaIntoLog(std::multimap<double, std::unique_ptr<FailingCriteria> >& distanceToFailingCriteriaMap,
                                          const boost::shared_ptr<timeline::Timeline>& timeline,
                                          double currentTime) {
  // print all failing nodes into logs
  for (std::multimap<double, std::unique_ptr<FailingCriteria> >::const_reverse_iterator failingCriteriaIt = distanceToFailingCriteriaMap.crbegin();
        failingCriteriaIt != distanceToFailingCriteriaMap.crend();
        ++failingCriteriaIt) {
    failingCriteriaIt->second->printOneFailingCriteriaIntoLog();
  }

  // print the 5 worst nodes in the timeline
  constexpr size_t failingCriteriaNumber = 5;
  const size_t maxFailingCritArraySize = std::min(failingCriteriaNumber, distanceToFailingCriteriaMap.size());
  std::multimap<double, std::unique_ptr<FailingCriteria> >::const_reverse_iterator worstFailingCriteriaBound = distanceToFailingCriteriaMap.crbegin();
  std::advance(worstFailingCriteriaBound, maxFailingCritArraySize);
  for (std::multimap<double, std::unique_ptr<FailingCriteria> >::const_reverse_iterator failingCriteriaIt = distanceToFailingCriteriaMap.crbegin();
        failingCriteriaIt != worstFailingCriteriaBound;
        ++failingCriteriaIt) {
    failingCriteriaIt->second->printOneFailingCriteriaIntoTimeline(timeline, failingCriteria_, currentTime);
  }
}

Criteria::FailingCriteria::FailingCriteria(Bound bound, std::string nodeId, const std::string& criteriaId) :
  bound_(bound),
  nodeId_(nodeId),
  criteriaId_(criteriaId) {}

Criteria::FailingCriteria::~FailingCriteria() {}

BusCriteria::BusCriteria(const std::shared_ptr<criteria::CriteriaParams>& params) :
            Criteria(params) {}

bool
BusCriteria::checkCriteria(double t, bool finalStep, const boost::shared_ptr<timeline::Timeline>& timeline) {
  failingCriteria_.clear();
  assert(params_->getType() != criteria::CriteriaParams::SUM);
  if (!finalStep && params_->getScope() == criteria::CriteriaParams::FINAL)
    return true;
  std::multimap<double, std::unique_ptr<FailingCriteria> > distanceToBusFailingCriteriaMap;
  for (const auto& bus : buses_) {
    double v = bus->getStateVarV();
    if (doubleIsZero(v)) continue;
    assert(params_->hasVoltageLevels());
    assert(params_->getVoltageLevels().size() == 1);
    const criteria::CriteriaParamsVoltageLevel& vl = params_->getVoltageLevels()[0];
    double vNom = bus->getVNom();
    if (vl.hasUMaxPu() && v > vl.getUMaxPu()*vNom) {
      std::unique_ptr<FailingCriteria> busFailingCriteria = DYN::make_unique<BusFailingCriteria>(Bound::MAX,
                                                                                                  bus->getID(),
                                                                                                  v,
                                                                                                  v/vNom,
                                                                                                  vl.getUMaxPu()*vNom,
                                                                                                  vl.getUMaxPu(),
                                                                                                  params_->getId());
      distanceToBusFailingCriteriaMap.insert(std::make_pair(busFailingCriteria->getDistance(), std::move(busFailingCriteria)));
    }
    if (vl.hasUMinPu() && v < vl.getUMinPu()*vNom) {
      std::unique_ptr<FailingCriteria> busFailingCriteria = DYN::make_unique<BusFailingCriteria>(Bound::MIN,
                                                                                                  bus->getID(),
                                                                                                  v,
                                                                                                  v/vNom,
                                                                                                  vl.getUMinPu()*vNom,
                                                                                                  vl.getUMinPu(),
                                                                                                  params_->getId());
      distanceToBusFailingCriteriaMap.insert(std::make_pair(busFailingCriteria->getDistance(), std::move(busFailingCriteria)));
    }
  }
  if (!distanceToBusFailingCriteriaMap.empty()) {
    printAllFailingCriteriaIntoLog(distanceToBusFailingCriteriaMap, timeline, t);
  }
  return distanceToBusFailingCriteriaMap.empty();
}

bool
BusCriteria::criteriaEligibleForBus(const std::shared_ptr<criteria::CriteriaParams>& params) {
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
BusCriteria::addBus(const std::shared_ptr<BusInterface>& bus) {
  assert(params_->hasVoltageLevels());
  assert(params_->getVoltageLevels().size() == 1);
  const criteria::CriteriaParamsVoltageLevel& vl = params_->getVoltageLevels()[0];
  if (vl.hasUNomMin() &&
      bus->getVNom() < vl.getUNomMin()) return;
  if (vl.hasUNomMax() &&
      bus->getVNom() > vl.getUNomMax()) return;
  if (doubleIsZero(bus->getV0())) return;
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
    case DYN::Criteria::Bound::MAX: {
        Trace::debug() << DYNLog(BusAboveVoltage, nodeId_, v_, vPu_, vBound_, vBoundPu_, criteriaId_) << Trace::endline;
      }
      break;
    case DYN::Criteria::Bound::MIN: {
        Trace::debug() << DYNLog(BusUnderVoltage, nodeId_, v_, vPu_, vBound_, vBoundPu_, criteriaId_) << Trace::endline;
      }
      break;
  }
}

void
BusCriteria::BusFailingCriteria::printOneFailingCriteriaIntoTimeline(const boost::shared_ptr<timeline::Timeline>& timeline,
                                                                      std::vector<std::pair<double, std::string> >& failingCriteria,
                                                                      double currentTime) const {
  const std::string name = "Simulation";
  switch (bound_) {
  case DYN::Criteria::Bound::MAX: {
      if (timeline != nullptr) {
        MessageTimeline messageTimeline = DYNTimeline(BusAboveVoltage, nodeId_, v_, vPu_, vBound_, vBoundPu_, criteriaId_);
        timeline->addEvent(currentTime, name, messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
      }
      Message failingCriteriaMessage = DYNLog(BusAboveVoltage, nodeId_, v_, vPu_, vBound_, vBoundPu_, criteriaId_);
      failingCriteria.push_back(std::make_pair(currentTime, failingCriteriaMessage.str()));
    }
    break;
  case DYN::Criteria::Bound::MIN: {
      if (timeline != nullptr) {
        MessageTimeline messageTimeline = DYNTimeline(BusUnderVoltage, nodeId_, v_, vPu_, vBound_, vBoundPu_, criteriaId_);
        timeline->addEvent(currentTime, name, messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
      }
      Message failingCriteriaMessage = DYNLog(BusUnderVoltage, nodeId_, v_, vPu_, vBound_, vBoundPu_, criteriaId_);
      failingCriteria.push_back(std::make_pair(currentTime, failingCriteriaMessage.str()));
    }
    break;
  }
}

LoadCriteria::LoadCriteria(const std::shared_ptr<criteria::CriteriaParams>& params) :
                Criteria(params) {}

bool
LoadCriteria::checkCriteria(double t, bool finalStep, const boost::shared_ptr<timeline::Timeline>& timeline) {
  failingCriteria_.clear();
  if (!finalStep && params_->getScope() == criteria::CriteriaParams::FINAL)
    return true;
  double sum = 0.;
  std::multimap<double, std::shared_ptr<LoadInterface> > loadToSourcesAddedIntoSumMap;
  bool atLeastOneEligibleLoadWasFound = false;
  std::unordered_set<std::string> alreadyChecked;
  bool isCriteriaOk = true;
  std::multimap<double, std::unique_ptr<FailingCriteria> > distanceToLoadFailingCriteriaMap;
  for (std::vector<std::shared_ptr<LoadInterface> >::const_iterator loadIt = loads_.begin(), loadItEnd = loads_.end();
      loadIt != loadItEnd; ++loadIt) {
    std::shared_ptr<DYN::LoadInterface> load = *loadIt;
    double p = load->getStateVarP() * SNREF;
    if (!params_->getVoltageLevels().empty()) {
      if (alreadyChecked.find(load->getID()) != alreadyChecked.end()) continue;
      for (const auto& vl : params_->getVoltageLevels()) {
        if ((vl.hasUMaxPu() || vl.hasUMinPu() || vl.hasUNomMax() || vl.hasUNomMin()) && load->getBusInterface()) {
          double v = load->getBusInterface()->getStateVarV();
          double vNom = load->getBusInterface()->getVNom();
          if (vl.hasUNomMin() && vNom < vl.getUNomMin()) continue;
          if (vl.hasUNomMax() && vNom > vl.getUNomMax()) continue;
          if (vl.hasUMaxPu() && v > vl.getUMaxPu()*vNom) continue;
          if (vl.hasUMinPu() && v < vl.getUMinPu()*vNom) continue;
        }
        checkCriteriaInLocalValueOrSumType(load,
                                            p,
                                            loadToSourcesAddedIntoSumMap,
                                            distanceToLoadFailingCriteriaMap,
                                            alreadyChecked,
                                            isCriteriaOk,
                                            sum,
                                            atLeastOneEligibleLoadWasFound);
        break;
      }
    } else {
      checkCriteriaInLocalValueOrSumType(load,
                                          p,
                                          loadToSourcesAddedIntoSumMap,
                                          distanceToLoadFailingCriteriaMap,
                                          alreadyChecked,
                                          isCriteriaOk,
                                          sum,
                                          atLeastOneEligibleLoadWasFound);
    }
  }

  if (params_->getType() == criteria::CriteriaParams::LOCAL_VALUE && !isCriteriaOk) {
    printAllFailingCriteriaIntoLog(distanceToLoadFailingCriteriaMap, timeline, t);
  } else if (params_->getType() == criteria::CriteriaParams::SUM && atLeastOneEligibleLoadWasFound) {
    if (params_->hasPMax() && sum > params_->getPMax()) {
      for (std::multimap<double, std::shared_ptr<LoadInterface> >::const_reverse_iterator loadIt = loadToSourcesAddedIntoSumMap.crbegin();
            loadIt != loadToSourcesAddedIntoSumMap.crend();
            ++loadIt) {
        const double activePowerSN = loadIt->second->getStateVarP() * SNREF;
        Trace::debug() << DYNLog(SourcePowerTakenIntoAccount, "load", loadIt->second->getID(), params_->getId(),
          activePowerSN, loadIt->second->getBusInterface()->getStateVarV()) << Trace::endline;
        if (timeline != nullptr && !doubleIsZero(activePowerSN)) {
          MessageTimeline loadMessageTimeline = DYNTimeline(SourcePowerTakenIntoAccount,
                                                            "load",
                                                            loadIt->second->getID(),
                                                            params_->getId(),
                                                            activePowerSN,
                                                            loadIt->second->getBusInterface()->getStateVarV());
          timeline->addEvent(t,
                              "Simulation",
                              loadMessageTimeline.str(),
                              loadMessageTimeline.priority(),
                              loadMessageTimeline.getKey());
        }
      }

      if (timeline != nullptr) {
        MessageTimeline sourcePowerAboveMaxMsgTimeline = DYNTimeline(SourcePowerAboveMax, sum, params_->getPMax(), params_->getId());
        timeline->addEvent(t,
                            "Simulation",
                            sourcePowerAboveMaxMsgTimeline.str(),
                            sourcePowerAboveMaxMsgTimeline.priority(),
                            sourcePowerAboveMaxMsgTimeline.getKey());
      }

      Message messageLog = DYNLog(SourcePowerAboveMax, sum, params_->getPMax(), params_->getId());
      Trace::info() << messageLog << Trace::endline;
      failingCriteria_.push_back(std::make_pair(t, messageLog.str()));
      isCriteriaOk &= false;
    }
    if (params_->hasPMin() && sum < params_->getPMin()) {
      for (std::multimap<double, std::shared_ptr<LoadInterface> >::const_iterator loadIt = loadToSourcesAddedIntoSumMap.cbegin();
            loadIt != loadToSourcesAddedIntoSumMap.cend();
            ++loadIt) {
        const double activePowerSN = loadIt->second->getStateVarP() * SNREF;
        Trace::debug() << DYNLog(SourcePowerTakenIntoAccount, "load", loadIt->second->getID(), params_->getId(),
          activePowerSN, loadIt->second->getBusInterface()->getStateVarV()) << Trace::endline;
        if (timeline != nullptr && !doubleIsZero(activePowerSN)) {
          MessageTimeline loadMessageTimeline = DYNTimeline(SourcePowerTakenIntoAccount,
                                                            "load",
                                                            loadIt->second->getID(),
                                                            params_->getId(),
                                                            activePowerSN,
                                                            loadIt->second->getBusInterface()->getStateVarV());
          timeline->addEvent(t,
                              "Simulation",
                              loadMessageTimeline.str(),
                              loadMessageTimeline.priority(),
                              loadMessageTimeline.getKey());
        }
      }

      if (timeline != nullptr) {
        MessageTimeline sourcePowerBelowMinMsgTimeline = DYNTimeline(SourcePowerBelowMin, sum, params_->getPMin(), params_->getId());
        timeline->addEvent(t,
                            "Simulation",
                            sourcePowerBelowMinMsgTimeline.str(),
                            sourcePowerBelowMinMsgTimeline.priority(),
                            sourcePowerBelowMinMsgTimeline.getKey());
      }

      Message messageLog = DYNLog(SourcePowerBelowMin, sum, params_->getPMin(), params_->getId());
      Trace::info() << messageLog << Trace::endline;
      failingCriteria_.push_back(std::make_pair(t, messageLog.str()));
      isCriteriaOk &= false;
    }
  }

  return isCriteriaOk;
}

void
LoadCriteria::checkCriteriaInLocalValueOrSumType(const std::shared_ptr<DYN::LoadInterface>& load,
                                                  double loadActivePower,
                                                  std::multimap<double, std::shared_ptr<LoadInterface> >& loadToSourcesAddedIntoSumMap,
                                                  std::multimap<double, std::unique_ptr<FailingCriteria> >& distanceToLoadFailingCriteriaMap,
                                                  std::unordered_set<std::string>& alreadyChecked,
                                                  bool& isCriteriaOk,
                                                  double& sum,
                                                  bool& atLeastOneEligibleLoadWasFound) {
  if (params_->getType() == criteria::CriteriaParams::LOCAL_VALUE) {
    if (params_->hasPMax() && loadActivePower > params_->getPMax()) {
      std::unique_ptr<FailingCriteria> loadFailingCriteria = DYN::make_unique<LoadFailingCriteria>(Bound::MAX,
                                                                                                    load->getID(),
                                                                                                    loadActivePower,
                                                                                                    params_->getPMax(),
                                                                                                    params_->getId());
      distanceToLoadFailingCriteriaMap.insert(std::make_pair(loadFailingCriteria->getDistance(), std::move(loadFailingCriteria)));
      isCriteriaOk &= false;
      alreadyChecked.insert(load->getID());
    }
    if (params_->hasPMin() && loadActivePower < params_->getPMin()) {
      std::unique_ptr<FailingCriteria> loadFailingCriteria = DYN::make_unique<LoadFailingCriteria>(Bound::MIN,
                                                                                                    load->getID(),
                                                                                                    loadActivePower,
                                                                                                    params_->getPMin(),
                                                                                                    params_->getId());
      distanceToLoadFailingCriteriaMap.insert(std::make_pair(loadFailingCriteria->getDistance(), std::move(loadFailingCriteria)));
      isCriteriaOk &= false;
      alreadyChecked.insert(load->getID());
    }
  } else {
    if (alreadyChecked.find(load->getID()) != alreadyChecked.end()) return;
    alreadyChecked.insert(load->getID());
    loadToSourcesAddedIntoSumMap.insert({loadActivePower, load});
    sum += loadActivePower;
    atLeastOneEligibleLoadWasFound = true;
  }
}

bool
LoadCriteria::criteriaEligibleForLoad(const std::shared_ptr<criteria::CriteriaParams>& params) {
  if (!params->hasPMin() && !params->hasPMax())
    return false;
  return true;
}

void
LoadCriteria::addLoad(const std::shared_ptr<LoadInterface>& load) {
  if (load->isFictitious())
    return;
  if (load->getBusInterface() &&
        (doubleIsZero(load->getBusInterface()->getV0()))) return;
  if (params_->getVoltageLevels().empty()) {
    loads_.push_back(load);
  } else {
    for (const auto& vl : params_->getVoltageLevels()) {
      if (vl.hasUNomMin() &&
          load->getBusInterface() &&
          load->getBusInterface()->getVNom() < vl.getUNomMin()) continue;
      if (vl.hasUNomMax() &&
          load->getBusInterface() &&
          load->getBusInterface()->getVNom() > vl.getUNomMax()) continue;
      loads_.push_back(load);
      break;
    }
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
    case DYN::Criteria::Bound::MAX: {
        Trace::debug() << DYNTimeline(SourceAbovePower, nodeId_, p_, pBound_, criteriaId_) << Trace::endline;
      }
      break;
    case DYN::Criteria::Bound::MIN: {
        Trace::debug() << DYNTimeline(SourceUnderPower, nodeId_, p_, pBound_, criteriaId_) << Trace::endline;
      }
      break;
  }
}

void
LoadCriteria::LoadFailingCriteria::printOneFailingCriteriaIntoTimeline(const boost::shared_ptr<timeline::Timeline>& timeline,
                                                                      std::vector<std::pair<double, std::string> >& failingCriteria,
                                                                      double currentTime) const {
  const std::string name = "Simulation";
  switch (bound_) {
  case DYN::Criteria::Bound::MAX: {
      if (timeline != nullptr) {
        MessageTimeline messageTimeline = DYNTimeline(SourceAbovePower, nodeId_, p_, pBound_, criteriaId_);
        timeline->addEvent(currentTime, name, messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
      }
      Message failingCriteriaMessage = DYNLog(SourceAbovePower, nodeId_, p_, pBound_, criteriaId_);
      failingCriteria.push_back(std::make_pair(currentTime, failingCriteriaMessage.str()));
    }
    break;
  case DYN::Criteria::Bound::MIN: {
      if (timeline != nullptr) {
        MessageTimeline messageTimeline = DYNTimeline(SourceUnderPower, nodeId_, p_, pBound_, criteriaId_);
        timeline->addEvent(currentTime, name, messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
      }
      Message failingCriteriaMessage = DYNLog(SourceUnderPower, nodeId_, p_, pBound_, criteriaId_);
      failingCriteria.push_back(std::make_pair(currentTime, failingCriteriaMessage.str()));
    }
    break;
  }
}

GeneratorCriteria::GeneratorCriteria(const std::shared_ptr<criteria::CriteriaParams>& params) :
                Criteria(params) {}

bool
GeneratorCriteria::checkCriteria(double t, bool finalStep, const boost::shared_ptr<timeline::Timeline>& timeline) {
  failingCriteria_.clear();
  if (!finalStep && params_->getScope() == criteria::CriteriaParams::FINAL)
    return true;
  double sum = 0.;
  std::multimap<double, std::shared_ptr<GeneratorInterface> > generatorToSourcesAddedIntoSumMap;
  bool atLeastOneEligibleGeneratorWasFound = false;
  std::unordered_set<std::string> alreadyChecked;
  bool isCriteriaOk = true;
  std::multimap<double, std::unique_ptr<FailingCriteria> > distanceToGeneratorFailingCriteriaMap;
  for (std::vector<std::shared_ptr<GeneratorInterface> >::const_iterator generatorIt = generators_.begin(),
        generatorItEnd = generators_.end();
        generatorIt != generatorItEnd; ++generatorIt) {
    std::shared_ptr<GeneratorInterface> generator = *generatorIt;
    double p = -generator->getStateVarP() * SNREF;
    if (params_->getVoltageLevels().size() != 0) {
      if (alreadyChecked.find(generator->getID()) != alreadyChecked.end()) continue;
      for (const auto& vl : params_->getVoltageLevels()) {
        if ((vl.hasUMaxPu() || vl.hasUMinPu() || vl.hasUNomMin() || vl.hasUNomMax()) && generator->getBusInterface()) {
          double v = generator->getBusInterface()->getStateVarV();
          double vNom = generator->getBusInterface()->getVNom();
          if (vl.hasUNomMin() && vNom < vl.getUNomMin()) continue;
          if (vl.hasUNomMax() && vNom > vl.getUNomMax()) continue;
          if (vl.hasUMaxPu() && v > vl.getUMaxPu()*vNom) continue;
          if (vl.hasUMinPu() && v < vl.getUMinPu()*vNom) continue;
        }
        checkCriteriaInLocalValueOrSumType(generator,
                                            p,
                                            generatorToSourcesAddedIntoSumMap,
                                            distanceToGeneratorFailingCriteriaMap,
                                            alreadyChecked,
                                            isCriteriaOk,
                                            sum,
                                            atLeastOneEligibleGeneratorWasFound);
        break;
      }
    } else {
      checkCriteriaInLocalValueOrSumType(generator,
                                          p,
                                          generatorToSourcesAddedIntoSumMap,
                                          distanceToGeneratorFailingCriteriaMap,
                                          alreadyChecked,
                                          isCriteriaOk,
                                          sum,
                                          atLeastOneEligibleGeneratorWasFound);
    }
  }

  if (params_->getType() == criteria::CriteriaParams::LOCAL_VALUE && !isCriteriaOk) {
    printAllFailingCriteriaIntoLog(distanceToGeneratorFailingCriteriaMap, timeline, t);
  } else if (params_->getType() == criteria::CriteriaParams::SUM && atLeastOneEligibleGeneratorWasFound) {
    if (params_->hasPMax() && sum > params_->getPMax()) {
      for (std::multimap<double, std::shared_ptr<GeneratorInterface> >::const_reverse_iterator generatorIt = generatorToSourcesAddedIntoSumMap.crbegin();
            generatorIt != generatorToSourcesAddedIntoSumMap.crend();
            ++generatorIt) {
        const double activePowerSN = -generatorIt->second->getStateVarP() * SNREF;
        Trace::info() << DYNLog(SourcePowerTakenIntoAccount, "generator", generatorIt->second->getID(), params_->getId(),
          activePowerSN, generatorIt->second->getBusInterface()->getStateVarV()) << Trace::endline;
        if (timeline != nullptr && !doubleIsZero(activePowerSN)) {
          MessageTimeline generatorMessageTimeline = DYNTimeline(SourcePowerTakenIntoAccount,
                                                                  "generator",
                                                                  generatorIt->second->getID(),
                                                                  params_->getId(),
                                                                  activePowerSN,
                                                                  generatorIt->second->getBusInterface()->getStateVarV());
          timeline->addEvent(t,
                              "Simulation",
                              generatorMessageTimeline.str(),
                              generatorMessageTimeline.priority(),
                              generatorMessageTimeline.getKey());
        }
      }

      if (timeline != nullptr) {
        MessageTimeline sourcePowerAboveMaxMsgTimeline = DYNTimeline(SourcePowerAboveMax, sum, params_->getPMax(), params_->getId());
        timeline->addEvent(t,
                            "Simulation",
                            sourcePowerAboveMaxMsgTimeline.str(),
                            sourcePowerAboveMaxMsgTimeline.priority(),
                            sourcePowerAboveMaxMsgTimeline.getKey());
      }

      Message messageLog = DYNLog(SourcePowerAboveMax, sum, params_->getPMax(), params_->getId());
      Trace::info() << messageLog << Trace::endline;
      failingCriteria_.push_back(std::make_pair(t, messageLog.str()));
      isCriteriaOk &= false;
    }
    if (params_->hasPMin() && sum < params_->getPMin()) {
      for (std::multimap<double, std::shared_ptr<GeneratorInterface> >::const_iterator generatorIt = generatorToSourcesAddedIntoSumMap.cbegin();
            generatorIt != generatorToSourcesAddedIntoSumMap.cend();
            ++generatorIt) {
        const double activePowerSN = -generatorIt->second->getStateVarP() * SNREF;
        Trace::debug() << DYNLog(SourcePowerTakenIntoAccount, "generator", generatorIt->second->getID(), params_->getId(),
          activePowerSN, generatorIt->second->getBusInterface()->getStateVarV()) << Trace::endline;
        if (timeline != nullptr && !doubleIsZero(activePowerSN)) {
          MessageTimeline generatorMessageTimeline = DYNTimeline(SourcePowerTakenIntoAccount,
                                                                  "generator",
                                                                  generatorIt->second->getID(),
                                                                  params_->getId(),
                                                                  activePowerSN,
                                                                  generatorIt->second->getBusInterface()->getStateVarV());
          timeline->addEvent(t,
                              "Simulation",
                              generatorMessageTimeline.str(),
                              generatorMessageTimeline.priority(),
                              generatorMessageTimeline.getKey());
        }
      }

      if (timeline != nullptr) {
        MessageTimeline sourcePowerBelowMinMsgTimeline = DYNTimeline(SourcePowerBelowMin, sum, params_->getPMin(), params_->getId());
        timeline->addEvent(t,
                            "Simulation",
                            sourcePowerBelowMinMsgTimeline.str(),
                            sourcePowerBelowMinMsgTimeline.priority(),
                            sourcePowerBelowMinMsgTimeline.getKey());
      }

      Message mess = DYNLog(SourcePowerBelowMin, sum, params_->getPMin(), params_->getId());
      Trace::info() << mess << Trace::endline;
      failingCriteria_.push_back(std::make_pair(t, mess.str()));
      isCriteriaOk &= false;
    }
  }

  return isCriteriaOk;
}

void
GeneratorCriteria::checkCriteriaInLocalValueOrSumType(const std::shared_ptr<DYN::GeneratorInterface>& generator,
                                                      double generatorActivePower,
                                                      std::multimap<double, std::shared_ptr<GeneratorInterface> >& generatorToSourcesAddedIntoSumMap,
                                                      std::multimap<double, std::unique_ptr<FailingCriteria> >& distanceToGeneratorFailingCriteriaMap,
                                                      std::unordered_set<std::string>& alreadyChecked,
                                                      bool& isCriteriaOk,
                                                      double& sum,
                                                      bool& atLeastOneEligibleGeneratorWasFound) {
  if (params_->getType() == criteria::CriteriaParams::LOCAL_VALUE) {
    if (params_->hasPMax() && generatorActivePower > params_->getPMax()) {
      std::unique_ptr<FailingCriteria> generatorFailingCriteria = DYN::make_unique<LoadCriteria::LoadFailingCriteria>(Bound::MAX,
                                                                                                                      generator->getID(),
                                                                                                                      generatorActivePower,
                                                                                                                      params_->getPMax(),
                                                                                                                      params_->getId());
      distanceToGeneratorFailingCriteriaMap.insert(std::make_pair(generatorFailingCriteria->getDistance(), std::move(generatorFailingCriteria)));
      isCriteriaOk &= false;
      alreadyChecked.insert(generator->getID());
    }
    if (params_->hasPMin() && generatorActivePower < params_->getPMin()) {
      std::unique_ptr<FailingCriteria> generatorFailingCriteria = DYN::make_unique<LoadCriteria::LoadFailingCriteria>(Bound::MIN,
                                                                                                                      generator->getID(),
                                                                                                                      generatorActivePower,
                                                                                                                      params_->getPMin(),
                                                                                                                      params_->getId());
      distanceToGeneratorFailingCriteriaMap.insert(std::make_pair(generatorFailingCriteria->getDistance(), std::move(generatorFailingCriteria)));
      isCriteriaOk &= false;
      alreadyChecked.insert(generator->getID());
    }
  } else {
    generatorToSourcesAddedIntoSumMap.insert({generatorActivePower, generator});
    if (alreadyChecked.find(generator->getID()) != alreadyChecked.end()) return;
    alreadyChecked.insert(generator->getID());
    sum += generatorActivePower;
    atLeastOneEligibleGeneratorWasFound = true;
  }
}

bool
GeneratorCriteria::criteriaEligibleForGenerator(const std::shared_ptr<criteria::CriteriaParams>& params) {
  if (!params->hasPMin() && !params->hasPMax())
    return false;
  return true;
}

void
GeneratorCriteria::addGenerator(const std::shared_ptr<GeneratorInterface>& generator) {
  if (generator->getBusInterface() &&
        (doubleIsZero(generator->getBusInterface()->getV0()))) return;
  if (params_->getVoltageLevels().empty()) {
    generators_.push_back(generator);
  } else {
    for (const auto& vl : params_->getVoltageLevels()) {
      if (vl.hasUNomMin() &&
          generator->getBusInterface() &&
          generator->getBusInterface()->getVNom() < vl.getUNomMin()) continue;
      if (vl.hasUNomMax() &&
          generator->getBusInterface() &&
          generator->getBusInterface()->getVNom() > vl.getUNomMax()) continue;
      generators_.push_back(generator);
      break;
    }
  }
}

}  // namespace DYN
