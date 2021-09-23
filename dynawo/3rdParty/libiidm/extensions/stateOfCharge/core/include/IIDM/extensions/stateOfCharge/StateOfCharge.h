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
 * @file IIDM/extensions/standbyAutomaton/StateOfCharge.h
 * @brief Provides Extension interface
 */

#ifndef LIBIIDM_EXTENSIONS_STATEOFCHARGE_GUARD_STATEOFCHARGE_H
#define LIBIIDM_EXTENSIONS_STATEOFCHARGE_GUARD_STATEOFCHARGE_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

#include <string>

namespace IIDM {
namespace extensions {
namespace stateofcharge {

class StateOfChargeBuilder;

class StateOfCharge : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  IIDM_UNIQUE_PTR<StateOfCharge> clone() const { return IIDM_UNIQUE_PTR<StateOfCharge>(do_clone()); }

protected:
  virtual StateOfCharge* do_clone() const IIDM_OVERRIDE;

private:
  StateOfCharge() {}
  friend class StateOfChargeBuilder;

public:
  double min() const { return m_min; }

  double max() const { return m_max; }

  double current() const { return m_current; }

  double storageCapacity() const { return m_storageCapacity; }

  StateOfCharge& min(double value) { m_min = value; return *this; }

  StateOfCharge& max(double value) { m_max = value; return *this; }

  StateOfCharge& current(double value) { m_current = value; return *this; }

  StateOfCharge& storageCapacity(double value) { m_storageCapacity = value; return *this; }

private:
  double m_min;
  double m_max;
  double m_current;
  double m_storageCapacity;
};

} // end of namespace IIDM::extensions::stateofcharge::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
