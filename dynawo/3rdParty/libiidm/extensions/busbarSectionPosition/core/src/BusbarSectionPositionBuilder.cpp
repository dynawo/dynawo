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
 * @file BusbarSectionPositionBuilder.cpp
 * @brief Provides BusbarSectionPositionBuilder
 */

#include <IIDM/extensions/busbarSectionPosition/BusbarSectionPositionBuilder.h>

namespace IIDM {
namespace extensions {
namespace busbarsection_position {

BusbarSectionPosition BusbarSectionPositionBuilder::build() const {
  BusbarSectionPosition builded;
  builded.m_busbarIndex = m_busbarIndex;
  builded.m_sectionIndex = m_sectionIndex;
  return builded;
}

} // end of namespace IIDM::extensions::busbarsection_position::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
