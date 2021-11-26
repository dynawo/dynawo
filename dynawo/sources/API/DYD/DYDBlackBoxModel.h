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

#include "DYDModel.h"

#include <map>
#include <vector>

namespace dynamicdata {

/**
 * @class BlackBoxModel
 * @brief Blackbox model interface class
 *
 * BlackBoxModel objects describe black box models
 * objects connected with other models through
 */
class BlackBoxModel : public Model {
 public:
  /**
   * @brief Constructor
   *
   * @param id Blackbox model's ID
   */
  explicit BlackBoxModel(const std::string& id);

  /**
   * @brief Destructor
   */
  virtual ~BlackBoxModel();

  /**
   * @brief Model library getter
   *
   * @returns Model library absolute path
   */
  const std::string& getLib() const;

  /**
   * @brief Model library setter
   *
   * @param[in] lib Model library absolute path
   * @returns Reference to current BlackBoxModel instance
   */
  BlackBoxModel& setLib(const std::string& lib);

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
  BlackBoxModel& setStaticId(const std::string& staticId);

  /**
   * @brief parameters file setter
   *
   * @param[in] parFile parameters file for this model
   * @return Reference to current Model instance
   */
  BlackBoxModel& setParFile(const std::string& parFile);

  /**
   * @brief parameters id setter
   *
   * @param[in] parId id to use for set of parameters inside the parameters file
   * @return Reference to current Model instance
   */
  BlackBoxModel& setParId(const std::string& parId);

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
  std::string lib_;       ///< Model's library name
  std::string staticId_;  ///< Identifiable device modeled by dynamic model
  std::string parFile_;   ///< name of the parameter file
  std::string parId_;     ///< id of the set of parameter for the model
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDBLACKBOXMODEL_H_
