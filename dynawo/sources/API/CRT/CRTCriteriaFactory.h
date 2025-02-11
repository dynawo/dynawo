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

#ifndef API_CRT_CRTCRITERIAFACTORY_H_
#define API_CRT_CRTCRITERIAFACTORY_H_


#include "CRTCriteria.h"

namespace criteria {
/**
 * @class CriteriaFactory
 * @brief CriteriaFactory factory class
 *
 * CriteriaFactory encapsulates methods for creating new
 * @p Criteria objects.
 */
class CriteriaFactory {
 public:
  /**
   * @brief Create new Criteria instance
   *
   * @returns a unique pointer to a new @p Criteria
   */
  static std::unique_ptr<Criteria> newCriteria();
};

}  //  namespace criteria

#endif  // API_CRT_CRTCRITERIAFACTORY_H_
