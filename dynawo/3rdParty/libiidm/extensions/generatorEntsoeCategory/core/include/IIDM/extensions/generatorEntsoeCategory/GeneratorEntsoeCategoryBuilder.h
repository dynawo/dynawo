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
 * @file IIDM/extensions/generatorEntsoeCategory/GeneratorEntsoeCategoryBuilder.h
 * @brief Provides GeneratorEntsoeCategory interface
 */

#ifndef LIBIIDM_EXTENSIONS_GENERATORENTSOECATEGORY_GUARD_GENERATORENTSOECATEGORY_BUILDER_H
#define LIBIIDM_EXTENSIONS_GENERATORENTSOECATEGORY_GUARD_GENERATORENTSOECATEGORY_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/generatorEntsoeCategory/GeneratorEntsoeCategory.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace generator_entsoe_category {

class GeneratorEntsoeCategoryBuilder {
public:
  typedef GeneratorEntsoeCategory builded_type;
  typedef GeneratorEntsoeCategoryBuilder builder_type;

  GeneratorEntsoeCategory build() const;

  MACRO_IIDM_BUILDER_PROPERTY(builder_type, unsigned int, code)
};

} // end of namespace IIDM::extensions::generator_entsoe_category::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
