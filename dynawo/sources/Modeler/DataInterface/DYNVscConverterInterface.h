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
#include "DYNReactiveCurvePointsInterface.h"

namespace DYN {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

  /**
 * @brief VSC converter interface
 */
class VscConverterInterface : public ConverterInterface, public ReactiveCurvePointsInterface {
 public:
  /**
   * @brief Constructor
   * @param hasInitialConditions @b true if component has initial conditions set, @b false else
   */
  explicit VscConverterInterface(bool hasInitialConditions = true) : ConverterInterface(hasInitialConditions) {}

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

  /**
   * @brief Getter for the maximum reactive power of the converter
   * @return The maximum reactive power of the converter in Mvar (following iidm convention)
   */
  virtual double getQMax() = 0;

  /**
   * @brief Getter for the mininmum reactive power of the converter
   * @return The mininmum reactive power of the converter in Mvar (following iidm convention)
   */
  virtual double getQMin() = 0;

  /**
   * @copydoc ReactiveCurvePointsInterface::getReactiveCurvesPoints() const
   */
  virtual std::vector<ReactiveCurvePoint> getReactiveCurvesPoints() const = 0;
};  ///< Interface class for Vsc Converter

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNVSCCONVERTERINTERFACE_H_
