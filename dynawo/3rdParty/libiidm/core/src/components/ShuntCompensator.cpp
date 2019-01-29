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
 * @file src/components/ShuntCompensator.cpp
 * @brief ShuntCompensator implementation file
 */

#include <IIDM/components/ShuntCompensator.h>

#include <stdexcept>
#include <sstream>

namespace IIDM {

ShuntCompensator::ShuntCompensator(Identifier const& id, properties_type const& properties): Identifiable(id, properties) {}

ShuntCompensator& ShuntCompensator::currentSection(section_id const& segment) {
  if (!is_acceptable(segment)) {
    std::ostringstream stream;
    stream << "ShuntCompensator " << id() << ": Invalid current section " << segment;
    throw std::runtime_error(stream.str());
  }
  m_section_current = segment;
  return *this;
}

} // end of namespace IIDM::

