//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

#include "DYNDataInterfaceImpl.h"

#include "DYNNetworkInterface.h"
#include "DYNBusInterface.h"
#include "DYNSwitchInterface.h"
#include "DYNLoadInterface.h"
#include "DYNLineInterface.h"
#include "DYNGeneratorInterface.h"
#include "DYNShuntCompensatorInterface.h"
#include "DYNStaticVarCompensatorInterface.h"
#include "DYNDanglingLineInterface.h"
#include "DYNTwoWTransformerInterface.h"
#include "DYNThreeWTransformerInterface.h"
#include "DYNHvdcLineInterface.h"
#include "DYNVoltageLevelInterface.h"

using boost::shared_ptr;
using std::vector;

namespace DYN {

template <class ComponentType>
static inline
bool componentsHasDynamicModel(const vector<std::shared_ptr<ComponentType> >& components) {
  if (std::any_of(components.begin(), components.end(), [](const std::shared_ptr<ComponentType>& component) { return !component->hasDynamicModel(); }))
    return true;
  return false;
}

bool
DataInterfaceImpl::instantiateNetwork() const {
  const boost::shared_ptr<NetworkInterface>& network = getNetwork();
  const vector<std::shared_ptr<VoltageLevelInterface> >& voltageLevels = network->getVoltageLevels();
  for (const auto& voltageLevel : voltageLevels) {
    if (componentsHasDynamicModel(voltageLevel->getBuses()))
      return true;

    if (componentsHasDynamicModel(voltageLevel->getSwitches()))
      return true;

    if (componentsHasDynamicModel(voltageLevel->getLoads()))
      return true;

    if (componentsHasDynamicModel(voltageLevel->getGenerators()))
      return true;

    if (componentsHasDynamicModel(voltageLevel->getShuntCompensators()))
      return true;

    if (componentsHasDynamicModel(voltageLevel->getStaticVarCompensators()))
      return true;

    if (componentsHasDynamicModel(voltageLevel->getDanglingLines()))
      return true;
  }

  if (componentsHasDynamicModel(network->getLines()))
    return true;

  if (componentsHasDynamicModel(network->getTwoWTransformers()))
    return true;

  if (componentsHasDynamicModel(network->getThreeWTransformers()))
    return true;

  if (componentsHasDynamicModel(network->getHvdcLines()))
    return true;

  return false;
}

}  // namespace DYN
