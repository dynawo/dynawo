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
 * @file IIDM/extensions/standbyAutomaton/StandbyAutomaton.h
 * @brief Provides Extension interface
 */

#ifndef LIBIIDM_EXTENSIONS_STANDBYAUTOMATON_GUARD_STANDBYAUTOMATON_H
#define LIBIIDM_EXTENSIONS_STANDBYAUTOMATON_GUARD_STANDBYAUTOMATON_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

#include <string>

namespace IIDM {
namespace extensions {
namespace standbyautomaton {

class StandbyAutomatonBuilder;

class StandbyAutomaton : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  IIDM_UNIQUE_PTR<StandbyAutomaton> clone() const { return IIDM_UNIQUE_PTR<StandbyAutomaton>(do_clone()); }
  
protected:
  virtual StandbyAutomaton* do_clone() const IIDM_OVERRIDE;

private:
  StandbyAutomaton() {}
  friend class StandbyAutomatonBuilder;
  
public:
  double b0() const { return m_b0; }

  bool standBy() const { return m_standBy; }

  double lowVoltageSetPoint() const { return m_lowVoltageSetPoint; }

  double highVoltageSetPoint() const { return m_highVoltageSetPoint; }

  double lowVoltageThreshold() const { return m_lowVoltageThreshold; }

  double highVoltageThreshold() const { return m_highVoltageThreshold; }

  StandbyAutomaton& b0(double value) { m_b0 = value; return *this; }

  StandbyAutomaton& standBy(bool value) { m_standBy = value; return *this; }

  StandbyAutomaton& lowVoltageSetPoint(double value) { m_lowVoltageSetPoint = value; return *this; }

  StandbyAutomaton& highVoltageSetPoint(double value) { m_highVoltageSetPoint = value; return *this; }

  StandbyAutomaton& lowVoltageThreshold(double value) { m_lowVoltageThreshold = value; return *this; }

  StandbyAutomaton& highVoltageThreshold(double value) { m_highVoltageThreshold = value; return *this; }

private:
  double m_b0;
  bool m_standBy;
  double m_lowVoltageSetPoint;
  double m_highVoltageSetPoint;
  double m_lowVoltageThreshold;
  double m_highVoltageThreshold;
};

} // end of namespace IIDM::extensions::standbyautomaton::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
