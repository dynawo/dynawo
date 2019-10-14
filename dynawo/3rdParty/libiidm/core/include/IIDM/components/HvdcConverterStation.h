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
 * @file components/HvdcConverterStation.h
 * @brief HvdcConverterStation interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_HVDCCONVERTERSTATION_H
#define LIBIIDM_COMPONENTS_GUARD_HVDCCONVERTERSTATION_H


#include <IIDM/cpp11.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/Injection.h>
#include <IIDM/components/ContainedIn.h>

namespace IIDM {

class VoltageLevel;

/**
 * @brief base class for LccConverterStation and VscConverterStation in the network
 * @tparam CRTP_ConverterStation the actual converter station class
 */
template <typename CRTP_ConverterStation>
class HvdcConverterStation: public Identifiable, public Injection<CRTP_ConverterStation>, public ContainedIn<VoltageLevel> {
public:
  //aliases of parent()
  ///tells if a parent is specified
  bool has_voltageLevel() const { return has_parent(); }

  ///gets a constant reference to the parent VoltageLevel
  VoltageLevel const& voltageLevel() const { return parent(); }

  ///gets a reference to the parent VoltageLevel
  VoltageLevel      & voltageLevel()       { return parent(); }

public:
  double lossFactor() const { return m_lossFactor; }

protected:
  //protected so that child class builders can access it
  double m_lossFactor;

protected:
  HvdcConverterStation(Identifier const& id, properties_type const& properties):
    Identifiable(id, properties)
  {}
};

} // end of namespace IIDM::

#endif
