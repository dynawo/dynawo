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
 * @file  DYNInjectorInterfaceIIDM.h
 *
 * @brief Injector interface : header file for IIDM interface
 *
 */
//======================================================================

#ifndef MODELER_DATAINTERFACE_DYNINJECTORINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_DYNINJECTORINTERFACEIIDM_H_

#include <IIDM/components/Injection.h>

#include <boost/shared_ptr.hpp>
#include <boost/weak_ptr.hpp>

namespace DYN {
class BusInterface;
class VoltageLevelInterface;

/**
 * class InjectorInterfaceIIDM
 */
template<class T>
class InjectorInterfaceIIDM {
 public:
  /**
   * @brief Destructor
   */
  ~InjectorInterfaceIIDM();

  /**
   * @brief Constructor
   * @param injector Injector's iidm instance
   * @param id Injector's id
   */
  InjectorInterfaceIIDM(IIDM::Injection<T>& injector, std::string id);

  /**
   * @brief Setter for the injector's bus interface
   * @param busInterface busInterface of the bus where the injector is connected
   */
  void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @brief Setter for the injector's voltage level interface
   * @param voltageLevelInterface voltageLevelInterface of the voltage level where the injector is connected
   */
  void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @brief Getter for the injector's voltage level interface
   * @return voltageLevelInterface voltageLevelInterface where the injector is connected
   */
  boost::shared_ptr<VoltageLevelInterface> getVoltageLevelInterface() const;

  /**
   * @brief Getter for the injector's bus interface
   * @return busInterface busInterface of the bus where the injector is connected
   */
  boost::shared_ptr<BusInterface> getBusInterface() const;

  /**
   * @brief Getter for the initial connection state of the injector
   * @return @b true if the injector is connected, @b false else
   */
  bool getInitialConnected();

  /**
   * @brief Getter for the nominal voltage of the bus where the injector is connected
   * @return The nominal voltage of the bus where the injector is connected in kV
   */
  double getVNom() const;

  /**
   * @brief Indicates whether the injector knows its injected/consumed active power
   * @return Whether the injector knows its injected/consumed active power
   */
  bool hasP();

  /**
   * @brief Indicates whether the injector knows its injected/consumed reactive power
   * @return Whether the injector knows its injected/consumed reactive power
   */
  bool hasQ();

  /**
   * @brief Getter for the active power injected/consumed by the injector
   * @return The active power injected/consumed by the injector in MW (following iidm convention)
   */
  double getP();

  /**
   * @brief Getter for the reactive power injected/consumed by the injector
   * @return The reactive power injected/consumed by the injector in Mvar (following iidm convention)
   */
  double getQ();

  /**
   * @brief Getter for the injector's id
   * @return The id of the injector
   */
  std::string getID() const;

 protected:
  IIDM::Injection<T>& injectorIIDM_;  ///< reference to the iidm injector instance
  std::string injectorId_;  ///< injector's id
  boost::shared_ptr<BusInterface> busInterface_;  ///< busInterface of the bus where the injector is connected
  boost::weak_ptr<VoltageLevelInterface> voltageLevelInterface_;  ///< voltageLevel interface where the injector is connected
  boost::optional<bool> initialConnected_;  ///< whether the injector is initially connected or not
};

}  // namespace DYN

#include "DYNInjectorInterfaceIIDM.hpp"

#endif  // MODELER_DATAINTERFACE_DYNINJECTORINTERFACEIIDM_H_
