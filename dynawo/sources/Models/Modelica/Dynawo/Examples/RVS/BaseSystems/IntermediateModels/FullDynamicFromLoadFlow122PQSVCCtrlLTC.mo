within Dynawo.Examples.RVS.BaseSystems.IntermediateModels;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model FullDynamicFromLoadFlow122PQSVCCtrlLTC
  import Modelica.SIunits.Conversions.from_deg;
  import Dynawo;
  import Dynawo.Electrical.SystemBase.SnRef;

  extends NetworkWithTrf;

  parameter Types.ReactivePowerPu QPu_load_101 = 2.5;
  parameter Types.VoltageModulePu URefStep_SVarC_10106 = 1.05;

  final parameter Types.VoltageModule UNom_upper = 230;
  final parameter Types.VoltageModule UNom_lower = 138 "Nominal Voltage of the lower part of the network in kV";
  final parameter Types.VoltageModule UNom_gen = 18 "Nominal Voltage of the generator busses in kV";
  final parameter Types.VoltageModule URef0_bus_101 = 1.0342 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_102 = 1.0358 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_106 = 1.0025 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_107 = 1.0286 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_110 = 1.0088 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_113 = 1.02 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_115 = 1.0113 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_116 = 1.0164 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_118 = 1.0432 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_122 = 1.05 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_123 = 1.0499 * UNom_upper;

  final constant Types.ActivePowerPu P0Pu_sVarC_10106_ALBER_SVC = -4.0495384823202585e-14;
  final constant Types.ReactivePowerPu Q0Pu_sVarC_10106_ALBER_SVC = -0.6164618807059862;
  final constant Types.VoltageModulePu U0Pu_sVarC_10106_ALBER_SVC = 1.049999952316467;
  final constant Types.Angle UPhase0_sVarC_10106_ALBER_SVC = -0.4170880483313303;
  final constant Types.ComplexApparentPowerPu s0Pu_sVarC_10106_ALBER_SVC = Complex(P0Pu_sVarC_10106_ALBER_SVC, Q0Pu_sVarC_10106_ALBER_SVC);
  final constant Types.ComplexVoltagePu u0Pu_sVarC_10106_ALBER_SVC = ComplexMath.fromPolar(U0Pu_sVarC_10106_ALBER_SVC, UPhase0_sVarC_10106_ALBER_SVC);
  final constant Types.ComplexCurrentPu i0Pu_sVarC_10106_ALBER_SVC = ComplexMath.conj(s0Pu_sVarC_10106_ALBER_SVC / u0Pu_sVarC_10106_ALBER_SVC);
  final constant Types.PerUnit B0Pu_sVarC_10106_ALBER_SVC = Q0Pu_sVarC_10106_ALBER_SVC / U0Pu_sVarC_10106_ALBER_SVC ^ 2;
  final constant Types.ActivePowerPu P0Pu_sVarC_10114_ARNOLD_SVC = -8.97615315409439e-14;
  final constant Types.ReactivePowerPu Q0Pu_sVarC_10114_ARNOLD_SVC = -1.254762105260428;
  final constant Types.VoltageModulePu U0Pu_sVarC_10114_ARNOLD_SVC = 1.049999952316385;
  final constant Types.Angle UPhase0_sVarC_10114_ARNOLD_SVC = -0.17175578394927937;
  final constant Types.ComplexApparentPowerPu s0Pu_sVarC_10114_ARNOLD_SVC = Complex(P0Pu_sVarC_10114_ARNOLD_SVC, Q0Pu_sVarC_10114_ARNOLD_SVC);
  final constant Types.ComplexVoltagePu u0Pu_sVarC_10114_ARNOLD_SVC = ComplexMath.fromPolar(U0Pu_sVarC_10114_ARNOLD_SVC, UPhase0_sVarC_10114_ARNOLD_SVC);
  final constant Types.ComplexCurrentPu i0Pu_sVarC_10114_ARNOLD_SVC = ComplexMath.conj(s0Pu_sVarC_10114_ARNOLD_SVC / u0Pu_sVarC_10114_ARNOLD_SVC);
  final constant Types.PerUnit B0Pu_sVarC_10114_ARNOLD_SVC = Q0Pu_sVarC_10114_ARNOLD_SVC / U0Pu_sVarC_10114_ARNOLD_SVC ^ 2;
  // Generators
  final constant Types.ActivePowerPu P0Pu_gen_10101_ABEL_G1 = -0.09999999999492322;
  final constant Types.ReactivePowerPu Q0Pu_gen_10101_ABEL_G1 = -0.0747006931432781;
  final constant Types.VoltageModulePu U0Pu_gen_10101_ABEL_G1 = 1.0296020605827343;
  final constant Types.Angle UPhase0_gen_10101_ABEL_G1 = -0.26528375249349523;
  final constant Types.ActivePowerPu P0Pu_gen_10102_ADAMS_G1 = -0.09999999999494089;
  final constant Types.ReactivePowerPu Q0Pu_gen_10102_ADAMS_G1 = -0.10294511872209362;
  final constant Types.VoltageModulePu U0Pu_gen_10102_ADAMS_G1 = 1.047286860269937;
  final constant Types.Angle UPhase0_gen_10102_ADAMS_G1 = -0.26873055958340697;
  final constant Types.ActivePowerPu P0Pu_gen_10107_ALDER_G1 = -0.7999999999726052;
  final constant Types.ReactivePowerPu Q0Pu_gen_10107_ALDER_G1 = -0.5106708523802469;
  final constant Types.VoltageModulePu U0Pu_gen_10107_ALDER_G1 = 1.0392093432573648;
  final constant Types.Angle UPhase0_gen_10107_ALDER_G1 = -0.2909981796235494;
  final constant Types.ActivePowerPu P0Pu_gen_10113_ARNE_G1 = -1.6250000001927132;
  final constant Types.ReactivePowerPu Q0Pu_gen_10113_ARNE_G1 = -0.0378376197136411;
  final constant Types.VoltageModulePu U0Pu_gen_10113_ARNE_G1 = 0.9699722451585717;
  final constant Types.Angle UPhase0_gen_10113_ARNE_G1 = 0.00410841273654951;
  final constant Types.ActivePowerPu P0Pu_gen_10115_ARTHUR_G1 = -0.11999999999728818;
  final constant Types.ReactivePowerPu Q0Pu_gen_10115_ARTHUR_G1 = -0.06383030028772678;
  final constant Types.VoltageModulePu U0Pu_gen_10115_ARTHUR_G1 = 1.0237450113009863;
  final constant Types.Angle UPhase0_gen_10115_ARTHUR_G1 = 0.14591107650805835;
  final constant Types.ActivePowerPu P0Pu_gen_10116_ASSER_G1 = -1.550000148856329;
  final constant Types.ReactivePowerPu Q0Pu_gen_10116_ASSER_G1 = -0.5361276776730247;
  final constant Types.VoltageModulePu U0Pu_gen_10116_ASSER_G1 = 1.005707605152536;
  final constant Types.Angle UPhase0_gen_10116_ASSER_G1 = 0.13728705789917342;
  final constant Types.ActivePowerPu P0Pu_gen_10118_ASTOR_G1 = -4.000000355338675;
  final constant Types.ReactivePowerPu Q0Pu_gen_10118_ASTOR_G1 = -2.0301805325991826;
  final constant Types.VoltageModulePu U0Pu_gen_10118_ASTOR_G1 = 1.049501524085332;
  final constant Types.Angle UPhase0_gen_10118_ASTOR_G1 = 0.219179365403202;
  final constant Types.ActivePowerPu P0Pu_gen_10122_AUBREY_G1 = -0.5000004099960184;
  final constant Types.ReactivePowerPu Q0Pu_gen_10122_AUBREY_G1 = -0.036463694362460664;
  final constant Types.VoltageModulePu U0Pu_gen_10122_AUBREY_G1 = 1.0025914159367653;
  final constant Types.Angle UPhase0_gen_10122_AUBREY_G1 = 0.35407238234960037;
  final constant Types.ActivePowerPu P0Pu_gen_10123_AUSTEN_G1 = -1.550000063473528;
  final constant Types.ReactivePowerPu Q0Pu_gen_10123_AUSTEN_G1 = -0.7087170883544405;
  final constant Types.VoltageModulePu U0Pu_gen_10123_AUSTEN_G1 = 1.0505080247133123;
  final constant Types.Angle UPhase0_gen_10123_AUSTEN_G1 = 0.15217939470869046;
  final constant Types.ActivePowerPu P0Pu_gen_20101_ABEL_G2 = -0.09999999999492801;
  final constant Types.ReactivePowerPu Q0Pu_gen_20101_ABEL_G2 = -0.07470069314325702;
  final constant Types.VoltageModulePu U0Pu_gen_20101_ABEL_G2 = 1.029602060582723;
  final constant Types.Angle UPhase0_gen_20101_ABEL_G2 = -0.265283752493495;
  final constant Types.ActivePowerPu P0Pu_gen_20102_ADAMS_G2 = -0.09999999999493148;
  final constant Types.ReactivePowerPu Q0Pu_gen_20102_ADAMS_G2 = -0.10294511872206842;
  final constant Types.VoltageModulePu U0Pu_gen_20102_ADAMS_G2 = 1.047286860269925;
  final constant Types.Angle UPhase0_gen_20102_ADAMS_G2 = -0.2687305595834085;
  final constant Types.ActivePowerPu P0Pu_gen_20107_ALDER_G2 = -0.7999999999725957;
  final constant Types.ReactivePowerPu Q0Pu_gen_20107_ALDER_G2 = -0.5107086749439578;
  final constant Types.VoltageModulePu U0Pu_gen_20107_ALDER_G2 = 1.0392137465540379;
  final constant Types.Angle UPhase0_gen_20107_ALDER_G2 = -0.29099869448046284;
  final constant Types.ActivePowerPu P0Pu_gen_20113_ARNE_G2 = -1.6249999999306455;
  final constant Types.ReactivePowerPu Q0Pu_gen_20113_ARNE_G2 = -1.2008084007899797;
  final constant Types.VoltageModulePu U0Pu_gen_20113_ARNE_G2 = 1.0427229897892534;
  final constant Types.Angle UPhase0_gen_20113_ARNE_G2 = -0.005206386553900649;
  final constant Types.ActivePowerPu P0Pu_gen_20115_ARTHUR_G2 = -0.11999999999728826;
  final constant Types.ReactivePowerPu Q0Pu_gen_20115_ARTHUR_G2 = -0.06383030028773819;
  final constant Types.VoltageModulePu U0Pu_gen_20115_ARTHUR_G2 = 1.023745011300991;
  final constant Types.Angle UPhase0_gen_20115_ARTHUR_G2 = 0.14591107650805607;
  final constant Types.ActivePowerPu P0Pu_gen_20122_AUBREY_G2 = -0.5000004099960331;
  final constant Types.ReactivePowerPu Q0Pu_gen_20122_AUBREY_G2 = -0.03646369436252084;
  final constant Types.VoltageModulePu U0Pu_gen_20122_AUBREY_G2 = 1.002591415936771;
  final constant Types.Angle UPhase0_gen_20122_AUBREY_G2 = 0.3540723823496088;
  final constant Types.ActivePowerPu P0Pu_gen_20123_AUSTEN_G2 = -1.5500000634748163;
  final constant Types.ReactivePowerPu Q0Pu_gen_20123_AUSTEN_G2 = -0.7087170883555296;
  final constant Types.VoltageModulePu U0Pu_gen_20123_AUSTEN_G2 = 1.0505080247133731;
  final constant Types.Angle UPhase0_gen_20123_AUSTEN_G2 = 0.15217939470878503;
  final constant Types.ActivePowerPu P0Pu_gen_30101_ABEL_G3 = -0.7599999999788776;
  final constant Types.ReactivePowerPu Q0Pu_gen_30101_ABEL_G3 = -0.22178314963648094;
  final constant Types.VoltageModulePu U0Pu_gen_30101_ABEL_G3 = 1.0161596964727235;
  final constant Types.Angle UPhase0_gen_30101_ABEL_G3 = -0.1984468778479227;
  final constant Types.ActivePowerPu P0Pu_gen_30102_ADAMS_G3 = -0.7599999999782525;
  final constant Types.ReactivePowerPu Q0Pu_gen_30102_ADAMS_G3 = -0.18651193763838703;
  final constant Types.VoltageModulePu U0Pu_gen_30102_ADAMS_G3 = 1.0119115875875173;
  final constant Types.Angle UPhase0_gen_30102_ADAMS_G3 = -0.1999727128428949;
  final constant Types.ActivePowerPu P0Pu_gen_30107_ALDER_G3 = -0.7999999999726064;
  final constant Types.ReactivePowerPu Q0Pu_gen_30107_ALDER_G3 = -0.5106708523801484;
  final constant Types.VoltageModulePu U0Pu_gen_30107_ALDER_G3 = 1.0392093432573528;
  final constant Types.Angle UPhase0_gen_30107_ALDER_G3 = -0.29099817962354707;
  final constant Types.ActivePowerPu P0Pu_gen_30113_ARNE_G3 = -1.6249999999307339;
  final constant Types.ReactivePowerPu Q0Pu_gen_30113_ARNE_G3 = -1.2008829225627582;
  final constant Types.VoltageModulePu U0Pu_gen_30113_ARNE_G3 = 1.042727343363208;
  final constant Types.Angle UPhase0_gen_30113_ARNE_G3 = -0.005206911147618021;
  final constant Types.ActivePowerPu P0Pu_gen_30115_ARTHUR_G3 = -0.11999999999728914;
  final constant Types.ReactivePowerPu Q0Pu_gen_30115_ARTHUR_G3 = -0.0638303002877329;
  final constant Types.VoltageModulePu U0Pu_gen_30115_ARTHUR_G3 = 1.023745011300996;
  final constant Types.Angle UPhase0_gen_30115_ARTHUR_G3 = 0.14591107650805565;
  final constant Types.ActivePowerPu P0Pu_gen_30122_AUBREY_G3 = -0.5000004099960347;
  final constant Types.ReactivePowerPu Q0Pu_gen_30122_AUBREY_G3 = -0.03646369436251523;
  final constant Types.VoltageModulePu U0Pu_gen_30122_AUBREY_G3 = 1.0025914159367775;
  final constant Types.Angle UPhase0_gen_30122_AUBREY_G3 = 0.35407238234960403;
  final constant Types.ActivePowerPu P0Pu_gen_30123_AUSTEN_G3 = -3.5000001656289816;
  final constant Types.ReactivePowerPu Q0Pu_gen_30123_AUSTEN_G3 = -1.3305380937734208;
  final constant Types.VoltageModulePu U0Pu_gen_30123_AUSTEN_G3 = 1.041325051732186;
  final constant Types.Angle UPhase0_gen_30123_AUSTEN_G3 = 0.1531333025151461;
  final constant Types.ActivePowerPu P0Pu_gen_40101_ABEL_G4 = -0.7599999999788802;
  final constant Types.ReactivePowerPu Q0Pu_gen_40101_ABEL_G4 = -0.22175966597865165;
  final constant Types.VoltageModulePu U0Pu_gen_40101_ABEL_G4 = 1.0161558787590688;
  final constant Types.Angle UPhase0_gen_40101_ABEL_G4 = -0.19844631612764815;
  final constant Types.ActivePowerPu P0Pu_gen_40102_ADAMS_G4 = -0.7599999999782637;
  final constant Types.ReactivePowerPu Q0Pu_gen_40102_ADAMS_G4 = -0.18651193763830845;
  final constant Types.VoltageModulePu U0Pu_gen_40102_ADAMS_G4 = 1.0119115875874976;
  final constant Types.Angle UPhase0_gen_40102_ADAMS_G4 = -0.19997271284288592;
  final constant Types.ActivePowerPu P0Pu_gen_40115_ARTHUR_G4 = -0.1199999999972882;
  final constant Types.ReactivePowerPu Q0Pu_gen_40115_ARTHUR_G4 = -0.06383987947986561;
  final constant Types.VoltageModulePu U0Pu_gen_40115_ARTHUR_G4 = 1.023754566693637;
  final constant Types.Angle UPhase0_gen_40115_ARTHUR_G4 = 0.1459096513171526;
  final constant Types.ActivePowerPu P0Pu_gen_40122_AUBREY_G4 = -0.5000004099960342;
  final constant Types.ReactivePowerPu Q0Pu_gen_40122_AUBREY_G4 = -0.03646369436253674;
  final constant Types.VoltageModulePu U0Pu_gen_40122_AUBREY_G4 = 1.002591415936775;
  final constant Types.Angle UPhase0_gen_40122_AUBREY_G4 = 0.3540723823496089;
  final constant Types.ActivePowerPu P0Pu_gen_50115_ARTHUR_G5 = -0.1199999999972885;
  final constant Types.ReactivePowerPu Q0Pu_gen_50115_ARTHUR_G5 = -0.06383030028772911;
  final constant Types.VoltageModulePu U0Pu_gen_50115_ARTHUR_G5 = 1.0237450113009892;
  final constant Types.Angle UPhase0_gen_50115_ARTHUR_G5 = 0.14591107650805663;
  final constant Types.ActivePowerPu P0Pu_gen_50122_AUBREY_G5 = -0.5000004099960343;
  final constant Types.ReactivePowerPu Q0Pu_gen_50122_AUBREY_G5 = -0.0364636943624852;
  final constant Types.VoltageModulePu U0Pu_gen_50122_AUBREY_G5 = 1.0025914159367704;
  final constant Types.Angle UPhase0_gen_50122_AUBREY_G5 = 0.35407238234960603;
  final constant Types.ActivePowerPu P0Pu_gen_60115_ARTHUR_G6 = -1.550000141046319;
  final constant Types.ReactivePowerPu Q0Pu_gen_60115_ARTHUR_G6 = -0.8602969818617706;
  final constant Types.VoltageModulePu U0Pu_gen_60115_ARTHUR_G6 = 1.0261638226400809;
  final constant Types.Angle UPhase0_gen_60115_ARTHUR_G6 = 0.14471146857702907;
  final constant Types.ActivePowerPu P0Pu_gen_60122_AUBREY_G6 = -0.5000004099960347;
  final constant Types.ReactivePowerPu Q0Pu_gen_60122_AUBREY_G6 = -0.03646369436248653;
  final constant Types.VoltageModulePu U0Pu_gen_60122_AUBREY_G6 = 1.00259141593677;
  final constant Types.Angle UPhase0_gen_60122_AUBREY_G6 = 0.3540723823496069;
  /*final constant Types.ReactivePowerPu P0Pu_sVarC_10106 = -1.4741274867446919e-10 / SnRef;
                        final constant Types.ReactivePowerPu Q0Pu_sVarC_10106 = -61.57231639473844 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_sVarC_10106 = 1.0499999523164407;
                        final constant Types.Angle UPhase0_sVarC_10106 = from_deg(-23.83213070343857);
                        final constant Types.ComplexApparentPowerPu s0Pu_sVarC_10106 = Complex(P0Pu_sVarC_10106, Q0Pu_sVarC_10106);
                        final constant Types.ComplexVoltagePu u0Pu_sVarC_10106 = ComplexMath.fromPolar(U0Pu_sVarC_10106, UPhase0_sVarC_10106);
                        final constant Types.ComplexCurrentPu i0Pu_sVarC_10106 = ComplexMath.conj(s0Pu_sVarC_10106 / u0Pu_sVarC_10106);
                        final constant Types.PerUnit B0Pu_sVarC_10106 = Q0Pu_sVarC_10106 / ComplexMath.'abs'(u0Pu_sVarC_10106) ^ 2;
                        final constant Types.ReactivePowerPu P0Pu_sVarC_10114 = -5.128448776758886e-10 / SnRef;
                        final constant Types.ReactivePowerPu Q0Pu_sVarC_10114 = -125.1286992599756 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_sVarC_10114 = 1.0499999523163814;
                        final constant Types.Angle UPhase0_sVarC_10114 = from_deg(-9.77989867949944);
                        final constant Types.ComplexApparentPowerPu s0Pu_sVarC_10114 = Complex(P0Pu_sVarC_10114, Q0Pu_sVarC_10114);
                        final constant Types.ComplexVoltagePu u0Pu_sVarC_10114 = ComplexMath.fromPolar(U0Pu_sVarC_10114, UPhase0_sVarC_10114);
                        final constant Types.ComplexCurrentPu i0Pu_sVarC_10114 = ComplexMath.conj(s0Pu_sVarC_10114 / u0Pu_sVarC_10114);
                        final constant Types.PerUnit B0Pu_sVarC_10114 = Q0Pu_sVarC_10114 / ComplexMath.'abs'(u0Pu_sVarC_10114) ^ 2;
                        final constant Types.ActivePowerPu PRef0Pu_gen_10101 = 10.000000000013134 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_10101 = 7.472924576520086 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_10101 = 1.0297081543670863;
                        final constant Types.Angle UPhase0_gen_10101 = from_deg(-15.136713683420748);
                        final constant Types.ActivePowerPu PRef0Pu_gen_10102 = 10.000000000001876 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_10102 = 10.0000000000016 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_10102 = 1.0456996703380583;
                        final constant Types.Angle UPhase0_gen_10102 = from_deg(-15.32639518811591);
                        final constant Types.ActivePowerPu PRef0Pu_gen_10107 = 79.99999999999318 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_10107 = 51.0369686546301 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_10107 = 1.0392293846836345;
                        final constant Types.Angle UPhase0_gen_10107 = from_deg(-16.607929765986448);
                        final constant Types.ActivePowerPu PRef0Pu_gen_10113 = 162.500000001876 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_10113 = 78.10532501609322 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_10113 = 1.017717695706123;
                        final constant Types.Angle UPhase0_gen_10113 = from_deg(-0.0608968176817201);
                        final constant Types.ActivePowerPu PRef0Pu_gen_10115 = 12.000000000000547 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_10115 = 6.000000000000285 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_10115 = 1.0199901295983258;
                        final constant Types.Angle UPhase0_gen_10115 = from_deg(8.445275862974727);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_10115 = Complex(PRef0Pu_gen_10115, QRef0Pu_gen_10115);
                        final constant Types.ComplexVoltagePu u0Pu_gen_10115 = ComplexMath.fromPolar(U0Pu_gen_10115, UPhase0_gen_10115);
                        final constant Types.ComplexCurrentPu i0Pu_gen_10115 = -1 * ComplexMath.conj(s0Pu_gen_10115 / u0Pu_gen_10115);
                        final constant Types.ActivePowerPu PRef0Pu_gen_10116 = 155.0000000005526 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_10116 = 56.995548537262025 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_10116 = 1.0088977415231837;
                        final constant Types.Angle UPhase0_gen_10116 = from_deg(7.886212359788583);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_10116 = Complex(PRef0Pu_gen_10116, QRef0Pu_gen_10116);
                        final constant Types.ComplexVoltagePu u0Pu_gen_10116 = ComplexMath.fromPolar(U0Pu_gen_10116, UPhase0_gen_10116);
                        final constant Types.ComplexCurrentPu i0Pu_gen_10116 = -1 * ComplexMath.conj(s0Pu_gen_10116 / u0Pu_gen_10116);
                        final constant Types.ActivePowerPu PRef0Pu_gen_10118 = 400.0000000000115 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_10118 = 200.0000000000052 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_10118 = 1.049310521069751;
                        final constant Types.Angle UPhase0_gen_10118 = from_deg(12.59791828910379);
                        final constant Types.ActivePowerPu PRef0Pu_gen_10121 = 398.9667714938814 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_10121 = 192.8882441882296 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_10121 = 1.050620483873115;
                        final constant Types.Angle UPhase0_gen_10121 = from_deg(13.399999999999457);
                        final constant Types.ActivePowerPu PRef0Pu_gen_10122 = 50.00000000000149 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_10122 = 3.47066536610613 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_10122 = 1.002637457718179;
                        final constant Types.Angle UPhase0_gen_10122 = from_deg(20.31711144218487);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_10122 = Complex(PRef0Pu_gen_10122, QRef0Pu_gen_10122);
                        final constant Types.ComplexVoltagePu u0Pu_gen_10122 = ComplexMath.fromPolar(U0Pu_gen_10122, UPhase0_gen_10122);
                        final constant Types.ComplexCurrentPu i0Pu_gen_10122 = -1 * ComplexMath.conj(s0Pu_gen_10122 / u0Pu_gen_10122);
                        final constant Types.ActivePowerPu PRef0Pu_gen_10123 = 155.0000000000228 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_10123 = 70.7018261655949 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_10123 = 1.0505187105214768;
                        final constant Types.Angle UPhase0_gen_10123 = from_deg(8.774904840389452);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_10123 = Complex(PRef0Pu_gen_10123, QRef0Pu_gen_10123);
                        final constant Types.ComplexVoltagePu u0Pu_gen_10123 = ComplexMath.fromPolar(U0Pu_gen_10123, UPhase0_gen_10123);
                        final constant Types.ComplexCurrentPu i0Pu_gen_10123 = -1 * ComplexMath.conj(s0Pu_gen_10123 / u0Pu_gen_10123);
                        final constant Types.ActivePowerPu PRef0Pu_gen_20101 = 10.000000000013134 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_20101 = 7.472924576520086 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_20101 = 1.0297081543670863;
                        final constant Types.Angle UPhase0_gen_20101 = from_deg(-15.136713683420748);
                        final constant Types.ActivePowerPu PRef0Pu_gen_20102 = 10.000000000001876 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_20102 = 10.0000000000016 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_20102 = 1.0456996703380586;
                        final constant Types.Angle UPhase0_gen_20102 = from_deg(-15.326395188115908);
                        final constant Types.ActivePowerPu PRef0Pu_gen_20107 = 79.99999999999318 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_20107 = 51.03696865463012 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_20107 = 1.0392293846836342;
                        final constant Types.Angle UPhase0_gen_20107 = from_deg(-16.60792976598645);
                        final constant Types.ActivePowerPu PRef0Pu_gen_20113 = 162.5000000000316 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_20113 = 80.0000000000155 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_20113 = 1.0188760820803306;
                        final constant Types.Angle UPhase0_gen_20113 = from_deg(-0.0692173513919302);
                        final constant Types.ActivePowerPu PRef0Pu_gen_20115 = 12.000000000000547 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_20115 = 6.000000000000285 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_20115 = 1.0199901295983258;
                        final constant Types.Angle UPhase0_gen_20115 = from_deg(8.445275862974727);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_20115 = Complex(PRef0Pu_gen_20115, QRef0Pu_gen_20115);
                        final constant Types.ComplexVoltagePu u0Pu_gen_20115 = ComplexMath.fromPolar(U0Pu_gen_20115, UPhase0_gen_20115);
                        final constant Types.ComplexCurrentPu i0Pu_gen_20115 = -1 * ComplexMath.conj(s0Pu_gen_20115 / u0Pu_gen_20115);
                        final constant Types.ActivePowerPu PRef0Pu_gen_20122 = 50.0000000000015 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_20122 = 3.470665366106129 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_20122 = 1.002637457718179;
                        final constant Types.Angle UPhase0_gen_20122 = from_deg(20.31711144218487);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_20122 = Complex(PRef0Pu_gen_20122, QRef0Pu_gen_20122);
                        final constant Types.ComplexVoltagePu u0Pu_gen_20122 = ComplexMath.fromPolar(U0Pu_gen_20122, UPhase0_gen_20122);
                        final constant Types.ComplexCurrentPu i0Pu_gen_20122 = -1 * ComplexMath.conj(s0Pu_gen_20122 / u0Pu_gen_20122);
                        final constant Types.ActivePowerPu PRef0Pu_gen_20123 = 155.0000000000228 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_20123 = 70.70182616559488 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_20123 = 1.0505187105214768;
                        final constant Types.Angle UPhase0_gen_20123 = from_deg(8.77490484038945);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_20123 = Complex(PRef0Pu_gen_20123, QRef0Pu_gen_20123);
                        final constant Types.ComplexVoltagePu u0Pu_gen_20123 = ComplexMath.fromPolar(U0Pu_gen_20123, UPhase0_gen_20123);
                        final constant Types.ComplexCurrentPu i0Pu_gen_20123 = -1 * ComplexMath.conj(s0Pu_gen_20123 / u0Pu_gen_20123);
                        final constant Types.ActivePowerPu PRef0Pu_gen_30101 = 76.00000000004893 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_30101 = 22.18153802872048 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_30101 = 1.0162565964090082;
                        final constant Types.Angle UPhase0_gen_30101 = from_deg(-11.307935828900904);
                        final constant Types.ActivePowerPu PRef0Pu_gen_30102 = 76.00000000000328 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_30102 = 18.873816470787677 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_30102 = 1.0123613686642747;
                        final constant Types.Angle UPhase0_gen_30102 = from_deg(-11.398125977940808);
                        final constant Types.ActivePowerPu PRef0Pu_gen_30107 = 79.99999999999318 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_30107 = 51.03696865463012 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_30107 = 1.0392293846836342;
                        final constant Types.Angle UPhase0_gen_30107 = from_deg(-16.60792976598645);
                        final constant Types.ActivePowerPu PRef0Pu_gen_30113 = 162.5000000000316 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_30113 = 80.0000000000155 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_30113 = 1.0188760820803306;
                        final constant Types.Angle UPhase0_gen_30113 = from_deg(-0.0692173513919302);
                        final constant Types.ActivePowerPu PRef0Pu_gen_30115 = 12.000000000000547 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_30115 = 6.000000000000285 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_30115 = 1.0199901295983258;
                        final constant Types.Angle UPhase0_gen_30115 = from_deg(8.445275862974727);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_30115 = Complex(PRef0Pu_gen_30115, QRef0Pu_gen_30115);
                        final constant Types.ComplexVoltagePu u0Pu_gen_30115 = ComplexMath.fromPolar(U0Pu_gen_30115, UPhase0_gen_30115);
                        final constant Types.ComplexCurrentPu i0Pu_gen_30115 = -1 * ComplexMath.conj(s0Pu_gen_30115 / u0Pu_gen_30115);
                        final constant Types.ActivePowerPu PRef0Pu_gen_30122 = 50.0000000000015 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_30122 = 3.470665366106129 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_30122 = 1.002637457718179;
                        final constant Types.Angle UPhase0_gen_30122 = from_deg(20.31711144218487);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_30122 = Complex(PRef0Pu_gen_30122, QRef0Pu_gen_30122);
                        final constant Types.ComplexVoltagePu u0Pu_gen_30122 = ComplexMath.fromPolar(U0Pu_gen_30122, UPhase0_gen_30122);
                        final constant Types.ComplexCurrentPu i0Pu_gen_30122 = -1 * ComplexMath.conj(s0Pu_gen_30122 / u0Pu_gen_30122);
                        final constant Types.ActivePowerPu PRef0Pu_gen_30123 = 350.0000000000501 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_30123 = 132.63443358196875 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_30123 = 1.0413228858367327;
                        final constant Types.Angle UPhase0_gen_30123 = from_deg(8.829652471806773);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_30123 = Complex(PRef0Pu_gen_30123, QRef0Pu_gen_30123);
                        final constant Types.ComplexVoltagePu u0Pu_gen_30123 = ComplexMath.fromPolar(U0Pu_gen_30123, UPhase0_gen_30123);
                        final constant Types.ComplexCurrentPu i0Pu_gen_30123 = -1 * ComplexMath.conj(s0Pu_gen_30123 / u0Pu_gen_30123);
                        final constant Types.ActivePowerPu PRef0Pu_gen_40101 = 76.00000000004893 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_40101 = 22.18153802872048 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_40101 = 1.0162565964090082;
                        final constant Types.Angle UPhase0_gen_40101 = from_deg(-11.307935828900904);
                        final constant Types.ActivePowerPu PRef0Pu_gen_40102 = 76.00000000000328 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_40102 = 18.873816470787677 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_40102 = 1.0123613686642747;
                        final constant Types.Angle UPhase0_gen_40102 = from_deg(-11.398125977940808);
                        final constant Types.ActivePowerPu PRef0Pu_gen_40115 = 12.000000000000547 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_40115 = 6.000000000000285 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_40115 = 1.0199901295983258;
                        final constant Types.Angle UPhase0_gen_40115 = from_deg(8.445275862974727);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_40115 = Complex(PRef0Pu_gen_40115, QRef0Pu_gen_40115);
                        final constant Types.ComplexVoltagePu u0Pu_gen_40115 = ComplexMath.fromPolar(U0Pu_gen_40115, UPhase0_gen_40115);
                        final constant Types.ComplexCurrentPu i0Pu_gen_40115 = -1 * ComplexMath.conj(s0Pu_gen_40115 / u0Pu_gen_40115);
                        final constant Types.ActivePowerPu PRef0Pu_gen_40122 = 50.0000000000015 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_40122 = 3.470665366106129 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_40122 = 1.002637457718179;
                        final constant Types.Angle UPhase0_gen_40122 = from_deg(20.31711144218487);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_40122 = Complex(PRef0Pu_gen_40122, QRef0Pu_gen_40122);
                        final constant Types.ComplexVoltagePu u0Pu_gen_40122 = ComplexMath.fromPolar(U0Pu_gen_40122, UPhase0_gen_40122);
                        final constant Types.ComplexCurrentPu i0Pu_gen_40122 = -1 * ComplexMath.conj(s0Pu_gen_40122 / u0Pu_gen_40122);
                        final constant Types.ActivePowerPu PRef0Pu_gen_50115 = 12.000000000000547 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_50115 = 6.000000000000285 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_50115 = 1.0199901295983258;
                        final constant Types.Angle UPhase0_gen_50115 = from_deg(8.445275862974727);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_50115 = Complex(PRef0Pu_gen_50115, QRef0Pu_gen_50115);
                        final constant Types.ComplexVoltagePu u0Pu_gen_50115 = ComplexMath.fromPolar(U0Pu_gen_50115, UPhase0_gen_50115);
                        final constant Types.ComplexCurrentPu i0Pu_gen_50115 = -1 * ComplexMath.conj(s0Pu_gen_50115 / u0Pu_gen_50115);
                        final constant Types.ActivePowerPu PRef0Pu_gen_50122 = 50.0000000000015 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_50122 = 3.470665366106129 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_50122 = 1.002637457718179;
                        final constant Types.Angle UPhase0_gen_50122 = from_deg(20.31711144218487);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_50122 = Complex(PRef0Pu_gen_50122, QRef0Pu_gen_50122);
                        final constant Types.ComplexVoltagePu u0Pu_gen_50122 = ComplexMath.fromPolar(U0Pu_gen_50122, UPhase0_gen_50122);
                        final constant Types.ComplexCurrentPu i0Pu_gen_50122 = -1 * ComplexMath.conj(s0Pu_gen_50122 / u0Pu_gen_50122);
                        final constant Types.ActivePowerPu PRef0Pu_gen_60115 = 155.00000000000705 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_60115 = 80.00000000000375 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_60115 = 1.02161813811797;
                        final constant Types.Angle UPhase0_gen_60115 = from_deg(8.382976529560553);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_60115 = Complex(PRef0Pu_gen_60115, QRef0Pu_gen_60115);
                        final constant Types.ComplexVoltagePu u0Pu_gen_60115 = ComplexMath.fromPolar(U0Pu_gen_60115, UPhase0_gen_60115);
                        final constant Types.ComplexCurrentPu i0Pu_gen_60115 = -1 * ComplexMath.conj(s0Pu_gen_60115 / u0Pu_gen_60115);
                        final constant Types.ActivePowerPu PRef0Pu_gen_60122 = 50.0000000000015 / SnRef;
                        final constant Types.ActivePowerPu QRef0Pu_gen_60122 = 3.470665366106129 / SnRef;
                        final constant Types.VoltageModulePu U0Pu_gen_60122 = 1.002637457718179;
                        final constant Types.Angle UPhase0_gen_60122 = from_deg(20.31711144218487);
                        final constant Types.ComplexApparentPowerPu s0Pu_gen_60122 = Complex(PRef0Pu_gen_60122, QRef0Pu_gen_60122);
                        final constant Types.ComplexVoltagePu u0Pu_gen_60122 = ComplexMath.fromPolar(U0Pu_gen_60122, UPhase0_gen_60122);
                        final constant Types.ComplexCurrentPu i0Pu_gen_60122 = -1 * ComplexMath.conj(s0Pu_gen_60122 / u0Pu_gen_60122);*/
  // ===================================================================
  Dynawo.Electrical.Controls.Basics.SetPoint N(Value0 = 0);
  /*  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = from_deg(13.4), UPu = 1.04685) annotation(
                                      Placement(visible = true, transformation(origin = {-100, 226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
                                  */
  Components.GeneratorWithControl.SteamEXACFrame gen_40101_ABEL_G4(P0Pu = P0Pu_gen_40101_ABEL_G4, Q0Pu = Q0Pu_gen_40101_ABEL_G4, U0Pu = U0Pu_gen_40101_ABEL_G4, UPhase0 = UPhase0_gen_40101_ABEL_G4, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g40101, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g40101, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g40101, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g40101) annotation(
    Placement(visible = true, transformation(origin = {-94, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_30101_ABEL_G3(P0Pu = P0Pu_gen_30101_ABEL_G3, Q0Pu = Q0Pu_gen_30101_ABEL_G3, U0Pu = U0Pu_gen_30101_ABEL_G3, UPhase0 = UPhase0_gen_30101_ABEL_G3, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g30101, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30101, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30101, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30101) annotation(
    Placement(visible = true, transformation(origin = {-134, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_10101_ABEL_G1(P0Pu = P0Pu_gen_10101_ABEL_G1, Q0Pu = Q0Pu_gen_10101_ABEL_G1, U0Pu = U0Pu_gen_10101_ABEL_G1, UPhase0 = UPhase0_gen_10101_ABEL_G1, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g10101, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10101, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10101, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10101) annotation(
    Placement(visible = true, transformation(origin = {-214, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_20101_ABEL_G2(P0Pu = P0Pu_gen_20101_ABEL_G2, Q0Pu = Q0Pu_gen_20101_ABEL_G2, U0Pu = U0Pu_gen_20101_ABEL_G2, UPhase0 = UPhase0_gen_20101_ABEL_G2, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g20101, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20101, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20101, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20101) annotation(
    Placement(visible = true, transformation(origin = {-174, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBeta load_101(alpha=1, beta=2, i0Pu = Complex(0, 0), s0Pu = Complex(0, 0), u0Pu = ComplexMath.fromPolar(1.034, from_deg(-18.6))) annotation(
    Placement(visible = true, transformation(origin = {-166, -280}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamEXACFrame gen_20102_ADAMS_G2(P0Pu = P0Pu_gen_20102_ADAMS_G2, Q0Pu = Q0Pu_gen_20102_ADAMS_G2, U0Pu = U0Pu_gen_20102_ADAMS_G2, UPhase0 = UPhase0_gen_20102_ADAMS_G2, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g20102, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20102, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20102, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20102) annotation(
    Placement(visible = true, transformation(origin = {30, -402}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamEXACFrame gen_40102_ADAMS_G4(P0Pu = P0Pu_gen_40102_ADAMS_G4, Q0Pu = Q0Pu_gen_40102_ADAMS_G4, U0Pu = U0Pu_gen_40102_ADAMS_G4, UPhase0 = UPhase0_gen_40102_ADAMS_G4, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g40102, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g40102, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g40102, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g40102) annotation(
    Placement(visible = true, transformation(origin = {110, -402}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_10102_ADAMS_G1(P0Pu = P0Pu_gen_10102_ADAMS_G1, Q0Pu = Q0Pu_gen_10102_ADAMS_G1, U0Pu = U0Pu_gen_10102_ADAMS_G1, UPhase0 = UPhase0_gen_10102_ADAMS_G1, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g10102, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10102, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10102, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10102) annotation(
    Placement(visible = true, transformation(origin = {-10, -402}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamEXACFrame gen_30102_ADAMS_G3(P0Pu = P0Pu_gen_30102_ADAMS_G3, Q0Pu = Q0Pu_gen_30102_ADAMS_G3, U0Pu = U0Pu_gen_30102_ADAMS_G3, UPhase0 = UPhase0_gen_30102_ADAMS_G3, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g30102, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30102, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30102, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30102) annotation(
    Placement(visible = true, transformation(origin = {70, -402}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_30107_ALDER_G3(P0Pu = P0Pu_gen_30107_ALDER_G3, Q0Pu = Q0Pu_gen_30107_ALDER_G3, U0Pu = U0Pu_gen_30107_ALDER_G3, UPhase0 = UPhase0_gen_30107_ALDER_G3, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30107, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30107, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30107, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g30107) annotation(
    Placement(visible = true, transformation(origin = {330, -310}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10107_ALDER_G1(P0Pu = P0Pu_gen_10107_ALDER_G1, Q0Pu = Q0Pu_gen_10107_ALDER_G1, U0Pu = U0Pu_gen_10107_ALDER_G1, UPhase0 = UPhase0_gen_10107_ALDER_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10107, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10107, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10107, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10107) annotation(
    Placement(visible = true, transformation(origin = {330, -230}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_20107_ALDER_G2(P0Pu = P0Pu_gen_20107_ALDER_G2, Q0Pu = Q0Pu_gen_20107_ALDER_G2, U0Pu = U0Pu_gen_20107_ALDER_G2, UPhase0 = UPhase0_gen_20107_ALDER_G2, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20107, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20107, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20107, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g20107) annotation(
    Placement(visible = true, transformation(origin = {330, -270}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Buses.InfiniteBus infiniteBus(UPhase = from_deg(13.4), UPu = 1.04685) annotation(
    Placement(visible = true, transformation(origin = {-100, 226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_20113_ARNE_G2(P0Pu = P0Pu_gen_20113_ARNE_G2, Q0Pu = Q0Pu_gen_20113_ARNE_G2, U0Pu = U0Pu_gen_20113_ARNE_G2, UPhase0 = UPhase0_gen_20113_ARNE_G2, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20113, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20113, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20113, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g20113) annotation(
    Placement(visible = true, transformation(origin = {220, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamSCRXFrame gen_30113_ARNE_G3(P0Pu = P0Pu_gen_30113_ARNE_G3, Q0Pu = Q0Pu_gen_30113_ARNE_G3, U0Pu = U0Pu_gen_30113_ARNE_G3, UPhase0 = UPhase0_gen_30113_ARNE_G3, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30113, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30113, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30113, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g30113) annotation(
    Placement(visible = true, transformation(origin = {220, -130}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10113_ARNE_G1(P0Pu = P0Pu_gen_10113_ARNE_G1, Q0Pu = Q0Pu_gen_10113_ARNE_G1, U0Pu = U0Pu_gen_10113_ARNE_G1, UPhase0 = UPhase0_gen_10113_ARNE_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10113, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10113, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10113, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10113) annotation(
    Placement(visible = true, transformation(origin = {220, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_20123_AUSTEN_G2(P0Pu = P0Pu_gen_20123_AUSTEN_G2, Q0Pu = Q0Pu_gen_20123_AUSTEN_G2, U0Pu = U0Pu_gen_20123_AUSTEN_G2, UPhase0 = UPhase0_gen_20123_AUSTEN_G2, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20123, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20123, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20123, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g20123) annotation(
    Placement(visible = true, transformation(origin = {330, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10123_AUSTEN_G1(P0Pu = P0Pu_gen_10123_AUSTEN_G1, Q0Pu = Q0Pu_gen_10123_AUSTEN_G1, U0Pu = U0Pu_gen_10123_AUSTEN_G1, UPhase0 = UPhase0_gen_10123_AUSTEN_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10123, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10123, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10123, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10123) annotation(
    Placement(visible = true, transformation(origin = {330, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_30123_AUSTEN_G3(P0Pu = P0Pu_gen_30123_AUSTEN_G3, Q0Pu = Q0Pu_gen_30123_AUSTEN_G3, U0Pu = U0Pu_gen_30123_AUSTEN_G3, UPhase0 = UPhase0_gen_30123_AUSTEN_G3, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30123, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30123, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30123, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g30123) annotation(
    Placement(visible = true, transformation(origin = {330, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_50115_ARTHUR_G5(P0Pu = P0Pu_gen_50115_ARTHUR_G5, Q0Pu = Q0Pu_gen_50115_ARTHUR_G5, U0Pu = U0Pu_gen_50115_ARTHUR_G5, UPhase0 = UPhase0_gen_50115_ARTHUR_G5, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g50115, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g50115, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g50115, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g50115) annotation(
    Placement(visible = true, transformation(origin = {-230, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamSCRXFrame gen_60115_ARTHUR_G6(P0Pu = P0Pu_gen_60115_ARTHUR_G6, Q0Pu = Q0Pu_gen_60115_ARTHUR_G6, U0Pu = U0Pu_gen_60115_ARTHUR_G6, UPhase0 = UPhase0_gen_60115_ARTHUR_G6, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g60115, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g60115, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g60115, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g60115) annotation(
    Placement(visible = true, transformation(origin = {-230, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10115_ARTHUR_G1(P0Pu = P0Pu_gen_10115_ARTHUR_G1, Q0Pu = Q0Pu_gen_10115_ARTHUR_G1, U0Pu = U0Pu_gen_10115_ARTHUR_G1, UPhase0 = UPhase0_gen_10115_ARTHUR_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10115, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10115, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10115, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10115) annotation(
    Placement(visible = true, transformation(origin = {-230, 196}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_40115_ARTHUR_G4(P0Pu = P0Pu_gen_40115_ARTHUR_G4, Q0Pu = Q0Pu_gen_40115_ARTHUR_G4, U0Pu = U0Pu_gen_40115_ARTHUR_G4, UPhase0 = UPhase0_gen_40115_ARTHUR_G4, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g40115, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g40115, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g40115, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g40115) annotation(
    Placement(visible = true, transformation(origin = {-230, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamSCRXFrame gen_30115_ARTHUR_G3(P0Pu = P0Pu_gen_30115_ARTHUR_G3, Q0Pu = Q0Pu_gen_30115_ARTHUR_G3, U0Pu = U0Pu_gen_30115_ARTHUR_G3, UPhase0 = UPhase0_gen_30115_ARTHUR_G3, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30115, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30115, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30115, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g30115) annotation(
    Placement(visible = true, transformation(origin = {-230, 116}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamSCRXFrame gen_20115_ARTHUR_G2(P0Pu = P0Pu_gen_20115_ARTHUR_G2, Q0Pu = Q0Pu_gen_20115_ARTHUR_G2, U0Pu = U0Pu_gen_20115_ARTHUR_G2, UPhase0 = UPhase0_gen_20115_ARTHUR_G2, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20115, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20115, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20115, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g20115) annotation(
    Placement(visible = true, transformation(origin = {-230, 156}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10116_ASSER_G1(P0Pu = P0Pu_gen_10116_ASSER_G1, Q0Pu = Q0Pu_gen_10116_ASSER_G1, U0Pu = U0Pu_gen_10116_ASSER_G1, UPhase0 = UPhase0_gen_10116_ASSER_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10116, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10116, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10116, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10116) annotation(
    Placement(visible = true, transformation(origin = {-112, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamIEEET1Frame gen_10118_ASTOR_G1(P0Pu = P0Pu_gen_10118_ASTOR_G1, Q0Pu = Q0Pu_gen_10118_ASTOR_G1, U0Pu = U0Pu_gen_10118_ASTOR_G1, UPhase0 = UPhase0_gen_10118_ASTOR_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10118, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10118, ieeet1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEET1.genFramePreset.g10118, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10118) annotation(
    Placement(visible = true, transformation(origin = {-20, 104}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.HydroFrame gen_30122_AUBREY_G3(GovInService = true, P0Pu = P0Pu_gen_30122_AUBREY_G3, Q0Pu = Q0Pu_gen_30122_AUBREY_G3, U0Pu = U0Pu_gen_30122_AUBREY_G3, UPhase0 = UPhase0_gen_30122_AUBREY_G3, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30122, hygovPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersHYGOV.genFramePreset.g30122, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30122, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g30122) annotation(
    Placement(visible = true, transformation(origin = {328, 212}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.HydroFrame gen_10122_AUBREY_G1(GovInService = true, P0Pu = P0Pu_gen_10122_AUBREY_G1, Q0Pu = Q0Pu_gen_10122_AUBREY_G1, U0Pu = U0Pu_gen_10122_AUBREY_G1, UPhase0 = UPhase0_gen_10122_AUBREY_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10122, hygovPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersHYGOV.genFramePreset.g10122, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10122, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10122) annotation(
    Placement(visible = true, transformation(origin = {196, 182}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.HydroFrame gen_50122_AUBREY_G5(GovInService = true, P0Pu = P0Pu_gen_50122_AUBREY_G5, Q0Pu = Q0Pu_gen_50122_AUBREY_G5, U0Pu = U0Pu_gen_50122_AUBREY_G5, UPhase0 = UPhase0_gen_50122_AUBREY_G5, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g50122, hygovPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersHYGOV.genFramePreset.g50122, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g50122, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g50122) annotation(
    Placement(visible = true, transformation(origin = {328, 132}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.HydroFrame gen_60122_AUBREY_G6(GovInService = true, P0Pu = P0Pu_gen_60122_AUBREY_G6, Q0Pu = Q0Pu_gen_60122_AUBREY_G6, U0Pu = U0Pu_gen_60122_AUBREY_G6, UPhase0 = UPhase0_gen_60122_AUBREY_G6, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g60122, hygovPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersHYGOV.genFramePreset.g60122, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g60122, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g60122) annotation(
    Placement(visible = true, transformation(origin = {328, 92}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.HydroFrame gen_20122_AUBREY_G2(GovInService = true, P0Pu = P0Pu_gen_20122_AUBREY_G2, Q0Pu = Q0Pu_gen_20122_AUBREY_G2, U0Pu = U0Pu_gen_20122_AUBREY_G2, UPhase0 = UPhase0_gen_20122_AUBREY_G2, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20122, hygovPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersHYGOV.genFramePreset.g20122, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20122, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g20122) annotation(
    Placement(visible = true, transformation(origin = {196, 142}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.HydroFrame gen_40122_AUBREY_G4(GovInService = true, P0Pu = P0Pu_gen_40122_AUBREY_G4, Q0Pu = Q0Pu_gen_40122_AUBREY_G4, U0Pu = U0Pu_gen_40122_AUBREY_G4, UPhase0 = UPhase0_gen_40122_AUBREY_G4, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g40122, hygovPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersHYGOV.genFramePreset.g40122, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g40122, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g40122) annotation(
    Placement(visible = true, transformation(origin = {328, 172}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Examples.RVS.Components.StaticVarCompensators.SVarCRVS sVarC_10106_ALBER_SVC(K = 150 * 150, Q0Pu = Q0Pu_sVarC_10106_ALBER_SVC, SBase = 100, U0Pu = U0Pu_sVarC_10106_ALBER_SVC, UPhase0 = UPhase0_sVarC_10106_ALBER_SVC, URef0Pu = U0Pu_sVarC_10106_ALBER_SVC, svcPreset = Dynawo.Examples.RVS.Components.StaticVarCompensators.Util.ParametersSVC.svcFramePreset.sVarC_10106) annotation(
    Placement(visible = true, transformation(origin = {210, -322}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.StaticVarCompensators.SVarCRVS sVarC_10114_ARNOLD_SVC(K = 150 * 250, Q0Pu = Q0Pu_sVarC_10114_ARNOLD_SVC, SBase = 100, U0Pu = U0Pu_sVarC_10114_ARNOLD_SVC, UPhase0 = UPhase0_sVarC_10114_ARNOLD_SVC, URef0Pu = U0Pu_sVarC_10114_ARNOLD_SVC, svcPreset = Dynawo.Examples.RVS.Components.StaticVarCompensators.Util.ParametersSVC.svcFramePreset.sVarC_10114) annotation(
    Placement(visible = true, transformation(origin = {50, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  gen_10101_ABEL_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10101_ABEL_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10101_ABEL_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10101_ABEL_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20101_ABEL_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20101_ABEL_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20101_ABEL_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20101_ABEL_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30101_ABEL_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30101_ABEL_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30101_ABEL_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30101_ABEL_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_40101_ABEL_G4.generatorSynchronous.switchOffSignal1.value = false;
  gen_40101_ABEL_G4.generatorSynchronous.switchOffSignal2.value = false;
  gen_40101_ABEL_G4.generatorSynchronous.switchOffSignal3.value = false;
  gen_40101_ABEL_G4.generatorSynchronous.omegaRefPu.value = 1;
  gen_10102_ADAMS_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10102_ADAMS_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10102_ADAMS_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10102_ADAMS_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20102_ADAMS_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20102_ADAMS_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20102_ADAMS_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20102_ADAMS_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30102_ADAMS_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30102_ADAMS_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30102_ADAMS_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30102_ADAMS_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_40102_ADAMS_G4.generatorSynchronous.switchOffSignal1.value = false;
  gen_40102_ADAMS_G4.generatorSynchronous.switchOffSignal2.value = false;
  gen_40102_ADAMS_G4.generatorSynchronous.switchOffSignal3.value = false;
  gen_40102_ADAMS_G4.generatorSynchronous.omegaRefPu.value = 1;
//vRRemote_bus_107.URegulated = ComplexMath.'abs'(bus_107_ALDER.terminal.V) * UNom_lower;
  gen_10107_ALDER_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10107_ALDER_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10107_ALDER_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10107_ALDER_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20107_ALDER_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20107_ALDER_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20107_ALDER_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20107_ALDER_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30107_ALDER_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30107_ALDER_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30107_ALDER_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30107_ALDER_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_10113_ARNE_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10113_ARNE_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10113_ARNE_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10113_ARNE_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20113_ARNE_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20113_ARNE_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20113_ARNE_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20113_ARNE_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30113_ARNE_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30113_ARNE_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30113_ARNE_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30113_ARNE_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_10118_ASTOR_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10118_ASTOR_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10118_ASTOR_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10118_ASTOR_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_10115_ARTHUR_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10115_ARTHUR_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10115_ARTHUR_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10115_ARTHUR_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20115_ARTHUR_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20115_ARTHUR_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20115_ARTHUR_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20115_ARTHUR_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30115_ARTHUR_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30115_ARTHUR_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30115_ARTHUR_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30115_ARTHUR_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_40115_ARTHUR_G4.generatorSynchronous.switchOffSignal1.value = false;
  gen_40115_ARTHUR_G4.generatorSynchronous.switchOffSignal2.value = false;
  gen_40115_ARTHUR_G4.generatorSynchronous.switchOffSignal3.value = false;
  gen_40115_ARTHUR_G4.generatorSynchronous.omegaRefPu.value = 1;
  gen_50115_ARTHUR_G5.generatorSynchronous.switchOffSignal1.value = false;
  gen_50115_ARTHUR_G5.generatorSynchronous.switchOffSignal2.value = false;
  gen_50115_ARTHUR_G5.generatorSynchronous.switchOffSignal3.value = false;
  gen_50115_ARTHUR_G5.generatorSynchronous.omegaRefPu.value = 1;
  gen_60115_ARTHUR_G6.generatorSynchronous.switchOffSignal1.value = false;
  gen_60115_ARTHUR_G6.generatorSynchronous.switchOffSignal2.value = false;
  gen_60115_ARTHUR_G6.generatorSynchronous.switchOffSignal3.value = false;
  gen_60115_ARTHUR_G6.generatorSynchronous.omegaRefPu.value = 1;
/*gen_10121_ATTLEE_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10121_ATTLEE_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10121_ATTLEE_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10121_ATTLEE_G1.generatorSynchronous.omegaRefPu.value = 1;
  */
  gen_10122_AUBREY_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10122_AUBREY_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10122_AUBREY_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10122_AUBREY_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20122_AUBREY_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20122_AUBREY_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20122_AUBREY_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20122_AUBREY_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30122_AUBREY_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30122_AUBREY_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30122_AUBREY_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30122_AUBREY_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_40122_AUBREY_G4.generatorSynchronous.switchOffSignal1.value = false;
  gen_40122_AUBREY_G4.generatorSynchronous.switchOffSignal2.value = false;
  gen_40122_AUBREY_G4.generatorSynchronous.switchOffSignal3.value = false;
  gen_40122_AUBREY_G4.generatorSynchronous.omegaRefPu.value = 1;
  gen_50122_AUBREY_G5.generatorSynchronous.switchOffSignal1.value = false;
  gen_50122_AUBREY_G5.generatorSynchronous.switchOffSignal2.value = false;
  gen_50122_AUBREY_G5.generatorSynchronous.switchOffSignal3.value = false;
  gen_50122_AUBREY_G5.generatorSynchronous.omegaRefPu.value = 1;
  gen_60122_AUBREY_G6.generatorSynchronous.switchOffSignal1.value = false;
  gen_60122_AUBREY_G6.generatorSynchronous.switchOffSignal2.value = false;
  gen_60122_AUBREY_G6.generatorSynchronous.switchOffSignal3.value = false;
  gen_60122_AUBREY_G6.generatorSynchronous.omegaRefPu.value = 1;
  gen_10116_ASSER_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10116_ASSER_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10116_ASSER_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10116_ASSER_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_10123_AUSTEN_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10123_AUSTEN_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10123_AUSTEN_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10123_AUSTEN_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20123_AUSTEN_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20123_AUSTEN_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20123_AUSTEN_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20123_AUSTEN_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30123_AUSTEN_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30123_AUSTEN_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30123_AUSTEN_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30123_AUSTEN_G3.generatorSynchronous.omegaRefPu.value = 1;
  sVarC_10114_ARNOLD_SVC.sVarCVPropInterface.switchOffSignal1.value = false;
  sVarC_10114_ARNOLD_SVC.sVarCVPropInterface.switchOffSignal2.value = false;
  sVarC_10114_ARNOLD_SVC.URefPu = U0Pu_sVarC_10114_ARNOLD_SVC;
  sVarC_10106_ALBER_SVC.sVarCVPropInterface.switchOffSignal1.value = false;
  sVarC_10106_ALBER_SVC.sVarCVPropInterface.switchOffSignal2.value = false;
  sVarC_10106_ALBER_SVC.URefPu = if time > 1 then URefStep_SVarC_10106 else U0Pu_sVarC_10106_ALBER_SVC;
  load_101.switchOffSignal1.value = false;
  load_101.switchOffSignal2.value = false;
  load_101.PRefPu = 0;
  load_101.QRefPu = if time < 1 then 0 else QPu_load_101;
// if time < 1 then true else

  connect(gen_10101_ABEL_G1.terminal, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-214, -362}, {-214, -342}}, color = {0, 0, 255}));
  connect(gen_20101_ABEL_G2.terminal, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-174, -362}, {-174, -342}}, color = {0, 0, 255}));
  connect(gen_30101_ABEL_G3.terminal, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{-134, -362}, {-134, -342}}, color = {0, 0, 255}));
  connect(gen_40101_ABEL_G4.terminal, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{-94, -362}, {-94, -342}}, color = {0, 0, 255}));
  connect(load_101.terminal, bus_101_ABEL.terminal) annotation(
    Line(points = {{-166, -280}, {-134, -280}, {-134, -302}}, color = {0, 0, 255}));
  connect(gen_10102_ADAMS_G1.terminal, bus_10102_ADAMS_G1.terminal) annotation(
    Line(points = {{-10, -402}, {-10, -382}}, color = {0, 0, 255}));
  connect(gen_20102_ADAMS_G2.terminal, bus_20102_ADAMS_G2.terminal) annotation(
    Line(points = {{30, -402}, {30, -382}}, color = {0, 0, 255}));
  connect(gen_30102_ADAMS_G3.terminal, bus_30102_ADAMS_G3.terminal) annotation(
    Line(points = {{70, -402}, {70, -382}}, color = {0, 0, 255}));
  connect(gen_40102_ADAMS_G4.terminal, bus_40102_ADAMS_G4.terminal) annotation(
    Line(points = {{110, -402}, {110, -382}}, color = {0, 0, 255}));
  connect(gen_10107_ALDER_G1.terminal, bus_10107_ALDER_G1.terminal) annotation(
    Line(points = {{330, -230}, {310, -230}}, color = {0, 0, 255}));
  connect(gen_20107_ALDER_G2.terminal, bus_20107_ALDER_G2.terminal) annotation(
    Line(points = {{330, -270}, {310, -270}}, color = {0, 0, 255}));
  connect(gen_30107_ALDER_G3.terminal, bus_30107_ALDER_G3.terminal) annotation(
    Line(points = {{330, -310}, {310, -310}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, bus_10121_ATTLEE_G1.terminal) annotation(
    Line(points = {{-100, 226}, {-100, 186}}, color = {0, 0, 255}));
  connect(gen_10113_ARNE_G1.terminal, bus_10113_ARNE_G1.terminal) annotation(
    Line(points = {{220, -50}, {200, -50}}, color = {0, 0, 255}));
  connect(gen_20113_ARNE_G2.terminal, bus_20113_ARNE_G2.terminal) annotation(
    Line(points = {{220, -90}, {200, -90}}, color = {0, 0, 255}));
  connect(gen_30113_ARNE_G3.terminal, bus_30113_ARNE_G3.terminal) annotation(
    Line(points = {{220, -130}, {200, -130}}, color = {0, 0, 255}));
  connect(gen_10123_AUSTEN_G1.terminal, bus_10123_AUSTEN_G1.terminal) annotation(
    Line(points = {{330, 50}, {300, 50}}, color = {0, 0, 255}));
  connect(gen_20123_AUSTEN_G2.terminal, bus_20123_AUSTEN_G2.terminal) annotation(
    Line(points = {{330, 10}, {300, 10}}, color = {0, 0, 255}));
  connect(gen_30123_AUSTEN_G3.terminal, bus_30123_AUSTEN_G3.terminal) annotation(
    Line(points = {{330, -30}, {300, -30}}, color = {0, 0, 255}));
  connect(gen_10115_ARTHUR_G1.terminal, bus_10115_ARTHUR_G1.terminal) annotation(
    Line(points = {{-230, 196}, {-210, 196}}, color = {0, 0, 255}));
  connect(gen_20115_ARTHUR_G2.terminal, bus_20115_ARTHUR_G2.terminal) annotation(
    Line(points = {{-230, 156}, {-210, 156}}, color = {0, 0, 255}));
  connect(gen_30115_ARTHUR_G3.terminal, bus_30115_ARTHUR_G3.terminal) annotation(
    Line(points = {{-230, 116}, {-210, 116}}, color = {0, 0, 255}));
  connect(gen_40115_ARTHUR_G4.terminal, bus_40115_ARTHUR_G4.terminal) annotation(
    Line(points = {{-230, 76}, {-210, 76}}, color = {0, 0, 255}));
  connect(gen_50115_ARTHUR_G5.terminal, bus_50115_ARTHUR_G5.terminal) annotation(
    Line(points = {{-230, 36}, {-210, 36}}, color = {0, 0, 255}));
  connect(gen_60115_ARTHUR_G6.terminal, bus_60115_ARTHUR_G6.terminal) annotation(
    Line(points = {{-230, -4}, {-210, -4}}, color = {0, 0, 255}));
  connect(gen_10116_ASSER_G1.terminal, bus_10116_ASSER_G1.terminal) annotation(
    Line(points = {{-112, 48}, {-90, 48}}, color = {0, 0, 255}));
  connect(gen_10118_ASTOR_G1.terminal, bus_10118_ASTOR_G1.terminal) annotation(
    Line(points = {{-20, 104}, {0, 104}}, color = {0, 0, 255}));
  connect(gen_30122_AUBREY_G3.terminal, bus_30122_AUBREY_G3.terminal) annotation(
    Line(points = {{328, 212}, {300, 212}}, color = {0, 0, 255}));
  connect(gen_40122_AUBREY_G4.terminal, bus_40122_AUBREY_G4.terminal) annotation(
    Line(points = {{328, 172}, {300, 172}}, color = {0, 0, 255}));
  connect(gen_50122_AUBREY_G5.terminal, bus_50122_AUBREY_G5.terminal) annotation(
    Line(points = {{328, 132}, {300, 132}}, color = {0, 0, 255}));
  connect(gen_60122_AUBREY_G6.terminal, bus_60122_AUBREY_G6.terminal) annotation(
    Line(points = {{328, 92}, {300, 92}}, color = {0, 0, 255}));
  connect(gen_10122_AUBREY_G1.terminal, bus_10122_AUBREY_G1.terminal) annotation(
    Line(points = {{196, 182}, {220, 182}}, color = {0, 0, 255}));
  connect(gen_20122_AUBREY_G2.terminal, bus_20122_AUBREY_G2.terminal) annotation(
    Line(points = {{196, 142}, {220, 142}}, color = {0, 0, 255}));
  connect(sVarC_10106_ALBER_SVC.terminal, bus_10106_ALBER_SVC.terminal) annotation(
    Line(points = {{210, -322}, {186, -322}}, color = {0, 0, 255}));
  connect(sVarC_10114_ARNOLD_SVC.terminal, bus_10114_ARNOLD_SVC.terminal) annotation(
    Line(points = {{50, 28}, {28, 28}}, color = {0, 0, 255}));

  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-03, Interval = 0.1),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida"),
    Diagram(coordinateSystem(extent = {{-200, -300}, {200, 300}})),
    Icon(coordinateSystem(extent = {{-200, -300}, {200, 300}})));
end FullDynamicFromLoadFlow122PQSVCCtrlLTC;
