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
 * @file components/ShuntCompensator.h
 * @brief ShuntCompensator interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_SHUNTCOMPENSATOR_H
#define LIBIIDM_COMPONENTS_GUARD_SHUNTCOMPENSATOR_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>
#include <IIDM/cpp11.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/Injection.h>
#include <IIDM/components/ContainedIn.h>

namespace IIDM {

class VoltageLevel;

namespace builders {
class ShuntCompensatorBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief ShuntCompensator in the network
 */
class IIDM_EXPORT ShuntCompensator:  public Identifiable, public Injection<ShuntCompensator>, public ContainedIn<VoltageLevel> {
public:
  //aliases of parent()
  ///tells if a parent is specified
  bool has_voltageLevel() const { return has_parent(); }

  ///gets a constant reference to the parent VoltageLevel
  VoltageLevel const& voltageLevel() const { return parent(); }
  ///gets a reference to the parent VoltageLevel
  VoltageLevel      & voltageLevel()       { return parent(); }

public:
  typedef int section_id;

  ShuntCompensator(Identifier const&, section_id max, section_id current, double suspectance_per_section, double q);

  double suspectancePerSection() const { return m_b_per_section; }
  double bPerSection() const { return suspectancePerSection(); }

  section_id minimumSection() const { return 0; }
  section_id maximumSection() const { return m_section_max; }
  section_id maximumSectionCount() const { return m_section_max; }

  section_id currentSection() const { return m_section_current; }

  //throws std::runtime_exception if the new segment is not in [minimumSection() .. maximumSection()]
  ShuntCompensator& currentSection(section_id const& segment);

  //return true if id is in [minimumSection() .. maximumSection()], false otherwise
  bool is_acceptable(section_id id) const { return id>=minimumSection() && id <= maximumSection(); }

private:
  section_id m_section_current, m_section_max;
  double m_b_per_section;

private:
  ShuntCompensator(Identifier const&, properties_type const&);
  friend class IIDM::builders::ShuntCompensatorBuilder;
};


} // end of namespace IIDM::

#endif
