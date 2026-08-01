//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file DYDUnitDynamicModel.h
 * @brief Modelica models description : interface file
 *
 */

#ifndef API_DYD_DYDUNITDYNAMICMODEL_H_
#define API_DYD_DYDUNITDYNAMICMODEL_H_

#include <string>

namespace dynamicdata {

/**
 * @class UnitDynamicModel
 * @brief Modelica dynamic model interface class
 *
 * UnitDynamicModel objects describe a device's dynamic modelisation
 * composed of a Modelica file associated with an adapted set of parameters
 */
class UnitDynamicModel {
 public:
  /**
   * @brief UnitDynamicModel constructor
   *
   * UnitDynamicModel constructor.
   *
   * @param id Dynamic model ID
   * @param name name of the model
   */
  UnitDynamicModel(const std::string& id, const std::string& name);

  /**
   * @brief Model id getter
   *
   * @returns Model id
   */
  const std::string& getId() const;

  /**
   * @brief parameters file setter
   *
   * @param[in] parFile parameters file for this model
   * @return Reference to current Model instance
   */
  UnitDynamicModel& setParFile(const std::string& parFile);

  /**
   * @brief parameters id setter
   *
   * @param[in] parId id to use for set of parameters inside the parameters file
   * @return Reference to current Model instance
   */
  UnitDynamicModel& setParId(const std::string& parId);

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

  /**
   * @brief Dynamic model name getter
   *
   * @return Dynamic model name
   */
  const std::string& getDynamicModelName() const;

  /**
   * @brief Model file path getter
   *
   * @return Modelica model file path
   */
  const std::string& getDynamicFileName() const;

  /**
   * @brief Initialisation model name getter
   *
   * @return Modelica initialisation model name
   */
  const std::string& getInitModelName() const;

  /**
   * @brief Initialisation model file path getter
   *
   * @return Modelica initialisation model file path
   */
  const std::string& getInitFileName() const;

  /**
   * @brief Model file path setter
   *
   * @param[in] path Modelica model file path
   * @return Reference to current UnitDynamicModel instance
   */
  UnitDynamicModel& setDynamicFileName(const std::string& path);

  /**
   * @brief Initialisation model name setter
   *
   * @param[in] name Modelica initialisation model name
   * @return Reference to current UnitDynamicModel instance
   */
  UnitDynamicModel& setInitModelName(const std::string& name);

  /**
   * @brief Initialisation model file path setter
   *
   * @param[in] path Modelica initialisation model file path
   * @return Reference to current UnitDynamicModel instance
   */
  UnitDynamicModel& setInitFileName(const std::string& path);

  /**
   * @brief equality operator : compare two unitDynamicModels
   *
   * @param other other unitDynamicModel to compare with
   *
   * @return @b whether dynamic/init modelName and dynamic/init model file are equal
   */
  inline bool operator==(const UnitDynamicModel& other) const {
    if (getDynamicModelName() == other.getDynamicModelName() && getDynamicFileName() == other.getDynamicFileName() &&
        getInitModelName() == other.getInitModelName() && getInitFileName() == other.getInitFileName())
      return true;

    return false;
  }

  /**
   * @brief comparaison operator : compare two unitDynamicModels
   *
   * @param other other unitDynamicModel to compare with
   *
   * @return @b whether models are different (at least one different attribute)
   */
  inline bool operator!=(const UnitDynamicModel& other) const {
    if (getDynamicModelName() != other.getDynamicModelName() || getDynamicFileName() != other.getDynamicFileName() ||
        getInitModelName() != other.getInitModelName() || getInitFileName() != other.getInitFileName())
      return true;

    return false;
  }

 private:
  std::string id_;                ///< Unit dynamic model id;
  std::string parFile_;           ///< name of the parameter file
  std::string parId_;             ///< id of the set of parameter for the unit dynamic model
  std::string dynamicModelName_;  ///< Name of the model's Modelica dynamic class
  std::string dynamicFileName_;   ///< Name of the model's Modelica dynamic file
  std::string initModelName_;     ///< Name of the model's Modelica init class
  std::string initFileName_;      ///< Name of the model's Modelica init file
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDUNITDYNAMICMODEL_H_
