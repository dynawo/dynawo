within Dynawo.Examples.RVS.Grid;

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

model FullDynamicInfiniteBusNoLoadReset "RVS test grid with buses, lines, shunts, alpha-beta loads, transformers, generators and static var compensators"
  import Modelica.SIunits.Conversions.from_deg;

  extends BaseClasses.NetworkWithTrf;

  Components.GeneratorWithControl.SteamEXACFrame gen_40101_ABEL_G4(P0Pu = P0Pu_gen_40101_ABEL_G4, Q0Pu = Q0Pu_gen_40101_ABEL_G4, U0Pu = U0Pu_gen_40101_ABEL_G4, UPhase0 = UPhase0_gen_40101_ABEL_G4, exac1Preset = Components.GeneratorWithControl.BaseClasses.ParametersEXAC.genFramePreset.g40101, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g40101, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g40101, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g40101) annotation(
    Placement(visible = true, transformation(origin = {-128, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_30101_ABEL_G3(P0Pu = P0Pu_gen_30101_ABEL_G3, Q0Pu = Q0Pu_gen_30101_ABEL_G3, U0Pu = U0Pu_gen_30101_ABEL_G3, UPhase0 = UPhase0_gen_30101_ABEL_G3, exac1Preset = Components.GeneratorWithControl.BaseClasses.ParametersEXAC.genFramePreset.g30101, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g30101, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g30101, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g30101) annotation(
    Placement(visible = true, transformation(origin = {-168, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_10101_ABEL_G1(P0Pu = P0Pu_gen_10101_ABEL_G1, Q0Pu = Q0Pu_gen_10101_ABEL_G1, U0Pu = U0Pu_gen_10101_ABEL_G1, UPhase0 = UPhase0_gen_10101_ABEL_G1, exac1Preset = Components.GeneratorWithControl.BaseClasses.ParametersEXAC.genFramePreset.g10101, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g10101, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g10101, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g10101) annotation(
    Placement(visible = true, transformation(origin = {-248, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_20101_ABEL_G2(P0Pu = P0Pu_gen_20101_ABEL_G2, Q0Pu = Q0Pu_gen_20101_ABEL_G2, U0Pu = U0Pu_gen_20101_ABEL_G2, UPhase0 = UPhase0_gen_20101_ABEL_G2, exac1Preset = Components.GeneratorWithControl.BaseClasses.ParametersEXAC.genFramePreset.g20101, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g20101, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g20101, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g20101) annotation(
    Placement(visible = true, transformation(origin = {-208, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_20102_ADAMS_G2(P0Pu = P0Pu_gen_20102_ADAMS_G2, Q0Pu = Q0Pu_gen_20102_ADAMS_G2, U0Pu = U0Pu_gen_20102_ADAMS_G2, UPhase0 = UPhase0_gen_20102_ADAMS_G2, exac1Preset = Components.GeneratorWithControl.BaseClasses.ParametersEXAC.genFramePreset.g20102, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g20102, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g20102, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g20102) annotation(
    Placement(visible = true, transformation(origin = {-4, -306}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_40102_ADAMS_G4(P0Pu = P0Pu_gen_40102_ADAMS_G4, Q0Pu = Q0Pu_gen_40102_ADAMS_G4, U0Pu = U0Pu_gen_40102_ADAMS_G4, UPhase0 = UPhase0_gen_40102_ADAMS_G4, exac1Preset = Components.GeneratorWithControl.BaseClasses.ParametersEXAC.genFramePreset.g40102, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g40102, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g40102, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g40102) annotation(
    Placement(visible = true, transformation(origin = {76, -306}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_10102_ADAMS_G1(P0Pu = P0Pu_gen_10102_ADAMS_G1, Q0Pu = Q0Pu_gen_10102_ADAMS_G1, U0Pu = U0Pu_gen_10102_ADAMS_G1, UPhase0 = UPhase0_gen_10102_ADAMS_G1, exac1Preset = Components.GeneratorWithControl.BaseClasses.ParametersEXAC.genFramePreset.g10102, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g10102, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g10102, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g10102) annotation(
    Placement(visible = true, transformation(origin = {-44, -306}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_30102_ADAMS_G3(P0Pu = P0Pu_gen_30102_ADAMS_G3, Q0Pu = Q0Pu_gen_30102_ADAMS_G3, U0Pu = U0Pu_gen_30102_ADAMS_G3, UPhase0 = UPhase0_gen_30102_ADAMS_G3, exac1Preset = Components.GeneratorWithControl.BaseClasses.ParametersEXAC.genFramePreset.g30102, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g30102, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g30102, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g30102) annotation(
    Placement(visible = true, transformation(origin = {36, -306}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_30107_ALDER_G3(P0Pu = P0Pu_gen_30107_ALDER_G3, Q0Pu = Q0Pu_gen_30107_ALDER_G3, U0Pu = U0Pu_gen_30107_ALDER_G3, UPhase0 = UPhase0_gen_30107_ALDER_G3, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g30107, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g30107, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g30107, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g30107) annotation(
    Placement(visible = true, transformation(origin = {296, -214}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10107_ALDER_G1(P0Pu = P0Pu_gen_10107_ALDER_G1, Q0Pu = Q0Pu_gen_10107_ALDER_G1, U0Pu = U0Pu_gen_10107_ALDER_G1, UPhase0 = UPhase0_gen_10107_ALDER_G1, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g10107, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g10107, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g10107, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g10107) annotation(
    Placement(visible = true, transformation(origin = {296, -134}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_20107_ALDER_G2(P0Pu = P0Pu_gen_20107_ALDER_G2, Q0Pu = Q0Pu_gen_20107_ALDER_G2, U0Pu = U0Pu_gen_20107_ALDER_G2, UPhase0 = UPhase0_gen_20107_ALDER_G2, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g20107, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g20107, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g20107, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g20107) annotation(
    Placement(visible = true, transformation(origin = {296, -174}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Buses.InfiniteBus infiniteBus(UPhase = from_deg(13.4), UPu = 1.04685) annotation(
    Placement(visible = true, transformation(origin = {-134, 322}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_20113_ARNE_G2(P0Pu = P0Pu_gen_20113_ARNE_G2, Q0Pu = Q0Pu_gen_20113_ARNE_G2, U0Pu = U0Pu_gen_20113_ARNE_G2, UPhase0 = UPhase0_gen_20113_ARNE_G2, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g20113, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g20113, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g20113, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g20113) annotation(
    Placement(visible = true, transformation(origin = {186, 6}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_30113_ARNE_G3(P0Pu = P0Pu_gen_30113_ARNE_G3, Q0Pu = Q0Pu_gen_30113_ARNE_G3, U0Pu = U0Pu_gen_30113_ARNE_G3, UPhase0 = UPhase0_gen_30113_ARNE_G3, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g30113, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g30113, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g30113, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g30113) annotation(
    Placement(visible = true, transformation(origin = {186, -34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10113_ARNE_G1(P0Pu = P0Pu_gen_10113_ARNE_G1, Q0Pu = Q0Pu_gen_10113_ARNE_G1, U0Pu = U0Pu_gen_10113_ARNE_G1, UPhase0 = UPhase0_gen_10113_ARNE_G1, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g10113, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g10113, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g10113, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g10113) annotation(
    Placement(visible = true, transformation(origin = {186, 46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_20123_AUSTEN_G2(P0Pu = P0Pu_gen_20123_AUSTEN_G2, Q0Pu = Q0Pu_gen_20123_AUSTEN_G2, U0Pu = U0Pu_gen_20123_AUSTEN_G2, UPhase0 = UPhase0_gen_20123_AUSTEN_G2, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g20123, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g20123, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g20123, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g20123) annotation(
    Placement(visible = true, transformation(origin = {296, 106}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10123_AUSTEN_G1(P0Pu = P0Pu_gen_10123_AUSTEN_G1, Q0Pu = Q0Pu_gen_10123_AUSTEN_G1, U0Pu = U0Pu_gen_10123_AUSTEN_G1, UPhase0 = UPhase0_gen_10123_AUSTEN_G1, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g10123, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g10123, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g10123, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g10123) annotation(
    Placement(visible = true, transformation(origin = {296, 146}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_30123_AUSTEN_G3(P0Pu = P0Pu_gen_30123_AUSTEN_G3, Q0Pu = Q0Pu_gen_30123_AUSTEN_G3, U0Pu = U0Pu_gen_30123_AUSTEN_G3, UPhase0 = UPhase0_gen_30123_AUSTEN_G3, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g30123, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g30123, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g30123, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g30123) annotation(
    Placement(visible = true, transformation(origin = {296, 66}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_50115_ARTHUR_G5(P0Pu = P0Pu_gen_50115_ARTHUR_G5, Q0Pu = Q0Pu_gen_50115_ARTHUR_G5, U0Pu = U0Pu_gen_50115_ARTHUR_G5, UPhase0 = UPhase0_gen_50115_ARTHUR_G5, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g50115, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g50115, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g50115, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g50115) annotation(
    Placement(visible = true, transformation(origin = {-264, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_60115_ARTHUR_G6(P0Pu = P0Pu_gen_60115_ARTHUR_G6, Q0Pu = Q0Pu_gen_60115_ARTHUR_G6, U0Pu = U0Pu_gen_60115_ARTHUR_G6, UPhase0 = UPhase0_gen_60115_ARTHUR_G6, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g60115, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g60115, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g60115, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g60115) annotation(
    Placement(visible = true, transformation(origin = {-264, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10115_ARTHUR_G1(P0Pu = P0Pu_gen_10115_ARTHUR_G1, Q0Pu = Q0Pu_gen_10115_ARTHUR_G1, U0Pu = U0Pu_gen_10115_ARTHUR_G1, UPhase0 = UPhase0_gen_10115_ARTHUR_G1, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g10115, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g10115, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g10115, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g10115) annotation(
    Placement(visible = true, transformation(origin = {-264, 292}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_40115_ARTHUR_G4(P0Pu = P0Pu_gen_40115_ARTHUR_G4, Q0Pu = Q0Pu_gen_40115_ARTHUR_G4, U0Pu = U0Pu_gen_40115_ARTHUR_G4, UPhase0 = UPhase0_gen_40115_ARTHUR_G4, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g40115, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g40115, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g40115, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g40115) annotation(
    Placement(visible = true, transformation(origin = {-264, 172}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_30115_ARTHUR_G3(P0Pu = P0Pu_gen_30115_ARTHUR_G3, Q0Pu = Q0Pu_gen_30115_ARTHUR_G3, U0Pu = U0Pu_gen_30115_ARTHUR_G3, UPhase0 = UPhase0_gen_30115_ARTHUR_G3, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g30115, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g30115, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g30115, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g30115) annotation(
    Placement(visible = true, transformation(origin = {-264, 212}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_20115_ARTHUR_G2(P0Pu = P0Pu_gen_20115_ARTHUR_G2, Q0Pu = Q0Pu_gen_20115_ARTHUR_G2, U0Pu = U0Pu_gen_20115_ARTHUR_G2, UPhase0 = UPhase0_gen_20115_ARTHUR_G2, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g20115, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g20115, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g20115, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g20115) annotation(
    Placement(visible = true, transformation(origin = {-264, 252}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10116_ASSER_G1(P0Pu = P0Pu_gen_10116_ASSER_G1, Q0Pu = Q0Pu_gen_10116_ASSER_G1, U0Pu = U0Pu_gen_10116_ASSER_G1, UPhase0 = UPhase0_gen_10116_ASSER_G1, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g10116, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g10116, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g10116, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g10116) annotation(
    Placement(visible = true, transformation(origin = {-146, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamIEEET1Frame gen_10118_ASTOR_G1(P0Pu = P0Pu_gen_10118_ASTOR_G1, Q0Pu = Q0Pu_gen_10118_ASTOR_G1, U0Pu = U0Pu_gen_10118_ASTOR_G1, UPhase0 = UPhase0_gen_10118_ASTOR_G1, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g10118, ieeeg1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1.genFramePreset.g10118, ieeet1Preset = Components.GeneratorWithControl.BaseClasses.ParametersIEEET1.genFramePreset.g10118, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, pss2bPreset = Components.GeneratorWithControl.BaseClasses.ParametersPSS2B.genFramePreset.g10118) annotation(
    Placement(visible = true, transformation(origin = {-54, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.HydroFrame gen_30122_AUBREY_G3(GovInService = true, P0Pu = P0Pu_gen_30122_AUBREY_G3, Q0Pu = Q0Pu_gen_30122_AUBREY_G3, U0Pu = U0Pu_gen_30122_AUBREY_G3, UPhase0 = UPhase0_gen_30122_AUBREY_G3, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g30122, hygovPreset = Components.GeneratorWithControl.BaseClasses.ParametersHYGOV.genFramePreset.g30122, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g30122) annotation(
    Placement(visible = true, transformation(origin = {294, 308}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.HydroFrame gen_10122_AUBREY_G1(GovInService = true, P0Pu = P0Pu_gen_10122_AUBREY_G1, Q0Pu = Q0Pu_gen_10122_AUBREY_G1, U0Pu = U0Pu_gen_10122_AUBREY_G1, UPhase0 = UPhase0_gen_10122_AUBREY_G1, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g10122, hygovPreset = Components.GeneratorWithControl.BaseClasses.ParametersHYGOV.genFramePreset.g10122, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g10122) annotation(
    Placement(visible = true, transformation(origin = {162, 278}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.HydroFrame gen_50122_AUBREY_G5(GovInService = true, P0Pu = P0Pu_gen_50122_AUBREY_G5, Q0Pu = Q0Pu_gen_50122_AUBREY_G5, U0Pu = U0Pu_gen_50122_AUBREY_G5, UPhase0 = UPhase0_gen_50122_AUBREY_G5, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g50122, hygovPreset = Components.GeneratorWithControl.BaseClasses.ParametersHYGOV.genFramePreset.g50122, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g50122) annotation(
    Placement(visible = true, transformation(origin = {294, 228}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.HydroFrame gen_60122_AUBREY_G6(GovInService = true, P0Pu = P0Pu_gen_60122_AUBREY_G6, Q0Pu = Q0Pu_gen_60122_AUBREY_G6, U0Pu = U0Pu_gen_60122_AUBREY_G6, UPhase0 = UPhase0_gen_60122_AUBREY_G6, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g60122, hygovPreset = Components.GeneratorWithControl.BaseClasses.ParametersHYGOV.genFramePreset.g60122, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g60122) annotation(
    Placement(visible = true, transformation(origin = {294, 188}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.HydroFrame gen_20122_AUBREY_G2(GovInService = true, P0Pu = P0Pu_gen_20122_AUBREY_G2, Q0Pu = Q0Pu_gen_20122_AUBREY_G2, U0Pu = U0Pu_gen_20122_AUBREY_G2, UPhase0 = UPhase0_gen_20122_AUBREY_G2, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g20122, hygovPreset = Components.GeneratorWithControl.BaseClasses.ParametersHYGOV.genFramePreset.g20122, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g20122) annotation(
    Placement(visible = true, transformation(origin = {162, 238}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.HydroFrame gen_40122_AUBREY_G4(GovInService = true, P0Pu = P0Pu_gen_40122_AUBREY_G4, Q0Pu = Q0Pu_gen_40122_AUBREY_G4, U0Pu = U0Pu_gen_40122_AUBREY_G4, UPhase0 = UPhase0_gen_40122_AUBREY_G4, gen = Components.GeneratorWithControl.BaseClasses.ParametersGenerators.genFramePreset.g40122, hygovPreset = Components.GeneratorWithControl.BaseClasses.ParametersHYGOV.genFramePreset.g40122, oelPreset = Components.GeneratorWithControl.BaseClasses.ParametersOEL.oelFramePreset.all, scrxPreset = Components.GeneratorWithControl.BaseClasses.ParametersSCRX.genFramePreset.g40122) annotation(
    Placement(visible = true, transformation(origin = {294, 268}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.StaticVarCompensators.SVarCRVS sVarC_10106_ALBER_SVC(K = 150 * 150, Q0Pu = Q0Pu_sVarC_10106_ALBER_SVC, U0Pu = U0Pu_sVarC_10106_ALBER_SVC, UPhase0 = UPhase0_sVarC_10106_ALBER_SVC, svcPreset = Components.StaticVarCompensators.BaseClasses.ParametersSVC.svcFramePreset.sVarC_10106) annotation(
    Placement(visible = true, transformation(origin = {176, -226}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.StaticVarCompensators.SVarCRVS sVarC_10114_ARNOLD_SVC(K = 150 * 250, Q0Pu = Q0Pu_sVarC_10114_ARNOLD_SVC, U0Pu = U0Pu_sVarC_10114_ARNOLD_SVC, UPhase0 = UPhase0_sVarC_10114_ARNOLD_SVC, svcPreset = Components.StaticVarCompensators.BaseClasses.ParametersSVC.svcFramePreset.sVarC_10114) annotation(
    Placement(visible = true, transformation(origin = {16, 124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Generators
  parameter Types.ActivePowerPu P0Pu_gen_10101_ABEL_G1;
  parameter Types.ReactivePowerPu Q0Pu_gen_10101_ABEL_G1;
  parameter Types.VoltageModulePu U0Pu_gen_10101_ABEL_G1;
  parameter Types.Angle UPhase0_gen_10101_ABEL_G1;

  parameter Types.ActivePowerPu P0Pu_gen_10102_ADAMS_G1;
  parameter Types.ReactivePowerPu Q0Pu_gen_10102_ADAMS_G1;
  parameter Types.VoltageModulePu U0Pu_gen_10102_ADAMS_G1;
  parameter Types.Angle UPhase0_gen_10102_ADAMS_G1;

  parameter Types.ActivePowerPu P0Pu_gen_10107_ALDER_G1;
  parameter Types.ReactivePowerPu Q0Pu_gen_10107_ALDER_G1;
  parameter Types.VoltageModulePu U0Pu_gen_10107_ALDER_G1;
  parameter Types.Angle UPhase0_gen_10107_ALDER_G1;

  parameter Types.ActivePowerPu P0Pu_gen_10113_ARNE_G1;
  parameter Types.ReactivePowerPu Q0Pu_gen_10113_ARNE_G1;
  parameter Types.VoltageModulePu U0Pu_gen_10113_ARNE_G1;
  parameter Types.Angle UPhase0_gen_10113_ARNE_G1;

  parameter Types.ActivePowerPu P0Pu_gen_10115_ARTHUR_G1;
  parameter Types.ReactivePowerPu Q0Pu_gen_10115_ARTHUR_G1;
  parameter Types.VoltageModulePu U0Pu_gen_10115_ARTHUR_G1;
  parameter Types.Angle UPhase0_gen_10115_ARTHUR_G1;

  parameter Types.ActivePowerPu P0Pu_gen_10116_ASSER_G1;
  parameter Types.ReactivePowerPu Q0Pu_gen_10116_ASSER_G1;
  parameter Types.VoltageModulePu U0Pu_gen_10116_ASSER_G1;
  parameter Types.Angle UPhase0_gen_10116_ASSER_G1;

  parameter Types.ActivePowerPu P0Pu_gen_10118_ASTOR_G1;
  parameter Types.ReactivePowerPu Q0Pu_gen_10118_ASTOR_G1;
  parameter Types.VoltageModulePu U0Pu_gen_10118_ASTOR_G1;
  parameter Types.Angle UPhase0_gen_10118_ASTOR_G1;

  parameter Types.ActivePowerPu P0Pu_gen_10122_AUBREY_G1;
  parameter Types.ReactivePowerPu Q0Pu_gen_10122_AUBREY_G1;
  parameter Types.VoltageModulePu U0Pu_gen_10122_AUBREY_G1;
  parameter Types.Angle UPhase0_gen_10122_AUBREY_G1;

  parameter Types.ActivePowerPu P0Pu_gen_10123_AUSTEN_G1;
  parameter Types.ReactivePowerPu Q0Pu_gen_10123_AUSTEN_G1;
  parameter Types.VoltageModulePu U0Pu_gen_10123_AUSTEN_G1;
  parameter Types.Angle UPhase0_gen_10123_AUSTEN_G1;

  parameter Types.ActivePowerPu P0Pu_gen_20101_ABEL_G2;
  parameter Types.ReactivePowerPu Q0Pu_gen_20101_ABEL_G2;
  parameter Types.VoltageModulePu U0Pu_gen_20101_ABEL_G2;
  parameter Types.Angle UPhase0_gen_20101_ABEL_G2;

  parameter Types.ActivePowerPu P0Pu_gen_20102_ADAMS_G2;
  parameter Types.ReactivePowerPu Q0Pu_gen_20102_ADAMS_G2;
  parameter Types.VoltageModulePu U0Pu_gen_20102_ADAMS_G2;
  parameter Types.Angle UPhase0_gen_20102_ADAMS_G2;

  parameter Types.ActivePowerPu P0Pu_gen_20107_ALDER_G2;
  parameter Types.ReactivePowerPu Q0Pu_gen_20107_ALDER_G2;
  parameter Types.VoltageModulePu U0Pu_gen_20107_ALDER_G2;
  parameter Types.Angle UPhase0_gen_20107_ALDER_G2;

  parameter Types.ActivePowerPu P0Pu_gen_20113_ARNE_G2;
  parameter Types.ReactivePowerPu Q0Pu_gen_20113_ARNE_G2;
  parameter Types.VoltageModulePu U0Pu_gen_20113_ARNE_G2;
  parameter Types.Angle UPhase0_gen_20113_ARNE_G2;

  parameter Types.ActivePowerPu P0Pu_gen_20115_ARTHUR_G2;
  parameter Types.ReactivePowerPu Q0Pu_gen_20115_ARTHUR_G2;
  parameter Types.VoltageModulePu U0Pu_gen_20115_ARTHUR_G2;
  parameter Types.Angle UPhase0_gen_20115_ARTHUR_G2;

  parameter Types.ActivePowerPu P0Pu_gen_20122_AUBREY_G2;
  parameter Types.ReactivePowerPu Q0Pu_gen_20122_AUBREY_G2;
  parameter Types.VoltageModulePu U0Pu_gen_20122_AUBREY_G2;
  parameter Types.Angle UPhase0_gen_20122_AUBREY_G2;

  parameter Types.ActivePowerPu P0Pu_gen_20123_AUSTEN_G2;
  parameter Types.ReactivePowerPu Q0Pu_gen_20123_AUSTEN_G2;
  parameter Types.VoltageModulePu U0Pu_gen_20123_AUSTEN_G2;
  parameter Types.Angle UPhase0_gen_20123_AUSTEN_G2;

  parameter Types.ActivePowerPu P0Pu_gen_30101_ABEL_G3;
  parameter Types.ReactivePowerPu Q0Pu_gen_30101_ABEL_G3;
  parameter Types.VoltageModulePu U0Pu_gen_30101_ABEL_G3;
  parameter Types.Angle UPhase0_gen_30101_ABEL_G3;

  parameter Types.ActivePowerPu P0Pu_gen_30102_ADAMS_G3;
  parameter Types.ReactivePowerPu Q0Pu_gen_30102_ADAMS_G3;
  parameter Types.VoltageModulePu U0Pu_gen_30102_ADAMS_G3;
  parameter Types.Angle UPhase0_gen_30102_ADAMS_G3;

  parameter Types.ActivePowerPu P0Pu_gen_30107_ALDER_G3;
  parameter Types.ReactivePowerPu Q0Pu_gen_30107_ALDER_G3;
  parameter Types.VoltageModulePu U0Pu_gen_30107_ALDER_G3;
  parameter Types.Angle UPhase0_gen_30107_ALDER_G3;

  parameter Types.ActivePowerPu P0Pu_gen_30113_ARNE_G3;
  parameter Types.ReactivePowerPu Q0Pu_gen_30113_ARNE_G3;
  parameter Types.VoltageModulePu U0Pu_gen_30113_ARNE_G3;
  parameter Types.Angle UPhase0_gen_30113_ARNE_G3;

  parameter Types.ActivePowerPu P0Pu_gen_30115_ARTHUR_G3;
  parameter Types.ReactivePowerPu Q0Pu_gen_30115_ARTHUR_G3;
  parameter Types.VoltageModulePu U0Pu_gen_30115_ARTHUR_G3;
  parameter Types.Angle UPhase0_gen_30115_ARTHUR_G3;

  parameter Types.ActivePowerPu P0Pu_gen_30122_AUBREY_G3;
  parameter Types.ReactivePowerPu Q0Pu_gen_30122_AUBREY_G3;
  parameter Types.VoltageModulePu U0Pu_gen_30122_AUBREY_G3;
  parameter Types.Angle UPhase0_gen_30122_AUBREY_G3;

  parameter Types.ActivePowerPu P0Pu_gen_30123_AUSTEN_G3;
  parameter Types.ReactivePowerPu Q0Pu_gen_30123_AUSTEN_G3;
  parameter Types.VoltageModulePu U0Pu_gen_30123_AUSTEN_G3;
  parameter Types.Angle UPhase0_gen_30123_AUSTEN_G3;

  parameter Types.ActivePowerPu P0Pu_gen_40101_ABEL_G4;
  parameter Types.ReactivePowerPu Q0Pu_gen_40101_ABEL_G4;
  parameter Types.VoltageModulePu U0Pu_gen_40101_ABEL_G4;
  parameter Types.Angle UPhase0_gen_40101_ABEL_G4;

  parameter Types.ActivePowerPu P0Pu_gen_40102_ADAMS_G4;
  parameter Types.ReactivePowerPu Q0Pu_gen_40102_ADAMS_G4;
  parameter Types.VoltageModulePu U0Pu_gen_40102_ADAMS_G4;
  parameter Types.Angle UPhase0_gen_40102_ADAMS_G4;

  parameter Types.ActivePowerPu P0Pu_gen_40115_ARTHUR_G4;
  parameter Types.ReactivePowerPu Q0Pu_gen_40115_ARTHUR_G4;
  parameter Types.VoltageModulePu U0Pu_gen_40115_ARTHUR_G4;
  parameter Types.Angle UPhase0_gen_40115_ARTHUR_G4;

  parameter Types.ActivePowerPu P0Pu_gen_40122_AUBREY_G4;
  parameter Types.ReactivePowerPu Q0Pu_gen_40122_AUBREY_G4;
  parameter Types.VoltageModulePu U0Pu_gen_40122_AUBREY_G4;
  parameter Types.Angle UPhase0_gen_40122_AUBREY_G4;

  parameter Types.ActivePowerPu P0Pu_gen_50115_ARTHUR_G5;
  parameter Types.ReactivePowerPu Q0Pu_gen_50115_ARTHUR_G5;
  parameter Types.VoltageModulePu U0Pu_gen_50115_ARTHUR_G5;
  parameter Types.Angle UPhase0_gen_50115_ARTHUR_G5;

  parameter Types.ActivePowerPu P0Pu_gen_50122_AUBREY_G5;
  parameter Types.ReactivePowerPu Q0Pu_gen_50122_AUBREY_G5;
  parameter Types.VoltageModulePu U0Pu_gen_50122_AUBREY_G5;
  parameter Types.Angle UPhase0_gen_50122_AUBREY_G5;

  parameter Types.ActivePowerPu P0Pu_gen_60115_ARTHUR_G6;
  parameter Types.ReactivePowerPu Q0Pu_gen_60115_ARTHUR_G6;
  parameter Types.VoltageModulePu U0Pu_gen_60115_ARTHUR_G6;
  parameter Types.Angle UPhase0_gen_60115_ARTHUR_G6;

  parameter Types.ActivePowerPu P0Pu_gen_60122_AUBREY_G6;
  parameter Types.ReactivePowerPu Q0Pu_gen_60122_AUBREY_G6;
  parameter Types.VoltageModulePu U0Pu_gen_60122_AUBREY_G6;
  parameter Types.Angle UPhase0_gen_60122_AUBREY_G6;

  //SVarC
  parameter Types.ActivePowerPu P0Pu_sVarC_10106_ALBER_SVC;
  parameter Types.ReactivePowerPu Q0Pu_sVarC_10106_ALBER_SVC;
  parameter Types.VoltageModulePu U0Pu_sVarC_10106_ALBER_SVC;
  parameter Types.Angle UPhase0_sVarC_10106_ALBER_SVC;

  parameter Types.ActivePowerPu P0Pu_sVarC_10114_ARNOLD_SVC;
  parameter Types.ReactivePowerPu Q0Pu_sVarC_10114_ARNOLD_SVC;
  parameter Types.VoltageModulePu U0Pu_sVarC_10114_ARNOLD_SVC;
  parameter Types.Angle UPhase0_sVarC_10114_ARNOLD_SVC;

  final parameter Types.PerUnit B0Pu_sVarC_10106_ALBER_SVC = Q0Pu_sVarC_10106_ALBER_SVC / U0Pu_sVarC_10106_ALBER_SVC ^ 2;
  final parameter Types.ComplexCurrentPu i0Pu_sVarC_10106_ALBER_SVC = ComplexMath.conj(s0Pu_sVarC_10106_ALBER_SVC / u0Pu_sVarC_10106_ALBER_SVC);
  final parameter Types.ComplexApparentPowerPu s0Pu_sVarC_10106_ALBER_SVC = Complex(P0Pu_sVarC_10106_ALBER_SVC, Q0Pu_sVarC_10106_ALBER_SVC);
  final parameter Types.ComplexVoltagePu u0Pu_sVarC_10106_ALBER_SVC = ComplexMath.fromPolar(U0Pu_sVarC_10106_ALBER_SVC, UPhase0_sVarC_10106_ALBER_SVC);

  final parameter Types.PerUnit B0Pu_sVarC_10114_ARNOLD_SVC = Q0Pu_sVarC_10114_ARNOLD_SVC / U0Pu_sVarC_10114_ARNOLD_SVC ^ 2;
  final parameter Types.ComplexCurrentPu i0Pu_sVarC_10114_ARNOLD_SVC = ComplexMath.conj(s0Pu_sVarC_10114_ARNOLD_SVC / u0Pu_sVarC_10114_ARNOLD_SVC);
  final parameter Types.ComplexApparentPowerPu s0Pu_sVarC_10114_ARNOLD_SVC = Complex(P0Pu_sVarC_10114_ARNOLD_SVC, Q0Pu_sVarC_10114_ARNOLD_SVC);
  final parameter Types.ComplexVoltagePu u0Pu_sVarC_10114_ARNOLD_SVC = ComplexMath.fromPolar(U0Pu_sVarC_10114_ARNOLD_SVC, UPhase0_sVarC_10114_ARNOLD_SVC);

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
  sVarC_10114_ARNOLD_SVC.sVarCPVInterfaces.switchOffSignal1.value = false;
  sVarC_10114_ARNOLD_SVC.sVarCPVInterfaces.switchOffSignal2.value = false;
  sVarC_10114_ARNOLD_SVC.URefPu = U0Pu_sVarC_10114_ARNOLD_SVC;
  sVarC_10106_ALBER_SVC.sVarCPVInterfaces.switchOffSignal1.value = false;
  sVarC_10106_ALBER_SVC.sVarCPVInterfaces.switchOffSignal2.value = false;
  sVarC_10106_ALBER_SVC.URefPu = U0Pu_sVarC_10106_ALBER_SVC;

  connect(gen_10101_ABEL_G1.terminal, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-248, -266}, {-248, -246}}, color = {0, 0, 255}));
  connect(gen_20101_ABEL_G2.terminal, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-208, -266}, {-208, -246}}, color = {0, 0, 255}));
  connect(gen_30101_ABEL_G3.terminal, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{-168, -266}, {-168, -246}}, color = {0, 0, 255}));
  connect(gen_40101_ABEL_G4.terminal, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{-128, -266}, {-128, -246}}, color = {0, 0, 255}));
  connect(gen_10102_ADAMS_G1.terminal, bus_10102_ADAMS_G1.terminal) annotation(
    Line(points = {{-44, -306}, {-44, -286}}, color = {0, 0, 255}));
  connect(gen_20102_ADAMS_G2.terminal, bus_20102_ADAMS_G2.terminal) annotation(
    Line(points = {{-4, -306}, {-4, -286}}, color = {0, 0, 255}));
  connect(gen_30102_ADAMS_G3.terminal, bus_30102_ADAMS_G3.terminal) annotation(
    Line(points = {{36, -306}, {36, -286}}, color = {0, 0, 255}));
  connect(gen_40102_ADAMS_G4.terminal, bus_40102_ADAMS_G4.terminal) annotation(
    Line(points = {{76, -306}, {76, -286}}, color = {0, 0, 255}));
  connect(gen_10107_ALDER_G1.terminal, bus_10107_ALDER_G1.terminal) annotation(
    Line(points = {{296, -134}, {276, -134}}, color = {0, 0, 255}));
  connect(gen_20107_ALDER_G2.terminal, bus_20107_ALDER_G2.terminal) annotation(
    Line(points = {{296, -174}, {276, -174}}, color = {0, 0, 255}));
  connect(gen_30107_ALDER_G3.terminal, bus_30107_ALDER_G3.terminal) annotation(
    Line(points = {{296, -214}, {276, -214}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, bus_10121_ATTLEE_G1.terminal) annotation(
    Line(points = {{-134, 322}, {-134, 282}}, color = {0, 0, 255}));
  connect(gen_10113_ARNE_G1.terminal, bus_10113_ARNE_G1.terminal) annotation(
    Line(points = {{186, 46}, {166, 46}}, color = {0, 0, 255}));
  connect(gen_20113_ARNE_G2.terminal, bus_20113_ARNE_G2.terminal) annotation(
    Line(points = {{186, 6}, {166, 6}}, color = {0, 0, 255}));
  connect(gen_30113_ARNE_G3.terminal, bus_30113_ARNE_G3.terminal) annotation(
    Line(points = {{186, -34}, {166, -34}}, color = {0, 0, 255}));
  connect(gen_10123_AUSTEN_G1.terminal, bus_10123_AUSTEN_G1.terminal) annotation(
    Line(points = {{296, 146}, {266, 146}}, color = {0, 0, 255}));
  connect(gen_20123_AUSTEN_G2.terminal, bus_20123_AUSTEN_G2.terminal) annotation(
    Line(points = {{296, 106}, {266, 106}}, color = {0, 0, 255}));
  connect(gen_30123_AUSTEN_G3.terminal, bus_30123_AUSTEN_G3.terminal) annotation(
    Line(points = {{296, 66}, {266, 66}}, color = {0, 0, 255}));
  connect(gen_10115_ARTHUR_G1.terminal, bus_10115_ARTHUR_G1.terminal) annotation(
    Line(points = {{-264, 292}, {-244, 292}}, color = {0, 0, 255}));
  connect(gen_20115_ARTHUR_G2.terminal, bus_20115_ARTHUR_G2.terminal) annotation(
    Line(points = {{-264, 252}, {-244, 252}}, color = {0, 0, 255}));
  connect(gen_30115_ARTHUR_G3.terminal, bus_30115_ARTHUR_G3.terminal) annotation(
    Line(points = {{-264, 212}, {-244, 212}}, color = {0, 0, 255}));
  connect(gen_40115_ARTHUR_G4.terminal, bus_40115_ARTHUR_G4.terminal) annotation(
    Line(points = {{-264, 172}, {-244, 172}}, color = {0, 0, 255}));
  connect(gen_50115_ARTHUR_G5.terminal, bus_50115_ARTHUR_G5.terminal) annotation(
    Line(points = {{-264, 132}, {-244, 132}}, color = {0, 0, 255}));
  connect(gen_60115_ARTHUR_G6.terminal, bus_60115_ARTHUR_G6.terminal) annotation(
    Line(points = {{-264, 92}, {-244, 92}}, color = {0, 0, 255}));
  connect(gen_10116_ASSER_G1.terminal, bus_10116_ASSER_G1.terminal) annotation(
    Line(points = {{-146, 144}, {-124, 144}}, color = {0, 0, 255}));
  connect(gen_10118_ASTOR_G1.terminal, bus_10118_ASTOR_G1.terminal) annotation(
    Line(points = {{-54, 200}, {-34, 200}}, color = {0, 0, 255}));
  connect(gen_30122_AUBREY_G3.terminal, bus_30122_AUBREY_G3.terminal) annotation(
    Line(points = {{294, 308}, {266, 308}}, color = {0, 0, 255}));
  connect(gen_40122_AUBREY_G4.terminal, bus_40122_AUBREY_G4.terminal) annotation(
    Line(points = {{294, 268}, {266, 268}}, color = {0, 0, 255}));
  connect(gen_50122_AUBREY_G5.terminal, bus_50122_AUBREY_G5.terminal) annotation(
    Line(points = {{294, 228}, {266, 228}}, color = {0, 0, 255}));
  connect(gen_60122_AUBREY_G6.terminal, bus_60122_AUBREY_G6.terminal) annotation(
    Line(points = {{294, 188}, {266, 188}}, color = {0, 0, 255}));
  connect(gen_10122_AUBREY_G1.terminal, bus_10122_AUBREY_G1.terminal) annotation(
    Line(points = {{162, 278}, {186, 278}}, color = {0, 0, 255}));
  connect(gen_20122_AUBREY_G2.terminal, bus_20122_AUBREY_G2.terminal) annotation(
    Line(points = {{162, 238}, {186, 238}}, color = {0, 0, 255}));
  connect(sVarC_10106_ALBER_SVC.terminal, bus_10106_ALBER_SVC.terminal) annotation(
    Line(points = {{176, -226}, {152, -226}}, color = {0, 0, 255}));
  connect(sVarC_10114_ARNOLD_SVC.terminal, bus_10114_ARNOLD_SVC.terminal) annotation(
    Line(points = {{16, 124}, {-6, 124}}, color = {0, 0, 255}));

  annotation(preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-03, Interval = 0.1),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida"),
    Diagram(coordinateSystem(extent = {{-300, -340}, {300, 340}})));
end FullDynamicInfiniteBusNoLoadReset;
