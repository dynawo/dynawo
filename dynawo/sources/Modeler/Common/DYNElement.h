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
 * @file  DYNElement.h
 *
 * @brief
 *
 */
#ifndef MODELER_COMMON_DYNELEMENT_H_
#define MODELER_COMMON_DYNELEMENT_H_
#include <vector>
#include <string>

namespace DYN {

/**
 * @class Element
 * @brief Element class
 *
 * A Genetic class of element
 */
class Element {
 public:
  /**
   * @brief structure for type of element
   *
   */
  typedef enum {
    STRUCTURE = 1,
    TERMINAL = 2
  } typeElement;

 public:
  /**
   * @brief default constructor
   *
   */
  Element()
  :type_(STRUCTURE) { }

  /**
   * @brief constructor
   * @param name element's name
   * @param id element's id
   * @param type element's type
   */
  Element(const std::string& name, const std::string& id, const typeElement type)
  : type_(type)
  , name_(name)
  , id_(id) { }

  /**
   * @brief get type element
   * @return type of element
   */
  inline typeElement getTypeElement() const {
    return type_;
  }

  /**
   * @brief get name
   * @return name
   */
  inline std::string name() const {
    return name_;
  }

  /**
   * @brief get id
   * @return id
   */
  inline std::string id() const {
    return id_;
  }

  /**
   * @brief get list of sub elements number
   * @return list of sub elements number
   */
  inline const std::vector<int>& subElementsNum() const {
    return subElementsNum_;
  }

  /**
   * @brief get list of sub elements number
   * @return list of sub elements number
   */
  inline std::vector<int>& subElementsNum() {
    return subElementsNum_;
  }

 private:
  typeElement type_;  ///< type
  std::string name_;  ///< name
  std::string id_;  ///< id
  std::vector<int> subElementsNum_;  ///< list of sub elements' number
};  ///< class Element
}  // namespace DYN

#endif  // MODELER_COMMON_DYNELEMENT_H_
