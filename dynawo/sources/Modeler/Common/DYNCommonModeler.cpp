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
  Element element(name, name, type);
  elements.push_back(element);
  mapElement[name] = elements.size() - 1;
}

void
addSubElement(const string& name, const string& elementName, const Element::typeElement& type, vector<Element>& elements, map<string, int>& mapElement) {
  string subName = elementName + "_" + name;
  Element subElement(name, subName, type);
  elements.push_back(subElement);
  mapElement[subName] = elements.size() - 1;
  map<string, int>::iterator iter = mapElement.find(elementName);
  if (iter != mapElement.end()) {
    elements[iter->second].subElementsNum().push_back(elements.size() - 1);
  } else {
    throw DYNError(Error::MODELER, SubModelUnknownElement, elementName);
  }
}


}  // namespace DYN
