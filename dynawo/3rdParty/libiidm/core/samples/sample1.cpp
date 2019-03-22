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


#include <IIDM/builders.h>
#include <IIDM/Network.h>

#include "internals/sample.h"


using std::cout;
using std::endl;

using namespace IIDM;
using namespace IIDM::builders;

#define WITH_TRIVIAL0 1
#define WITH_TRIVIAL1 1
#define WITH_SWITCH_TEST 1
#define WITH_NODENET1 1

int main() {
  const char * const separator = "----------------------------------------";

  cout << separator << "\n--------------- TEST API ---------------\n" << separator << endl;

  LoadBuilder load_builder;
    load_builder.type(Load::type_undefined).p0(0).q0(0).p(0).q(0).p(2);

  SubstationBuilder substation_fr_builder;
  SubstationBuilder substation_be_builder;
  substation_fr_builder.country("FR").tso("RTE");
  substation_be_builder.country("BE");

//a few builder to ease network building
  NetworkBuilder networks;
    networks.sourceFormat("handcrafted").caseDate("today").forecastDistance(0);

  ShuntCompensatorBuilder shuntCompensator_builder;
    shuntCompensator_builder.section_current(1).section_max(2).b_per_section(1).q(0);

  BusBuilder bus_builder;
    bus_builder.v(0).angle(10);

  VoltageLevelBuilder bus_voltagelevel_builder, node_voltagelevel_builder;
    bus_voltagelevel_builder.mode(VoltageLevel::bus_breaker).nominalV(50);
    node_voltagelevel_builder.mode(VoltageLevel::node_breaker).node_count(7).nominalV(50);

  SwitchBuilder switch_builder;
    switch_builder.type(Switch::breaker).opened(false).retained(false);

  LineBuilder line_builder;
    line_builder.r(0).x(0).g1(0).b1(0).g2(0).b2(0);



#if WITH_TRIVIAL0
  Network trivial0 = networks.build("trivial0");
  //trivial0 has two stations S1 et S2

  //S1 has one voltagelevel: S1V1
  //S1V1 has one bus: S1V1B1
  //S1V1B1 has one load: L1

  //S2 has one voltagelevel: S2V1
  //S2V1 has one bus: S2V1B1

  //there is a line "L1_1_1-2_1_1-1": S1V1B1->S2V1B1

  trivial0.add( substation_fr_builder.build("S1") )
    .add( bus_voltagelevel_builder.build("S1V1") )
      .add( bus_builder.build("S1V1B1") )
        .add( load_builder.build("L1"), at("S1V1B1", connected) )
  ;

  trivial0.add( substation_be_builder.build("S2") )
    .add( bus_voltagelevel_builder.build("S2V1") )
      .add( bus_builder.build("S2V1B1") )
  ;

  trivial0.add(
    line_builder.build("L1_1_1-2_1_1-1"),
    at("S1V1", "S1V1B1", connected, side_1),
    at("S2V1", "S2V1B1", connected, side_2)
  );

  cout << trivial0 << endl;
#endif

#if WITH_TRIVIAL1
  cout << separator << endl;

  Network trivial1 = networks.build("trivial1");
  //trivial1 has two stations S1 et S2
  //S1 has one voltagelevel: S1V1
  //S1V1 has two bus: S1V1B1 et S1V1B2
  //each of them has two loads L1A, L1B, L2A, L2B
  //there is a switch between them: S1V1S1(1:S1V1B1, 2:S1V1B2)

  //S1 has one voltagelevel: S2V1
  //S1V1 has two bus: S2V1B1 et S2V1B2
  //there is a switch between them: S2V1S1(1:S2V1B1, 2:S2V1B2)

  //finaly, there is a line between S1V1B2 and S2V1B1

  trivial1.add( substation_fr_builder.build("S1") )
    .add( bus_voltagelevel_builder.build("S1V1") )
      .add( bus_builder.build("S1V1B1") )
      .add( load_builder.build("L1_1A"), at("S1V1B1", connected) )
      .add( load_builder.build("L1_1B"), at("S1V1B1", connected) )

      .add( bus_builder.build("S1V1B2") )
  ;

  trivial1.add( substation_be_builder.build("S2") )
    .add( bus_voltagelevel_builder.build("S2V1") )
      .add( bus_builder.build("S2V1B1") )
      .add( bus_builder.build("S2V1B2") )
      .add( switch_builder.build("S2V1S1"), "S2V1B1", "S2V1B2")

      .add( load_builder.build("L2_2A"), at("S2V1B2", connected) )
      .add( load_builder.build("L2_2B"), at("S2V1B2", connected) )
      .add( shuntCompensator_builder.build("Shunt_2.1.2"), at("S2V1B2", connected) )

      .add( load_builder.build("L2_0") )
      .add(
        DanglingLineBuilder()
          .p0(1)
          .q0(1)
          .p (0)
          .q (0)
          .r (0)
          .x (0)
          .g (0)
          .b (0)
          .ucte_xNodeCode("N")
          .currentLimits(CurrentLimits(9999).add("CL1", 1200, 600).add("CL2", 1800, 300))
        .build("DL2"),
        at("S2V1B1", connected)
      )
  ;

  trivial1.add(
    line_builder.build("L1_1_1-2_1_1-1"),
    at("S1V1", "S1V1B2", connected, side_1),
    at("S2V1", "S2V1B1", connected, side_2)
  );

  cout << trivial1 << endl;
#endif

#if WITH_SWITCH_TEST
  cout << separator << endl;

  Network switchtest = networks.build("switch test");

  Substation& switchtest_station = switchtest.add( substation_be_builder.build("S") );

  switchtest_station.add( bus_voltagelevel_builder.build("V1") )
      .add( bus_builder.build("B1") )
      .add( bus_builder.build("B2") )
      .add( switch_builder.build("Switch1"), "B1", "B2" )
  ;

  switchtest_station.add( node_voltagelevel_builder.build("V2") )
      .add( switch_builder.build("Switch2"), 1, 2 )
  ;

  cout << switchtest << endl;
#endif

#if WITH_NODENET1
  cout << separator << endl;

  Network nodenet1 = networks.build("nodenet1");

  /*
    <substation id=".BENO" name=".BENO" country="ES" tso="RTE">
        <voltageLevel id=".BENOP5" name=".BENOP5" nominalV="150" topologyKind="NODE_BREAKER">
            <nodeBreakerTopology nodeCount="5">
                <busbarSection id=".BENOP5_1_1_0" name="1" node="0"/>
                <switch id=".BENO5L.OO .1SA.1F" name=".BENO5L.OO .1SA.1F" kind="DISCONNECTOR" retained="false" node1="0" node2="3" open="false"/>
                <switch id=".BENO5CONSOSA.1F" name=".BENO5CONSOSA.1F" kind="DISCONNECTOR" retained="false" node1="0" node2="1" open="false"/>
                <switch id=".BENO5CONSODJF" name=".BENO5CONSODJF" kind="BREAKER" retained="true" node1="1" node2="2" open="false"/>
                <switch id=".BENO5L.OO .1DJ" name=".BENO5L.OO .1DJ" kind="BREAKER" retained="true" node1="3" node2="4" open="true"/>
            </nodeBreakerTopology>
            <load id=".BENO5CONSO" name=".BENO5CONSO" p0="0" q0="0" node="2"/>
        </voltageLevel>
    </substation>
  */
  nodenet1.add( SubstationBuilder().country("ES").tso("RTE").name(".BENO").build(".BENO") )
    .add(VoltageLevelBuilder().name(".BENOP5").nominalV(150).mode(VoltageLevel::node_breaker).node_count(5).build(".BENOP5") )
      .add(BusBarSectionBuilder().node(0).name("1").build(".BENOP5_1_1_0") )
      .add(
        SwitchBuilder()
          .type(Switch::disconnector).retained(false).opened(false).name(".BENO5L.OO .1SA.1F")
        .build(".BENO5L.OO .1SA.1F"),
        0, 3
      )

      .add(
        SwitchBuilder()
          .type(Switch::disconnector).retained(false).opened(false).name(".BENO5CONSOSA.1F")
        .build(".BENO5CONSOSA.1F"),
        0, 1
      )

      .add(
        SwitchBuilder()
          .type(Switch::breaker).retained(true).opened(false).name(".BENO5CONSODJF")
        .build(".BENO5CONSODJF"),
        1, 2
      )

      .add(
        SwitchBuilder()
          .type(Switch::breaker).retained(true).opened(true).name(".BENO5L.OO .1DJ")
        .build(".BENO5L.OO .1DJ"),
        3, 4
      )
      .add(
        LoadBuilder().type(Load::type_undefined).p0(0).q0(0).p(0).q(0).name(".BENO5CONSO").build(".BENO5CONSO"),
        at(2)
      )
  ;

  cout << nodenet1 << endl;

  cout << separator << endl;
#endif
  return 0;
}
