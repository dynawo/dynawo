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
  FINAL,  ///< evaluated only at the final time step of the simulation
  DYNAMIC  ///< evaluated at all time steps of the simulation
} CriteriaScope_t;  ///< criteria scope

/**
* define type of the criteria
*/
typedef enum {
  UNDEFINED_TYPE,
  LOCAL_VALUE,  ///< evaluation values per values
  SUM  ///< sum over all the values
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

  /**
   * @brief Destructor
   */
  virtual ~CriteriaParams() { }

  /**
   * @brief Setter for criteria scope
   * @param scope criteria scope
   */
  virtual void setScope(CriteriaScope_t scope) = 0;

  /**
   * @brief Getter for criteria scope
   * @return criteria scope
   */
  virtual CriteriaScope_t getScope() const = 0;

  /**
   * @brief Setter for criteria type
   * @param type criteria type
   */
  virtual void setType(CriteriaType_t type) = 0;

  /**
   * @brief Getter for criteria type
   * @return criteria type
   */
  virtual CriteriaType_t getType() const = 0;

  /**
   * @brief Setter for criteria id
   * @param id criteria id
   */
  virtual void setId(const std::string& id) = 0;

  /**
   * @brief Getter for criteria id
   * @return criteria id
   */
  virtual const std::string& getId() const = 0;

  /**
   * @brief Setter for maximum voltage
   * @param uMaxPu maximum voltage
   */
  virtual void setUMaxPu(double uMaxPu) = 0;

  /**
   * @brief Getter for maximum voltage
   * @return maximum voltage
   */
  virtual double getUMaxPu() const = 0;

  /**
   * @brief return true if uMax has been defined
   * @return true if uMax has been defined
   */
  virtual bool hasUMaxPu() const = 0;

  /**
   * @brief Setter for maximum nominal voltage
   * @param uMaxNom maximum nominal voltage
   */
  virtual void setUMaxNom(double uMaxNom) = 0;

  /**
   * @brief Getter for maximum nominal voltage
   * @return maximum nominal voltage
   */
  virtual double getUMaxNom() const = 0;

  /**
   * @brief return true if uMaxNom has been defined
   * @return true if uMaxNom has been defined
   */
  virtual bool hasUMaxNom() const = 0;

  /**
   * @brief Setter for minimum voltage
   * @param uMin minimum voltage
   */
  virtual void setUMinPu(double uMin) = 0;

  /**
   * @brief Getter for minimum voltage
   * @return minimum voltage
   */
  virtual double getUMinPu() const = 0;

  /**
   * @brief return true if uMin has been defined
   * @return true if uMin has been defined
   */
  virtual bool hasUMinPu() const = 0;

  /**
   * @brief Setter for minimum nominal voltage
   * @param uMinNom minimum nominal voltage
   */
  virtual void setUMinNom(double uMinNom) = 0;

  /**
   * @brief Getter for minimum nominal voltage
   * @return minimum nominal voltage
   */
  virtual double getUMinNom() const = 0;

  /**
   * @brief return true if uMinNom has been defined
   * @return true if uMinNom has been defined
   */
  virtual bool hasUMinNom() const = 0;

  /**
   * @brief Setter for maximum active power
   * @param pMax maximum active power
   */
  virtual void setPMax(double pMax) = 0;

  /**
   * @brief Getter for maximum active power
   * @return maximum active power
   */
  virtual double getPMax() const = 0;

  /**
   * @brief return true if pMax has been defined
   * @return true if pMax has been defined
   */
  virtual bool hasPMax() const = 0;

  /**
   * @brief Setter for minimum active power
   * @param pMin minimum active power
   */
  virtual void setPMin(double pMin) = 0;

  /**
   * @brief Getter for minimum active power
   * @return minimum active power
   */
  virtual double getPMin() const = 0;

  /**
   * @brief return true if pMin has been defined
   * @return true if pMin has been defined
   */
  virtual bool hasPMin() const = 0;


  class Impl;
};

}  // namespace criteria

#endif  // API_CRT_CRTCRITERIAPARAMS_H_
