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

model SteamIEEET1Frame "Model of a steam generator with a governor, a voltage regulator, a power system stabilizer and an overexcitation limiter, for the RVS test system"
  import Dynawo.Examples.RVS.Components.GeneratorWithControl.BaseClasses.ParametersGenerators;
  import Dynawo.Examples.RVS.Components.GeneratorWithControl.BaseClasses.ParametersIEEEG1;
  import Dynawo.Examples.RVS.Components.GeneratorWithControl.BaseClasses.ParametersIEEET1;
  import Dynawo.Examples.RVS.Components.GeneratorWithControl.BaseClasses.ParametersOEL;
  import Dynawo.Examples.RVS.Components.GeneratorWithControl.BaseClasses.ParametersPSS2B;

  parameter ParametersGenerators.genFramePreset gen = ParametersGenerators.genFramePreset.g10118;
  parameter ParametersIEEEG1.genFramePreset ieeeg1Preset = ParametersIEEEG1.genFramePreset.g10118;
  parameter ParametersIEEET1.genFramePreset ieeet1Preset = ParametersIEEET1.genFramePreset.g10118;
  parameter ParametersOEL.oelFramePreset oelPreset = ParametersOEL.oelFramePreset.all;
  parameter ParametersPSS2B.genFramePreset pss2bPreset = ParametersPSS2B.genFramePreset.g10118;

  parameter Boolean AvrInService = true;
  parameter Boolean GovInService = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.hasGov] > 0;
  parameter Types.VoltageModule UNom = 18;

  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator
  Dynawo.Examples.BaseClasses.GeneratorSynchronousThreeWindingsInterfaces generatorSynchronous(
    DPu = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.DPu],
    ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad,
    H = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.H],
    P0Pu = P0Pu,
    PNomAlt = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.PNom],
    PNomTurb = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.PNom],
    Q0Pu = Q0Pu,
    RTfPu = 0,
    RaPu = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.RaPu],
    SNom = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.SNom],
    SnTfo = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.SNom],
    Tpd0 = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.Tpd0],
    Tppd0 = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.Tppd0],
    Tppq0 = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.Tppq0],
    Tpq0 = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.Tpq0],
    U0Pu = U0Pu,
    UBaseHV = UNom,
    UBaseLV = UNom,
    UNom = UNom,
    UNomHV = UNom,
    UNomLV = UNom,
    UPhase0 = UPhase0,
    XTfPu = 0,
    XdPu = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.XdPu],
    XlPu = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.XlPu],
    XpdPu = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.XpdPu],
    XppdPu = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.XppdPu],
    XppqPu = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.XppqPu],
    XpqPu = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.XpqPu],
    XqPu = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.XqPu],
    md = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.md],
    mq = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.mq],
    nd = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.nd],
    nq = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.nq]) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Controls
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.IEEEG11 ieeeg1(
    DerPMaxPu = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.DerPMaxPu],
    DerPMinPu = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.DerPMinPu],
    K = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.K],
    K1 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.K1],
    K2 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.K2],
    K3 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.K3],
    K4 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.K4],
    K5 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.K5],
    K6 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.K6],
    K7 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.K7],
    K8 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.K8],
    Pm0Pu = generatorSynchronous.Pm0Pu,
    PMaxPu = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.PMaxPu],
    PMinPu = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.PMinPu],
    PNomTurb = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.PNom],
    SNom = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.SNom],
    t1 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.t1],
    t2 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.t2],
    t3 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.t3],
    t4 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.t4],
    t5 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.t5],
    t6 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.t6],
    t7 = ParametersIEEEG1.exciterParams[ieeeg1Preset, ParametersIEEEG1.exciterParamNames.t7]) annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.IEEET1 ieeet1(
    Efd0Pu = generatorSynchronous.Efd0Pu,
    EfdHighPu = ParametersIEEET1.exciterParams[ieeet1Preset, ParametersIEEET1.exciterParamNames.EfdHighPu],
    EfdLowPu = ParametersIEEET1.exciterParams[ieeet1Preset, ParametersIEEET1.exciterParamNames.EfdLowPu],
    EfdRawMaxPu = ParametersIEEET1.exciterParams[ieeet1Preset, ParametersIEEET1.exciterParamNames.EfdRawMaxPu],
    EfdRawMinPu = ParametersIEEET1.exciterParams[ieeet1Preset, ParametersIEEET1.exciterParamNames.EfdRawMinPu],
    EfdSatHighPu = ParametersIEEET1.exciterParams[ieeet1Preset, ParametersIEEET1.exciterParamNames.EfdSatHighPu],
    EfdSatLowPu = ParametersIEEET1.exciterParams[ieeet1Preset, ParametersIEEET1.exciterParamNames.EfdSatLowPu],
    Ka = ParametersIEEET1.exciterParams[ieeet1Preset, ParametersIEEET1.exciterParamNames.Ka],
    Ke = ParametersIEEET1.exciterParams[ieeet1Preset, ParametersIEEET1.exciterParamNames.Ke],
    Kf = ParametersIEEET1.exciterParams[ieeet1Preset, ParametersIEEET1.exciterParamNames.Kf],
    tA = ParametersIEEET1.exciterParams[ieeet1Preset, ParametersIEEET1.exciterParamNames.tA],
    tE = ParametersIEEET1.exciterParams[ieeet1Preset, ParametersIEEET1.exciterParamNames.tE],
    tF = ParametersIEEET1.exciterParams[ieeet1Preset, ParametersIEEET1.exciterParamNames.tF],
    tR = ParametersIEEET1.exciterParams[ieeet1Preset, ParametersIEEET1.exciterParamNames.tR],
    Us0Pu = generatorSynchronous.UStator0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.PssIEEE2B pssIEEE2B(
    KOmega = -1,
    KOmegaRef = 1,
    Ks1 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.Ks1],
    Ks2 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.Ks2],
    Ks3 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.Ks3],
    PGen0Pu = -P0Pu,
    SNom = generatorSynchronous.SNom,
    t1 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.t1],
    t2 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.t2],
    t3 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.t3],
    t4 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.t4],
    t6 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.t6],
    t7 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.t7],
    t8 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.t8],
    t9 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.t9],
    t10 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.t10],
    t11 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.t11],
    tw1 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.tw1],
    tw2 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.tw2],
    tw3 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.tw3],
    tw4 = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.tw4],
    Vsi1MaxPu = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.Vsi1MaxPu],
    Vsi1MinPu = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.Vsi1MinPu],
    Vsi2MaxPu = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.Vsi2MaxPu],
    Vsi2MinPu = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.Vsi2MinPu],
    VstMaxPu = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.VstMaxPu],
    VstMinPu = ParametersPSS2B.exciterParams[pss2bPreset, ParametersPSS2B.exciterParamNames.VstMinPu]) annotation(
    Placement(visible = true, transformation(origin = {-60, -60}, extent = {{20, 20}, {-20, -20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.MAXEX2 maxex2(
    Ifd0Pu = generatorSynchronous.IRotor0Pu,
    Ifd1Pu = ParametersOEL.oelParamValues[oelPreset, ParametersOEL.oelParamNames.Ifd1Pu],
    Ifd2Pu = ParametersOEL.oelParamValues[oelPreset, ParametersOEL.oelParamNames.Ifd2Pu],
    Ifd3Pu = ParametersOEL.oelParamValues[oelPreset, ParametersOEL.oelParamNames.Ifd3Pu],
    IfdRated = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.ifdRatedPu],
    Kmx = ParametersOEL.oelParamValues[oelPreset, ParametersOEL.oelParamNames.Kmx],
    t1 = ParametersOEL.oelParamValues[oelPreset, ParametersOEL.oelParamNames.t1],
    t2 = ParametersOEL.oelParamValues[oelPreset, ParametersOEL.oelParamNames.t2],
    t3 = ParametersOEL.oelParamValues[oelPreset, ParametersOEL.oelParamNames.t3],
    ULowPu = ParametersOEL.oelParamValues[oelPreset, ParametersOEL.oelParamNames.ULowPu]) annotation(
    Placement(visible = true, transformation(origin = {-130, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  //Target values
  Modelica.Blocks.Sources.Constant PmRefPu(k = ieeeg1.PmRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {190, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-54, 40}, extent = {{-6, 6}, {6, -6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = generatorSynchronous.Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {-86, 80}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = generatorSynchronous.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {86, 80}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {46, 40}, extent = {{6, 6}, {-6, -6}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = AvrInService) annotation(
    Placement(visible = true, transformation(origin = {-86, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = GovInService) annotation(
    Placement(visible = true, transformation(origin = {86, 40}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = ieeet1.URef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-174, 0}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UUelPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-174, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

  //Initial parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at generator terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at generator terminal in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at generator terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Initial voltage angle at generator terminal in rad";

equation
  connect(generatorSynchronous.PGenPu_out, pssIEEE2B.PGenPu) annotation(
    Line(points = {{-10, -18}, {-10, -48}, {-36, -48}}, color = {0, 0, 127}));
  connect(generatorSynchronous.terminal, terminal) annotation(
    Line(points = {{0, 0}, {0, 100}}, color = {0, 0, 255}));
  connect(generatorSynchronous.IRotorPu_out, maxex2.IfdPu) annotation(
    Line(points = {{-18, -10}, {-30, -10}, {-30, 90}, {-118, 90}}, color = {0, 0, 127}));
  connect(constant2.y, switch1.u3) annotation(
    Line(points = {{79, 80}, {60, 80}, {60, 45}, {53, 45}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, pssIEEE2B.omegaPu) annotation(
    Line(points = {{0, -18}, {0, -72}, {-36, -72}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaRefPu_out, pssIEEE2B.omegaRefPu) annotation(
    Line(points = {{10, -18}, {10, -60}, {-36, -60}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(maxex2.UOelPu, ieeet1.UOelPu) annotation(
    Line(points = {{-141, 90}, {-150, 90}, {-150, 16}, {-144, 16}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u3) annotation(
    Line(points = {{-79, 80}, {-70, 80}, {-70, 45}, {-61, 45}}, color = {0, 0, 127}));
  connect(ieeet1.EfdPu, switch.u1) annotation(
    Line(points = {{-98, 0}, {-70, 0}, {-70, 35}, {-61, 35}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch.u2) annotation(
    Line(points = {{-79.4, 40}, {-61.4, 40}}, color = {255, 0, 255}));
  connect(booleanConstant1.y, switch1.u2) annotation(
    Line(points = {{79.4, 40}, {53.4, 40}}, color = {255, 0, 255}));
  connect(URefPu.y, ieeet1.URefPu) annotation(
    Line(points = {{-167, 0}, {-144, 0}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UStatorPu_out, ieeet1.UStatorPu) annotation(
    Line(points = {{-6, 18}, {-6, 60}, {-200, 60}, {-200, -20}, {-160, -20}, {-160, -8}, {-144, -8}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(pssIEEE2B.UPssPu, ieeet1.UPssPu) annotation(
    Line(points = {{-82, -60}, {-150, -60}, {-150, -16}, {-144, -16}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, ieeeg1.omegaPu) annotation(
    Line(points = {{0, -18}, {0, -80}, {160, -80}, {160, -8}, {144, -8}}, color = {0, 0, 127}));
  connect(PmRefPu.y, ieeeg1.PmRefPu) annotation(
    Line(points = {{180, 20}, {160, 20}, {160, 8}, {144, 8}}, color = {0, 0, 127}));
  connect(switch.y, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{-48, 40}, {-40, 40}, {-40, 0}, {-16, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(ieeeg1.Pm1Pu, switch1.u1) annotation(
    Line(points = {{98, 8}, {60, 8}, {60, 35}, {54, 35}}, color = {0, 0, 127}));
  connect(switch1.y, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{39, 40}, {30, 40}, {30, 0}, {16, 0}}, color = {0, 0, 127}));
  connect(UUelPu.y, ieeet1.UUelPu) annotation(
    Line(points = {{-167, 20}, {-160, 20}, {-160, 8}, {-144, 8}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Icon(graphics = {Line(points = {{-35.9986, -20}, {-34.0014, -5.4116}, {-30.0014, 9.5884}, {-23.0014, 22.0884}, {-16.0014, 26.5884}, {-6.00142, 21.5884}, {-1, 8.4116}, {0, 0}, {1, -8.4116}, {6.00142, -21.5884}, {16.0014, -26.5884}, {23.0014, -22.0884}, {30.0014, -9.5884}, {34.0014, 5.4116}, {35.9986, 20}}), Line(origin = {-110, 55}, points = {{42, -15}}), Ellipse(extent = {{-60, 60}, {60, -60}}, endAngle = 360), Text(origin = {0, 80}, lineColor = {0, 0, 255}, extent = {{-80, 10}, {80, -10}}, textString = "%name"), Rectangle(extent = {{-100, 100}, {100, -100}})}),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end SteamIEEET1Frame;
