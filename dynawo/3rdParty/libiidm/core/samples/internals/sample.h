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

#ifndef LIBIIDM_TESTS_INTERNALS__SAMPLE_H
#define LIBIIDM_TESTS_INTERNALS__SAMPLE_H

#include <iosfwd>

namespace IIDM {
class Network;

class Line;
class TieLine;

class Substation;

class VoltageLevel;
class Bus;
class BusBarSection;
class Switch;

class Battery;
class Load;
class ShuntCompensator;
class DanglingLine;
class StaticVarCompensator;
class Generator;

class Transformer2Windings;
class Transformer3Windings;
}

std::ostream& operator << (std::ostream&, IIDM::Network const&);


std::ostream& operator << (std::ostream&, IIDM::Line const&);

std::ostream& operator << (std::ostream&, IIDM::TieLine const&);


std::ostream& operator << (std::ostream&, IIDM::Substation const&);


std::ostream& operator << (std::ostream&, IIDM::VoltageLevel const&);

std::ostream& operator << (std::ostream&, IIDM::Bus const&);

std::ostream& operator << (std::ostream&, IIDM::BusBarSection const&);

std::ostream& operator << (std::ostream&, IIDM::Switch const&);

std::ostream& operator << (std::ostream&, IIDM::Battery const&);

std::ostream& operator << (std::ostream&, IIDM::Load const&);

std::ostream& operator << (std::ostream&, IIDM::ShuntCompensator const&);

std::ostream& operator << (std::ostream&, IIDM::DanglingLine const&);

std::ostream& operator << (std::ostream&, IIDM::StaticVarCompensator const&);

std::ostream& operator << (std::ostream&, IIDM::Generator const&);


std::ostream& operator << (std::ostream&, IIDM::Transformer2Windings const&);

std::ostream& operator << (std::ostream&, IIDM::Transformer3Windings const&);

#endif
