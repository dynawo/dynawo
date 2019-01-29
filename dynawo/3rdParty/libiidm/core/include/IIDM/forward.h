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

class IIDM_EXPORT Network;
class IIDM_EXPORT Substation;

class IIDM_EXPORT Line;
class IIDM_EXPORT TieLine;
class IIDM_EXPORT HvdcLine;

class IIDM_EXPORT VoltageLevel;

class IIDM_EXPORT Bus;
class IIDM_EXPORT BusBarSection;
class IIDM_EXPORT Switch;

class IIDM_EXPORT DanglingLine;
class IIDM_EXPORT Load;
class IIDM_EXPORT ShuntCompensator;
class IIDM_EXPORT StaticVarCompensator;
class IIDM_EXPORT Generator;
class IIDM_EXPORT VscConverterStation;
class IIDM_EXPORT LccConverterStation;

class IIDM_EXPORT Transformer2Windings;
class IIDM_EXPORT Transformer3Windings;

//details classes

class IIDM_EXPORT TerminalReference;
class IIDM_EXPORT CurrentLimits;

class IIDM_EXPORT MinMaxReactiveLimits;
class IIDM_EXPORT ReactiveCapabilityCurve;

class IIDM_EXPORT LccFilter;

class IIDM_EXPORT RatioTapChanger;
class IIDM_EXPORT PhaseTapChanger;

//utility classes

class IIDM_EXPORT Identifiable;

template <typename CRTP_COMPONENT, side_id Sides>
class IIDM_EXPORT Connectable;

class IIDM_EXPORT Connection;
class IIDM_EXPORT Port;
class IIDM_EXPORT ConnectionPoint;

template <typename CRTP_Parent>
class IIDM_EXPORT ContainedIn;

template <typename Contained>
class IIDM_EXPORT Contains;
}

#endif
