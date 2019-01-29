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
 * @file DYDModelTemplateExpansion.h
 * @brief model tempalte expansion description : interface file
 *
 */


#ifndef API_DYD_DYDMODELTEMPLATEEXPANSION_H_
#define API_DYD_DYDMODELTEMPLATEEXPANSION_H_

#include <map>
#include <vector>

#include "DYDExport.h"
#include "DYDModel.h"


namespace dynamicdata {

/**
 * @class ModelTemplateExpansion
 * @brief Blackbox model interface class
 *
 * ModelTemplateExpansion objects describe black box models
 * objects connected with other models through
 */

class __DYNAWO_DYD_EXPORT ModelTemplateExpansion : public Model {
 public:
  /**
   * @brief Template Model getter
   *
   * @returns Template Model absolute path
   */
  virtual std::string getTemplateId() const = 0;

  /**
   * @brief Template Model setter
   *
   * @param[in] templateId template model id
   * @returns Reference to current ModelTemplateExpansion instance
   */
  virtual ModelTemplateExpansion& setTemplateId(const std::string& templateId) = 0;

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
  virtual ModelTemplateExpansion& setStaticId(const std::string& staticId) = 0;

  /**
   * @brief parameters file setter
   *
   * @param[in] parFile parameters file for this model
   * @return Reference to current Model instance
   */
  virtual ModelTemplateExpansion& setParFile(const std::string& parFile) = 0;

  /**
   * @brief parameters id setter
   *
   * @param[in] parId id to use for set of parameters inside the parameters file
   * @return Reference to current Model instance
   */
  virtual ModelTemplateExpansion& setParId(const std::string& parId) = 0;

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

#endif  // API_DYD_DYDMODELTEMPLATEEXPANSION_H_
