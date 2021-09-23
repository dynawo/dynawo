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
 * @file forward.h
 * @brief forward declarations of the main IIDM classes
 */

#ifndef LIBIIDM_GUARD_FORWARD_H
#define LIBIIDM_GUARD_FORWARD_H

#include <IIDM/BasicTypes.h>

namespace IIDM {

//network classes

class Network;
class Substation;

class Line;
class TieLine;
class HvdcLine;

class VoltageLevel;

class Bus;
class BusBarSection;
class Switch;

class Battery;
class DanglingLine;
class Load;
class ShuntCompensator;
class StaticVarCompensator;
class Generator;
class VscConverterStation;
class LccConverterStation;

class Transformer2Windings;
class Transformer3Windings;

//details classes

struct TerminalReference;
class CurrentLimits;

class MinMaxReactiveLimits;
class ReactiveCapabilityCurve;

class LccFilter;

class RatioTapChanger;
class PhaseTapChanger;

//utility classes

class Identifiable;

template <typename CRTP_COMPONENT, side_id Sides>
class Connectable;

class Connection;
class Port;
class ConnectionPoint;

template <typename CRTP_Parent>
class ContainedIn;

template <typename Contained>
class Contains;
}

#endif
