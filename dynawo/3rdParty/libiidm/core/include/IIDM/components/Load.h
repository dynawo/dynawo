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
 * @file components/Load.h
 * @brief Load interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_LOAD_H
#define LIBIIDM_COMPONENTS_GUARD_LOAD_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>
#include <IIDM/cpp11.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/Injection.h>
#include <IIDM/components/ContainedIn.h>

namespace IIDM {

class VoltageLevel;

namespace builders {
class LoadBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief Load in the network
 */
class IIDM_EXPORT Load: public Identifiable, public Injection<Load>, public ContainedIn<VoltageLevel> {
public:
  //aliases of parent()
  ///tells if a parent is specified
  bool has_voltageLevel() const { return has_parent(); }

  ///gets a constant reference to the parent VoltageLevel
  VoltageLevel const& voltageLevel() const { return parent(); }

  ///gets a reference to the parent VoltageLevel
  VoltageLevel & voltageLevel() { return parent(); }


public:
  enum e_type {type_undefined, type_auxiliary, type_fictitious};

public:
  e_type type() const { return m_type; }

  /** get the constant active power */
  double p0() const { return m_p0; }

  /** get the constant reactive power */
  double q0() const { return m_q0; }

private:
  double m_p0;
  double m_q0;
  e_type m_type;

private:
  Load(Identifier const&, properties_type const&);
  friend class IIDM::builders::LoadBuilder;
};

} // end of namespace IIDM::

#endif
