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
 * @file IIDM/extensions/generatorShortCircuits/GeneratorShortCircuits.h
 * @brief Provides GeneratorShortCircuits
 */

#ifndef LIBIIDM_EXTENSIONS_GENERATORSHORTCIRCUITS_GUARD_GENERATORSHORTCIRCUITS_BUILDER_H
#define LIBIIDM_EXTENSIONS_GENERATORSHORTCIRCUITS_GUARD_GENERATORSHORTCIRCUITS_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/generatorShortCircuits/GeneratorShortCircuits.h>

namespace IIDM {
namespace extensions {
namespace generatorshortcircuits {

class GeneratorShortCircuitsBuilder {
public:
  typedef GeneratorShortCircuits builded_type;
  typedef GeneratorShortCircuitsBuilder builder_type;

  GeneratorShortCircuits build() const;

  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, transientReactance)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, stepUpTransformerReactance)
};

} // end of namespace IIDM::extensions::generatorshortcircuits::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
