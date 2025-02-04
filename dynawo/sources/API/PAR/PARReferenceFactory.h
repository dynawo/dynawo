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
 * @file PARReferenceFactory.h
 * @brief Dynawo reference factory : header file
 *
 */

#ifndef API_PAR_PARREFERENCEFACTORY_H_
#define API_PAR_PARREFERENCEFACTORY_H_

#include "PARReference.h"

#include <memory>


namespace parameters {

/**
 * @class ReferenceFactory
 * @brief Reference factory class
 *
 * ReferenceFactory encapsulates methods for creating new
 * @p Reference objects.
 */
class ReferenceFactory {
 public:
  /**
   * @brief Create new Reference instance
   *
   * @param[in] name reference name
   * @param[in] origData origin of the data
   *
   * @returns Unique pointer to a new @p Reference
   */
  static std::unique_ptr<Reference> newReference(const std::string& name, Reference::OriginData origData);
};

}  // namespace parameters

#endif  // API_PAR_PARREFERENCEFACTORY_H_
