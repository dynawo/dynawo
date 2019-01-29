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
 * @file IIDM/extensions/generatorActivePowerControl/GeneratorActivePowerControl.h
 * @brief Provides GeneratorActivePowerControl interface
 */

#ifndef LIBIIDM_EXTENSIONS_GENERATORACTIVEPOWERCONTROL_GUARD_GENERATORACTIVEPOWERCONTROL_H
#define LIBIIDM_EXTENSIONS_GENERATORACTIVEPOWERCONTROL_GUARD_GENERATORACTIVEPOWERCONTROL_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace generatoractivepowercontrol {

class GeneratorActivePowerControlBuilder;

class GeneratorActivePowerControl : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  IIDM_UNIQUE_PTR<GeneratorActivePowerControl> clone() const { return IIDM_UNIQUE_PTR<GeneratorActivePowerControl>(do_clone()); }
  
protected:
  virtual GeneratorActivePowerControl* do_clone() const IIDM_OVERRIDE;

private:
  GeneratorActivePowerControl() {}
  friend class GeneratorActivePowerControlBuilder;

public:
  bool participate() const { return m_participate; }

  double droop() const { return m_droop; }

  GeneratorActivePowerControl& participate(bool value) { m_participate = value; return *this; }

  GeneratorActivePowerControl& droop(double value) { m_droop = value; return *this; }
  
private:
  double m_droop;
  bool m_participate;
};

} // end of namespace IIDM::extensions::generatoractivepowercontrol::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
