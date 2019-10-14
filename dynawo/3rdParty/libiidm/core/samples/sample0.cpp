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


#include <iostream>
#include <string>

#include <boost/optional/optional_io.hpp>

#include "internals/sample.h"

#include <IIDM/builders.h>
#include <IIDM/Network.h>


using std::cout;
using std::endl;

using namespace IIDM;
using namespace IIDM::builders;


int main() {
  const char * const separator = "----------------------------------------";

  cout << separator << "\n------------ BUILDERS TESTS ------------\n" << separator << endl;

  cout << NetworkBuilder().sourceFormat("handcrafted").caseDate("today").forecastDistance(0).build("Network") << endl;

  cout << SubstationBuilder().country("FR").tso(std::string("RTE")).build("Substation") << endl;

  cout << LineBuilder().r(0).x(0).g1(0).b1(0).g2(0).b2(0).build("Line") << endl;
  cout << "tie line" << endl;

  VoltageLevelBuilder bus_voltagelevel_builder, node_voltagelevel_builder;
  cout << bus_voltagelevel_builder.mode(VoltageLevel::bus_breaker).nominalV(50).build("BusVL") << endl;
  cout << node_voltagelevel_builder.mode(VoltageLevel::node_breaker).node_count(7).nominalV(50).build("NodeVL") << endl;

  cout << BusBuilder().v(0).angle(10).build("Bus") << endl;
  cout << BusBarSectionBuilder().node(0).name(std::string("1")).build("BusBarSection") << endl;

  cout << SwitchBuilder().type(Switch::breaker).opened(false).retained(false).build("Switch") << endl;

  cout << LoadBuilder().type(Load::type_auxiliary).p0(0).q0(0).p(0).q(0).name(std::string("a load")).build("Load") << endl;

  cout << ShuntCompensatorBuilder().section_current(1).section_max(2).b_per_section(1).q(0).build("Shunt") << endl;

  cout << DanglingLineBuilder()
            .p0(1)
            .q0(1)
            .p (0)
            .q (0)
            .r (0)
            .x (0)
            .g (0)
            .b (0)
            .ucte_xNodeCode(std::string("N"))
            .currentLimits(CurrentLimits(9999).add("CL1", 1200, 600).add("CL2", 1800, 300))
          .build("DanglingLine")
    << endl;

  cout << GeneratorBuilder()
    .energySource(Generator::source_other)//Spinning Butterback Cat
    .regulating(true)
    .pmin(0)
    .pmax(1)
    .targetP(2)
    .targetQ(3)
    .targetV(4)
    .ratedS(5)
    .p(6)
    .q(7)
    .minMaxReactiveLimits( MinMaxReactiveLimits(0, 10) )
    .reactiveCapabilityCurve( ReactiveCapabilityCurve(0, 0, 10)(1, 5, 15)(2, 0, 10) )
    .regulatingTerminal( TerminalReference("DL2") )
    .build("Generator")
  << endl;

  cout << "2WT" << endl;
  cout << "3WT" << endl;

  cout << separator << endl;

  return 0;
}
