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
 * @file  DYNCurrentLimitInterface.h
 *
 * @brief Current limit interface : interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNCURRENTLIMITINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNCURRENTLIMITINTERFACE_H_

namespace DYN {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @brief Current limit interface
 */
class CurrentLimitInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~CurrentLimitInterface() = default;

  /**
   * @brief Getter for current limit value
   * @return The current limit value in kA
   */
  virtual double getLimit() const = 0;

  /**
   * @brief Getter for the acceptable duration of the current limit
   * @return The acceptable duration in s
   */
  virtual int getAcceptableDuration() const = 0;

  /**
   * @brief Getter for the fictitious status of the current limit
   * @return whether the current limit is fictitious
   */
  virtual bool isFictitious() const = 0;
};  ///< class for current limit interface

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNCURRENTLIMITINTERFACE_H_
