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
 * @file DYDBlackBoxModel.h
 * @brief Blackbox model description : interface file
 *
 */

#ifndef API_DYD_DYDBLACKBOXMODEL_H_
#define API_DYD_DYDBLACKBOXMODEL_H_

#include <map>
#include <vector>

#include "DYDExport.h"
#include "DYDModel.h"


namespace dynamicdata {

/**
 * @class BlackBoxModel
 * @brief Blackbox model interface class
 *
 * BlackBoxModel objects describe black box models
 * objects connected with other models through
 */
class __DYNAWO_DYD_EXPORT BlackBoxModel : public Model {
 public:
  /**
   * @brief Model library getter
   *
   * @returns Model library absolute path
   */
  virtual std::string getLib() const = 0;

  /**
   * @brief Model library setter
   *
   * @param[in] lib Model library absolute path
   * @returns Reference to current BlackBoxModel instance
   */
  virtual BlackBoxModel& setLib(const std::string& lib) = 0;

  /**
   * @brief Network Identifiable device modeled getter

   * @returns Id of Network Identifiable device modeled
   */
  virtual std::string getStaticId() const = 0;

  /**
   * @brief Network Identifiable device modeled setter
   *
   * @param[in] staticId of modeledDevice Network Identifiable device modeled
   * @returns Reference to current Model instance
   */
  virtual BlackBoxModel& setStaticId(const std::string& staticId) = 0;

  /**
   * @brief parameters file setter
   *
   * @param[in] parFile parameters file for this model
   * @return Reference to current Model instance
   */
  virtual BlackBoxModel& setParFile(const std::string& parFile) = 0;

  /**
   * @brief parameters id setter
   *
   * @param[in] parId id to use for set of parameters inside the parameters file
   * @return Reference to current Model instance
   */
  virtual BlackBoxModel& setParId(const std::string& parId) = 0;

  /**
   * @brief parameters file getter
   * @return parameters file for this model
   */
  virtual std::string getParFile() const = 0;

  /**
   * @brief parameters id getter
   * @return parameters id for this model
   */
  virtual std::string getParId() const = 0;

  /**
   * @brief  implementation class
   *
   */
  class Impl;  // Implementation class
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDBLACKBOXMODEL_H_
