//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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

/**
 * @file  DYNModelConstants.h
 *
 * @brief define constants for models
 *
 */
#ifndef MODELER_COMMON_DYNMODELCONSTANTS_H_
#define MODELER_COMMON_DYNMODELCONSTANTS_H_

#include <cmath>

namespace DYN {
static const double FNOM = 50.;  ///< AC-system frequency
static const double OMEGA_NOM = FNOM * 2 * M_PI;  ///< AC-system angular frequency
static const double SNREF = 100.;  ///< per unit base Sn
static const double VALDEF = 999999;  ///< VALDEF a constant
static const double DEG_TO_RAD = M_PI / 180.0;  ///< degree to radius conversion constant
static const double RAD_TO_DEG = 180.0 / M_PI;  ///< radius to degree conversion constant
static const int VHV_THRESHOLD = 130;  ///< lower voltage threshold (in kV) for the very high voltage grid
static const int HV_THRESHOLD = 50;  ///< lower voltage threshold (in kV) for the high voltage grid
static const char UPDATABLE_INPUT_VALUE_NAME[] = "input_value";  ///< updatable model parameter name
static const char UPDATABLE_INPUT_MULTIPLIER_NAME[] = "input_multiplier";  ///< updatable model multiplier name
static const char UPDATABLE_VARIABLE_NAME[] = "input_variable";  ///< updatable model variable name

/**
 * @brief state type : state of a network component
 */
typedef enum {
  // Enumeration in Modelica always begins from 1.
  // To be consistent with Modelica constant in Constants.mo, OPEN=1 instead of 0
  UNDEFINED_STATE = 0,  ///< component status is undefined
  OPEN = 1,  ///< component is disconnected
  CLOSED = 2,  ///< component is connected
  CLOSED_1 = 3,  ///< component is connected at side 1
  CLOSED_2 = 4,  ///< component is connected at side 2
  CLOSED_3 = 5  ///< component is connected at side 3
} State;

/**
 * @brief checks whether a component connection state means side 1 is connected, regardless of other side(s)
 * @param state the state to check
 * @returns true if this state entails closed on side 1, false otherwise
 */
inline bool isClosedSide1(State state) {
  return (state == CLOSED) || (state == CLOSED_1);
}

/**
 * @brief checks whether a component connection state means side 2 is connected, regardless of other side(s)
 * @param state the state to check
 * @returns true if this state entails closed on side 2, false otherwise
 */
inline bool isClosedSide2(State state) {
  return (state == CLOSED) || (state == CLOSED_2);
}

}  // namespace DYN

#endif  // MODELER_COMMON_DYNMODELCONSTANTS_H_
