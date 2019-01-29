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
 * @file components/HvdcLine.h
 * @brief HvdcLine interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_HVDCLINE_H
#define LIBIIDM_COMPONENTS_GUARD_HVDCLINE_H

#include <IIDM/Export.h>
#include <IIDM/cpp11.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/ContainedIn.h>

namespace IIDM {

class Network;

namespace builders {
class HvdcLineBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief Line in the network
 */
class IIDM_EXPORT HvdcLine: public Identifiable, public ContainedIn<Network> {
public:
  //aliases of parent()
  ///tells if a parent network is specified
  bool has_network() const { return has_parent(); }

  ///gets a constant reference to the parent network
  Network const& network() const { return parent(); }
  ///gets a reference to the parent network
  Network      & network()       { return parent(); }

public:
  enum mode_enum { mode_RectifierInverter, mode_InverterRectifier };

public:
  double r() const { return m_r; }

  double nominalV() const { return m_nominalV; }

  double activePowerSetpoint() const { return m_activePowerSetpoint; }

  double maxP() const { return m_maxP; }

  mode_enum convertersMode() const { return m_convertersMode; }

  id_type converterStation1() const { return m_converterStation1; }

  id_type converterStation2() const { return m_converterStation2; }

private:
  double m_r;
  double m_nominalV;
  double m_activePowerSetpoint;
  double m_maxP;

  mode_enum m_convertersMode;

  id_type m_converterStation1;
  id_type m_converterStation2;

private:
  HvdcLine(Identifier const&, properties_type const&);
  friend class IIDM::builders::HvdcLineBuilder;
};

} // end of namespace IIDM

#endif
