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
 * @file DYNStaticRefInterface.h
 * @brief static reference interface structure header file
 */
#ifndef MODELER_COMMON_DYNSTATICREFINTERFACE_H_
#define MODELER_COMMON_DYNSTATICREFINTERFACE_H_

#include <string>

namespace DYN {

/**
 * @class StaticRefInterface
 * @brief StaticRefInterface
 */
class StaticRefInterface {
 public:
  /**
   * @brief default destructor.
   */
  virtual ~StaticRefInterface() { }

  /**
   * @brief set model id
   * @param modelID
   */
  void setModelID(const std::string& modelID) {
    modelID_ = modelID;
  }

  /**
   * @brief set model variable
   * @param modelVar
   */
  void setModelVar(const std::string& modelVar) {
    modelVar_ = modelVar;
  }

  /**
   * @brief set static variable
   * @param staticVar
   */
  void setStaticVar(const std::string& staticVar) {
    staticVar_ = staticVar;
  }

  /**
   * @brief get model id
   * @returns model ID
   */
  std::string getModelID() const {
    return modelID_;
  }

  /**
   * @brief get model var
   * @returns model var
   */
  std::string getModelVar() const {
    return modelVar_;
  }

  /**
   * @brief get static var
   * @returns static var
   */
  std::string getStaticVar() const {
    return staticVar_;
  }

 private:
  std::string modelID_; /**< ID of the model */
  std::string modelVar_; /**< Var name of the model */
  std::string staticVar_; /**< Pin name of the static Device */
};  ///< interface class for static reference


}  // namespace DYN

#endif  // MODELER_COMMON_DYNSTATICREFINTERFACE_H_
