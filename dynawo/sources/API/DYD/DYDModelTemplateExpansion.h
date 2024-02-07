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

#include "DYDModel.h"

#include <map>
#include <vector>

namespace dynamicdata {

/**
 * @class ModelTemplateExpansion
 * @brief Blackbox model interface class
 *
 * ModelTemplateExpansion objects describe black box models
 * objects connected with other models through
 */

class ModelTemplateExpansion : public Model {
 public:
  /**
   * @brief Constructor
   *
   * @param id Model template expansion's ID
   */
  explicit ModelTemplateExpansion(const std::string& id);

  /**
   * @brief Destructor
   */
  virtual ~ModelTemplateExpansion() = default;

  /**
   * @brief Template Model getter
   *
   * @returns Template Model absolute path
   */
  const std::string& getTemplateId() const;

  /**
   * @brief Template Model setter
   *
   * @param[in] templateId template model id
   * @returns Reference to current ModelTemplateExpansion instance
   */
  ModelTemplateExpansion& setTemplateId(const std::string& templateId);

  /**
   * @brief Network Identifiable device modeled getter

   * @returns Id of Network Identifiable device modeled
   */
  const std::string& getStaticId() const;

  /**
   * @brief Network Identifiable device modeled setter
   *
   * @param[in] staticId of modeledDevice Network Identifiable device modeled
   * @returns Reference to current Model instance
   */
  ModelTemplateExpansion& setStaticId(const std::string& staticId);

  /**
   * @brief parameters file setter
   *
   * @param[in] parFile parameters file for this model
   * @return Reference to current Model instance
   */
  ModelTemplateExpansion& setParFile(const std::string& parFile);

  /**
   * @brief parameters id setter
   *
   * @param[in] parId id to use for set of parameters inside the parameters file
   * @return Reference to current Model instance
   */
  ModelTemplateExpansion& setParId(const std::string& parId);

  /**
   * @brief parameters file getter
   * @return parameters file for this model
   */
  const std::string& getParFile() const;

  /**
   * @brief parameters id getter
   * @return parameters id for this model
   */
  const std::string& getParId() const;

 private:
  std::string templateId_; /**< template model id*/
  std::string staticId_;   ///< Identifiable device modeled by dynamic model
  std::string parFile_;    ///< name of the parameter file
  std::string parId_;      ///< id of the set of parameter for the model
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMODELTEMPLATEEXPANSION_H_
