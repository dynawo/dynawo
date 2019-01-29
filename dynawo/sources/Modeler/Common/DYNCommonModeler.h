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
 * @file  DYNCommonModeler.h
 *
 * @brief Definition of utilities functions to use in modeler : header file
 *
 */
#ifndef MODELER_COMMON_DYNCOMMONMODELER_H_
#define MODELER_COMMON_DYNCOMMONMODELER_H_

#include <vector>
#include <string>
#include <map>
#include "DYNElement.h"


namespace DYN {
  /**
   * @brief add an element to existing structure
   *
   * @param name : name of the element
   * @param type : type of the element
   * @param elements: vector where the new element should be store
   * @param mapElement : map associating name of element and element where the new element should be store
   */
  void addElement(const std::string& name, const Element::typeElement& type, std::vector<Element> &elements, std::map<std::string, int>& mapElement);

  /**
   * @brief add an sub-element to existing structure
   *
   * @param name : name of the sub element
   * @param elementName : name of the element
   * @param type : type of the sub element
   * @param elements: vector where the new sub element should be store
   * @param mapElement: map associating name of element and element where the new sub element should be store
   */
  void addSubElement(const std::string& name, const std::string& elementName, const Element::typeElement& type, std::vector<Element> &elements,
                     std::map<std::string, int>& mapElement);
}  // namespace DYN
#endif  // MODELER_COMMON_DYNCOMMONMODELER_H_
