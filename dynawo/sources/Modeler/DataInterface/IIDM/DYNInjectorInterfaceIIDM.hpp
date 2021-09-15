//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
//

//======================================================================
/**
 * @file  DYNInjectorInterfaceIIDM.hpp
 *
 * @brief Injector interface : implementation file for IIDM interface
 *
 */
//======================================================================

#ifndef MODELER_DATAINTERFACE_IIDM_DYNINJECTORINTERFACEIIDM_HPP_
#define MODELER_DATAINTERFACE_IIDM_DYNINJECTORINTERFACEIIDM_HPP_

// included in DYNInjectorInterfaceIIDM.h

#include <IIDM/components/Injection.h>
#include <IIDM/components/Bus.h>
#include <IIDM/components/VoltageLevel.h>

#include "DYNBusInterface.h"
#include "DYNVoltageLevelInterface.h"

#include "DYNModelConstants.h"
#include "DYNTrace.h"

namespace DYN {

template<class T>
InjectorInterfaceIIDM<T>::~InjectorInterfaceIIDM() { }

template<class T>
InjectorInterfaceIIDM<T>::InjectorInterfaceIIDM(IIDM::Injection<T>& injector, std::string id) :
injectorIIDM_(injector),
injectorId_(id),
initialConnected_(boost::none) { }

template<class T>
void
InjectorInterfaceIIDM<T>::setBusInterface(const boost::shared_ptr<BusInterface>& busInterface) {
  busInterface_ = busInterface;
}

template<class T>
boost::shared_ptr<BusInterface>
InjectorInterfaceIIDM<T>::getBusInterface() const {
  return busInterface_;
}

template<class T>
void
InjectorInterfaceIIDM<T>::setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  voltageLevelInterface_ = voltageLevelInterface;
}

template<class T>
boost::shared_ptr<VoltageLevelInterface>
InjectorInterfaceIIDM<T>::getVoltageLevelInterface() const {
  boost::shared_ptr<VoltageLevelInterface> voltageLevel = voltageLevelInterface_.lock();
  assert(voltageLevel && "shared_ptr for voltage level is empty");
  return voltageLevel;
}

template<class T>
bool
InjectorInterfaceIIDM<T>::getInitialConnected() {
  if (initialConnected_ == boost::none)
    initialConnected_ = isConnected();
  return initialConnected_.value();
}

template<class T>
bool
InjectorInterfaceIIDM<T>::isConnected() const {
  bool connected = false;
  if (injectorIIDM_.has_connection()) {
    if (injectorIIDM_.connectionPoint()->is_bus()) {
      connected = injectorIIDM_.isConnected();
    } else {
      connected = getVoltageLevelInterface()->isNodeConnected(injectorIIDM_.node());
    }
  }
  return connected;
}

template<class T>
double
InjectorInterfaceIIDM<T>::getVNom() const {
  return getVoltageLevelInterface()->getVNom();
}

template<class T>
bool
InjectorInterfaceIIDM<T>::hasP() {
  return injectorIIDM_.has_p();
}

template<class T>
bool
InjectorInterfaceIIDM<T>::hasQ() {
  return injectorIIDM_.has_q();
}

template<class T>
double
InjectorInterfaceIIDM<T>::getP() {
  if (getInitialConnected()) {
    if (!hasP()) {
      Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "Injection", getID(), "P") << Trace::endline;
      return 0;
    }
    return injectorIIDM_.p();
  } else {
    return 0.;
  }
}

template<class T>
double
InjectorInterfaceIIDM<T>::getQ() {
  if (getInitialConnected()) {
    if (!hasQ()) {
      Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "Injection", getID(), "Q") << Trace::endline;
      return 0;
    }
    return injectorIIDM_.q();
  } else {
    return 0.;
  }
}

template<class T>
std::string
InjectorInterfaceIIDM<T>::getID() const {
  return injectorId_;
}

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_IIDM_DYNINJECTORINTERFACEIIDM_HPP_
