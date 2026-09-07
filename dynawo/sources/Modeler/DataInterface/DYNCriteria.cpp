//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

#include "DYNTrace.h"
#include "DYNCommon.h"
#include "DYNCriteria.h"
#include "DYNCommonConstants.h"
#include "DYNModelConstants.h"
#include "CRTCriteriaParamsVoltageLevel.h"

#include "make_unique.hpp"

#include <algorithm>

namespace DYN {

namespace {

/**
 * @brief check if a bus matches at least one voltage level of the criteria regarding its nominal voltage
 * @param voltageLevels voltage levels of the criteria
 * @param bus bus to check (may be null)
 * @return true if the voltage levels list is empty or if at least one voltage level matches the nominal voltage of the bus
 */
bool
matchesNominalVoltage(const std::vector<criteria::CriteriaParamsVoltageLevel>& voltageLevels, const std::shared_ptr<BusInterface>& bus) {
  if (voltageLevels.empty())
    return true;
  for (const auto& vl : voltageLevels) {
    if (vl.hasUNomMin() && bus && bus->getVNom() < vl.getUNomMin()) continue;
    if (vl.hasUNomMax() && bus && bus->getVNom() > vl.getUNomMax()) continue;
    return true;
  }
  return false;
}

/**
 * @brief check if a load or a generator is eligible to a criteria regarding the voltage levels filters, at the current time
 * @param voltageLevels voltage levels of the criteria
 * @param component load or generator to check
 * @return true if the voltage levels list is empty or if the component matches at least one voltage level
 */
template<typename T>
bool
isEligibleForVoltageLevels(const std::vector<criteria::CriteriaParamsVoltageLevel>& voltageLevels, const T& component) {
  if (voltageLevels.empty())
    return true;
  const std::shared_ptr<BusInterface> bus = component.getBusInterface();
  for (const auto& vl : voltageLevels) {
    if (bus && (vl.hasUMaxPu() || vl.hasUMinPu() || vl.hasUNomMax() || vl.hasUNomMin())) {
      const double vNom = bus->getVNom();
      if (vl.hasUNomMin() && vNom < vl.getUNomMin()) continue;
      if (vl.hasUNomMax() && vNom > vl.getUNomMax()) continue;
      const double v = bus->getStateVarV();
      if (vl.hasUMaxPu() && v > vl.getUMaxPu() * vNom) continue;
      if (vl.hasUMinPu() && v < vl.getUMinPu() * vNom) continue;
    }
    return true;
  }
  return false;
}

/**
 * @brief sort eligible sources by increasing active power, keeping insertion order for equal powers
 * @param sources sources (active power, source) to sort
 */
template<typename T>
void
sortByActivePower(std::vector<std::pair<double, T*> >& sources) {
  std::stable_sort(sources.begin(), sources.end(),
                   [](const std::pair<double, T*>& lhs, const std::pair<double, T*>& rhs) { return lhs.first < rhs.first; });
}

}  // namespace

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
  if (buses_.empty())
    return true;
  std::multimap<double, std::unique_ptr<FailingCriteria> > distanceToBusFailingCriteriaMap;
  assert(params_->hasVoltageLevels());
  assert(params_->getVoltageLevels().size() == 1);
  const criteria::CriteriaParamsVoltageLevel& vl = params_->getVoltageLevels()[0];
  for (const auto& bus : buses_) {
    const double v = bus->getStateVarV();
    if (doubleIsZero(v)) continue;
    const double vNom = bus->getVNom();
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

void
BusCriteria::getComponentsToUpdate(std::vector<std::shared_ptr<ComponentInterface> >& components) const {
  components.insert(components.end(), buses_.begin(), buses_.end());
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
  const bool isSumType = params_->getType() == criteria::CriteriaParams::SUM;
  const std::vector<criteria::CriteriaParamsVoltageLevel>& voltageLevels = params_->getVoltageLevels();
  double sum = 0.;
  bool atLeastOneEligibleLoadWasFound = false;
  bool isCriteriaOk = true;
  std::multimap<double, std::unique_ptr<FailingCriteria> > distanceToLoadFailingCriteriaMap;
  for (const auto& load : loads_) {
    if (!isEligibleForVoltageLevels(voltageLevels, *load)) continue;
    const double p = load->getStateVarP() * SNREF;
    if (isSumType) {
      sum += p;
      atLeastOneEligibleLoadWasFound = true;
      continue;
    }
    if (params_->hasPMax() && p > params_->getPMax()) {
      std::unique_ptr<FailingCriteria> loadFailingCriteria = DYN::make_unique<LoadFailingCriteria>(Bound::MAX,
                                                                                                    load->getID(),
                                                                                                    p,
                                                                                                    params_->getPMax(),
                                                                                                    params_->getId());
      distanceToLoadFailingCriteriaMap.insert(std::make_pair(loadFailingCriteria->getDistance(), std::move(loadFailingCriteria)));
      isCriteriaOk = false;
    }
    if (params_->hasPMin() && p < params_->getPMin()) {
      std::unique_ptr<FailingCriteria> loadFailingCriteria = DYN::make_unique<LoadFailingCriteria>(Bound::MIN,
                                                                                                    load->getID(),
                                                                                                    p,
                                                                                                    params_->getPMin(),
                                                                                                    params_->getId());
      distanceToLoadFailingCriteriaMap.insert(std::make_pair(loadFailingCriteria->getDistance(), std::move(loadFailingCriteria)));
      isCriteriaOk = false;
    }
  }

  if (!isSumType && !isCriteriaOk) {
    printAllFailingCriteriaIntoLog(distanceToLoadFailingCriteriaMap, timeline, t);
  } else if (isSumType && atLeastOneEligibleLoadWasFound) {
    const bool isAboveMax = params_->hasPMax() && sum > params_->getPMax();
    const bool isBelowMin = params_->hasPMin() && sum < params_->getPMin();
    // the sorted list of loads is only needed to print the failing criteria
    std::vector<std::pair<double, LoadInterface*> > sortedLoads;
    if (isAboveMax || isBelowMin)
      sortedLoads = getSortedEligibleLoads();
    if (isAboveMax) {
      for (auto loadIt = sortedLoads.crbegin(); loadIt != sortedLoads.crend(); ++loadIt) {
        const double activePowerSN = loadIt->first;
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
      isCriteriaOk = false;
    }
    if (isBelowMin) {
      for (auto loadIt = sortedLoads.cbegin(); loadIt != sortedLoads.cend(); ++loadIt) {
        const double activePowerSN = loadIt->first;
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
      isCriteriaOk = false;
    }
  }

  return isCriteriaOk;
}

std::vector<std::pair<double, LoadInterface*> >
LoadCriteria::getSortedEligibleLoads() const {
  const std::vector<criteria::CriteriaParamsVoltageLevel>& voltageLevels = params_->getVoltageLevels();
  std::vector<std::pair<double, LoadInterface*> > sortedLoads;
  sortedLoads.reserve(loads_.size());
  for (const auto& load : loads_) {
    if (isEligibleForVoltageLevels(voltageLevels, *load))
      sortedLoads.emplace_back(load->getStateVarP() * SNREF, load.get());
  }
  sortByActivePower(sortedLoads);
  return sortedLoads;
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
  const std::shared_ptr<BusInterface> bus = load->getBusInterface();
  if (bus && doubleIsZero(bus->getV0())) return;
  if (!matchesNominalVoltage(params_->getVoltageLevels(), bus)) return;
  // a load listed several times is only checked once
  if (addedLoads_.insert(load.get()).second)
    loads_.push_back(load);
}

void
LoadCriteria::getComponentsToUpdate(std::vector<std::shared_ptr<ComponentInterface> >& components) const {
  for (const auto& load : loads_) {
    components.push_back(load);
    const std::shared_ptr<BusInterface> bus = load->getBusInterface();
    if (bus)
      components.push_back(bus);
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
  const bool isSumType = params_->getType() == criteria::CriteriaParams::SUM;
  const std::vector<criteria::CriteriaParamsVoltageLevel>& voltageLevels = params_->getVoltageLevels();
  double sum = 0.;
  bool atLeastOneEligibleGeneratorWasFound = false;
  bool isCriteriaOk = true;
  std::multimap<double, std::unique_ptr<FailingCriteria> > distanceToGeneratorFailingCriteriaMap;
  for (const auto& generator : generators_) {
    if (!isEligibleForVoltageLevels(voltageLevels, *generator)) continue;
    const double p = -generator->getStateVarP() * SNREF;
    if (isSumType) {
      sum += p;
      atLeastOneEligibleGeneratorWasFound = true;
      continue;
    }
    if (params_->hasPMax() && p > params_->getPMax()) {
      std::unique_ptr<FailingCriteria> generatorFailingCriteria = DYN::make_unique<LoadCriteria::LoadFailingCriteria>(Bound::MAX,
                                                                                                                      generator->getID(),
                                                                                                                      p,
                                                                                                                      params_->getPMax(),
                                                                                                                      params_->getId());
      distanceToGeneratorFailingCriteriaMap.insert(std::make_pair(generatorFailingCriteria->getDistance(), std::move(generatorFailingCriteria)));
      isCriteriaOk = false;
    }
    if (params_->hasPMin() && p < params_->getPMin()) {
      std::unique_ptr<FailingCriteria> generatorFailingCriteria = DYN::make_unique<LoadCriteria::LoadFailingCriteria>(Bound::MIN,
                                                                                                                      generator->getID(),
                                                                                                                      p,
                                                                                                                      params_->getPMin(),
                                                                                                                      params_->getId());
      distanceToGeneratorFailingCriteriaMap.insert(std::make_pair(generatorFailingCriteria->getDistance(), std::move(generatorFailingCriteria)));
      isCriteriaOk = false;
    }
  }

  if (!isSumType && !isCriteriaOk) {
    printAllFailingCriteriaIntoLog(distanceToGeneratorFailingCriteriaMap, timeline, t);
  } else if (isSumType && atLeastOneEligibleGeneratorWasFound) {
    const bool isAboveMax = params_->hasPMax() && sum > params_->getPMax();
    const bool isBelowMin = params_->hasPMin() && sum < params_->getPMin();
    // the sorted list of generators is only needed to print the failing criteria
    std::vector<std::pair<double, GeneratorInterface*> > sortedGenerators;
    if (isAboveMax || isBelowMin)
      sortedGenerators = getSortedEligibleGenerators();
    if (isAboveMax) {
      for (auto generatorIt = sortedGenerators.crbegin(); generatorIt != sortedGenerators.crend(); ++generatorIt) {
        const double activePowerSN = generatorIt->first;
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
      isCriteriaOk = false;
    }
    if (isBelowMin) {
      for (auto generatorIt = sortedGenerators.cbegin(); generatorIt != sortedGenerators.cend(); ++generatorIt) {
        const double activePowerSN = generatorIt->first;
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
      isCriteriaOk = false;
    }
  }

  return isCriteriaOk;
}

std::vector<std::pair<double, GeneratorInterface*> >
GeneratorCriteria::getSortedEligibleGenerators() const {
  const std::vector<criteria::CriteriaParamsVoltageLevel>& voltageLevels = params_->getVoltageLevels();
  std::vector<std::pair<double, GeneratorInterface*> > sortedGenerators;
  sortedGenerators.reserve(generators_.size());
  for (const auto& generator : generators_) {
    if (isEligibleForVoltageLevels(voltageLevels, *generator))
      sortedGenerators.emplace_back(-generator->getStateVarP() * SNREF, generator.get());
  }
  sortByActivePower(sortedGenerators);
  return sortedGenerators;
}

bool
GeneratorCriteria::criteriaEligibleForGenerator(const std::shared_ptr<criteria::CriteriaParams>& params) {
  if (!params->hasPMin() && !params->hasPMax())
    return false;
  return true;
}

void
GeneratorCriteria::addGenerator(const std::shared_ptr<GeneratorInterface>& generator) {
  const std::shared_ptr<BusInterface> bus = generator->getBusInterface();
  if (bus && doubleIsZero(bus->getV0())) return;
  if (!matchesNominalVoltage(params_->getVoltageLevels(), bus)) return;
  // a generator listed several times is only checked once
  if (addedGenerators_.insert(generator.get()).second)
    generators_.push_back(generator);
}

void
GeneratorCriteria::getComponentsToUpdate(std::vector<std::shared_ptr<ComponentInterface> >& components) const {
  for (const auto& generator : generators_) {
    components.push_back(generator);
    const std::shared_ptr<BusInterface> bus = generator->getBusInterface();
    if (bus)
      components.push_back(bus);
  }
}

}  // namespace DYN
