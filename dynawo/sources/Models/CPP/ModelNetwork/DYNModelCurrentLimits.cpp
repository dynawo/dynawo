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
ModelCurrentLimits::sizeZ() {
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
ModelCurrentLimits::addLimit(const double limit, const int acceptableDuration, bool fictitious) {
  if (!std::isnan(limit)) {
    limits_.push_back(limit);
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
  for (unsigned int i = 0; i < limits_.size(); ++i) {
    g[0 + 2 * i] = (current > limits_[i] && !(desactivate > 0)) ? ROOT_UP : ROOT_DOWN;  // I > Imax
    if (openingAuthorized_[i])
        g[1 + 2 * i] = (activated_[i] && t - tLimitReached_[i] > acceptableDurations_[i] && !(desactivate > 0)
                        && acceptableDurations_[i] < maxTimeOperation_) ? ROOT_UP : ROOT_DOWN;   // t -tLim > tempo
  }
}

constraints::ConstraintData
ModelCurrentLimits::constraintData(const constraints::ConstraintData::kind_t& kind, const unsigned int i) {
  // The value for the limit and the current in SI units (Amperes)
  const bool isTemporary = openingAuthorized_[i];
  if (isTemporary) {
    return constraints::ConstraintData(kind, limits_[i]*factorPuToA_, lastCurrentValue_*factorPuToA_, side_, acceptableDurations_[i]);
  } else {
    return constraints::ConstraintData(kind, limits_[i]*factorPuToA_, lastCurrentValue_*factorPuToA_, side_);
  }
}

ModelCurrentLimits::state_t
ModelCurrentLimits::evalZ(const string& componentName, const double t, const state_g* g, const double desactivate,
    const string& modelType, ModelNetwork* network, bool deactivateZeroCrossingFunctions) {
  state_t state = COMPONENT_CLOSE;
  using constraints::ConstraintData;
  if (deactivateZeroCrossingFunctions)
    return state;

  for (unsigned int i = 0; i < limits_.size(); ++i) {
    if (!(desactivate > 0)) {
      if (g[0 + 2 * i] == ROOT_UP) {
        if (openingAuthorized_[i]) {  // Delay is specified => temporary limit
          DYNAddConstraintWithData(network, componentName, true, modelType,
            constraintData(ConstraintData::OverloadUp, i),
            OverloadUp, acceptableDurations_[i], side_);
        } else {
          if (fictitious_[i]) {
            // Fictitious limit
            DYNAddConstraintWithData(network, componentName, true, modelType,
                constraintData(ConstraintData::FictLim, i),
                FictLim, limits_[i]*factorPuToA_, side_);
          } else {
            // Permanent limit
            DYNAddConstraintWithData(network, componentName, true, modelType,
                constraintData(ConstraintData::PATL, i),
                PATL, side_);
          }
        }
        if (!activated_[i])
          tLimitReached_[i] = t;
        activated_[i] = true;
      }

      if (g[0 + 2 * i] == ROOT_DOWN && activated_[i]) {
        if (openingAuthorized_[i]) {  // Delay is specified => temporary limit
          DYNAddConstraintWithData(network, componentName, false, modelType,
              constraintData(ConstraintData::OverloadUp, i),
              OverloadUp, acceptableDurations_[i], side_);
        } else {
          if (fictitious_[i]) {
            // Fictitious limit
            DYNAddConstraintWithData(network, componentName, false, modelType,
                constraintData(ConstraintData::FictLim, i),
                FictLim, limits_[i]*factorPuToA_, side_);
          } else {
              // Permanent limit
              DYNAddConstraintWithData(network, componentName, false, modelType,
                  constraintData(ConstraintData::PATL, i),
                  PATL, side_);
            }
        }
        activated_[i] = false;
        tLimitReached_[i] = std::numeric_limits<double>::quiet_NaN();
      }

      if (openingAuthorized_[i] && g[1 + 2 * i] == ROOT_UP) {  // Warning: openingAuthorized_ = false => no associated g
        state = COMPONENT_OPEN;
        if (!DYN::doubleIsZero(lastCurrentValue_)) {
          DYNAddConstraintWithData(network, componentName, true, modelType,
              constraintData(ConstraintData::OverloadOpen, i),
              OverloadOpen, acceptableDurations_[i], side_);
        }
        DYNAddTimelineEvent(network, componentName, OverloadOpen, acceptableDurations_[i]);
      }
    }
  }

  return state;
}

}  // namespace DYN
