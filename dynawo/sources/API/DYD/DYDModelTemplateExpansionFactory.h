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
 * @file DYDModelTemplateExpansionFactory.h
 * @brief model template expansion factory : header file
 *
 */

#ifndef API_DYD_DYDMODELTEMPLATEEXPANSIONFACTORY_H_
#define API_DYD_DYDMODELTEMPLATEEXPANSIONFACTORY_H_

#include "DYDModelTemplateExpansion.h"

#include <boost/shared_ptr.hpp>

namespace dynamicdata {

/**
 * @class ModelTemplateExpansionFactory
 * @brief ModelTemplateExpansionFactory factory class
 *
 * ModelTemplateExpansionFactory encapsulate methods for creating new
 * @p ModelTemplateExpansion objects.
 */
class ModelTemplateExpansionFactory {
 public:
  /**
   * @brief Create new ModelTemplateExpansion instance
   *
   * @param[in] modelId ID for new ModelTemplateExpansion instance
   * @returns Shared pointer to a new @p ModelTemplateExpansion with given ID
   */
  static boost::shared_ptr<ModelTemplateExpansion> newModel(const std::string& modelId);
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMODELTEMPLATEEXPANSIONFACTORY_H_
