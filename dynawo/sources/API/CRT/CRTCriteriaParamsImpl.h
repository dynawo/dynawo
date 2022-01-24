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
#ifndef API_CRT_CRTCRITERIAPARAMSIMPL_H_
#define API_CRT_CRTCRITERIAPARAMSIMPL_H_

#include "CRTCriteriaParams.h"

namespace criteria {

/**
 * @class CriteriaParams::Impl
 * @brief CriteriaParams implementation class
 *
 * Implementation class for criteria parameters object.
 */
class CriteriaParams::Impl : public CriteriaParams {
 public:
  /**
   * @brief Constructor
   */
  Impl();

  /**
   * @brief Destructor
   */
  virtual ~Impl() { }

  /**
   * @copydoc CriteriaParams::setScope(CriteriaScope_t scope)
   */
  void setScope(CriteriaScope_t scope);

  /**
   * @copydoc CriteriaParams::getScope() const
   */
  CriteriaScope_t getScope() const;

  /**
   * @copydoc CriteriaParams::setType(CriteriaType_t type)
   */
  void setType(CriteriaType_t type);

  /**
   * @copydoc CriteriaParams::getType() const
   */
  CriteriaType_t getType() const;

  /**
   * @copydoc CriteriaParams::setId(const std::string& id)
   */
  void setId(const std::string& id);

  /**
   * @copydoc CriteriaParams::getId() const
   */
  const std::string& getId() const;

  /**
   * @copydoc CriteriaParams::addVoltageLevel(const CriteriaParamsVoltageLevel& vl)
   */
  void addVoltageLevel(const CriteriaParamsVoltageLevel& vl);

  /**
   * @copydoc CriteriaParams::getVoltageLevels() const
   */
  const std::vector<CriteriaParamsVoltageLevel>& getVoltageLevels() const;

  /**
   * @copydoc CriteriaParams::hasVoltageLevels() const
   */
  bool hasVoltageLevels() const;

  /**
   * @copydoc CriteriaParams::setPMax(double pMax)
   */
  void setPMax(double pMax);

  /**
   * @copydoc CriteriaParams::getPMax() const
   */
  double getPMax() const;

  /**
   * @copydoc CriteriaParams::hasPMax() const
   */
  bool hasPMax() const;

  /**
   * @copydoc CriteriaParams::setPMin(double pMin)
   */
  void setPMin(double pMin);

  /**
   * @copydoc CriteriaParams::getPMin() const
   */
  double getPMin() const;

  /**
   * @copydoc CriteriaParams::hasPMin() const
   */
  bool hasPMin() const;

 private:
  CriteriaParams::CriteriaScope_t scope_;  ///< scope of the criteria
  CriteriaType_t type_;  ///< type of the criteria
  double pMin_;  ///< minimum active power in MW
  double pMax_;  ///< maximum active power in MW
  std::vector<CriteriaParamsVoltageLevel> voltageLevels_;  ///< voltage levels
  std::string id_;  ///< criteria id
};

}  // namespace criteria

#endif  // API_CRT_CRTCRITERIAPARAMSIMPL_H_
