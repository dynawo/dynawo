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
 * @file IIDM/extensions/activePowerControl/ActivePowerControl.h
 * @brief Provides ActivePowerControl interface
 */

#ifndef LIBIIDM_EXTENSIONS_ACTIVEPOWERCONTROL_GUARD_ACTIVEPOWERCONTROL_H
#define LIBIIDM_EXTENSIONS_ACTIVEPOWERCONTROL_GUARD_ACTIVEPOWERCONTROL_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace activepowercontrol {

class ActivePowerControlBuilder;

class ActivePowerControl : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  IIDM_UNIQUE_PTR<ActivePowerControl> clone() const { return IIDM_UNIQUE_PTR<ActivePowerControl>(do_clone()); }

protected:
  virtual ActivePowerControl* do_clone() const IIDM_OVERRIDE;

private:
  ActivePowerControl() {}
  friend class ActivePowerControlBuilder;

public:
  bool participate() const { return m_participate; }

  double droop() const { return m_droop; }

  ActivePowerControl& participate(bool value) { m_participate = value; return *this; }

  ActivePowerControl& droop(double value) { m_droop = value; return *this; }

private:
  double m_droop;
  bool m_participate;
};

} // end of namespace IIDM::extensions::activepowercontrol::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
