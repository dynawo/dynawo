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
   * @brief Destructor
   */
  virtual ~StaticRef() {}
  /**
   * @brief Model Variable setter
   * @param modelVar model variable
   */
  virtual void setModelVar(const std::string& modelVar) = 0;
  /**
   * @brief Static Variable setter
   * @param staticVar static variable
   */
  virtual void setStaticVar(const std::string& staticVar) = 0;

  /**
   * @brief Model variable getter
   * @return model variable
   */
  virtual std::string getModelVar() const = 0;
  /**
   * @brief Static Variable getter
   * @return static variable
   */
  virtual std::string getStaticVar() const = 0;

  /**
   * @brief compare two staticRef
   *
   * @param other other staticRef to compare with
   *
   * @return @b true staticRef are equals (same var and staticVar)
   *         @b false else
   */
  inline bool operator==(const StaticRef& other) {
    if (getModelVar() == other.getModelVar()
            && getStaticVar() == other.getStaticVar())
      return true;

    return false;
  }

  class Impl;  ///< Implementation class
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDSTATICREF_H_
