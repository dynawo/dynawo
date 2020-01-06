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
 * @file DYDStaticRefImpl.h
 * @brief StaticRef description : header file
 *
 */

#ifndef API_DYD_DYDSTATICREFIMPL_H_
#define API_DYD_DYDSTATICREFIMPL_H_

#include "DYDStaticRef.h"

namespace dynamicdata {

/**
 * @class StaticRef::Impl
 * @brief StaticRef implemented class
 *
 * Implementation of StaticRef interface.
 */
class StaticRef::Impl : public StaticRef {
 public:
  /**
   * @brief StaticRef constructor
   *
   * Static reference constructor.
   *
   * @returns New StaticRef::Impl instance with void attributes
   */
  Impl() { }
  /**
   * @brief StaticRef constructor
   *
   * Static reference constructor.
   *
   * @param modelVar Dynamic model variable
   * @param staticVar static model variable
   *
   * @returns New StaticRef::Impl instance with given attributes
   */
  Impl(const std::string& modelVar, const std::string& staticVar);

  /**
   * @brief destructor
   */
  virtual ~Impl();

  /**
   * @copydoc StaticRef::setModelVar()
   */
  void setModelVar(const std::string& modelVar);

  /**
   * @copydoc StaticRef::setStaticVar()
   */
  void setStaticVar(const std::string& staticVar);

  /**
   * @copydoc StaticRef::getModelVar()
   */
  std::string getModelVar() const;

  /**
   * @copydoc StaticRef::getStaticVar()
   */
  std::string getStaticVar() const;

 private:
  std::string modelVar_;  ///< model variable
  std::string staticVar_;  ///< static variable
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDSTATICREFIMPL_H_
