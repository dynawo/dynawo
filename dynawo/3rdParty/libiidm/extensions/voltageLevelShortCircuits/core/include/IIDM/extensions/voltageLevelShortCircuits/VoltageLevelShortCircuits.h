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
 * @file IIDM/extensions/voltageLevelShortCircuits/VoltageLevelShortCircuits.h
 * @brief Provides VoltageLevelShortCircuits interface
 */

#ifndef LIBIIDM_EXTENSIONS_VOLTAGELEVELSHORTCIRCUITS_GUARD_VOLTAGELEVELSHORTCIRCUITS_H
#define LIBIIDM_EXTENSIONS_VOLTAGELEVELSHORTCIRCUITS_GUARD_VOLTAGELEVELSHORTCIRCUITS_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace voltagelevelshortcircuits {

class VoltageLevelShortCircuitsBuilder;

class VoltageLevelShortCircuits : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  IIDM_UNIQUE_PTR<VoltageLevelShortCircuits> clone() const { return IIDM_UNIQUE_PTR<VoltageLevelShortCircuits>(do_clone()); }

protected:
  virtual VoltageLevelShortCircuits* do_clone() const IIDM_OVERRIDE;

private:
  VoltageLevelShortCircuits() {}
  friend class VoltageLevelShortCircuitsBuilder;

public:
  double minShortCircuitsCurrent() const { return m_minShortCircuitsCurrent; }

  double maxShortCircuitsCurrent() const { return m_maxShortCircuitsCurrent; }

  VoltageLevelShortCircuits& minShortCircuitsCurrent(double value) { m_minShortCircuitsCurrent = value; return *this; }

  VoltageLevelShortCircuits& maxShortCircuitsCurrent(double value) { m_maxShortCircuitsCurrent = value; return *this; }

private:
  double m_minShortCircuitsCurrent;
  double m_maxShortCircuitsCurrent;
};

} // end of namespace IIDM::extensions::voltagelevelshortcircuits::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
