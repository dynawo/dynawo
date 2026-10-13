//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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

/**
 * @file  DYNModelCurrentLimits.cpp
 *
 * @brief
 *
 */
#include <limits>
#include <iostream>
#include "DYNModelCurrentLimits.h"

#include <DYNTimer.h>

#include "DYNModelNetwork.h"
#include "DYNMacrosMessage.h"
#include "DYNModelConstants.h"

using std::string;

namespace DYN {

ModelCurrentLimits::ModelCurrentLimits() :
nbTemporaryLimits_(0),
lastCurrentValue_(0.),
factorPuToA_(1.) {
  side_ = SIDE_UNDEFINED;
  maxTimeOperation_ = VALDEF;
}

int
ModelCurrentLimits::sizeG() const {
  return static_cast<int>(2 * limits_.size());
}

int
ModelCurrentLimits::sizeZ() const {
  return 0;
}

void
ModelCurrentLimits::setSide(const side_t side) {
  side_ = side;
}

void
ModelCurrentLimits::setFactorPuToA(const double factorPuToA) {
  factorPuToA_ = factorPuToA;
}

void
ModelCurrentLimits::setMaxTimeOperation(const double maxTimeOperation) {
  maxTimeOperation_ = maxTimeOperation;
}

void
ModelCurrentLimits::addLimit(const std::string&  name, const double limit, const int acceptableDuration, bool fictitious) {
  if (!std::isnan(limit)) {
    limits_.push_back(limit);
    names_.push_back(name);
    activated_.push_back(false);
    tLimitReached_.push_back(std::numeric_limits<double>::quiet_NaN());
    acceptableDurations_.push_back(acceptableDuration);
    fictitious_.push_back(fictitious);
    if (acceptableDuration == std::numeric_limits<int>::max()) {
      openingAuthorized_.push_back(false);
    } else {
      openingAuthorized_.push_back(true);
      nbTemporaryLimits_++;
    }
  }
}

void
ModelCurrentLimits::evalG(const double t, const double current, const double desactivate, state_g* g) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelNetwork::ModelCurrentLimits::evalG");
#endif
  lastCurrentValue_ = current;
  maxCurrentValue_ = std::max(maxCurrentValue_, current);
  for (unsigned int i = 0; i < limits_.size(); ++i) {
    g[0 + 2 * i] = (current > limits_[i] && !(desactivate > 0)) ? ROOT_UP : ROOT_DOWN;  // I > Imax
    if (openingAuthorized_[i])
        g[1 + 2 * i] = (activated_[i] && t - tLimitReached_[i] > acceptableDurations_[i] && !(desactivate > 0)
                        && acceptableDurations_[i] < maxTimeOperation_) ? ROOT_UP : ROOT_DOWN;   // t -tLim > tempo
  }
}

#define CSTR_TYPE(value) {kind = ConstraintData::value; key = KeyConstraint_t::value;}
static const bool CSTR_BEGIN = true;
static const bool CSTR_END = false;
static const bool OPENING = true;

void
ModelCurrentLimits::logConstraint(ModelNetwork * network, const string & componentName, const string & modelType, int i, bool begin, bool opening) const {
  using constraints::ConstraintData;

  if (!network->hasConstraints())
    return;

  ConstraintData::kind_t kind; KeyConstraint_t::value key;
  if      (opening)                 CSTR_TYPE(OverloadOpen)
  else if (openingAuthorized_[i])   CSTR_TYPE(OverloadUp)
  else if (fictitious_[i])          CSTR_TYPE(FictLim)
  else                              CSTR_TYPE(PATL)

  ConstraintData data(kind, limits_[i]*factorPuToA_, lastCurrentValue_*factorPuToA_, this, names_[i], side_);
  if (openingAuthorized_[i])
    data.acceptableDuration = acceptableDurations_[i];

  // operator "," is overloaded on Message and concatenates
  Message msg(Message::CONSTRAINT_KEY, KeyConstraint_t::names(key));
  if      (openingAuthorized_[i])   msg, acceptableDurations_[i];
  else if (fictitious_[i])          msg, limits_[i]*factorPuToA_;
  msg, side_;

  network->addConstraint(componentName, begin, msg, modelType, data);
}

#undef CSTR_TYPE

ModelCurrentLimits::state_t
ModelCurrentLimits::evalZ(const string& componentName, double t, const state_g* g, double desactivate, const string& modelType, ModelNetwork* network) {
  state_t state = COMPONENT_CLOSE;

  for (unsigned int i = 0; i < limits_.size(); ++i) {
    if (!(desactivate > 0)) {
      if (g[0 + 2 * i] == ROOT_UP) {
        logConstraint(network, componentName, modelType, i, CSTR_BEGIN);
        if (!activated_[i])
          tLimitReached_[i] = t;
        activated_[i] = true;
      }

      if (g[0 + 2 * i] == ROOT_DOWN && activated_[i]) {
        logConstraint(network, componentName, modelType, i, CSTR_END);
        activated_[i] = false;
        tLimitReached_[i] = std::numeric_limits<double>::quiet_NaN();
      }

      if (openingAuthorized_[i] && g[1 + 2 * i] == ROOT_UP) {  // Warning: openingAuthorized_ = false => no associated g
        state = COMPONENT_OPEN;
        if (!DYN::doubleIsZero(lastCurrentValue_))
          logConstraint(network, componentName, modelType, i, CSTR_BEGIN, OPENING);
        DYNAddTimelineEvent(network, componentName, OverloadOpen, acceptableDurations_[i]);
      }
    }
  }

  return state;
}

void
ModelCurrentLimits::getFinalValues(ConstraintData::kind_t kind,
                                   int /*varIndex*/,
                                   double & valueFinal,
                                   boost::optional<double> & /*valueMin*/,
                                   boost::optional<double> & valueMax) const {
  switch (kind) {
    case ConstraintData::OverloadOpen:
    case ConstraintData::OverloadUp:
    case ConstraintData::FictLim:
    case ConstraintData::PATL:
      break;
    case ConstraintData::UInfUmin:
    case ConstraintData::USupUmax:
    case ConstraintData::Undefined:
    default:
      throw DYNError(Error::API, UnhandledConstraintKind, kind, "CurrentLimits");
  }
  valueFinal = lastCurrentValue_*factorPuToA_;
  valueMax = maxCurrentValue_*factorPuToA_;
}

}  // namespace DYN
