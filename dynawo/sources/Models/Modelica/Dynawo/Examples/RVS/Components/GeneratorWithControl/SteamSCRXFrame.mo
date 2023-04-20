within Dynawo.Examples.RVS.Components.GeneratorWithControl;

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

model SteamSCRXFrame
  import Modelica;
  import Dynawo;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import ieeeg1par = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1;
  import pss2bpar = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B;
  import scrxpar = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX;
  import oelpar = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL;
  import genpar = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators;

  parameter ieeeg1par.genFramePreset ieeeg1Preset = ieeeg1par.genFramePreset.g10107;
  parameter pss2bpar.genFramePreset pss2bPreset = pss2bpar.genFramePreset.g10107;
  parameter scrxpar.genFramePreset scrxPreset = scrxpar.genFramePreset.g10107;
  parameter oelpar.oelFramePreset oelPreset = oelpar.oelFramePreset.all;
  parameter genpar.genFramePreset gen = genpar.genFramePreset.g10107;
  parameter Types.ActivePowerPu P0Pu;
  parameter Types.ReactivePowerPu Q0Pu;
  parameter Types.VoltageModulePu U0Pu;
  parameter Types.Angle UPhase0;
  parameter Types.VoltageModule UNom = 18;
  parameter Boolean AvrInService = true;
  parameter Boolean GovInService = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.hasGov] > 0;

  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.GeneratorSynchronousThreeWindingsInterface generatorSynchronous(

    DPu = genpar.genParamValues[gen, genpar.genParamNames.DPu],
    ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad,
    H = genpar.genParamValues[gen, genpar.genParamNames.H],P0Pu = P0Pu,
    PNomAlt = genpar.genParamValues[gen, genpar.genParamNames.PNom],
    PNomTurb = genpar.genParamValues[gen, genpar.genParamNames.PNom],
    Q0Pu = Q0Pu,
    RTfPu = 0,
    RaPu = genpar.genParamValues[gen, genpar.genParamNames.RaPu],
    SNom = genpar.genParamValues[gen, genpar.genParamNames.SNom],
    SnTfo = genpar.genParamValues[gen, genpar.genParamNames.SNom],
    Tpd0 = genpar.genParamValues[gen, genpar.genParamNames.Tpd0],
    Tppd0 = genpar.genParamValues[gen, genpar.genParamNames.Tppd0],
    Tppq0 = genpar.genParamValues[gen, genpar.genParamNames.Tppq0],
    Tpq0 = genpar.genParamValues[gen, genpar.genParamNames.Tpq0],
    U0Pu = U0Pu,
    UBaseHV = UNom,
    UBaseLV = UNom,
    UNom = UNom,
    UNomHV = UNom,
    UNomLV = UNom,
    UPhase0 = UPhase0,
    XTfPu = 0,
    XdPu = genpar.genParamValues[gen, genpar.genParamNames.XdPu],
    XlPu = genpar.genParamValues[gen, genpar.genParamNames.XlPu],
    XpdPu = genpar.genParamValues[gen, genpar.genParamNames.XpdPu],
    XppdPu = genpar.genParamValues[gen, genpar.genParamNames.XppdPu],
    XppqPu = genpar.genParamValues[gen, genpar.genParamNames.XppqPu],
    XpqPu = genpar.genParamValues[gen, genpar.genParamNames.XpqPu],
    XqPu = genpar.genParamValues[gen, genpar.genParamNames.XqPu],
    md = genpar.genParamValues[gen, genpar.genParamNames.md],
    mq = genpar.genParamValues[gen, genpar.genParamNames.mq],
    nd = genpar.genParamValues[gen, genpar.genParamNames.nd],
    nq = genpar.genParamValues[gen, genpar.genParamNames.nq]
  ) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Governors.GovSteam1 ieeeg1(
    Db1 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.Db1],
    Db2 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.Db2],
    Eps = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.Eps],
    K = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K],
    K1 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K1],
    K2 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K2],
    K3 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K3],
    K4 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K4],
    K5 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K5],
    K6 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K6],
    K7 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K7],
    K8 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K8],
    PMaxPu = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.PMax],
    PMinPu = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.PMin], PNomTurb = genpar.genParamValues[gen, genpar.genParamNames.PNom],
    PgvTableName = "Pgv",
    Pm0Pu = generatorSynchronous.Pm0Pu,
    PmRef0Pu(fixed = false),
    SNom = genpar.genParamValues[gen, genpar.genParamNames.SNom],
    Sdb1 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.Sdb1] > 0,
    Sdb2 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.Sdb2] > 0, TablesFile = "../dynawo/dynawo/nrt/data/SMIB/Standard/Gain_power.txt",
    Uc = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.Uc],
    Uo = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.Uo],
    ValveOn = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.ValveOn] > 0,
    t1 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.T1],
    t2 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.T2],
    t3 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.T3],
    t4 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.T4],
    t5 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.T5],
    t6 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.T6],
    t7 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.T7]
  ) annotation(
    Placement(visible = true, transformation(origin = {64.4, 0.666667}, extent = {{24.4, -20.3333}, {-24.4, 20.3333}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.SCRX avr(
    Efd0Pu = generatorSynchronous.Efd0Pu,
    IRotor0Pu = generatorSynchronous.IRotor0Pu,
    UStator0Pu = generatorSynchronous.UStator0Pu,
    EMaxPu = scrxpar.exciterParams[scrxPreset, scrxpar.exciterParamNames.EMaxPu],
    EMinPu = scrxpar.exciterParams[scrxPreset, scrxpar.exciterParamNames.EMinPu],
    K = scrxpar.exciterParams[scrxPreset, scrxpar.exciterParamNames.K],
    Ta = scrxpar.exciterParams[scrxPreset, scrxpar.exciterParamNames.Ta],
    Tb = scrxpar.exciterParams[scrxPreset, scrxpar.exciterParamNames.Tb],
    Te = scrxpar.exciterParams[scrxPreset, scrxpar.exciterParamNames.Te],
    URef0Pu = generatorSynchronous.UStator0Pu + generatorSynchronous.Efd0Pu / U0Pu / avr.K, Ut0Pu = U0Pu
  ) annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.PssIEEE2B pssIEEE2B(
    Ks1 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.Ks1],
    Ks2 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.Ks2],
    Ks3 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.Ks3],
    PGen0Pu = -P0Pu,
    SNom = generatorSynchronous.SNom,
    Vsi1MaxPu = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.VSI1Max],
    Vsi1MinPu = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.VSI1Min],
    Vsi2MaxPu = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.VSI2Max],
    Vsi2MinPu = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.VSI2Min],
    VstMaxPu = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.VSTMax],
    VstMinPu = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.VSTMin],
    t1 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T1],
    t10 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T10],
    t11 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T11],
    t2 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T2],
    t3 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T3],
    t4 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T4],
    t6 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T6],
    t7 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T7],
    t8 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T8],
    t9 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T9],
    tw1 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.Tw1],
    tw2 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.Tw2],
    tw3 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.Tw3],
    tw4 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.Tw4]
  ) annotation(
    Placement(visible = true, transformation(origin = {-60, -60}, extent = {{20, 20}, {-20, -20}}, rotation = 0)));
  Controls.OEL.MAXEX2 maxex2(
    Xfd0Pu = generatorSynchronous.IRotor0Pu,
    XfdRatedPu = genpar.genParamValues[gen, genpar.genParamNames.ifdRatedPu],
    Kmx = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.Kmx],
    ULowPu = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.ULowPu],
    T1 = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.T1],
    T2 = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.T2],
    T3 = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.T3],
    E1 = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.E1],
    E2 = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.E2],
    E3 = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.E3]
  ) annotation(
    Placement(visible = true, transformation(origin = {-130, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant UuelConst(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPuConst(k = ieeeg1.PmRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {114, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmPuConst(k = generatorSynchronous.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {45, 65}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {29, 25}, extent = {{5, 5}, {-5, -5}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-29, 7}, extent = {{-5, 5}, {5, -5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = generatorSynchronous.Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {-47, 47}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Add dOmegaPu(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-16, -72}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  switch.u2 = AvrInService;
  switch1.u2 = GovInService;
  avr.URefPu = generatorSynchronous.UStator0Pu + generatorSynchronous.Efd0Pu / U0Pu / avr.K;
  connect(generatorSynchronous.PGenPu_out, pssIEEE2B.PGenPu) annotation(
    Line(points = {{-10, -18}, {-10, -48}, {-36, -48}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UPu_out, avr.UtPu) annotation(
    Line(points = {{-18, 14}, {-30, 14}, {-30, 34}, {-44, 34}, {-44, 24}}, color = {0, 0, 127}));
  connect(generatorSynchronous.terminal, terminal) annotation(
    Line(points = {{0, 0}, {0, 100}}, color = {0, 0, 255}));
  connect(UuelConst.y, avr.UuelPu) annotation(
    Line(points = {{-118, 50}, {-76, 50}, {-76, 24}}, color = {0, 0, 127}));
  connect(pssIEEE2B.UPssPu, avr.UPssPu) annotation(
    Line(points = {{-82, -60}, {-100, -60}, {-100, -12}, {-84, -12}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UStatorPu_out, avr.UStatorPu) annotation(
    Line(points = {{-6, 18}, {-6, 54}, {-40, 54}, {-40, 124}, {-168, 124}, {-168, -16}, {-110, -16}, {-110, 0}, {-84, 0}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, ieeeg1.omegaPu) annotation(
    Line(points = {{0, -18}, {0, -72}, {132, -72}, {132, 1}, {89, 1}}, color = {0, 0, 127}));
  connect(generatorSynchronous.IRotorPu_out, avr.IRotorPu) annotation(
    Line(points = {{-18, -10}, {-24, -10}, {-24, -16}, {-36, -16}}, color = {0, 0, 127}));
  connect(generatorSynchronous.IRotorPu_out, maxex2.XfdPu) annotation(
    Line(points = {{-18, -10}, {-24, -10}, {-24, -32}, {-150, -32}, {-150, 90}, {-140, 90}}, color = {0, 0, 127}));
  connect(PmPuConst.y, switch1.u3) annotation(
    Line(points = {{39.5, 65}, {38, 65}, {38, 29}, {35, 29}}, color = {0, 0, 127}));
  connect(switch1.y, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{23.5, 25}, {22, 25}, {22, 0}, {16, 0}}, color = {0, 0, 127}));
  connect(maxex2.UoelPu, avr.UoelPu) annotation(
    Line(points = {{-120, 90}, {-64, 90}, {-64, 24}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaRefPu_out, dOmegaPu.u1) annotation(
    Line(points = {{10, -18}, {10, -66}, {-4, -66}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, dOmegaPu.u2) annotation(
    Line(points = {{0, -18}, {0, -78}, {-4, -78}}, color = {0, 0, 127}));
  connect(dOmegaPu.y, pssIEEE2B.omegaPu) annotation(
    Line(points = {{-26, -72}, {-36, -72}}, color = {0, 0, 127}));
  connect(PmRefPuConst.y, ieeeg1.PmRefPu) annotation(
    Line(points = {{104, 40}, {64, 40}, {64, 21}}, color = {0, 0, 127}));
  connect(ieeeg1.Pm1Pu, switch1.u1) annotation(
    Line(points = {{39, 9}, {35, 9}, {35, 21}}, color = {0, 0, 127}));
  connect(avr.EfdPu, switch.u1) annotation(
    Line(points = {{-38, 0}, {-36, 0}, {-36, 3}, {-35, 3}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u3) annotation(
    Line(points = {{-42, 48}, {-36, 48}, {-36, 11}, {-35, 11}}, color = {0, 0, 127}));
  connect(switch.y, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{-23.5, 7}, {-22, 7}, {-22, 0}, {-16, 0}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Line(points = {{-35.9986, -20}, {-34.0014, -5.4116}, {-30.0014, 9.5884}, {-23.0014, 22.0884}, {-16.0014, 26.5884}, {-6.00142, 21.5884}, {-1, 8.4116}, {0, 0}, {1, -8.4116}, {6.00142, -21.5884}, {16.0014, -26.5884}, {23.0014, -22.0884}, {30.0014, -9.5884}, {34.0014, 5.4116}, {35.9986, 20}}), Line(origin = {-110, 55}, points = {{42, -15}}), Ellipse(origin = {0, -1}, extent = {{-60, 61}, {60, -59}}), Text(origin = {0, 80}, lineColor = {0, 0, 255}, extent = {{-80, 10}, {80, -10}}, textString = "%name"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end SteamSCRXFrame;
