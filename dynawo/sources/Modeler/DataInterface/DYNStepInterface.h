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
 * @file  DYNStepInterface.h
 *
 * @brief Step data interface : interface file
 *
 * A step could be a phase tap changer step or a ratio tap changer step
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNSTEPINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNSTEPINTERFACE_H_

namespace DYN {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * class StepInterface
 */
class StepInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~StepInterface() = default;

  /**
   * @brief Getter for the resistance of the step
   * @return The resistance of the step in ohms
   */
  virtual double getR() const = 0;

  /**
   * @brief Getter for the reactance of the step
   * @return The reactance of the step in ohms
   */
  virtual double getX() const = 0;

  /**
   * @brief Getter for the susceptance of the step
   * @return The susceptance of the step in siemens
   */
  virtual double getB() const = 0;

  /**
   * @brief Getter for the conductance of the step
   * @return The conductance of the step in siemens
   */
  virtual double getG() const = 0;

  /**
   * @brief Getter for the ratio of the step
   * @return The ratio of the step in pu
   */
  virtual double getRho() const = 0;

  /**
   * @brief Getter for the phase shift of the step
   * @return The phase shift of the step in degree
   */
  virtual double getAlpha() const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNSTEPINTERFACE_H_
