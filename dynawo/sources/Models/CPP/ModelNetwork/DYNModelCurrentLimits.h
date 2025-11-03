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
 * @file  DYNModelCurrentLimits.h
 *
 * @brief
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELCURRENTLIMITS_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELCURRENTLIMITS_H_

#include <vector>
#include "CSTRConstraint.h"
#include "DYNEnumUtils.h"

namespace DYN {
class ModelNetwork;

/**
 * @brief  Generic Current Limits model
 */
class ModelCurrentLimits {  ///< Generic Current Limits model
 public:
  /**
   * @brief structure for side
   */
  typedef enum {
    SIDE_UNDEFINED = 0,
    SIDE_1 = 1,
    SIDE_2 = 2,
    SIDE_3 = 3
  } side_t;

  /**
   * @brief structure for state
   */
  typedef enum {
    COMPONENT_OPEN = 0,
    COMPONENT_CLOSE = 1
  } state_t;

  /**
   * @brief default constructor
   */
  ModelCurrentLimits();

  /**
   * @brief compute the local root function
   *
   * @param t current time
   * @param current current inside the component
   * @param desactivate @b true if the current limits is off
   * @param g value of the root function
   */
  void evalG(double t, double current, double desactivate, state_g* g);

  /**
   * @brief compute the state of the current limits
   *
   * @param componentName name of the component for which the current limits is
   * @param t current time
   * @param g buffer of the roots
   * @param desactivate @b true if the current limits is off
   * @param modelType type of the model
   * @param network model of network
   * @param deactivateZeroCrossingFunctions option to deactivate zero crossing functions
   *
   * @return the state of the current limits
   */
  state_t evalZ(const std::string& componentName, double t, const state_g* g, double desactivate,
    const std::string& modelType, ModelNetwork* network, bool deactivateZeroCrossingFunctions);  // compute the local Z function

  /**
   * @brief add a new current limit (pu base UNom, base SNRef)
   * @param limit new current limit
   * @param acceptableDuration acceptable duration
   * @param fictitious whether the limit is fictitious
   */
  void addLimit(double limit, int acceptableDuration, bool fictitious);

  /**
   * @brief set side
   * @param side side
   */
  void setSide(side_t side);

  /**
   * @brief set factor to convert from pu to Amperes
   * @param factorPuToA factor
   */
  void setFactorPuToA(double factorPuToA);

  /**
   * @brief set the max time operation
   * @param maxTimeOperation max time operation
   */
  void setMaxTimeOperation(double maxTimeOperation);

  /**
   * @brief get G size
   * @return size of G
   */
  int sizeG() const;
  /**
   * @brief get size of Z
   * @return size of Z
   */
  static int sizeZ();

 private:
  /**
   * @brief build constraint data details for a violation of limit i
   * @param kind of limit violation
   * @param i limit index
   * @return details for the constraint
   */
  constraints::ConstraintData constraintData(const constraints::ConstraintData::kind_t& kind, unsigned int i);

  int nbTemporaryLimits_;  ///< number of temporary limits (limits with a time duration)
  side_t side_;  ///< side

  double maxTimeOperation_;  ///< maximum time operation, if limits duration is over this time, the current limit does not operate
  double lastCurrentValue_;  ///< last value of the current, kept to be reported in constraints
  double factorPuToA_;  ///< factor to convert pu values to Amperes

  std::vector<double> limits_;  ///< vector of current limits (pu base UNom, base SNRef)
  std::vector<double> acceptableDurations_;  ///< vector of limits duration (unit : s)
  std::vector<bool> openingAuthorized_;  ///< whether opening is authorized
  std::vector<bool> fictitious_;  ///< whether the limit is fictitious
  std::vector<double> tLimitReached_;  ///< last time the limit was reached
  std::vector<bool> activated_;  ///< state of activation
};
}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELCURRENTLIMITS_H_
