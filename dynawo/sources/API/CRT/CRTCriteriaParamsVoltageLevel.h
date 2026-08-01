//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
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

#ifndef API_CRT_CRTCRITERIAPARAMSVOLTAGELEVEL_H_
#define API_CRT_CRTCRITERIAPARAMSVOLTAGELEVEL_H_

namespace criteria {

/**
 * @class CriteriaParamsVoltageLevel
 * @brief CriteriaParamsVoltageLevel interface class
 *
 * Interface class for criteria parameters voltage level object.
 */
class CriteriaParamsVoltageLevel {
 public:
  /**
   * @brief Constructor
   */
  CriteriaParamsVoltageLevel();

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
   * @brief return true if no value was defined in this voltage level
   * @return true if no value was defined in this voltage level
   */
  bool empty() const;

  /**
   * @brief reset the values to default
   */
  void reset();

 private:
  double uMinPu_;          ///< minimum voltage in pu
  double uMaxPu_;          ///< maximum voltage in pu
  double uNomMin_;         ///< minimum nominal voltage in kV
  double uNomMax_;         ///< maximum nominal voltage in kV
};

}  // namespace criteria

#endif  // API_CRT_CRTCRITERIAPARAMSVOLTAGELEVEL_H_
