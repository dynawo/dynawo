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
 * @file IIDM/extensions/voltageRegulation/VoltageRegulation.h
 * @brief Provides VoltageRegulation interface
 */

#ifndef LIBIIDM_EXTENSIONS_VOLTAGEREGULATION_GUARD_VOLTAGEREGULATION_H
#define LIBIIDM_EXTENSIONS_VOLTAGEREGULATION_GUARD_VOLTAGEREGULATION_H

#include <boost/optional.hpp>

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>
#include <IIDM/components/TerminalReference.h>

namespace IIDM {
namespace extensions {
namespace voltageregulation {

class VoltageRegulationBuilder;

class VoltageRegulation : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  /// clones this VoltageRegulation
  IIDM_UNIQUE_PTR<VoltageRegulation> clone() const { return IIDM_UNIQUE_PTR<VoltageRegulation>(do_clone()); }

protected:
  virtual VoltageRegulation* do_clone() const IIDM_OVERRIDE;

private:
  VoltageRegulation() {}
  friend class VoltageRegulationBuilder;

public:
  bool voltageRegulatorOn() const { return m_voltageRegulatorOn; }

  VoltageRegulation& voltageRegulatorOn(bool voltageRegulatorOn) { m_voltageRegulatorOn = voltageRegulatorOn; return *this; }

  bool has_regulatingTerminal() const { return static_cast<bool>(m_regulatingTerminal); }
  TerminalReference regulatingTerminal() const { return m_regulatingTerminal.value(); }
  boost::optional<TerminalReference> const& optional_regulatingTerminal() const { return m_regulatingTerminal; }
  VoltageRegulation& regulatingTerminal(TerminalReference const& terminal) { m_regulatingTerminal = terminal; return *this; }
  VoltageRegulation& regulatingTerminal(boost::optional<TerminalReference> const& terminal) { m_regulatingTerminal = terminal; return *this; }


  bool has_targetV() const { return static_cast<bool>(m_targetV); }
  double targetV() const { return m_targetV.value(); }
  boost::optional<double> const& optional_targetV() const { return m_targetV; }
  VoltageRegulation& targetV(double targetV) { m_targetV = targetV; return *this; }
  VoltageRegulation& targetV(boost::optional<double> const& targetV) { m_targetV = targetV; return *this; }


private:
  bool m_voltageRegulatorOn;
  boost::optional<double> m_targetV;
  boost::optional<TerminalReference> m_regulatingTerminal;
};

} // end of namespace IIDM::extensions::voltageregulation::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
