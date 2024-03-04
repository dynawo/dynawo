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

model HydroFrame "Model of a hydraulic generator with a governor, a voltage regulator and an overexcitation limitation, for the RVS test system"
  import Dynawo.Examples.RVS.Components.GeneratorWithControl.BaseClasses.ParametersGenerators;
  import Dynawo.Examples.RVS.Components.GeneratorWithControl.BaseClasses.ParametersHYGOV;
  import Dynawo.Examples.RVS.Components.GeneratorWithControl.BaseClasses.ParametersOEL;
  import Dynawo.Examples.RVS.Components.GeneratorWithControl.BaseClasses.ParametersSCRX;

  parameter ParametersGenerators.genFramePreset gen = ParametersGenerators.genFramePreset.g10122;
  parameter ParametersHYGOV.genFramePreset hygovPreset = ParametersHYGOV.genFramePreset.g10122;
  parameter ParametersOEL.oelFramePreset oelPreset = ParametersOEL.oelFramePreset.all;
  parameter ParametersSCRX.genFramePreset scrxPreset = ParametersSCRX.genFramePreset.g10122;

  parameter Boolean AvrInService = true;
  parameter Boolean GovInService = false;
  parameter Types.VoltageModule UNom = 18;

  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Hydraulic.HYGOV1 hygov(
    At = ParametersHYGOV.exciterParams[hygovPreset, ParametersHYGOV.exciterParamNames.At],
    DTurb = ParametersHYGOV.exciterParams[hygovPreset, ParametersHYGOV.exciterParamNames.DTurb],
    FlowNoLoad = ParametersHYGOV.exciterParams[hygovPreset, ParametersHYGOV.exciterParamNames.FlowNoLoad],
    KDroopPerm = ParametersHYGOV.exciterParams[hygovPreset, ParametersHYGOV.exciterParamNames.KDroopPerm],
    KDroopTemp = ParametersHYGOV.exciterParams[hygovPreset, ParametersHYGOV.exciterParamNames.KDroopTemp],
    OpeningGateMax = ParametersHYGOV.exciterParams[hygovPreset, ParametersHYGOV.exciterParamNames.OpeningGateMax],
    OpeningGateMin = ParametersHYGOV.exciterParams[hygovPreset, ParametersHYGOV.exciterParamNames.OpeningGateMin],
    Pm0Pu = generatorSynchronous.Pm0Pu,
    PNomTurb = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.PNom],
    SNom = ParametersGenerators.genParamValues[gen, ParametersGenerators.genParamNames.SNom],
    tF = ParametersHYGOV.exciterParams[hygovPreset, ParametersHYGOV.exciterParamNames.tF],
    tG = ParametersHYGOV.exciterParams[hygovPreset, ParametersHYGOV.exciterParamNames.tG],
    tR = ParametersHYGOV.exciterParams[hygovPreset, ParametersHYGOV.exciterParamNames.tR],
    tW = ParametersHYGOV.exciterParams[hygovPreset, ParametersHYGOV.exciterParamNames.tW],
    VelMax = ParametersHYGOV.exciterParams[hygovPreset, ParametersHYGOV.exciterParamNames.VelMax]) annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.SCRX scrx(
    Efd0Pu = generatorSynchronous.Efd0Pu,
    IRotor0Pu = generatorSynchronous.IRotor0Pu,
    K = ParametersSCRX.exciterParams[scrxPreset, ParametersSCRX.exciterParamNames.K],
    tA = ParametersSCRX.exciterParams[scrxPreset, ParametersSCRX.exciterParamNames.tA],
    tB = ParametersSCRX.exciterParams[scrxPreset, ParametersSCRX.exciterParamNames.tB],
    tE = ParametersSCRX.exciterParams[scrxPreset, ParametersSCRX.exciterParamNames.tE],
    UStator0Pu(fixed = false),
    Ut0Pu = U0Pu,
    VrMaxPu = ParametersSCRX.exciterParams[scrxPreset, ParametersSCRX.exciterParamNames.VrMaxPu],
    VrMinPu = ParametersSCRX.exciterParams[scrxPreset, ParametersSCRX.exciterParamNames.VrMinPu]) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
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
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  //Target values
  Modelica.Blocks.Sources.Constant PmRefPu(k = hygov.PmRef0Pu) annotation(
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
  Modelica.Blocks.Sources.Constant URefPu(k = generatorSynchronous.UStator0Pu + generatorSynchronous.Efd0Pu / (U0Pu * scrx.K)) annotation(
    Placement(visible = true, transformation(origin = {-174, 0}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-174, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

  //Initial parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at generator terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at generator terminal in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at generator terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Initial voltage angle at generator terminal in rad";

initial algorithm
  scrx.UStator0Pu := generatorSynchronous.UStator0Pu;

equation
  connect(PmRefPu.y, hygov.PmRefPu) annotation(
    Line(points = {{179, 20}, {160, 20}, {160, 12}, {144, 12}}, color = {0, 0, 127}));
  connect(maxex2.UOelPu, scrx.UOelPu) annotation(
    Line(points = {{-121, -60}, {-190, -60}, {-190, 40}, {-150, 40}, {-150, 16}, {-144, 16}}, color = {0, 0, 127}));
  connect(constant2.y, switch1.u3) annotation(
    Line(points = {{79, 80}, {60, 80}, {60, 45}, {53, 45}}, color = {0, 0, 127}));
  connect(generatorSynchronous.IRotorPu_out, maxex2.IfdPu) annotation(
    Line(points = {{-18, -10}, {-40, -10}, {-40, -60}, {-98, -60}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UPu_out, scrx.UtPu) annotation(
    Line(points = {{-18, 14}, {-96, 14}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(generatorSynchronous.IRotorPu_out, scrx.IRotorPu) annotation(
    Line(points = {{-18, -10}, {-40, -10}, {-40, -16}, {-96, -16}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaRefPu_out, hygov.omegaRefPu) annotation(
    Line(points = {{10, -18}, {10, -60}, {160, -60}, {160, -12}, {144, -12}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, hygov.omegaPu) annotation(
    Line(points = {{0, -18}, {0, -80}, {180, -80}, {180, 0}, {144, 0}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UStatorPu_out, scrx.UStatorPu) annotation(
    Line(points = {{-6, 18}, {-6, 60}, {-200, 60}, {-200, -20}, {-150, -20}, {-150, -8}, {-144, -8}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(generatorSynchronous.terminal, terminal) annotation(
    Line(points = {{0, 0}, {0, 100}}, color = {0, 0, 255}));
  connect(switch1.y, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{39, 40}, {30, 40}, {30, 0}, {16, 0}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u3) annotation(
    Line(points = {{-79, 80}, {-70, 80}, {-70, 45}, {-61, 45}}, color = {0, 0, 127}));
  connect(scrx.EfdPu, switch.u1) annotation(
    Line(points = {{-98, 0}, {-70, 0}, {-70, 35}, {-61, 35}}, color = {0, 0, 127}));
  connect(switch.y, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{-47, 40}, {-40, 40}, {-40, 0}, {-16, 0}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch.u2) annotation(
    Line(points = {{-79.4, 40}, {-61.4, 40}}, color = {255, 0, 255}));
  connect(booleanConstant1.y, switch1.u2) annotation(
    Line(points = {{79.4, 40}, {53.4, 40}}, color = {255, 0, 255}));
  connect(hygov.PmPu, switch1.u1) annotation(
    Line(points = {{98, 0}, {60, 0}, {60, 35}, {54, 35}}, color = {0, 0, 127}));
  connect(URefPu.y, scrx.URefPu) annotation(
    Line(points = {{-167, 0}, {-144, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(const.y, scrx.UUelPu) annotation(
    Line(points = {{-168, 20}, {-160, 20}, {-160, 8}, {-144, 8}}, color = {0, 0, 127}));
  connect(const.y, scrx.UPssPu) annotation(
    Line(points = {{-168, 20}, {-160, 20}, {-160, -16}, {-144, -16}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Icon(graphics = {Line(points = {{-35.9986, -20}, {-34.0014, -5.4116}, {-30.0014, 9.5884}, {-23.0014, 22.0884}, {-16.0014, 26.5884}, {-6.00142, 21.5884}, {-1, 8.4116}, {0, 0}, {1, -8.4116}, {6.00142, -21.5884}, {16.0014, -26.5884}, {23.0014, -22.0884}, {30.0014, -9.5884}, {34.0014, 5.4116}, {35.9986, 20}}), Line(origin = {-110, 55}, points = {{42, -15}}), Ellipse(extent = {{-60, 60}, {60, -60}}, endAngle = 360), Text(origin = {0, 80}, lineColor = {0, 0, 255}, extent = {{-80, 10}, {80, -10}}, textString = "%name"), Rectangle(extent = {{-100, 100}, {100, -100}})}),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end HydroFrame;
