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
 * @file  DYNBusBarSectionInterface.h
 *
 * @brief Bus bar section data interface : interface file
 *
 **/

#ifndef MODELER_DATAINTERFACE_DYNBUSBARSECTIONINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNBUSBARSECTIONINTERFACE_H_

#include <string>

namespace DYN {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class BusBarSectionInterface
 * @brief bus bar section data interface
 */
class BusBarSectionInterface {
 public:
  /**
   * @brief destructor
   */
  virtual ~BusBarSectionInterface() = default;

  /**
   * @brief getter for the id of the bus bar section
   * @return the id of the bus bar section
   */
  virtual std::string id() const = 0;

  /**
   * @brief set the voltage magnitude of the bus bar section
   * @param v voltage magnitude
   */
  virtual void setV(const double& v) = 0;

  /**
   * @brief set the voltage angle of the bus bar section
   * @param angle voltage angle
   */
  virtual void setAngle(const double& angle) = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNBUSBARSECTIONINTERFACE_H_
