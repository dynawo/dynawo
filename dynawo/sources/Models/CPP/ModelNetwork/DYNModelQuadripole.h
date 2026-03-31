// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.

/**
 * @file  DYNModelQuadripole.h
 * @brief interface for components connecting two buses together
 */

#ifndef MODELS_CPP_MODELNETWORK_DYNMODELQUADRIPOLE_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELQUADRIPOLE_H_

#include "DYNNetworkComponent.h"

namespace DYN {
class ModelBus;

/**
 * @brief interface for components connecting two buses together
 */
class ModelQuadripole : public NetworkComponent {
 public:
  /**
   * @brief set the bus at end 1 of the line
   * @param model model of the bus
   */
  virtual void setModelBus1(const std::shared_ptr<ModelBus>& model) { modelBus1_ = model; }

  /**
   * @brief set the bus at end 2 of the line
   * @param model model of the bus
   */
  virtual void setModelBus2(const std::shared_ptr<ModelBus>& model) { modelBus2_ = model; }

  /**
   * @brief get the bus at end 1 of the transformer
   * @return model of the bus
   */
  virtual const std::shared_ptr<ModelBus> & getModelBus1() const { return modelBus1_; }

  /**
   * @brief get the bus at end 2 of the transformer
   * @return model model of the bus
   */
  virtual const std::shared_ptr<ModelBus> & getModelBus2() const { return modelBus2_; }

  /**
   * @brief trivial setter, for unit testing purposes
   * @param connectionState new state to set
   */
  void setConnectionState(State connectionState) { connectionState_ = connectionState; }

  /**
   * @brief get the connected state (fully connected, one end open, ...) of the line
   * @return state
   */
  State getConnectionState() const { return connectionState_; }

  /**
   * @brief override interconnecting buses from both sides in global network
   */
  void addBusNeighbors() override;

 protected:
   /**
   * @brief transparent constructor deferring to NetworkComponent
   * @param id staticId allowing tracking of component within ModelNetwork
   */
  explicit ModelQuadripole(const std::string & id) : NetworkComponent(id) {}

 protected:
  State connectionState_;  ///< "internal" line connection status, evaluated at the end of evalZ to detect if the state was modified by another component
  std::shared_ptr<ModelBus> modelBus1_;  ///< bus model on side 1 of the quadripole
  std::shared_ptr<ModelBus> modelBus2_;  ///< bus model on side 2 of the quadripole
};

}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELQUADRIPOLE_H_
