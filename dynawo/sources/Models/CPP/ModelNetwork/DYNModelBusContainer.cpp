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
 * @file  DYNModelBusContainer.cpp
 */

#include "DYNModelBusContainer.h"
#include "DYNModelBus.h"
#include "DYNModelSubNetwork.hpp"
#include "DYNTrace.h"
#include "DYNEnumUtils.h"


namespace DYN {

ModelBusContainer::ModelBusContainer() {
}

void
ModelBusContainer::add(const std::shared_ptr<ModelBus>& model) {
  models_.push_back(model);
}

void
ModelBusContainer::resetCurrentUStatus() {
  for (const auto& busModel : models_)
    busModel->resetCurrentUStatus();
}

void
ModelBusContainer::resetNodeInjections() {
  for (const auto& busModel : models_) {
    busModel->resetNodeInjection();
  }
}

void
ModelBusContainer::resetInjections() {
  for (auto& bus : models_) {
    bus->resetNodeInjection();
    bus->resetCurrentUStatus();
  }
}

void
ModelBusContainer::resetDerivatives() {
  for (const auto& busModel : models_)
    busModel->resetDerivatives();
}

void
ModelBusContainer::evalF(propertyF_t type) {
  for (const auto& busModel : models_)
    busModel->evalF(type);
}

void
ModelBusContainer::evalJt(const double cj, const int rowOffset, SparseMatrix& jt) {
  for (const auto& busModel : models_)
    busModel->evalJt(cj, rowOffset, jt);
}

void
ModelBusContainer::evalJtPrim(const int rowOffset, SparseMatrix& jtPrim) {
  for (const auto& busModel : models_)
    busModel->evalJtPrim(rowOffset, jtPrim);
}

void
ModelBusContainer::resetSubNetwork() {
  subNetworks_.clear();
  for (const auto& busModel : models_) {
    busModel->clearNeighbors();
    busModel->clearNumSubNetwork();
  }
}

void
ModelBusContainer::exploreNeighbors(const double t) {
  int numSubNetwork = 0;
  boost::shared_ptr<SubNetwork> subNetwork(new SubNetwork());
  subNetworks_.push_back(subNetwork);

  for (const auto& busModel : models_) {
    if (!busModel->isNumSubNetworkSet()) {  // Bus not yet treated
      busModel->setNumSubNetwork(numSubNetwork);
      subNetwork->addBus(busModel);
      busModel->exploreNeighbors(numSubNetwork, subNetwork);

      ++numSubNetwork;
      subNetwork.reset(new SubNetwork());
      subNetworks_.push_back(subNetwork);
    }
  }

  // Erase the last subNetwork which is empty
  subNetworks_.erase(subNetworks_.end() - 1);

  Trace::debug(Trace::network()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::network()) << "SubNetworks at time " << t << Trace::endline;
  Trace::debug(Trace::network()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::network()) << DYNLog(NbSubNetwork, subNetworks_.size()) << Trace::endline;
  for (unsigned int i = 0; i < subNetworks_.size(); ++i) {
    Trace::debug(Trace::network()) << DYNLog(SubNetwork, i, subNetworks_[i]->nbBus()) << Trace::endline;
    for (unsigned int j = 0; j < subNetworks_[i]->nbBus(); ++j) {
      Trace::debug(Trace::network()) << "                " << subNetworks_[i]->bus(j)->id() << " (subNetwork " << i << ")" << Trace::endline;
    }
  }
}

void
ModelBusContainer::initRefIslands() {
  for (const auto& busModel : models_) {
    busModel->refIslands = 0;
  }
}

}  // namespace DYN
