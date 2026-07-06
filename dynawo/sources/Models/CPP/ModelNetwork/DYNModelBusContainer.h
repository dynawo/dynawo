// Copyright (c) 2015-2026, RTE (http://www.rte-france.com)
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
 * @file  DYNModelBusContainer.h
 */

#ifndef MODELS_CPP_MODELNETWORK_DYNMODELBUSCONTAINER_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELBUSCONTAINER_H_

#include <vector>
#include <boost/shared_ptr.hpp>
#include "DYNEnumUtils.h"

namespace DYN {
class ModelBus;
class SubNetwork;
class SparseMatrix;

/**
 * class ModelBusContainer
 */
class ModelBusContainer {
 public:
  /**
   * @brief default constructor
   */
  ModelBusContainer();

  /**
   * @brief add bus
   * @param model model
   */
  void add(const std::shared_ptr<ModelBus>& model);

  /**
   * @brief remove all buses from the sub-network
   *
   */
  void resetSubNetwork();   // remove all buses from the sub-network

  /**
   * @brief  reset node injection
   *
   */
  void resetNodeInjections();

  /**
   * @brief create a new-subnetwork, and scan the network to find all buses located within
   * @param t : time to use  (only used for log purpose)
   */
  void exploreNeighbors(double t);  // create a new-subnetwork, and scan the network to find all buses located within

  /**
   * @brief init reference islands
   *
   */
  void initRefIslands();

  /**
   * @brief init derivatives
   *
   */
  void resetDerivatives();

  /**
   * @brief evaluate the residual functions for each bus
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(propertyF_t type);

  /**
   * @brief get sub networks
   * @return sub networks
   */
  const std::vector<boost::shared_ptr<SubNetwork> >& getSubNetworks() const {
    return subNetworks_;
  }   // get the list of sub-networks

  /**
   * @brief evaluate Jacobian \f$( J = @F/@x + cj * @F/@x')\f$
   * @param cj Jacobian prime coefficient
   * @param rowOffset row offset to use to find the first row to fill
   * @param jt sparse matrix to fill
   */
  void evalJt(double cj, int rowOffset, SparseMatrix& jt);

  /**
   * @brief  evaluate Jacobian \f$( J =  @F/@x')\f$
   * @param rowOffset row offset to use to find the first row to fill
   * @param jtPrim sparse matrix to fill
   */
  void evalJtPrim(int rowOffset, SparseMatrix& jtPrim);

  /**
   * @brief reset the bit mask of every bus corresponding to the status of U calculation for the current time step
   */
  void resetCurrentUStatus();

  /**
   * @brief reset resetNodeInjections and resetCurrentUStatus
   */
  void resetInjections();


 private:
  std::vector<std::shared_ptr<ModelBus> > models_;  ///< model bus
  std::vector<boost::shared_ptr<SubNetwork> > subNetworks_;  ///< sub network
};
}  // namespace DYN
#endif  // MODELS_CPP_MODELNETWORK_DYNMODELBUSCONTAINER_H_
