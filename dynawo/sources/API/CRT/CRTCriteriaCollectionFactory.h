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

#ifndef API_CRT_CRTCRITERIACOLLECTIONFACTORY_H_
#define API_CRT_CRTCRITERIACOLLECTIONFACTORY_H_


#include "CRTCriteriaCollection.h"


namespace criteria {
/**
 * @class CriteriaCollectionFactory
 * @brief Criteria collection factory class
 *
 * CriteriaCollectionFactory encapsulate methods for creating new
 * @p CriteriaCollection objects.
 */
class CriteriaCollectionFactory {
 public:
  /**
   * @brief Create new CriteriaCollection instance
   *
   * @return unique pointer to a new empty @p CriteriaCollection
   */
  static std::unique_ptr<CriteriaCollection> newInstance();
};
}  // namespace criteria

#endif  // API_CRT_CRTCRITERIACOLLECTIONFACTORY_H_
