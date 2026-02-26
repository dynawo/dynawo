//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#ifndef API_CRT_CRTCRITERIAPARAMS_H_
#define API_CRT_CRTCRITERIAPARAMS_H_

#include "CRTCriteriaParamsVoltageLevel.h"

#include <string>
#include <vector>

namespace criteria {

/**
 * @class CriteriaParams
 * @brief CriteriaParams interface class
 *
 * Interface class for criteria parameters object.
 */
class CriteriaParams {
 public:
  /**
  * define scope of the criteria
  */
  typedef enum {
    UNDEFINED_SCOPE,
    FINAL,            ///< evaluated only at the final time step of the simulation
    DYNAMIC           ///< evaluated at all time steps of the simulation
  } CriteriaScope_t;  ///< criteria scope

  /**
* define type of the criteria
*/
  typedef enum {
    UNDEFINED_TYPE,
    LOCAL_VALUE,     ///< evaluation values per values
    SUM              ///< sum over all the values
  } CriteriaType_t;  ///< criteria type

  /**
 * @brief get scope corresponding a string
 * @param str scope string
 * @return scope corresponding str
 */
  static CriteriaScope_t string2Scope(const std::string& str) {
    if (str == "FINAL")
      return FINAL;
    if (str == "DYNAMIC")
      return DYNAMIC;
    return UNDEFINED_SCOPE;
  }

  /**
 * @brief get type corresponding a string
 * @param str type string
 * @return type corresponding str
 */
  static CriteriaType_t string2Type(const std::string& str) {
    if (str == "LOCAL_VALUE")
      return LOCAL_VALUE;
    if (str == "SUM")
      return SUM;
    return UNDEFINED_TYPE;
  }

 public:
  /**
   * @brief Constructor
   */
  CriteriaParams();

  /**
   * @brief Setter for criteria scope
   * @param scope criteria scope
   */
  void setScope(CriteriaScope_t scope);

  /**
   * @brief Getter for criteria scope
   * @return criteria scope
   */
  CriteriaScope_t getScope() const;

  /**
   * @brief Setter for criteria type
   * @param type criteria type
   */
  void setType(CriteriaType_t type);

  /**
   * @brief Getter for criteria type
   * @return criteria type
   */
  CriteriaType_t getType() const;

  /**
   * @brief Setter for criteria id
   * @param id criteria id
   */
  void setId(const std::string& id);

  /**
   * @brief Getter for criteria id
   * @return criteria id
   */
  const std::string& getId() const;

  /**
   * @brief Add a voltage level
   * @param vl voltage level to add
   */
  void addVoltageLevel(const CriteriaParamsVoltageLevel& vl);

  /**
   * @brief Getter for voltage levels
   * @return voltage levels
   */
  const std::vector<CriteriaParamsVoltageLevel>& getVoltageLevels() const;

  /**
   * @brief return true if at least one voltage level was defined
   * @return true if at least one voltage level was defined
   */
  bool hasVoltageLevels() const;

  /**
   * @brief Setter for maximum active power
   * @param pMax maximum active power
   */
  void setPMax(double pMax);

  /**
   * @brief Getter for maximum active power
   * @return maximum active power
   */
  double getPMax() const;

  /**
   * @brief return true if pMax has been defined
   * @return true if pMax has been defined
   */
  bool hasPMax() const;

  /**
   * @brief Setter for minimum active power
   * @param pMin minimum active power
   */
  void setPMin(double pMin);

  /**
   * @brief Getter for minimum active power
   * @return minimum active power
   */
  double getPMin() const;

  /**
   * @brief return true if pMin has been defined
   * @return true if pMin has been defined
   */
  bool hasPMin() const;

 private:
  CriteriaScope_t scope_;  ///< scope of the criteria
  CriteriaType_t type_;    ///< type of the criteria
  double pMin_;            ///< minimum active power in MW
  double pMax_;            ///< maximum active power in MW
  std::vector<CriteriaParamsVoltageLevel> voltageLevels_;  ///< voltage levels
  std::string id_;         ///< criteria id
};

}  // namespace criteria

#endif  // API_CRT_CRTCRITERIAPARAMS_H_
