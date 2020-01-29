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

//======================================================================
/**
 * @file  DYNVscConverterInterface.h
 *
 * @brief voltage source converter interface : header file
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_DYNVSCCONVERTERINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNVSCCONVERTERINTERFACE_H_

#include "DYNConverterInterface.h"

namespace DYN {

class VscConverterInterface : public ConverterInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~VscConverterInterface() { }

  /**
   * @brief Getter for the boolean indicating if the converter regulates the voltage (otherwise it regulates the reactive power)
   * @return @b true if the vsc converter controls the voltage, @b false if it controls the reactive power
   */
  virtual bool getVoltageRegulatorOn() const = 0;

  /**
   * @brief Getter for the reactive power set-point
   * @return The reactive power set-point in Mvar
   */
  virtual double getReactivePowerSetpoint() const = 0;

  /**
   * @brief Getter for the voltage set-point
   * @return The voltage set-point in kV
   */
  virtual double getVoltageSetpoint() const = 0;
};  ///< Interface class for Vsc Converter

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNVSCCONVERTERINTERFACE_H_
