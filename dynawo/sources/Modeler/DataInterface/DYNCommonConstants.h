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
 * @file  DYNCommonConstants.h
 *
 * @brief define constants for dataInterface
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNCOMMONCONSTANTS_H_
#define MODELER_DATAINTERFACE_DYNCOMMONCONSTANTS_H_

namespace DYN {
static const double uMinPu = 0.8;  ///< factor used to calculate the value of Umin = k * UNom
static const double uMaxPu = 1.2;  ///< factor used to calculate the value of Umax = k * uNom
static const double defaultAngle0 = 0.;  ///< default value of the voltage angle, when not defined
}  // namespace DYN


#endif  // MODELER_DATAINTERFACE_DYNCOMMONCONSTANTS_H_
