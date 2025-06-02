//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  DataInterface/PowSyblIIDM/DYNInjectorInterfaceIIDM.h
 *
 * @brief Injector interface : header file for IIDM interface
 *
 */
//======================================================================

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNINJECTORINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNINJECTORINTERFACEIIDM_H_

#include "DYNBusInterface.h"
#include "DYNModelConstants.h"
#include "DYNTrace.h"
#include "DYNVoltageLevelInterface.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Injection.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>

namespace DYN {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * class InjectorInterfaceIIDM
 */
class InjectorInterfaceIIDM {
 public:
  /**
   * @brief Destructor
   */
  virtual ~InjectorInterfaceIIDM() = default;

  /**
   * @brief Constructor
   * @param injector Injector's iidm instance
   * @param id Injector's id
   */
  InjectorInterfaceIIDM(const powsybl::iidm::Injection& injector, const std::string& id) : injectorIIDM_(injector),
                                                                                           injectorId_(id),
                                                                                           initialConnected_(boost::none) {}

  /**
   * @brief Setter for the injector's bus interface
   * @param busInterface busInterface of the bus where the injector is connected
   */
  void
  setBusInterfaceInjector(const std::shared_ptr<BusInterface>& busInterface) {
    busInterface_ = busInterface;
  }

  /**
   * @brief Getter for the injector's bus interface
   * @return busInterface busInterface of the bus where the injector is connected
   */
  const std::shared_ptr<BusInterface>&
  getBusInterfaceInjector() const {
    return busInterface_;
  }

  /**
   * @brief Setter for the injector's voltage level interface
   * @param voltageLevelInterface voltageLevelInterface of the voltage level where the injector is connected
   */
  void
  setVoltageLevelInterfaceInjector(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
    voltageLevelInterface_ = voltageLevelInterface;
  }

  /**
   * @brief Getter for the injector's voltage level interface
   * @return voltageLevelInterface voltageLevelInterface where the injector is connected
   */
  std::shared_ptr<VoltageLevelInterface>
  getVoltageLevelInterfaceInjector() const {
    std::shared_ptr<VoltageLevelInterface> voltageLevel = voltageLevelInterface_.lock();
    assert(voltageLevel && "shared_ptr for voltage level is empty");
    return voltageLevel;
  }

  /**
   * @brief Getter for the nominal voltage of the bus where the injector is connected
   * @return The nominal voltage of the bus where the injector is connected in kV
   */
  double
  getVNomInjector() const {
    return getVoltageLevelInterfaceInjector()->getVNom();
  }

  /**
   * @brief Getter for the initial connection state of the injector
   * @return @b true if the injector is connected, @b false else
   */
  bool
  getInitialConnectedInjector() {
    if (initialConnected_ == boost::none)
      initialConnected_ = isConnectedInjector();
    return initialConnected_.value();
  }

  /**
   * @brief Checks the connection state of the injector
   * @return @b true is the injector is connected, @b false else
   */
  bool
  isConnectedInjector() const {
    bool connected = injectorIIDM_.getTerminal().isConnected();
    if (connected && getVoltageLevelInterfaceInjector()->isNodeBreakerTopology())
      connected = getVoltageLevelInterfaceInjector()->isNodeConnected(static_cast<unsigned int>(injectorIIDM_.getTerminal().getNodeBreakerView().getNode()));
    return connected;
  }

  /**
   * @brief Indicates whether the injector knows its injected/consumed active power
   * @return Whether the injector knows its injected/consumed active power
   */
  bool
  hasPInjector() const {
    return !std::isnan(injectorIIDM_.getTerminal().getP());
  }

  /**
   * @brief Indicates whether the injector knows its injected/consumed reactive power
   * @return Whether the injector knows its injected/consumed reactive power
   */
  bool
  hasQInjector() const {
    return !std::isnan(injectorIIDM_.getTerminal().getQ());
  }

  /**
   * @brief Getter for the active power injected/consumed by the injector
   * @return The active power injected/consumed by the injector in MW (following iidm convention)
   */
  inline double getPInjector() {
    if (getInitialConnectedInjector()) {
      if (!hasPInjector()) {
        Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "Injection", getIDInjector(), "P") << Trace::endline;
        return 0.;
      }
      return injectorIIDM_.getTerminal().getP();
    } else {
      return 0.;
    }
  }

  /**
   * @brief Getter for the reactive power injected/consumed by the injector
   * @return The reactive power injected/consumed by the injector in Mvar (following iidm convention)
   */
  inline double
  getQInjector() {
    if (getInitialConnectedInjector()) {
      if (!hasQInjector()) {
        Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "Injection", getIDInjector(), "Q") << Trace::endline;
        return 0.;
      }
      return injectorIIDM_.getTerminal().getQ();
    } else {
      return 0.;
    }
  }

  /**
   * @brief Getter for the injector's id
   * @return The id of the injector
   */
  const std::string&
  getIDInjector() const {
    return injectorId_;
  }

 private:
  const powsybl::iidm::Injection& injectorIIDM_;                  ///< reference to the iidm injector instance
  std::shared_ptr<BusInterface> busInterface_;                  ///< busInterface of the bus where the injector is connected
  std::weak_ptr<VoltageLevelInterface> voltageLevelInterface_;  ///< voltageLevel interface where the injector is connected
  std::string injectorId_;                                        ///< injector's id
  boost::optional<bool> initialConnected_;                        ///< whether the injector is initially connected or not
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN
#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNINJECTORINTERFACEIIDM_H_
