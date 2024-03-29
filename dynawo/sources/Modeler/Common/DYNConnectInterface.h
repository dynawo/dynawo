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
 * @file DYNConnectInterface.h
 * @brief Connect interface structure header file
 */
#ifndef MODELER_COMMON_DYNCONNECTINTERFACE_H_
#define MODELER_COMMON_DYNCONNECTINTERFACE_H_

#include <string>

namespace DYN {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class ConnectInterface
 * @brief connections of a model
 */
class ConnectInterface {  ///< Generic class for connecting two dynamic models
 public:
  /**
   * @brief default destructor.
   */
  virtual ~ConnectInterface() = default;

  /**
   * @brief set first model
   * @param model first model
   */
  inline void setConnectedModel1(const std::string& model) {
    connectedModel1_ = model;
  }

  /**
   * @brief set first model variable
   * @param var variable
   */
  inline void setModel1Var(const std::string& var) {
    model1Var_ = var;
  }

  /**
   * @brief set second model
   * @param model second model
   */
  inline void setConnectedModel2(const std::string& model) {
    connectedModel2_ = model;
  }

  /**
   * @brief set second model variable
   * @param var variable
   */
  inline void setModel2Var(const std::string& var) {
    model2Var_ = var;
  }

  /**
   * @brief get first model
   * @returns Compiled Model name
   */
  inline std::string getConnectedModel1() const {
    return connectedModel1_;
  }

  /**
   * @brief get first model variable
   * @returns first model variable
   */
  inline std::string getModel1Var() const {
    return model1Var_;
  }

  /**
   * @brief get second model
   * @returns second model
   */
  inline std::string getConnectedModel2() const {
    return connectedModel2_;
  }

  /**
   * @brief get second model variable
   * @returns second model variable
   */
  inline std::string getModel2Var() {
    return model2Var_;
  }

 private:
  std::string connectedModel1_;  ///< first model
  std::string model1Var_;  ///< first model's variable
  std::string connectedModel2_;  ///< second model
  std::string model2Var_;  ///< second model's variable
};  ///< interface class for dynamic connections

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_COMMON_DYNCONNECTINTERFACE_H_
