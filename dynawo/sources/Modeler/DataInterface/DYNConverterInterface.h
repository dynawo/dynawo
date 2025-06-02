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

#ifndef MODELER_DATAINTERFACE_DYNCONVERTERINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNCONVERTERINTERFACE_H_

#include "DYNComponentInterface.hpp"

namespace DYN {
class BusInterface;
class VoltageLevelInterface;

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @brief Converter interface
 */
class ConverterInterface : public ComponentInterface {
 public:
  /**
   * @brief Definition of the type of the converter
   */
  typedef enum {
    VSC_CONVERTER,  ///< the component is a voltage source converter
    LCC_CONVERTER   ///< the component is a line-commutated converter
  } ConverterType_t;

 public:
  /**
   * @brief Constructor
   * @param hasInitialConditions @b true if component has initial conditions set, @b false else
   */
  explicit ConverterInterface(bool hasInitialConditions = true) : ComponentInterface(hasInitialConditions) {}

  /**
   * @brief Destructor
   */
  virtual ~ConverterInterface() = default;

  /**
   * @brief Setter for the converter bus interface
   * @param busInterface interface of the bus where the converter is connected
   */
  virtual void setBusInterface(const std::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the converter voltage interface
   * @param voltageLevelInterface interface of the voltageLevel where the converter is connected
   */
  virtual void setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

  /**
   * @brief Getter for the converter bus interface
   * @return busInterface interface of the bus where the converter is connected
   */
  virtual std::shared_ptr<BusInterface> getBusInterface() const = 0;

  /**
   * @brief Getter for the initial connection state of the converter
   * @return @b true if the converter is connected, @b false otherwise
   */
  virtual bool getInitialConnected() = 0;

  /**
   * @brief Getter for the converter id
   * @return The id of the converter
   */
  virtual const std::string& getID() const = 0;

  /**
   * @brief Getter for the nominal voltage of the bus where the converter is connected
   * @return The nominal voltage of the bus where the converter is connected in kV
   */
  virtual double getVNom() const = 0;

  /**
   * @brief Indicates whether the injector knows its injected/consumed active power
   * @return Whether the injector knows its injected/consumed active power
   */
  virtual bool hasP() = 0;

  /**
   * @brief Indicates whether the injector knows its injected/consumed reactive power
   * @return Whether the injector knows its injected/consumed reactive power
   */
  virtual bool hasQ() = 0;

  /**
   * @brief Getter for the active power of the converter
   * @return The active power of the converter in MW (following iidm convention)
   */
  virtual double getP() = 0;

  /**
   * @brief Getter for the reactive power of the converter
   * @return The reactive power of the converter in Mvar (following iidm convention)
   */
  virtual double getQ() = 0;

  /**
   * @brief Getter for the loss factor of the converter
   * @return The loss factor of the converter
   */
  virtual double getLossFactor() const = 0;

  /**
   * @brief Getter fot the converter's type
   * @return converter's type
   */
  inline ConverterType_t getConverterType() const {
    switch (type_) {
      case ComponentInterface::BUS:
      case ComponentInterface::CALCULATED_BUS:
      case ComponentInterface::SWITCH:
      case ComponentInterface::LOAD:
      case ComponentInterface::LINE:
      case ComponentInterface::GENERATOR:
      case ComponentInterface::SHUNT:
      case ComponentInterface::DANGLING_LINE:
      case ComponentInterface::TWO_WTFO:
      case ComponentInterface::THREE_WTFO:
      case ComponentInterface::SVC:
      case ComponentInterface::HVDC_LINE:
      case ComponentInterface::UNKNOWN:
      case ComponentInterface::VSC_CONVERTER: {
        return VSC_CONVERTER;
        break;
      }
      case ComponentInterface::LCC_CONVERTER: {
        return LCC_CONVERTER;
        break;
      }
      case ComponentInterface::COMPONENT_TYPE_COUNT:
        throw DYNError(Error::MODELER, ConverterWrongType, getID());
      default:
        throw DYNError(Error::MODELER, ConverterWrongType, getID());
    }
  }
};  ///< common interface class for converters

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNCONVERTERINTERFACE_H_
