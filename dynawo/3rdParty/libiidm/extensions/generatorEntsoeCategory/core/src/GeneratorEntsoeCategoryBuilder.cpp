//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libiidm, a library to model IIDM networks and allows
// importing and exporting them to files.
//

/**
 * @file GeneratorEntsoeCategoryBuilder.cpp
 * @brief Provides GeneratorEntsoeCategoryBuilder
 */

#include <IIDM/extensions/generatorEntsoeCategory/GeneratorEntsoeCategoryBuilder.h>

namespace IIDM {
namespace extensions {
namespace generator_entsoe_category {

GeneratorEntsoeCategory GeneratorEntsoeCategoryBuilder::build() const {
  GeneratorEntsoeCategory builded;
  builded.m_code = m_code;
  return builded;
}

} // end of namespace IIDM::extensions::generator_entsoe_category::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
