// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.

/**
 * @file  DYNModelSubNetwork.hpp
 */

#ifndef MODELS_CPP_MODELNETWORK_DYNMODELSUBNETWORK_HPP_
#define MODELS_CPP_MODELNETWORK_DYNMODELSUBNETWORK_HPP_

#include <vector>
#include <boost/shared_ptr.hpp>
#include "DYNTrace.h"

namespace DYN {
class ModelBus;

/**
 * class SubNetwork
 */
class SubNetwork {  ///< sub-network gathering buses connected by AC components
 public:
  /**
   * @brief default constructor
   */
  SubNetwork() = default;

  /**
   * @brief  add a bus to the sub-network
   * @param bus bus
   */
  inline void addBus(const std::shared_ptr<ModelBus>& bus) {
    assert(bus && "Undefined bus");
    bus_.push_back(bus);
  }

  /**
   * @brief  get the number of buses within the sub-network
   * @return number of buses
   */
  inline unsigned int nbBus() const {
    return static_cast<unsigned int>(bus_.size());
  }

  /**
   * @brief get bus
   * @param num num
   * @return bus
   */
  inline std::shared_ptr<ModelBus> bus(const int num) const {
    assert(num >= 0 && static_cast<size_t>(num) < bus_.size() && "Bus index unknown");
    return bus_[num];
  }
  /**
   * @brief  switch off all buses within the sub-network
   */
  void shutDownNodes() {
    for (unsigned int i = 0; i < bus_.size(); ++i) {
      if (!bus_[i]->getSwitchOff()) {
        bus_[i]->switchOff();
        Trace::info() << DYNLog(SwitchOffBus, bus_[i]->id()) << Trace::endline;
      }
    }
  }

  /**
   * @brief turn on all buses within the sub-network
   */
  void turnOnNodes() {
    for (unsigned int i = 0; i < bus_.size(); ++i) {
      if (bus_[i]->getSwitchOff()) {
        bus_[i]->switchOn();
        Trace::info() << DYNLog(SwitchOnBus, bus_[i]->id()) << Trace::endline;
      }
    }
  }

 private:
  std::vector<std::shared_ptr<ModelBus> > bus_;  ///< vector of ModelBus located within the sub-network
};

}  // namespace DYN
#endif  // MODELS_CPP_MODELNETWORK_DYNMODELSUBNETWORK_HPP_
