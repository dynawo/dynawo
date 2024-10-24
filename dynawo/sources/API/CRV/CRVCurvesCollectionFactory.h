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
 * @file  CRVCurvesCollectionFactory.h
 *
 * @brief Dynawo Curves collection factory : header file
 *
 */
#ifndef API_CRV_CRVCURVESCOLLECTIONFACTORY_H_
#define API_CRV_CRVCURVESCOLLECTIONFACTORY_H_

#include "CRVCurvesCollection.h"

namespace curves {
/**
 * @class CurvesCollectionFactory
 * @brief Curves collection factory class
 *
 * CurvesCollectionFactory encapsulate methods for creating new
 * @p CurvesCollection objects.
 */
class CurvesCollectionFactory {
 public:
  /**
   * @brief Create new CurvesCollection instance
   *
   * @param id id of the new instance
   *
   * @return unique pointer to a new empty @p CurvesCollection
   */
  static std::unique_ptr<CurvesCollection> newInstance(const std::string& id);

  /**
   * @brief Create new CurvesCollection instance as a clone of given instance
   *
   * @param[in] original CurvesCollection to be cloned
   *
   * @return Unique pointer to a new @p CurvesCollection copied from original
   */
  static std::unique_ptr<CurvesCollection> copyInstance(const std::shared_ptr<CurvesCollection>& original);

  /**
   * @brief Create new CurvesCollection instance as a clone of given instance
   *
   * @param[in] original CurvesCollection to be cloned
   *
   * @return Unique pointer to a new @p CurvesCollection copied from original
   */
  static std::unique_ptr<CurvesCollection> copyInstance(const CurvesCollection& original);
};
}  // namespace curves

#endif  // API_CRV_CRVCURVESCOLLECTIONFACTORY_H_
