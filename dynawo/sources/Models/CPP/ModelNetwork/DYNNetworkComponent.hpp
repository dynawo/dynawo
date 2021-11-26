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

/**
 * @file  DYNNetworkComponent.hpp
 *
 * @brief Implementation of template methods
 *
 */

#ifndef MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENT_HPP_
#define MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENT_HPP_

namespace DYN {

template <>
double
NetworkComponent::getParameterDynamicNoThrow(const boost::unordered_map<std::string, ParameterModeler>&,
                                                   const std::string&, bool&, const std::vector<std::string>&) const;

template <>
int
NetworkComponent::getParameterDynamicNoThrow(const boost::unordered_map<std::string, ParameterModeler>&,
                                                   const std::string&, bool&, const std::vector<std::string>&) const;

template <>
bool
NetworkComponent::getParameterDynamicNoThrow(const boost::unordered_map<std::string, ParameterModeler>&,
                                                   const std::string&, bool&, const std::vector<std::string>&) const;

template <>
std::string
NetworkComponent::getParameterDynamicNoThrow(const boost::unordered_map<std::string, ParameterModeler>&,
                                                   const std::string&, bool&, const std::vector<std::string>&) const;

template<typename T>
T
inline NetworkComponent::getParameterDynamic(const boost::unordered_map<std::string, ParameterModeler>& params,
    const std::string& id, const std::vector<std::string>& ids) const {
  bool foundParam = false;
  T value = getParameterDynamicNoThrow<T>(params, id, foundParam, ids);
  if (foundParam)
    return value;

  throw DYNError(Error::MODELER, ParameterNotReadInPARFile, id);
}

template<typename T>
void
inline NetworkComponent::findParameterDynamicNoThrow(const boost::unordered_map<std::string, ParameterModeler>& params,
    const std::string& id, bool& foundParam, const std::vector<std::string>& ids, T& value) const {
  foundParam = false;
  if (ids.empty()) {
    if (hasParameter(id, params)) {
      ParameterModeler pm = findParameter(id, params);
      if (pm.hasOrigin(PAR)) {
        value = pm.getValue<T>();
        foundParam = true;
        return;
      }
    }
  } else {
    for (std::vector<std::string>::const_iterator iter = ids.begin(), iterEnd = ids.end(); iter != iterEnd; ++iter) {
      const std::string& name = (*iter) + "_" + id;
      if (hasParameter(name, params)) {
        ParameterModeler pm = findParameter(name, params);
        if (pm.hasOrigin(PAR)) {
          value = pm.getValue<T>();
          foundParam = true;
          return;
        }
      }
    }
  }
}

}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENT_HPP_
