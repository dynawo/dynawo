//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#ifndef API_CRT_CRTCRITERIAPARAMS_H_
#define API_CRT_CRTCRITERIAPARAMS_H_

#include <string>

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
   * @brief Setter for maximum voltage
   * @param uMaxPu maximum voltage
   */
  void setUMaxPu(double uMaxPu);

  /**
   * @brief Getter for maximum voltage
   * @return maximum voltage
   */
  double getUMaxPu() const;

  /**
   * @brief return true if uMax has been defined
   * @return true if uMax has been defined
   */
  bool hasUMaxPu() const;

  /**
   * @brief Setter for maximum nominal voltage
   * @param uNomMax maximum nominal voltage
   */
  void setUNomMax(double uNomMax);

  /**
   * @brief Getter for maximum nominal voltage
   * @return maximum nominal voltage
   */
  double getUNomMax() const;

  /**
   * @brief return true if uNomMax has been defined
   * @return true if uNomMax has been defined
   */
  bool hasUNomMax() const;

  /**
   * @brief Setter for minimum voltage
   * @param uMinPu minimum voltage
   */
  void setUMinPu(double uMinPu);

  /**
   * @brief Getter for minimum voltage
   * @return minimum voltage
   */
  double getUMinPu() const;

  /**
   * @brief return true if uMin has been defined
   * @return true if uMin has been defined
   */
  bool hasUMinPu() const;

  /**
   * @brief Setter for minimum nominal voltage
   * @param uNomMin minimum nominal voltage
   */
  void setUNomMin(double uNomMin);

  /**
   * @brief Getter for minimum nominal voltage
   * @return minimum nominal voltage
   */
  double getUNomMin() const;

  /**
   * @brief return true if uNomMin has been defined
   * @return true if uNomMin has been defined
   */
  bool hasUNomMin() const;

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
  double uMinPu_;          ///< minimum voltage in pu
  double uMaxPu_;          ///< maximum voltage in pu
  double uNomMin_;         ///< minimum nominal voltage in kV
  double uNomMax_;         ///< maximum nominal voltage in kV
  double pMin_;            ///< minimum active power in MW
  double pMax_;            ///< maximum active power in MW
  std::string id_;         ///< criteria id
};

}  // namespace criteria

#endif  // API_CRT_CRTCRITERIAPARAMS_H_
