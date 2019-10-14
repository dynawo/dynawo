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
 * @file components/LccConverterStation.h
 * @brief LccConverterStation interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_LCCCONVERTERSTATION_H
#define LIBIIDM_COMPONENTS_GUARD_LCCCONVERTERSTATION_H


#include <IIDM/cpp11.h>

#include <IIDM/components/HvdcConverterStation.h>

#include <IIDM/components/ReactiveInformations.h>

namespace IIDM {

class VoltageLevel;

namespace builders {
class LccConverterStationBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief LccConverterStation in the network
 */
class LccConverterStation: public HvdcConverterStation<LccConverterStation> {
public:
  double powerFactor() const { return m_powerFactor; }

private:
  double m_powerFactor;

private:
  LccConverterStation(Identifier const&, properties_type const&);
  friend class IIDM::builders::LccConverterStationBuilder;

};

} // end of namespace IIDM::

#endif
