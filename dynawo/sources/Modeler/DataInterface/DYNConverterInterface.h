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

class ConverterInterface : public ComponentInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~ConverterInterface() { }

  /**
   * @brief Setter for the lcc converter bus interface
   * @param busInterface: interface of the bus where the lcc converter is connected
   */
  virtual void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the lcc converter voltage interface
   * @param voltageLevelInterface: interface of the voltageLevel where the lcc converter is connected
   */
  virtual void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

  /**
   * @brief Getter for the lcc converter bus interface
   * @return busInterface: interface of the bus where the lcc converter is connected
   */
  virtual boost::shared_ptr<BusInterface> getBusInterface() const = 0;

  /**
   * @brief Getter for the initial connection state of the lcc converter
   * @return @b true if the lcc converter is connected, @b false otherwise
   */
  virtual bool getInitialConnected() = 0;

  /**
   * @brief Getter for the lcc converter id
   * @return The id of the lcc converter
   */
  virtual std::string getID() const = 0;

  /**
   * @brief Getter for the nominal voltage of the bus where the lcc converter is connected
   * @return The nominal voltage of the bus where the lcc converter is connected in kV
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
   * @brief Getter for the active power of the lcc converter
   * @return The active power of the lcc converter in MW (following iidm convention)
   */
  virtual double getP() = 0;

  /**
   * @brief Getter for the reactive power of the lcc converter
   * @return The reactive power of the lcc converter in Mvar (following iidm convention)
   */
  virtual double getQ() = 0;

  /**
   * @brief Getter for the loss factor of the converter
   * @return The loss factor of the converter
   */
  virtual double getLossFactor() const = 0;
};  ///< common interface class for converters
}  // namespace DYN


#endif  // MODELER_DATAINTERFACE_DYNCONVERTERINTERFACE_H_
