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
 * @file  DYNCommonModeler.cpp
 *
 * @brief Definition of utilities functions to use in modeler : implementation file
 *
 */

#include "DYNCommonModeler.h"
#include "DYNMacrosMessage.h"

using std::string;
using std::vector;
using std::map;

namespace DYN {

void
addElement(const string& name, const Element::typeElement& type, vector<Element>& elements, map<string, int >& mapElement) {
  elements.emplace_back(name, name, type);
  mapElement[name] = static_cast<int>(elements.size()) - 1;
}

void
addSubElement(const string& name, const string& elementName, const Element::typeElement& type,
    const std::string& parentName, const std::string& parentType, vector<Element>& elements, map<string, int>& mapElement) {
  const string subName = elementName + "_" + name;
  elements.emplace_back(name, subName, type);
  mapElement[subName] = static_cast<int>(elements.size()) - 1;
  const auto& iter = mapElement.find(elementName);
  if (iter != mapElement.end()) {
    elements[iter->second].subElementsNum().push_back(static_cast<int>(elements.size()) - 1);
  } else {
    throw DYNError(Error::MODELER, SubModelUnknownElement, elementName, parentName, parentType);
  }
}

void
replaceMacroInVariableId(const string& index, const string& name,
    const string& model1, const string& model2, const string& connector, string& variableId) {
  static const string indexLabel = "@INDEX@";
  static const string nameLabel = "@NAME@";
  // replace @INDEX@ in variableId
  size_t pos = variableId.find(indexLabel);
  if (pos != string::npos) {
    if (index.empty())
      throw DYNError(Error::MODELER, IncompleteMacroConnection, model1, model2, connector, "index");
    variableId.replace(pos, indexLabel.size(), index);
  }

  // replace @NAME@ in variableId
  pos = variableId.find(nameLabel);
  if (pos != string::npos) {
    if (name.empty())
      throw DYNError(Error::MODELER, IncompleteMacroConnection, model1, model2, connector, "name");
    variableId.replace(pos, nameLabel.size(), name);
  }
}
}  // namespace DYN
