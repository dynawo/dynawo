within Dynawo.Examples.RVS.BaseSystems.BaseSystems_INIT;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model Loadflow_INIT
  import Modelica.SIunits.Conversions.from_deg;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Machines.SignalN.GeneratorPV_INIT;
  import Dynawo.Electrical.Controls.Basics.SetPoint_INIT;
  
  extends NetworkWithPQLoads_INIT;
  
  final parameter Types.VoltageModulePu U0Pu_bus_101 = 1.0342;
  final parameter Types.Angle UPhase0_bus_101 = from_deg(-18.6);
  final parameter Types.VoltageModulePu U0Pu_bus_10101 = 1.029;
  final parameter Types.Angle UPhase0_bus_10101 = from_deg(-15.1);
  final parameter Types.VoltageModulePu U0Pu_bus_20101 = 1.029;
  final parameter Types.Angle UPhase0_bus_20101 = from_deg(-15.1);
  final parameter Types.VoltageModulePu U0Pu_bus_30101 = 1.0115;
  final parameter Types.Angle UPhase0_bus_30101 = from_deg(-11.2);
  final parameter Types.VoltageModulePu U0Pu_bus_40101 = 1.0155;
  final parameter Types.Angle UPhase0_bus_40101 = from_deg(-11.2);
  final parameter Types.VoltageModulePu U0Pu_bus_102 = 1.0358;
  final parameter Types.Angle UPhase0_bus_102 = from_deg(-18.7);
  final parameter Types.VoltageModulePu U0Pu_bus_10102 = 1.043;
  final parameter Types.Angle UPhase0_bus_10102 = from_deg(-15.2);
  final parameter Types.VoltageModulePu U0Pu_bus_20102 = 1.043;
  final parameter Types.Angle UPhase0_bus_20102 = from_deg(-15.2);
  final parameter Types.VoltageModulePu U0Pu_bus_30102 = 1.0096;
  final parameter Types.Angle UPhase0_bus_30102 = from_deg(-11.3);
  final parameter Types.VoltageModulePu U0Pu_bus_40102 = 1.0096;
  final parameter Types.Angle UPhase0_bus_40102 = from_deg(-11.3);
  final parameter Types.VoltageModulePu U0Pu_bus_103 = 1.0072;
  final parameter Types.Angle UPhase0_bus_103 = from_deg(-16.2);
  final parameter Types.VoltageModulePu U0Pu_bus_104 = 1.0055;
  final parameter Types.Angle UPhase0_bus_104 = from_deg(-20.3);
  final parameter Types.VoltageModulePu U0Pu_bus_105 = 1.003;
  final parameter Types.Angle UPhase0_bus_105 = from_deg(-20.9);
  final parameter Types.VoltageModulePu U0Pu_bus_106 = 1.025;
  final parameter Types.Angle UPhase0_bus_106 = from_deg(-23.7);
  final parameter Types.VoltageModulePu U0Pu_bus_10106 = 1.05;
  final parameter Types.Angle UPhase0_bus_10106 = from_deg(-23.8);
  final parameter Types.VoltageModulePu U0Pu_bus_107 = 1.0286;
  final parameter Types.Angle UPhase0_bus_107 = from_deg(-22.2);
  final parameter Types.VoltageModulePu U0Pu_bus_10107 = 1.037;
  final parameter Types.Angle UPhase0_bus_10107 = from_deg(-16.5);
  final parameter Types.VoltageModulePu U0Pu_bus_20107 = 1.037;
  final parameter Types.Angle UPhase0_bus_20107 = from_deg(-16.5);
  final parameter Types.VoltageModulePu U0Pu_bus_30107 = 1.037;
  final parameter Types.Angle UPhase0_bus_30107 = from_deg(-16.5);
  final parameter Types.VoltageModulePu U0Pu_bus_108 = 1.0136;
  final parameter Types.Angle UPhase0_bus_108 = from_deg(-22.8);
  final parameter Types.VoltageModulePu U0Pu_bus_109 = 1.028;
  final parameter Types.Angle UPhase0_bus_109 = from_deg(-17.6);
  final parameter Types.VoltageModulePu U0Pu_bus_110 = 1.0088;
  final parameter Types.Angle UPhase0_bus_110 = from_deg(-19.8);
  final parameter Types.VoltageModulePu U0Pu_bus_111 = 0.9872;
  final parameter Types.Angle UPhase0_bus_111 = from_deg(-11.8);
  final parameter Types.VoltageModulePu U0Pu_bus_112 = 0.9851;
  final parameter Types.Angle UPhase0_bus_112 = from_deg(-10.1);
  final parameter Types.VoltageModulePu U0Pu_bus_113 = 1.0191;
  final parameter Types.Angle UPhase0_bus_113 = from_deg(-6.1);
  final parameter Types.VoltageModulePu U0Pu_bus_10113 = 1.0198;
  final parameter Types.Angle UPhase0_bus_10113 = from_deg(-0.1);
  final parameter Types.VoltageModulePu U0Pu_bus_20113 = 1.0181;
  final parameter Types.Angle UPhase0_bus_20113 = from_deg(-0.1);
  final parameter Types.VoltageModulePu U0Pu_bus_30113 = 1.0181;
  final parameter Types.Angle UPhase0_bus_30113 = from_deg(-0.1);
  final parameter Types.VoltageModulePu U0Pu_bus_114 = 1.0033;
  final parameter Types.Angle UPhase0_bus_114 = from_deg(-9.7);
  final parameter Types.VoltageModulePu U0Pu_bus_10114 = 1.05;
  final parameter Types.Angle UPhase0_bus_10114 = from_deg(-9.9);
  final parameter Types.VoltageModulePu U0Pu_bus_115 = 1.0111;
  final parameter Types.Angle UPhase0_bus_115 = from_deg(1);
  final parameter Types.VoltageModulePu U0Pu_bus_10115 = 1.0204;
  final parameter Types.Angle UPhase0_bus_10115 = from_deg(8.4);
  final parameter Types.VoltageModulePu U0Pu_bus_20115 = 1.0204;
  final parameter Types.Angle UPhase0_bus_20115 = from_deg(-8.4);
  final parameter Types.VoltageModulePu U0Pu_bus_30115 = 1.0204;
  final parameter Types.Angle UPhase0_bus_30115 = from_deg(8.4);
  final parameter Types.VoltageModulePu U0Pu_bus_40115 = 1.0204;
  final parameter Types.Angle UPhase0_bus_40115 = from_deg(8.4);
  final parameter Types.VoltageModulePu U0Pu_bus_50115 = 1.0204;
  final parameter Types.Angle UPhase0_bus_50115 = from_deg(8.4);
  final parameter Types.VoltageModulePu U0Pu_bus_60115 = 1.022;
  final parameter Types.Angle UPhase0_bus_60115 = from_deg(8.4);
  final parameter Types.VoltageModulePu U0Pu_bus_116 = 1.0164;
  final parameter Types.Angle UPhase0_bus_116 = from_deg(0.4);
  final parameter Types.VoltageModulePu U0Pu_bus_10116 = 1.0159;
  final parameter Types.Angle UPhase0_bus_10116 = from_deg(7.8);
  final parameter Types.VoltageModulePu U0Pu_bus_117 = 1.0338;
  final parameter Types.Angle UPhase0_bus_117 = from_deg(4.5);
  final parameter Types.VoltageModulePu U0Pu_bus_118 = 1.0425;
  final parameter Types.Angle UPhase0_bus_118 = from_deg(5.6);
  final parameter Types.VoltageModulePu U0Pu_bus_10118 = 1.0487;
  final parameter Types.Angle UPhase0_bus_10118 = from_deg(12.6);
  final parameter Types.VoltageModulePu U0Pu_bus_119 = 1.018;
  final parameter Types.Angle UPhase0_bus_119 = from_deg(-0.7);
  final parameter Types.VoltageModulePu U0Pu_bus_120 = 1.0349;
  final parameter Types.Angle UPhase0_bus_120 = from_deg(0.4);
  final parameter Types.VoltageModulePu U0Pu_bus_121 = 1.0459;
  final parameter Types.Angle UPhase0_bus_121 = from_deg(6.5);
  final parameter Types.VoltageModulePu U0Pu_bus_10121 = 1.0468;
  final parameter Types.Angle UPhase0_bus_10121 = from_deg(13.4);
  final parameter Types.VoltageModulePu U0Pu_bus_122 = 1.05;
  final parameter Types.Angle UPhase0_bus_122 = from_deg(12.2);
  final parameter Types.VoltageModulePu U0Pu_bus_10122 = 1.0034;
  final parameter Types.Angle UPhase0_bus_10122 = from_deg(20.3);
  final parameter Types.VoltageModulePu U0Pu_bus_20122 = 1.0034;
  final parameter Types.Angle UPhase0_bus_20122 = from_deg(20.3);
  final parameter Types.VoltageModulePu U0Pu_bus_30122 = 1.0034;
  final parameter Types.Angle UPhase0_bus_30122 = from_deg(20.3);
  final parameter Types.VoltageModulePu U0Pu_bus_40122 = 1.0034;
  final parameter Types.Angle UPhase0_bus_40122 = from_deg(20.3);
  final parameter Types.VoltageModulePu U0Pu_bus_50122 = 1.0034;
  final parameter Types.Angle UPhase0_bus_50122 = from_deg(20.3);
  final parameter Types.VoltageModulePu U0Pu_bus_60122 = 1.0034;
  final parameter Types.Angle UPhase0_bus_60122 = from_deg(20.3);
  final parameter Types.VoltageModulePu U0Pu_bus_123 = 1.0499;
  final parameter Types.Angle UPhase0_bus_123 = from_deg(1.8);
  final parameter Types.VoltageModulePu U0Pu_bus_10123 = 1.0491;
  final parameter Types.Angle UPhase0_bus_10123 = from_deg(8.8);
  final parameter Types.VoltageModulePu U0Pu_bus_20123 = 1.0491;
  final parameter Types.Angle UPhase0_bus_20123 = from_deg(8.8);
  final parameter Types.VoltageModulePu U0Pu_bus_30123 = 1.0401;
  final parameter Types.Angle UPhase0_bus_30123 = from_deg(8.8);
  final parameter Types.VoltageModulePu U0Pu_bus_124 = 0.955;
  final parameter Types.Angle UPhase0_bus_124 = from_deg(-5.8);
  
  // Generators
  final parameter Types.ActivePower P0Pu_gen_10101 = 10 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_10101 = 7.3689 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_10101 = 1.0342;
  final parameter Types.ActivePower P0Pu_gen_20101 = 10 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_20101 = 7.3689 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_20101 = 1.0342;
  final parameter Types.ActivePower P0Pu_gen_30101 = 76 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_30101 = 21.7756 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_30101 = 1.0342;
  final parameter Types.ActivePower P0Pu_gen_40101 = 76 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_40101 = 21.7756 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_40101 = 1.0342;
  
  final parameter Types.ActivePower P0Pu_gen_10102 = 10 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_10102 = 9.5355 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_10102 = 1.0358;
  
  final parameter Types.ActivePower P0Pu_gen_20102 = 10 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_20102 = 9.5355 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_20102 = 1.0358;
  final parameter Types.ActivePower P0Pu_gen_30102 = 76 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_30102 = 21.7756 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_30102 = 1.0358;
  final parameter Types.ActivePower P0Pu_gen_40102 = 76 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_40102 = 21.7756 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_40102 = 1.0358;
  
  final parameter Types.ActivePower P0Pu_gen_10107 = 80 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_10107 = 49.1462 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_10107 = 1.0286;
  final parameter Types.ActivePower P0Pu_gen_20107 = 80 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_20107 = 49.1462 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_20107 = 1.0286;
  final parameter Types.ActivePower P0Pu_gen_30107 = 80 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_30107 = 49.1462 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_30107 = 1.0286;
  
  final parameter Types.ActivePower P0Pu_gen_10113 = 162.5 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_10113 = 82.7791 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_10113 = 1.02;
  final parameter Types.ActivePower P0Pu_gen_20113 = 162.5 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_20113 = 80 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_20113 = 1.02;
  final parameter Types.ActivePower P0Pu_gen_30113 = 162.5 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_30113 = 80 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_30113 = 1.02;
  
  final parameter Types.ActivePower P0Pu_gen_10115 = 12 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_10115 = 6 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_10115 = 1.0113;
  final parameter Types.ActivePower P0Pu_gen_20115 = 12 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_20115 = 6 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_20115 = 1.0113;
  final parameter Types.ActivePower P0Pu_gen_30115 = 12 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_30115 = 6 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_30115 = 1.0113;
  final parameter Types.ActivePower P0Pu_gen_40115 = 12 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_40115 = 6 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_40115 = 1.0113;
  final parameter Types.ActivePower P0Pu_gen_50115 = 12 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_50115 = 6 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_50115 = 1.0113;
  final parameter Types.ActivePower P0Pu_gen_60115 = 155 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_60115 = 80 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_60115 = 1.0113;
  
  final parameter Types.ActivePower P0Pu_gen_10116 = 155 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_10116 = 65.9891 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_10116 = 1.0164;
  
  final parameter Types.ActivePower P0Pu_gen_10118 = 400 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_10118 = 200 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_10118 = 1.0432;
  
  final parameter Types.ActivePower P0Pu_gen_10121 = 398.6392 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_10121 = 182.7737 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_10121 = 1.0468;
  final parameter Types.ActivePower P0Pu_gen_10122 = 50 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_10122 = 3.7514 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_10122 = 1.05;
  final parameter Types.ActivePower P0Pu_gen_20122 = 50 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_20122 = 3.7514 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_20122 = 1.05;
  final parameter Types.ActivePower P0Pu_gen_30122 = 50 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_30122 = 3.7514 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_30122 = 1.05;
  final parameter Types.ActivePower P0Pu_gen_40122 = 50 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_40122 = 3.7514 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_40122 = 1.05;
  final parameter Types.ActivePower P0Pu_gen_50122 = 50 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_50122 = 3.7514 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_50122 = 1.05;
  final parameter Types.ActivePower P0Pu_gen_60122 = 50 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_60122 = 3.7514 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_60122 = 1.05;
  
  final parameter Types.ActivePower P0Pu_gen_10123 = 155 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_10123 = 68.8361 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_10123 = 1.0499;
  final parameter Types.ActivePower P0Pu_gen_20123 = 155 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_20123 = 68.8361 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_20123 = 1.0499;
  final parameter Types.ActivePower P0Pu_gen_30123 = 350 / SystemBase.SnRef;
  final parameter Types.ReactivePower Q0Pu_gen_30123 = 128.9053 / SystemBase.SnRef;
  final parameter Types.VoltageModulePu USched_gen_30123 = 1.0499;
  
  // Init Models
  SetPoint_INIT N;
  SetPoint_INIT URef_gen_10101;
  SetPoint_INIT URef_gen_20101;
  SetPoint_INIT URef_gen_30101;
  SetPoint_INIT URef_gen_40101;
  SetPoint_INIT URef_gen_10102;
  SetPoint_INIT URef_gen_20102;
  SetPoint_INIT URef_gen_30102;
  SetPoint_INIT URef_gen_40102;
  SetPoint_INIT URef_gen_10107;
  SetPoint_INIT URef_gen_20107;
  SetPoint_INIT URef_gen_30107;
  SetPoint_INIT URef_gen_10113;
  SetPoint_INIT URef_gen_20113;
  SetPoint_INIT URef_gen_30113;
  SetPoint_INIT URef_gen_10115;
  SetPoint_INIT URef_gen_20115;
  SetPoint_INIT URef_gen_30115;
  SetPoint_INIT URef_gen_40115;
  SetPoint_INIT URef_gen_50115;
  SetPoint_INIT URef_gen_60115;
  SetPoint_INIT URef_gen_10116;
  SetPoint_INIT URef_gen_10118;
  SetPoint_INIT URef_gen_10121;
  SetPoint_INIT URef_gen_10122;
  SetPoint_INIT URef_gen_20122;
  SetPoint_INIT URef_gen_30122;
  SetPoint_INIT URef_gen_40122;
  SetPoint_INIT URef_gen_50122;
  SetPoint_INIT URef_gen_60122;
  SetPoint_INIT URef_gen_10123;
  SetPoint_INIT URef_gen_20123;
  SetPoint_INIT URef_gen_30123;
  
  GeneratorPV_INIT gen_10101_ABEL_G1(PMax = 9999, PMin = 0, QMax = 10, QMin = 0,
                                      P0Pu = P0Pu_gen_10101, Q0Pu = Q0Pu_gen_10101, U0Pu = U0Pu_bus_10101, UPhase0 = UPhase0_bus_10101);
  GeneratorPV_INIT gen_20101_ABEL_G2(PMax = 9999, PMin = 0, QMax = 10, QMin = 0,
                                      P0Pu = P0Pu_gen_20101, Q0Pu = Q0Pu_gen_20101, U0Pu = U0Pu_bus_20101, UPhase0 = UPhase0_bus_20101);
  GeneratorPV_INIT gen_30101_ABEL_G3(PMax = 9999, PMin = 0, QMax = 30, QMin = -25,
                                      P0Pu = P0Pu_gen_30101, Q0Pu = Q0Pu_gen_30101, U0Pu = U0Pu_bus_30101, UPhase0 = UPhase0_bus_30101);
  GeneratorPV_INIT gen_40101_ABEL_G4(PMax = 9999, PMin = 0, QMax = 30, QMin = -25,
                                      P0Pu = P0Pu_gen_40101, Q0Pu = Q0Pu_gen_40101, U0Pu = U0Pu_bus_40101, UPhase0 = UPhase0_bus_40101);
  GeneratorPV_INIT gen_10102_ADAMS_G1(PMax = 9999, PMin = 0, QMax = 10, QMin = 0,
                                      P0Pu = P0Pu_gen_10102, Q0Pu = Q0Pu_gen_10102, U0Pu = U0Pu_bus_10102, UPhase0 = UPhase0_bus_10102);
  GeneratorPV_INIT gen_20102_ADAMS_G2(PMax = 9999, PMin = 0, QMax = 10, QMin = 0,
                                      P0Pu = P0Pu_gen_20102, Q0Pu = Q0Pu_gen_20102, U0Pu = U0Pu_bus_20102, UPhase0 = UPhase0_bus_20102);
  GeneratorPV_INIT gen_30102_ADAMS_G3(PMax = 9999, PMin = 0, QMax = 30, QMin = -25,
                                      P0Pu = P0Pu_gen_30102, Q0Pu = Q0Pu_gen_30102, U0Pu = U0Pu_bus_30102, UPhase0 = UPhase0_bus_30102);
  GeneratorPV_INIT gen_40102_ADAMS_G4(PMax = 9999, PMin = 0, QMax = 30, QMin = -25,
                                      P0Pu = P0Pu_gen_40102, Q0Pu = Q0Pu_gen_40102, U0Pu = U0Pu_bus_40102, UPhase0 = UPhase0_bus_40102);
  GeneratorPV_INIT gen_10107_ALDER_G1(PMax = 9999, PMin = 0, QMax = 60, QMin = 0,
                                      P0Pu = P0Pu_gen_10107, Q0Pu = Q0Pu_gen_10107, U0Pu = U0Pu_bus_10107, UPhase0 = UPhase0_bus_10107);
  GeneratorPV_INIT gen_20107_ALDER_G2(PMax = 9999, PMin = 0, QMax = 60, QMin = 0,
                                      P0Pu = P0Pu_gen_20107, Q0Pu = Q0Pu_gen_20107, U0Pu = U0Pu_bus_20107, UPhase0 = UPhase0_bus_20107);
  GeneratorPV_INIT gen_30107_ALDER_G3(PMax = 9999, PMin = 0, QMax = 60, QMin = 0,
                                      P0Pu = P0Pu_gen_30107, Q0Pu = Q0Pu_gen_30107, U0Pu = U0Pu_bus_30107, UPhase0 = UPhase0_bus_30107);
  GeneratorPV_INIT gen_10113_ARNE_G1(PMax = 9999, PMin = 0, QMax = 82.7791, QMin = 0,
                                      P0Pu = P0Pu_gen_10113, Q0Pu = Q0Pu_gen_10113, U0Pu = U0Pu_bus_10113, UPhase0 = UPhase0_bus_10113);
  GeneratorPV_INIT gen_20113_ARNE_G2(PMax = 9999, PMin = 0, QMax = 80, QMin = 0,
                                      P0Pu = P0Pu_gen_20113, Q0Pu = Q0Pu_gen_20113, U0Pu = U0Pu_bus_20113, UPhase0 = UPhase0_bus_20113);
  GeneratorPV_INIT gen_30113_ARNE_G3(PMax = 9999, PMin = 0, QMax = 80, QMin = 0,
                                      P0Pu = P0Pu_gen_30113, Q0Pu = Q0Pu_gen_30113, U0Pu = U0Pu_bus_30113, UPhase0 = UPhase0_bus_30113);
  GeneratorPV_INIT gen_10115_ARTHUR_G1(PMax = 9999, PMin = 0, QMax = 6, QMin = 0,
                                      P0Pu = P0Pu_gen_10115, Q0Pu = Q0Pu_gen_10115, U0Pu = U0Pu_bus_10115, UPhase0 = UPhase0_bus_10115);
  GeneratorPV_INIT gen_20115_ARTHUR_G2(PMax = 9999, PMin = 0, QMax = 6, QMin = 0,
                                      P0Pu = P0Pu_gen_20115, Q0Pu = Q0Pu_gen_20115, U0Pu = U0Pu_bus_20115, UPhase0 = UPhase0_bus_20115);
  GeneratorPV_INIT gen_30115_ARTHUR_G3(PMax = 9999, PMin = 0, QMax = 6, QMin = 0,
                                      P0Pu = P0Pu_gen_30115, Q0Pu = Q0Pu_gen_30115, U0Pu = U0Pu_bus_30115, UPhase0 = UPhase0_bus_30115);
  GeneratorPV_INIT gen_40115_ARTHUR_G4(PMax = 9999, PMin = 0, QMax = 6, QMin = 0,
                                      P0Pu = P0Pu_gen_40115, Q0Pu = Q0Pu_gen_40115, U0Pu = U0Pu_bus_40115, UPhase0 = UPhase0_bus_40115);
  GeneratorPV_INIT gen_50115_ARTHUR_G5(PMax = 9999, PMin = 0, QMax = 6, QMin = 0,
                                      P0Pu = P0Pu_gen_50115, Q0Pu = Q0Pu_gen_50115, U0Pu = U0Pu_bus_50115, UPhase0 = UPhase0_bus_50115);
  GeneratorPV_INIT gen_60115_ARTHUR_G6(PMax = 9999, PMin = 0, QMax = 80, QMin = -50,
                                      P0Pu = P0Pu_gen_60115, Q0Pu = Q0Pu_gen_60115, U0Pu = U0Pu_bus_60115, UPhase0 = UPhase0_bus_60115);
  GeneratorPV_INIT gen_10116_ASSER_G1(PMax = 9999, PMin = 0, QMax = 80, QMin = -50,
                                      P0Pu = P0Pu_gen_10116, Q0Pu = Q0Pu_gen_10116, U0Pu = U0Pu_bus_10116, UPhase0 = UPhase0_bus_10116);
  GeneratorPV_INIT gen_10118_ASTOR_G1(PMax = 9999, PMin = 0, QMax = 200, QMin = -50,
                                      P0Pu = P0Pu_gen_10118, Q0Pu = Q0Pu_gen_10118, U0Pu = U0Pu_bus_10118, UPhase0 = UPhase0_bus_10118);
  GeneratorPV_INIT gen_10121_ATTLEE_G1(PMax = 9999, PMin = 0, QMax = 200, QMin = -50,
                                      P0Pu = P0Pu_gen_10121, Q0Pu = Q0Pu_gen_10121, U0Pu = U0Pu_bus_10121, UPhase0 = UPhase0_bus_10121);
  GeneratorPV_INIT gen_10122_AUBREY_G1(PMax = 9999, PMin = 0, QMax = 16, QMin = -10,
                                      P0Pu = P0Pu_gen_10122, Q0Pu = Q0Pu_gen_10122, U0Pu = U0Pu_bus_10122, UPhase0 = UPhase0_bus_10122);
  GeneratorPV_INIT gen_20122_AUBREY_G2(PMax = 9999, PMin = 0, QMax = 16, QMin = -10,
                                      P0Pu = P0Pu_gen_20122, Q0Pu = Q0Pu_gen_20122, U0Pu = U0Pu_bus_20122, UPhase0 = UPhase0_bus_20122);
  GeneratorPV_INIT gen_30122_AUBREY_G3(PMax = 9999, PMin = 0, QMax = 16, QMin = -10,
                                      P0Pu = P0Pu_gen_30122, Q0Pu = Q0Pu_gen_30122, U0Pu = U0Pu_bus_30122, UPhase0 = UPhase0_bus_30122);
  GeneratorPV_INIT gen_40122_AUBREY_G4(PMax = 9999, PMin = 0, QMax = 16, QMin = -10,
                                      P0Pu = P0Pu_gen_40122, Q0Pu = Q0Pu_gen_40122, U0Pu = U0Pu_bus_40122, UPhase0 = UPhase0_bus_40122);
  GeneratorPV_INIT gen_50122_AUBREY_G5(PMax = 9999, PMin = 0, QMax = 16, QMin = -10,
                                      P0Pu = P0Pu_gen_50122, Q0Pu = Q0Pu_gen_50122, U0Pu = U0Pu_bus_50122, UPhase0 = UPhase0_bus_50122);
  GeneratorPV_INIT gen_60122_AUBREY_G6(PMax = 9999, PMin = 0, QMax = 16, QMin = -10,
                                      P0Pu = P0Pu_gen_60122, Q0Pu = Q0Pu_gen_60122, U0Pu = U0Pu_bus_60122, UPhase0 = UPhase0_bus_60122);
  GeneratorPV_INIT gen_10123_AUSTEN_G1(PMax = 9999, PMin = 0, QMax = 80, QMin = -50,
                                      P0Pu = P0Pu_gen_10123, Q0Pu = Q0Pu_gen_10123, U0Pu = U0Pu_bus_10123, UPhase0 = UPhase0_bus_10123);
  GeneratorPV_INIT gen_20123_AUSTEN_G2(PMax = 9999, PMin = 0, QMax = 80, QMin = -50,
                                      P0Pu = P0Pu_gen_20123, Q0Pu = Q0Pu_gen_20123, U0Pu = U0Pu_bus_20123, UPhase0 = UPhase0_bus_20123);
  GeneratorPV_INIT gen_30123_AUSTEN_G3(PMax = 9999, PMin = 0,  QMax = 150, QMin = -50,
                                      P0Pu = P0Pu_gen_30123, Q0Pu = Q0Pu_gen_30123, U0Pu = U0Pu_bus_30123, UPhase0 = UPhase0_bus_30123);
equation
  N.Value0 = 0;
  URef_gen_10101.Value0 = USched_gen_10101;
  URef_gen_20101.Value0 = USched_gen_20101;
  URef_gen_30101.Value0 = USched_gen_30101;
  URef_gen_40101.Value0 = USched_gen_40101;
  URef_gen_10102.Value0 = USched_gen_10102;
  URef_gen_20102.Value0 = USched_gen_20102;
  URef_gen_30102.Value0 = USched_gen_30102;
  URef_gen_40102.Value0 = USched_gen_40102;
  URef_gen_10107.Value0 = USched_gen_10107;
  URef_gen_20107.Value0 = USched_gen_20107;
  URef_gen_30107.Value0 = USched_gen_30107;
  URef_gen_10113.Value0 = USched_gen_10113;
  URef_gen_20113.Value0 = USched_gen_20113;
  URef_gen_30113.Value0 = USched_gen_30113;
  URef_gen_10115.Value0 = USched_gen_10115;
  URef_gen_20115.Value0 = USched_gen_20115;
  URef_gen_30115.Value0 = USched_gen_30115;
  URef_gen_40115.Value0 = USched_gen_40115;
  URef_gen_50115.Value0 = USched_gen_50115;
  URef_gen_60115.Value0 = USched_gen_60115;
  URef_gen_10116.Value0 = USched_gen_10116;
  URef_gen_10118.Value0 = USched_gen_10118;
  URef_gen_10121.Value0 = USched_gen_10121;
  URef_gen_10122.Value0 = USched_gen_10122;
  URef_gen_20122.Value0 = USched_gen_20122;
  URef_gen_30122.Value0 = USched_gen_30122;
  URef_gen_40122.Value0 = USched_gen_40122;
  URef_gen_50122.Value0 = USched_gen_50122;
  URef_gen_60122.Value0 = USched_gen_60122;
  URef_gen_10123.Value0 = USched_gen_10123;
  URef_gen_20123.Value0 = USched_gen_20123;
  URef_gen_30123.Value0 = USched_gen_30123;

end Loadflow_INIT;
