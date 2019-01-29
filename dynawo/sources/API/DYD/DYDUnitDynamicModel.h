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
 * @file DYDUnitDynamicModel.h
 * @brief Modelica models description : interface file
 *
 */

#ifndef API_DYD_DYDUNITDYNAMICMODEL_H_
#define API_DYD_DYDUNITDYNAMICMODEL_H_

#include <string>

#include "DYDExport.h"

namespace dynamicdata {

/**
 * @class UnitDynamicModel
 * @brief Modelica dynamic model interface class
 *
 * UnitDynamicModel objects describe a device's dynamic modelisation
 * composed of a Modelica file associated with an adapted set of parameters
 */
class __DYNAWO_DYD_EXPORT UnitDynamicModel {
 public:
  /**
   * @brief Model id getter
   *
   * @returns Model id
   */
  virtual std::string getId() const = 0;

  /**
   * @brief parameters file setter
   *
   * @param[in] parFile parameters file for this model
   * @return Reference to current Model instance
   */
  virtual UnitDynamicModel& setParFile(const std::string& parFile) = 0;

  /**
   * @brief parameters id setter
   *
   * @param[in] parId id to use for set of parameters inside the parameters file
   * @return Reference to current Model instance
   */
  virtual UnitDynamicModel& setParId(const std::string& parId) = 0;

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
   * @brief Dynamic model name getter
   *
   * @return Dynamic model name
   */
  virtual std::string getDynamicModelName() const = 0;

  /**
   * @brief Model file path getter
   *
   * @return Modelica model file path
   */
  virtual std::string getDynamicFileName() const = 0;

  /**
   * @brief Initialisation model name getter
   *
   * @return Modelica initialisation model name
   */
  virtual std::string getInitModelName() const = 0;

  /**
   * @brief Initialisation model file path getter
   *
   * @return Modelica initialisation model file path
   */
  virtual std::string getInitFileName() const = 0;

  /**
   * @brief Model file path setter
   *
   * @param[in] path Modelica model file path
   * @return Reference to current UnitDynamicModel instance
   */
  virtual UnitDynamicModel& setDynamicFileName(const std::string& path) = 0;

  /**
   * @brief Initialisation model name setter
   *
   * @param[in] name Modelica initialisation model name
   * @return Reference to current UnitDynamicModel instance
   */
  virtual UnitDynamicModel& setInitModelName(const std::string& name) = 0;

  /**
   * @brief Initialisation model file path setter
   *
   * @param[in] path Modelica initialisation model file path
   * @return Reference to current UnitDynamicModel instance
   */
  virtual UnitDynamicModel& setInitFileName(const std::string& path) = 0;

  /**
   * @brief equality operator : compare two unitDynamicModels
   *
   * @param other other unitDynamicModel to compare with
   *
   * @return @b whether dynamic/init modelName and dynamic/init model file are equal
   */
  inline bool operator==(const UnitDynamicModel& other) const {
    if (getDynamicModelName() == other.getDynamicModelName()
            && getDynamicFileName() == other.getDynamicFileName()
            && getInitModelName() == other.getInitModelName()
            && getInitFileName() == other.getInitFileName())
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
    if (getDynamicModelName() != other.getDynamicModelName()
            || getDynamicFileName() != other.getDynamicFileName()
            || getInitModelName() != other.getInitModelName()
            || getInitFileName() != other.getInitFileName())
      return true;

    return false;
  }

  class Impl;  ///< Implementation class
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDUNITDYNAMICMODEL_H_
