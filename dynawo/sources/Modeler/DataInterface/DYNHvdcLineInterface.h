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
 * @file  DYNHvdcLineInterface.h
 *
 * @brief Hvdc Line data interface : interface file
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_DYNHVDCLINEINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNHVDCLINEINTERFACE_H_

#include "DYNComponentInterface.hpp"
#include <boost/optional.hpp>

namespace DYN {
class BusInterface;
class CurrentLimitInterface;
class VoltageLevelInterface;
class ConverterInterface;

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * class HvdcLineInterface
 */
class HvdcLineInterface : public ComponentInterface {
 public:
  /**
   * @brief Definition of the hvdc converters mode
   */
  typedef enum {
    RECTIFIER_INVERTER = 1,
    INVERTER_RECTIFIER = 2
  } ConverterMode_t;

  /**
   * @brief Destructor
   */
  virtual ~HvdcLineInterface() = default;

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  virtual void exportStateVariablesUnitComponent() = 0;

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  virtual void importStaticParameters() = 0;

  /**
   * @brief Getter for the hvdc line id
   * @return The id of the hvdc line
   */
  virtual const std::string& getID() const = 0;

  /**
   * @brief Getter for the dc resistance of the hvdc line
   * @return The dc resistance of the hvdc line in ohm
   */
  virtual double getResistanceDC() const = 0;

  /**
   * @brief Getter for the nominal voltage of the hvdc line
   * @return The nominal voltage of the hvdc line in kV
   */
  virtual double getVNom() const = 0;

  /**
   * @brief Getter for the active power set-point of the hvdc line
   * @return The active power set-point of the hvdc line in MW
   */
  virtual double getActivePowerSetpoint() const = 0;

  /**
   * @brief Getter for the maximum power of the hvdc line
   * @return The maximum power of the hvdc line in MW
   */
  virtual double getPmax() const = 0;

  /**
   * @brief Getter for the converters mode
   * @return The converters mode
   */
  virtual ConverterMode_t getConverterMode() const = 0;

  /**
   * @brief Getter for converter 1 id
   * @return The converter 1 id
   */
  virtual std::string getIdConverter1() const = 0;

  /**
   * @brief Getter for converter 2 id
   * @return The converter 2 id
   */
  virtual std::string getIdConverter2() const = 0;

  /**
   * @brief Getter for converter 1
   * @return converter 1
   */
  virtual const std::shared_ptr<ConverterInterface>& getConverter1() const = 0;

  /**
   * @brief Getter for converter 2
   * @return converter 2
   */
  virtual const std::shared_ptr<ConverterInterface>& getConverter2() const = 0;

  /**
   * @brief Get droop
   * @returns the droop value or nullopt if the extension containing the data is not defined
   */
  virtual boost::optional<double> getDroop() const = 0;

  /**
   * @brief Get P0
   * @returns the P0 value or nullopt if the extension containing the data is not defined
   */
  virtual boost::optional<double> getP0() const = 0;

  /**
   * @brief Determines if the HVDC is enabled
   * @returns true if enabled, false if not or nullopt if the extension containing the data is not defined
   */
  virtual boost::optional<bool> isActivePowerControlEnabled() const = 0;

  /**
   * @brief Retrieve OPR from CS1 to CS2
   * @returns the value or nullopt if extension containing the data not found
   */
  virtual boost::optional<double> getOprFromCS1toCS2() const = 0;

  /**
   * @brief Retrieve OPR from CS2 to CS1
   * @returns the value or nullopt if extension containing the data not found
   */
  virtual boost::optional<double> getOprFromCS2toCS1() const = 0;
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNHVDCLINEINTERFACE_H_
