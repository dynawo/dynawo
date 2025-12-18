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
 * @file DYDStaticRef.h
 * @brief Dynawo staticRef description : interface file
 *
 */

#ifndef API_DYD_DYDSTATICREF_H_
#define API_DYD_DYDSTATICREF_H_

#include <string>

namespace dynamicdata {

/**
 * @class StaticRef
 * @brief Dynawo staticRef interface class
 *
 * StaticRef objects describe a dynamic connection between two models
 */
class StaticRef {
 public:
  /**
   * @brief StaticRef constructor
   */
  StaticRef() = default;
  /**
   * @brief StaticRef constructor
   *
   * @param modelVar Dynamic model variable
   * @param staticVar static model variable
   * @param componentID static model ID
   */
  StaticRef(const std::string& modelVar, const std::string& staticVar, const std::string& componentID);

  /**
   * @brief Model Variable setter
   * @param modelVar model variable
   */
  void setModelVar(const std::string& modelVar);
  /**
   * @brief Static Variable setter
   * @param staticVar static variable
   */
  void setStaticVar(const std::string& staticVar);
  /**
   * @brief Component ID setter
   * @param staticVar component ID
   */
  void setComponentID(const std::string& componentID);

  /**
   * @brief Model variable getter
   * @return model variable
   */
  const std::string& getModelVar() const;
  /**
   * @brief Static Variable getter
   * @return static variable
   */
  const std::string& getStaticVar() const;
  /**
   * @brief Component ID getter
   * @return component ID
   */
  const std::string& getComponentID() const;

  /**
   * @brief compare two staticRef
   *
   * @param other other staticRef to compare with
   *
   * @return @b true staticRef are equals (same var and staticVar)
   *         @b false else
   */
  inline bool operator==(const StaticRef& other) {
    return getModelVar() == other.getModelVar() && getStaticVar() == other.getStaticVar() && getComponentID() == other.getComponentID();
  }

 private:
  std::string modelVar_;   ///< model variable
  std::string staticVar_;  ///< static variable
  std::string componentID_;  ///< component ID
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDSTATICREF_H_
