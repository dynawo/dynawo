//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
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
   * @param elements : vector where the new element should be store
   * @param mapElement : map associating name of element and element where the new element should be store
   */
  void addElement(const std::string& name, const Element::typeElement& type, std::vector<Element> &elements, std::map<std::string, int>& mapElement);

  /**
   * @brief add an sub-element to existing structure
   *
   * @param name : name of the sub element
   * @param elementName : name of the element
   * @param type : type of the sub element
   * @param parentName : name of the parent model
   * @param parentType : type of the parent model
   * @param elements : vector where the new sub element should be store
   * @param mapElement : map associating name of element and element where the new sub element should be store
   */
  void addSubElement(const std::string& name, const std::string& elementName, const Element::typeElement& type,
      const std::string& parentName, const std::string& parentType,
      std::vector<Element> &elements, std::map<std::string, int>& mapElement);

  /**
   * @brief Collect the existing connected extvar
   * @param index string that should be inserted if \@INDEX\@ is found in variableId
   * @param name string that should be inserted if \@NAME\@ is found in variableId
   * @param model1 name of the first model connected by this macro connection
   * @param model2 name of the second model connected by this macro connection
   * @param connector macro connection name
   * @param variableId after calling this method, contains the variable id with name and index macros replaced
   */
  void replaceMacroInVariableId(const std::string& index, const std::string& name,
      const std::string& model1, const std::string& model2, const std::string& connector, std::string& variableId);

}  // namespace DYN
#endif  // MODELER_COMMON_DYNCOMMONMODELER_H_
