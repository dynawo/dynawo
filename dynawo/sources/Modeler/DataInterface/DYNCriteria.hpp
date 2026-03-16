//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
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
 * @file  DYNCriteria.hpp
 *
 * @brief Implementation of methods of template class
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNCRITERIA_HPP_
#define MODELER_DATAINTERFACE_DYNCRITERIA_HPP_

#include "DYNTrace.h"
#include "DYNCommon.h"
#include "CRTCriteriaParams.h"
#include "DYNLineInterface.h"
#include "DYNTwoWTransformerInterface.h"
#include <boost/shared_ptr.hpp>
#include "TLTimeline.h"
#include "make_unique.hpp"

#include <map>
#include <unordered_set>

namespace DYN {

template<typename T>
QuadripoleCriteria<T>::QuadripoleCriteria(const std::shared_ptr<criteria::CriteriaParams>& params) :
            Criteria(params) {}

template<typename T> bool
QuadripoleCriteria<T>::checkCriteria(double t, bool finalStep, const boost::shared_ptr<timeline::Timeline>& timeline) {
  failingCriteria_.clear();
  assert(params_->getType() != criteria::CriteriaParams::SUM);
  if (!finalStep && params_->getScope() == criteria::CriteriaParams::FINAL)
    return true;
  std::multimap<double, std::unique_ptr<FailingCriteria> > distanceToQuadripoleFailingCriteriaMap;
  for (const auto& quadripole : quadripoles_) {
    double i1 = quadripole->getStateVarI1();
    double i2 = quadripole->getStateVarI2();
    if (params_->hasI1Max() && i1 > params_->getI1Max()) {
      std::unique_ptr<FailingCriteria> quadripoleFailingCriteria = DYN::make_unique<QuadripoleFailingCriteria>(Side::ONE,
                                                                                                  quadripole->getID(),
                                                                                                  i1,
                                                                                                  params_->getI1Max(),
                                                                                                  params_->getId());
      distanceToQuadripoleFailingCriteriaMap.insert(std::make_pair(quadripoleFailingCriteria->getDistance(), std::move(quadripoleFailingCriteria)));
    }
    if (params_->hasI2Max() && i2 > params_->getI2Max()) {
      std::unique_ptr<FailingCriteria> quadripoleFailingCriteria = DYN::make_unique<QuadripoleFailingCriteria>(Side::TWO,
                                                                                                  quadripole->getID(),
                                                                                                  i2,
                                                                                                  params_->getI2Max(),
                                                                                                  params_->getId());
      distanceToQuadripoleFailingCriteriaMap.insert(std::make_pair(quadripoleFailingCriteria->getDistance(), std::move(quadripoleFailingCriteria)));
    }
  }
  if (!distanceToQuadripoleFailingCriteriaMap.empty()) {
    printAllFailingCriteriaIntoLog(distanceToQuadripoleFailingCriteriaMap, timeline, t);
  }
  return distanceToQuadripoleFailingCriteriaMap.empty();
}

template<typename T> bool
QuadripoleCriteria<T>::criteriaEligibleForQuadripole(const std::shared_ptr<criteria::CriteriaParams>& params) {
  if (params->getType() == criteria::CriteriaParams::SUM) {
    Trace::warn() << DYNLog(SumQuadripoleCriteriaIgnored) << Trace::endline;
    return false;
  }
  if (params->hasVoltageLevels())
    return false;
  if (!params->hasI1Max() && !params->hasI2Max())
    return false;
  if (params->hasPMax())
    Trace::warn() << DYNLog(PowerQuadripoleCriteriaIgnored) << Trace::endline;
  if (params->hasPMin())
    Trace::warn() << DYNLog(PowerQuadripoleCriteriaIgnored) << Trace::endline;
  return true;
}

template<typename T> void
QuadripoleCriteria<T>::addQuadripole(const std::shared_ptr<T>& quadripole) {
  quadripoles_.push_back(quadripole);
}

template<typename T>
QuadripoleCriteria<T>::QuadripoleFailingCriteria::QuadripoleFailingCriteria(Side side,
                                                    std::string quadripoleId,
                                                    double i,
                                                    double iBound,
                                                    const std::string& criteriaId) :
  FailingCriteria(Bound::MAX, quadripoleId, criteriaId),
  side_(side),
  i_(i),
  iBound_(iBound) {}

template<typename T> void
QuadripoleCriteria<T>::QuadripoleFailingCriteria::printOneFailingCriteriaIntoLog() const {
  switch (side_) {
    case DYN::QuadripoleCriteria<T>::Side::ONE: {
      Trace::debug() << DYNLog(QuadripoleAboveCurrent, nodeId_, "1", i_, iBound_, criteriaId_) << Trace::endline;
    }
    break;
    case DYN::QuadripoleCriteria<T>::Side::TWO: {
      Trace::debug() << DYNLog(QuadripoleAboveCurrent, nodeId_, "2", i_, iBound_, criteriaId_) << Trace::endline;
    }
    break;
  }
}

template<typename T> void
QuadripoleCriteria<T>::QuadripoleFailingCriteria::printOneFailingCriteriaIntoTimeline(const boost::shared_ptr<timeline::Timeline>& timeline,
                                                                      std::vector<std::pair<double, std::string> >& failingCriteria,
                                                                      double currentTime) const {
  const std::string name = "Simulation";
  switch (side_) {
    case DYN::QuadripoleCriteria<T>::Side::ONE: {
      if (timeline != nullptr) {
        MessageTimeline messageTimeline = DYNTimeline(QuadripoleAboveCurrent, nodeId_, "1", i_, iBound_, criteriaId_);
        timeline->addEvent(currentTime, name, messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
      }
      Message failingCriteriaMessage = DYNLog(QuadripoleAboveCurrent, nodeId_, "1", i_, iBound_, criteriaId_);
      failingCriteria.push_back(std::make_pair(currentTime, failingCriteriaMessage.str()));
    }
    break;
    case DYN::QuadripoleCriteria<T>::Side::TWO: {
      if (timeline != nullptr) {
        MessageTimeline messageTimeline = DYNTimeline(QuadripoleAboveCurrent, nodeId_, "2", i_, iBound_, criteriaId_);
        timeline->addEvent(currentTime, name, messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
      }
      Message failingCriteriaMessage = DYNLog(QuadripoleAboveCurrent, nodeId_, "2", i_, iBound_, criteriaId_);
      failingCriteria.push_back(std::make_pair(currentTime, failingCriteriaMessage.str()));
    }
    break;
  }
}

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNCRITERIA_HPP_
