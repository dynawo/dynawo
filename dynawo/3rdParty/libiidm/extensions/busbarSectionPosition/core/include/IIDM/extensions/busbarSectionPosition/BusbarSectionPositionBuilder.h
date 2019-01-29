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
 * @file IIDM/extensions/busbarSectionPosition/BusbarSectionPositionBuilder.h
 * @brief Provides BusbarSectionPosition interface
 */

#ifndef LIBIIDM_EXTENSIONS_BUSBARSECTIONPOSITION_GUARD_BUSBARSECTIONPOSITION_BUILDER_H
#define LIBIIDM_EXTENSIONS_BUSBARSECTIONPOSITION_GUARD_BUSBARSECTIONPOSITION_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/busbarSectionPosition/BusbarSectionPosition.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace busbarsection_position {

class BusbarSectionPositionBuilder {
public:
  typedef BusbarSectionPosition builded_type;
  typedef BusbarSectionPositionBuilder builder_type;

  BusbarSectionPosition build() const;
  
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, unsigned int, busbarIndex)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, unsigned int, sectionIndex)
};

} // end of namespace IIDM::extensions::busbarsection_position::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
