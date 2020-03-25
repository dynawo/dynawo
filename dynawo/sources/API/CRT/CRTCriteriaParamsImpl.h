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
   * @copydoc CriteriaParams::setUMaxPu(double uMaxPu)
   */
  void setUMaxPu(double uMaxPu);

  /**
   * @copydoc CriteriaParams::getUMaxPu() const
   */
  double getUMaxPu() const;

  /**
   * @copydoc CriteriaParams::hasUMaxPu() const
   */
  bool hasUMaxPu() const;

  /**
   * @copydoc CriteriaParams::setUNomMax(double uNomMax)
   */
  void setUNomMax(double uNomMax);

  /**
   * @copydoc CriteriaParams::getUNomMax() const
   */
  double getUNomMax() const;

  /**
   * @copydoc CriteriaParams::hasUNomMax() const
   */
  bool hasUNomMax() const;

  /**
   * @copydoc CriteriaParams::setUMinPu(double uMinPu)
   */
  void setUMinPu(double uMinPu);

  /**
   * @copydoc CriteriaParams::getUMinPu() const
   */
  double getUMinPu() const;

  /**
   * @copydoc CriteriaParams::hasUMinPu() const
   */
  bool hasUMinPu() const;

  /**
   * @copydoc CriteriaParams::setUNomMin(double uNomMin)
   */
  void setUNomMin(double uNomMin);

  /**
   * @copydoc CriteriaParams::getUNomMin() const
   */
  double getUNomMin() const;

  /**
   * @copydoc CriteriaParams::hasUNomMin() const
   */
  bool hasUNomMin() const;

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
  double uMinPu_;  ///< minimum voltage in p.u.
  double uMaxPu_;  ///< maximum voltage in p.u.
  double uNomMin_;  ///< minimum nominal voltage in kV
  double uNomMax_;  ///< maximum nominal voltage in kV
  double pMin_;  ///< minimum active power in MW
  double pMax_;  ///< maximum active power in MW
  std::string id_;  ///< criteria id
};

}  // namespace criteria

#endif  // API_CRT_CRTCRITERIAPARAMSIMPL_H_
