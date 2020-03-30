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
 * @file  DYNShuntCompensatorInterface.h
 *
 * @brief Shunt compensator interface : header file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNSHUNTCOMPENSATORINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNSHUNTCOMPENSATORINTERFACE_H_

#include "DYNComponentInterface.hpp"

namespace DYN {
class BusInterface;
class VoltageLevelInterface;

class ShuntCompensatorInterface : public ComponentInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~ShuntCompensatorInterface() { }

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  virtual void exportStateVariablesUnitComponent() = 0;

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  virtual void importStaticParameters() = 0;

  /**
   * @brief Setter for the shuntCompensator's bus interface
   * @param busInterface of the bus where the shunt compensator is connected
   */
  virtual void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the shuntCompensator's voltage interface
   * @param voltageLevelInterface of the voltageLevel where the shuntCompensator is connected
   */
  virtual void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

  /**
   * @brief Getter for the shuntCompensator's bus interface
   * @return The busInterface of the bus where the shunt compensator is connected
   */
  virtual boost::shared_ptr<BusInterface> getBusInterface() const = 0;

  /**
   * @brief Getter for the initial connection state of the shunt compensator
   * @return @b true if the shunt compensator is connected, @b false otherwise
   */
  virtual bool getInitialConnected() = 0;

  /**
   * @brief Getter for the nominal voltage of the bus where the shunt compensator is connected
   * @return The nominal voltage of the bus where the shunt compensator is connected in kV
   */
  virtual double getVNom() const = 0;

  /**
   * @brief Getter for the reactive power of the shunt compensator
   * @return The reactive power of the shunt compensator in Mvar
   */
  virtual double getQ() = 0;

  /**
   * @brief Getter for the shunt compensator's id
   * @return The id of the shunt compensator
   */
  virtual std::string getID() const = 0;

  /**
   * @brief Getter for the shuntCompensator's current number of connected sections
   * @return The current number of connected sections of the shunt compensator
   */
  virtual int getCurrentSection() const = 0;

  /**
   * @brief Getter for the shuntCompensator's maximum number of sections
   * @return The maximum number of sections of the shunt compensator
   */
  virtual int getMaximumSection() const = 0;

  /**
   * @brief Getter for the shuntCompensator's susceptance per section
   * @return The susceptance per section of the shunt compensator in Siemens
   */
  virtual double getBPerSection() const = 0;
};  ///< Interface class for Shunt Compensator

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNSHUNTCOMPENSATORINTERFACE_H_
