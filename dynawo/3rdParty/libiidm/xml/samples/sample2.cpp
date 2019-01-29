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

#include <IIDM/xml/export.h>
#include <IIDM/xml/import.h>

#include <iostream>
#include <fstream>
#include <string>

#include <boost/optional/optional_io.hpp>

#include <IIDM/builders.h>
#include <IIDM/Network.h>

#ifndef MACRO_WITH_CONNECTIVITY_TEST
#define MACRO_WITH_CONNECTIVITY_TEST 1
#endif

#ifndef MACRO_WITH_COMPONENTS_TEST
#define MACRO_WITH_COMPONENTS_TEST 1
#endif

#ifndef MACRO_WITH_TOPOLOGY_TEST
#define MACRO_WITH_TOPOLOGY_TEST 1
#endif

#include <boost/shared_ptr.hpp>

using std::cerr;
using std::endl;

using namespace IIDM;
using namespace IIDM::builders;

int main(int argc, char** argv) {
//a few builder to ease network building

	LineBuilder line_builder = LineBuilder().r(0).x(0).g1(0).b1(0).g2(0).b2(0);

	TieLineBuilder tieline_builder = TieLineBuilder()
    .id_1("A").r_1(0).x_1(0).g1_1(0).b1_1(0).g2_1(0).b2_1(0).xnodeP_1(0).xnodeP_2(0)
    .id_2("B").r_2(0).x_2(0).g1_2(0).b1_2(0).g2_2(0).b2_2(0).xnodeP_1(0).xnodeP_2(0)
  ;

  HvdcLineBuilder hvdcline_builder = HvdcLineBuilder().r(0).nominalV(0).activePowerSetpoint(0).maxP(10);

  SubstationBuilder substation_fr_builder = SubstationBuilder().country("FR").tso("RTE");
  SubstationBuilder substation_be_builder = SubstationBuilder().country("BE");



  LoadBuilder load_builder = LoadBuilder().p0(0).q0(0).p(0).q(0).p(2);

	ShuntCompensatorBuilder shunt_builder= ShuntCompensatorBuilder().section_current(1).section_max(2).b_per_section(1).q(0);

	StaticVarCompensatorBuilder svc_off_builder, svc_voltage_builder, svc_reactive_builder;
  svc_off_builder.regulationMode(StaticVarCompensator::regulation_off).bmin(1).bmax(2);
  svc_voltage_builder.regulationMode(StaticVarCompensator::regulation_voltage).bmin(1).bmax(2).voltageSetPoint(1.2);
  svc_reactive_builder.regulationMode(StaticVarCompensator::regulation_reactive_power).bmin(1).bmax(2).reactivePowerSetPoint(1.7);

	DanglingLineBuilder danglingline_builder = DanglingLineBuilder().p0(0).q0(0).r(0).x(0).g(0).b(0);


	GeneratorBuilder solar_builder = GeneratorBuilder()
    .energySource(Generator::source_solar)
    .minMaxReactiveLimits( MinMaxReactiveLimits(0, 10) )
    .regulating(false)
    .pmin(0).pmax(10).targetP(5);
	GeneratorBuilder nuclear_builder = GeneratorBuilder()
    .energySource(Generator::source_nuclear)
    .minMaxReactiveLimits( MinMaxReactiveLimits(0, 10) )
    .regulating(true)
    .pmin(0).pmax(10).targetP(5);

  VscConverterStationBuilder VscCSBuilder = VscConverterStationBuilder()
    .lossFactor(0.5)
    .regulating(true)
    .voltageSetpoint(1.0)
    .reactivePowerSetpoint(2.5)
    .minMaxReactiveLimits( MinMaxReactiveLimits(0, 10) )
    .p(0).q(0)
  ;
  LccConverterStationBuilder LccCSBuilder = LccConverterStationBuilder()
    .lossFactor(0.5)
    .powerFactor(1.0)
    .p(0).q(0)
  ;

  BusBuilder bus_builder = BusBuilder().v(0).angle(10);

	VoltageLevelBuilder bus_voltagelevel_builder = VoltageLevelBuilder().mode(VoltageLevel::bus_breaker).nominalV(50);


	SwitchBuilder breaker_builder = SwitchBuilder().type(Switch::breaker).opened(false).retained(false);
	SwitchBuilder disconnector_builder = SwitchBuilder().type(Switch::disconnector).opened(false).retained(false);
	SwitchBuilder load_break_builder = SwitchBuilder().type(Switch::load_break_switch).opened(false).retained(false);


  //caracteristics:
  CurrentLimits basic_current_limits = CurrentLimits(9999).add("L1", 1200, 600).add("L2", 1800, 300);


//creating the network

	cerr << "creating network..." << endl;
	Network network = NetworkBuilder().sourceFormat("handcrafted").caseDate("2000-01-01T00:00:00").forecastDistance(0).build("network");
  
  //connectivity test: 2 stations, bus, busbarsection, lines and tielines
#if MACRO_WITH_CONNECTIVITY_TEST
  {
    cerr << "adding connectivity test..." << endl;

    VoltageLevelBuilder node_voltagelevel_builder = VoltageLevelBuilder().mode(VoltageLevel::node_breaker).node_count(3).nominalV(50);

    BusBuilder bus_builder = BusBuilder().v(0).angle(10);

    network.add( substation_fr_builder.build("S1") )
      .add( bus_voltagelevel_builder.build("S1V1") )
        .add( bus_builder.build("S1V1B1") )//for bus to bus line
        .add( bus_builder.build("S1V1B2") )//for bus to bus tieline
        .add( bus_builder.build("S1V1B3") )//for bus to node line
      .parent()
      .add(node_voltagelevel_builder.build("S1V2") )
        .add( BusBarSectionBuilder().node(0).build("S1V2BBS0") )//for node to node line
        .add( BusBarSectionBuilder().node(1).build("S1V2BBS1") )//for node to node tieline
        .add( BusBarSectionBuilder().node(2).build("S1V2BBS2") )//for bus to node tieline

    ;

    network.add( substation_be_builder.build("S2") )
      .add( bus_voltagelevel_builder.build("S2V1") )
        .add( bus_builder.build("S2V1B1") )//for bus to bus line
        .add( bus_builder.build("S2V1B2") )//for bus to bus tieline
        .add( bus_builder.build("S2V1B3") )//for bus to node tieline
      .parent()
      .add(node_voltagelevel_builder.build("S2V2") )
        .add( BusBarSectionBuilder().node(0).build("S2V2BBS0") )//for node to node line
        .add( BusBarSectionBuilder().node(1).build("S2V2BBS1") )//for node to node tieline
        .add( BusBarSectionBuilder().node(2).build("S2V2BBS2") )//for bus to node line
    ;

    //bus to bus line
    network.add(
      line_builder.build("L1-1_1_1-2_1_1"),
      at("S1V1", "S1V1B1", connected, side_1),
      at("S2V1", "S2V1B1", connected, side_2)
    );

    //bus to bus tieline
    network.add(
      tieline_builder.build("TL1-1_1_2-2_1_2"),
      at("S1V1", "S1V1B2", connected, side_1),
      at("S2V1", "S2V1B2", connected, side_2)
    );

    //node to node line
    network.add(
      line_builder.build("L2-1_2_1-2_2_1"),
      at("S1V2", 0, side_1),
      at("S2V2", 0, side_2)
    );

    //node to node tieline
    network.add(
      tieline_builder.build("TL2-1_2_2-2_2_2"),
      at("S1V2", 1, side_1),
      at("S2V2", 1, side_2)
    );

    //bus to node line
    network.add(
      line_builder.build("L3-1_1_3-2_2_3"),
      at("S1V1", "S1V1B3", connected, side_1),
      at("S2V2", 2, side_2)
    );

    //bus to node tieline
    network.add(
      tieline_builder.build("TL3-1_2_3-2_1_3"),
      at("S1V2", 2, side_2),
      at("S2V1", "S2V1B3", connected, side_1)
    );
  }
#endif

  //endpoint components test: load, danglingline, SVC, shunt, generator
#if MACRO_WITH_COMPONENTS_TEST
  {
    cerr << "adding components test..." << endl;
    
    LoadBuilder loads = load_builder;
    DanglingLineBuilder const& dlines = danglingline_builder;

    GeneratorBuilder solars = solar_builder;
    GeneratorBuilder nuclears = nuclear_builder;

    network.add( substation_fr_builder.build("component tests") )
      .add( bus_voltagelevel_builder.build("CT_VL") )
        .add( bus_builder.build("CT_loads") )
        .add( bus_builder.build("CT_svc") )
        .add( bus_builder.build("CT_dlines") )
        .add( bus_builder.build("CT_shunts") )
        .add( bus_builder.build("CT_generators") )
        .add( bus_builder.build("CT_VscConverterStations") )
        .add( bus_builder.build("CT_LccConverterStations") )

        .add( bus_builder.build("CT_disconnecteds") )

        //loads
        .add( loads.type(Load::type_undefined ).build("CT_load1"), at("CT_loads", connected) )
        .add( loads.type(Load::type_auxiliary ).build("CT_load2"), at("CT_loads", connected) )
        .add( loads.type(Load::type_fictitious).build("CT_load3"), at("CT_loads", connected) )


        //svc
        .add( svc_off_builder.build("CT_svc_1"), at("CT_svc", disconnected)  )
        .add( svc_voltage_builder.build("CT_svc_2"), at("CT_svc", disconnected)  )
        .add( svc_reactive_builder.build("CT_svc_3"), at("CT_svc", disconnected)  )

        //danglinglines

        .add(
          dlines.clone().currentLimits( basic_current_limits ).build("CT_dline1"),
          at("CT_dlines", connected)
        )
        .add(
          dlines.clone().currentLimits( basic_current_limits ).ucte_xNodeCode("N").build("CT_dline2"),
          at("CT_dlines", connected)
        )
        .add(
          dlines.clone().ucte_xNodeCode("N").build("CT_dline3"),
          at("CT_dlines", connected)
        )
        .add(
          dlines.clone().currentLimits(boost::none).ucte_xNodeCode(boost::none).build("CT_dline4"),
          at("CT_dlines", connected)
        )
        .add(
          dlines.clone().build("CT_dline5"),
          at("CT_dlines", connected)
        )

        //shunt
        .add( shunt_builder.build("CT_shunt1"), at("CT_shunts", connected) )

        //generator
        .add( nuclears.regulatingTerminal(TerminalReference("CT_load1", side_1)).build("CT_nuclear1"), at("CT_generators", connected) )
        .add( solars.regulatingTerminal(TerminalReference("CT_load1", side_1)).build("CT_solar1"), at("CT_generators", connected) )

        //vscConverterStation
        .add( VscCSBuilder.build("CT_VscConverterStation1"), at("CT_VscConverterStations", connected) )

        //lccConverterStation
        .add( LccCSBuilder.build("CT_LccConverterStation1"), at("CT_LccConverterStations", connected) )

        //disconnecteds
        .add( load_builder.build("CT_disconnected_load"), at("CT_disconnecteds", disconnected) )
        .add( danglingline_builder.build("CT_disconnected_dline"), at("CT_disconnecteds", disconnected) )
        .add( nuclear_builder.build("CT_disconnected_generator"), at("CT_disconnecteds", disconnected) )

        //unconnectable
        .add( load_builder.build("CT_unconnectable_load") )
        .add( danglingline_builder.build("CT_unconnectable_dline"))
        .add( nuclear_builder.build("CT_unconnectable_generator"))
        
      .parent()
        .add( bus_voltagelevel_builder.build("CT_VL_transfos0") )
          .add( bus_builder.build("CT_transformersWindings0") )
          .add( load_builder.build("CT_reference0"), at("CT_transformersWindings0", connected) )
        .parent()
        .add( bus_voltagelevel_builder.build("CT_VL_transfos1") )
          .add( bus_builder.build("CT_transformersWindings1") )
          .add( load_builder.build("CT_reference1"), at("CT_transformersWindings1", connected) )
        .parent()
        .add( bus_voltagelevel_builder.build("CT_VL_transfos2") )
          .add( bus_builder.build("CT_transformersWindings2") )
          .add( load_builder.build("CT_reference2"), at("CT_transformersWindings2", connected) )
        .parent()
        .add( bus_voltagelevel_builder.build("CT_VL_transfos3") )
          .add( bus_builder.build("CT_transformersWindings3") )
          .add( load_builder.build("CT_reference3"), at("CT_transformersWindings3", connected) )
        .parent()
        
        // 2 windings transformersWindings
        .add( 
          Transformer2WindingsBuilder()
            .r(0).x(0).g(0).b(0)
            .ratedU1(0).p1(0).q1(0)
            .ratedU2(0).p2(0).q2(0)
            .phaseTapChanger(
              PhaseTapChanger(0, 2, PhaseTapChanger::mode_current_limiter).regulating(true).terminalReference(TerminalReference("CT_reference0"))
                .regulationValue(2)
                .step(0, 0, 0, 1, 0, 0)
                .step(0, 0, 0, 2, 0, 0)
                .step(0, 0, 0, 3, 0, 0)
            )
            .ratioTapChanger(
              RatioTapChanger(0, 2, false).regulating(true).terminalReference(TerminalReference("CT_reference1"))
                .targetV(1)
                .step(0, 0, 1, 0, 0)
                .step(0, 0, 2, 0, 0)
                .step(0, 0, 3, 0, 0)
            )
            .currentLimits1(basic_current_limits)
            .currentLimits2(basic_current_limits)
          .build("CT_2WT"),
          at("CT_VL_transfos0", "CT_transformersWindings0", connected, side_1),
          at("CT_VL_transfos1", "CT_transformersWindings1", connected, side_2)
        )

        // 3 windings transformersWindings
        .add( 
          Transformer3WindingsBuilder()
            .g1(0).b1(0)
            .r1(0).x1(0).ratedU1(0).p1(0).q1(0)
            .r2(0).x2(0).ratedU2(0).p2(0).q2(0)
            .r3(0).x3(0).ratedU3(0).p3(0).q3(0)
            .ratioTapChanger2(
              RatioTapChanger(0, 2, false).regulating(true).terminalReference(TerminalReference("CT_reference2"))
                .targetV(1)
                .step(0, 0, 1, 0, 0)
                .step(0, 0, 2, 0, 0)
                .step(0, 0, 3, 0, 0)
            )
            .ratioTapChanger3(
              RatioTapChanger(0, 2, false).regulating(true).terminalReference(TerminalReference("CT_reference3"))
                .targetV(1)
                .step(0, 0, 1, 0, 0)
                .step(0, 0, 2, 0, 0)
                .step(0, 0, 3, 0, 0)
            )
            .currentLimits1(basic_current_limits)
            .currentLimits2(basic_current_limits)
            .currentLimits3(basic_current_limits)
          .build("CT_3WT"),
          at("CT_VL_transfos1", "CT_transformersWindings1", connected, side_1),
          at("CT_VL_transfos2", "CT_transformersWindings2", connected, side_2),
          at("CT_VL_transfos3", "CT_transformersWindings3", connected, side_3)
        )
    ;
    
    Contains<Load>& CT_loads = network.substations().get("component tests").voltageLevels().get("CT_VL").loads();
    for (Contains<Load>::iterator it = CT_loads.begin(); it!=CT_loads.end(); ++it) {
      it->p(42);
    }
    
    network.add(
      hvdcline_builder.clone()
        .convertersMode(HvdcLine::mode_RectifierInverter)
        .converterStation1("CT_VscConverterStation1")
        .converterStation2("CT_LccConverterStation1")
      .build("HVDCLINE_1")
    );
    network.add(
      hvdcline_builder.clone()
        .convertersMode(HvdcLine::mode_InverterRectifier)
        .converterStation1("CT_LccConverterStation2")
        .converterStation2("CT_LccConverterStation3")
      .build("HVDCLINE_2")
    );
  }
#endif

  //topology test: voltagelevel, switches and transformators
#if MACRO_WITH_TOPOLOGY_TEST
  {
    cerr << "adding topology test..." << endl;
    VoltageLevelBuilder nodesVL_builder = VoltageLevelBuilder().mode(VoltageLevel::node_breaker).node_count(1).nominalV(50);
    BusBuilder bus_builder = BusBuilder().v(0).angle(10);

    Transformer2WindingsBuilder _2WT = Transformer2WindingsBuilder().r(0).x(0).g(0).b(0).ratedU1(0).ratedU2(0);
    Transformer3WindingsBuilder _3WT = Transformer3WindingsBuilder()
      .g1(0).b1(0)
      .r1(0).x1(0).ratedU1(0)
      .r2(0).x2(0).ratedU2(0)
      .r3(0).x3(0).ratedU3(0)
    ;

    network.add( substation_be_builder.build("topology tests") )

    //switch between buses
      .add( bus_voltagelevel_builder.build("TOPO_VL_switch_buses") )
        .add( bus_builder.build("TOPO_busA") )
        .add( bus_builder.build("TOPO_busB") )
        .add( bus_builder.build("TOPO_busC") )
        .add( breaker_builder.build("TOPO_bus_switch1"), "TOPO_busA", "TOPO_busB" )
        .add( breaker_builder.build("TOPO_bus_switch2"), "TOPO_busA", "TOPO_busC" )
        .add( breaker_builder.clone().opened(true).build("TOPO_bus_switch3"), "TOPO_busB", "TOPO_busC" )
      .parent()

    //switch between nodes
      .add( nodesVL_builder.clone().node_count(3).build("TOPO_VL_switch_nodes") )
        .add( BusBarSectionBuilder().node(0).build("TOPO_BBSA") )
        .add( BusBarSectionBuilder().node(1).build("TOPO_BBSB") )
        .add( BusBarSectionBuilder().node(2).build("TOPO_BBSC") )
        .add( breaker_builder.build("TOPO_node_switch1"), 0, 1 )
        .add( breaker_builder.build("TOPO_node_switch2"), 0, 1 )
        .add( breaker_builder.clone().opened(true).build("TOPO_node_switch3"), 0, 1 )
      .parent()



      // voltage levels for transformersWindings
      .add( bus_voltagelevel_builder.build("TOPO_VL_transfos_B1") )
        .add( bus_builder.build("TOPO_bus1") )
      .parent()
      .add( bus_voltagelevel_builder.build("TOPO_VL_transfos_B2") )
        .add( bus_builder.build("TOPO_bus2") )
      .parent()
      .add( bus_voltagelevel_builder.build("TOPO_VL_transfos_B3") )
        .add( bus_builder.build("TOPO_bus3") )
      .parent()

      .add( nodesVL_builder.build("TOPO_VL_transfos_N1") )
        .add( BusBarSectionBuilder().node(0).build("TOPO_BBS1") )
      .parent()

      .add( nodesVL_builder.build("TOPO_VL_transfos_N2") )
        .add( BusBarSectionBuilder().node(0).build("TOPO_BBS2") )
      .parent()

      .add( nodesVL_builder.build("TOPO_VL_transfos_N3") )
        .add( BusBarSectionBuilder().node(0).build("TOPO_BBS3") )
      .parent()

      // 2 windings transformersWindings
      .add( _2WT.build("BB 2WT"),
        at("TOPO_VL_transfos_B1", "TOPO_bus1", connected, side_1),
        at("TOPO_VL_transfos_B2", "TOPO_bus2", connected, side_2)
      )
      
      .add( _2WT.build("BN 2WT"),
        at("TOPO_VL_transfos_B1", "TOPO_bus1", connected, side_1),
        at("TOPO_VL_transfos_N2", 0, side_2)
      )
      
      .add( _2WT.build("NB 2WT"),
        at("TOPO_VL_transfos_N1", 0, side_1),
        at("TOPO_VL_transfos_B2", "TOPO_bus2", connected, side_2)
      )
      
      .add( _2WT.build("NN 2WT"),
        at("TOPO_VL_transfos_N1", 0, side_1),
        at("TOPO_VL_transfos_N2", 0, side_2)
      )

      // 3 windings transformersWindings
      .add( _3WT.build("BBB 3WT"),
        at("TOPO_VL_transfos_B1", "TOPO_bus1", connected, side_1),
        at("TOPO_VL_transfos_B2", "TOPO_bus2", connected, side_2),
        at("TOPO_VL_transfos_B3", "TOPO_bus3", connected, side_3)
      )

      .add( _3WT.build("BBN 3WT"),
        at("TOPO_VL_transfos_B1", "TOPO_bus1", connected, side_1),
        at("TOPO_VL_transfos_B2", "TOPO_bus2", connected, side_2),
        at("TOPO_VL_transfos_N3", 0, side_3)
      )
      .add( _3WT.build("BNB 3WT"),
        at("TOPO_VL_transfos_B1", "TOPO_bus1", connected, side_1),
        at("TOPO_VL_transfos_N2", 0, side_2),
        at("TOPO_VL_transfos_B3", "TOPO_bus3", connected, side_3)
      )
      .add( _3WT.build("NBB 3WT"),
        at("TOPO_VL_transfos_N1", 0, side_1),
        at("TOPO_VL_transfos_B2", "TOPO_bus2", connected, side_2),
        at("TOPO_VL_transfos_B3", "TOPO_bus3", connected, side_3)
      )

      .add( _3WT.build("BNN 3WT"),
        at("TOPO_VL_transfos_B1", "TOPO_bus1", connected, side_1),
        at("TOPO_VL_transfos_N2", 0, side_2),
        at("TOPO_VL_transfos_N3", 0, side_3)
      )
      .add( _3WT.build("NBN 3WT"),
        at("TOPO_VL_transfos_N1", 0, side_1),
        at("TOPO_VL_transfos_B2", "TOPO_bus2", connected, side_2),
        at("TOPO_VL_transfos_N3", 0, side_3)
      )
      .add( _3WT.build("NNB 3WT"),
        at("TOPO_VL_transfos_N1", 0, side_1),
        at("TOPO_VL_transfos_N2", 0, side_2),
        at("TOPO_VL_transfos_B3", "TOPO_bus3", connected, side_3)
      )

      .add( _3WT.build("NNN 3WT"),
        at("TOPO_VL_transfos_N1", 0, side_1),
        at("TOPO_VL_transfos_N2", 0, side_2),
        at("TOPO_VL_transfos_N3", 0, side_3)
      )
    ;
  }
#endif

  {
    cerr << "adding insertion order test..." << endl;

    network.add( substation_fr_builder.build("insertion order tests") )
      .add( bus_voltagelevel_builder.build("IOT_VL") )
        .add( bus_builder.build("IOT_bus") )

        .add( shunt_builder.build("IOT_3"), at("IOT_bus", connected)  )
        .add( shunt_builder.build("IOT_2"), at("IOT_bus", connected)  )
        .add( shunt_builder.build("IOT_1"), at("IOT_bus", connected)  )
    ;
  }

	cerr << "export xml..." << endl;
  
  if (argc >1) {
    for (int i = 1; i < argc; ++i) {
      std::ofstream output(argv[1]);
      IIDM::xml::to_xml(network, output);
      output.close();
    }
  } else {
    IIDM::xml::to_xml(network, std::cout);
  }

	cerr << "done." << endl;
	return 0;
}

