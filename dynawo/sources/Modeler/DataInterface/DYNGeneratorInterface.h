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
 * @file  DYNGeneratorInterface.h
 *
 * @brief Generator data interface : interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNGENERATORINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNGENERATORINTERFACE_H_

#include "DYNComponentInterface.hpp"

namespace DYN {
class BusInterface;
class VoltageLevelInterface;

class GeneratorInterface : public ComponentInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~GeneratorInterface() { }

  /**
   * @brief Setter for the generator's bus interface
   * @param busInterface of the bus where the generator is connected
   */
  virtual void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface) = 0;

  /**
   * @brief Setter for the generator's voltage interface
   * @param voltageLevelInterface of the voltageLevel where the generator is connected
   */
  virtual void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) = 0;

  /**
   * @brief Getter for the generator's bus interface
   * @return busInterface of the bus where the generator is connected
   */
  virtual boost::shared_ptr<BusInterface> getBusInterface() const = 0;

  /**
   * @brief Getter for the active power of the generator
   * @return The active power of the generator in MW (generator convention)
   */
  virtual double getP() = 0;

  /**
   * @brief Getter for the minimum active power of the generator
   * @return The minimum active power of the generator in MW (generator convention)
   */
  virtual double getPMin() = 0;

  /**
   * @brief Getter for the maximum active power of the generator
   * @return The maximum active power of the generator in MW (generator convention)
   */
  virtual double getPMax() = 0;

  /**
   * @brief Getter for the reactive power of the generator
   * @return The reactive power of the generator in Mvar (generator convention)
   */
  virtual double getQ() = 0;

  /**
   * @brief Getter for the maximum reactive power of the generator
   * @return The maximum reactive power of the generator in MVar (generator convention)
   */
  virtual double getQMax() = 0;

  /**
   * @brief Getter for the initial connection state of the generator
   * @return @b true if the generator is connected, @b false else
   */
  virtual bool getInitialConnected() = 0;

  /**
   * @brief Getter for the generator's id
   * @return The id of the generator
   */
  virtual std::string getID() const = 0;

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  virtual void exportStateVariablesUnitComponent() = 0;

  /**
   * @copydoc ComponentInterface::checkCriteria(bool checkEachIter)
   */
  virtual bool checkCriteria(bool checkEachIter) = 0;
};  ///< Class for Generator data interface
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNGENERATORINTERFACE_H_
