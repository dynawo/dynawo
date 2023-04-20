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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model HydroFrame
  import Modelica;
  import Dynawo;
  import Dynawo.Connectors;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;
  import hgpar = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersHYGOV;
  import pss2bpar = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B;
  import scrxpar = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX;
  import oelpar = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL;
  import genpar = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators;

  parameter hgpar.genFramePreset hygovPreset = hgpar.genFramePreset.g10122;
  parameter pss2bpar.genFramePreset pss2bPreset = pss2bpar.genFramePreset.g10122;
  parameter scrxpar.genFramePreset scrxPreset = scrxpar.genFramePreset.g10122;
  parameter oelpar.oelFramePreset oelPreset = oelpar.oelFramePreset.all;
  parameter genpar.genFramePreset gen = genpar.genFramePreset.g10122;
  parameter Types.VoltageModule UNom = 18;
  parameter Types.ActivePowerPu P0Pu;
  parameter Types.ReactivePowerPu Q0Pu;
  parameter Types.VoltageModulePu U0Pu;
  parameter Types.Angle UPhase0;
  parameter Boolean AvrInService = true;
  parameter Boolean GovInService = false;

  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Controllers & Governors
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Governors.HYGOV hygov(
    At = hgpar.exciterParams[hygovPreset, hgpar.exciterParamNames.At], 
    DTurb = hgpar.exciterParams[hygovPreset, hgpar.exciterParamNames.DTurb], 
    GMax = hgpar.exciterParams[hygovPreset, hgpar.exciterParamNames.GMax], 
    GMin = hgpar.exciterParams[hygovPreset, hgpar.exciterParamNames.GMin], 
    PNomTurb = genpar.genParamValues[gen, genpar.genParamNames.PNom], 
    Pm0Pu(fixed = false), 
    R = hgpar.exciterParams[hygovPreset, hgpar.exciterParamNames.R], 
    SNom = genpar.genParamValues[gen, genpar.genParamNames.SNom], 
    Tf = hgpar.exciterParams[hygovPreset, hgpar.exciterParamNames.Tf], 
    Tg = hgpar.exciterParams[hygovPreset, hgpar.exciterParamNames.Tg],
    Tr = hgpar.exciterParams[hygovPreset, hgpar.exciterParamNames.Tr], 
    Tw = hgpar.exciterParams[hygovPreset, hgpar.exciterParamNames.Tw], 
    Velm = hgpar.exciterParams[hygovPreset, hgpar.exciterParamNames.Velm], 
    omega0Pu = SystemBase.omega0Pu, 
    omegaRef0Pu = SystemBase.omegaRef0Pu, 
    qNL = hgpar.exciterParams[hygovPreset, hgpar.exciterParamNames.qNL], 
    r = hgpar.exciterParams[hygovPreset, hgpar.exciterParamNames.r]
  ) annotation(
    Placement(visible = true, transformation(origin = {64.4, 0.666667}, extent = {{24.4, -20.3333}, {-24.4, 20.3333}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.SCRX scrx(
    Efd0Pu(fixed = false), 
    IRotor0Pu(fixed = false), 
    UStator0Pu(fixed = false), 
    EMaxPu = scrxpar.exciterParams[scrxPreset, scrxpar.exciterParamNames.EMaxPu], 
    EMinPu = scrxpar.exciterParams[scrxPreset, scrxpar.exciterParamNames.EMinPu], 
    K = scrxpar.exciterParams[scrxPreset, scrxpar.exciterParamNames.K], 
    Ta = scrxpar.exciterParams[scrxPreset, scrxpar.exciterParamNames.Ta], 
    Tb = scrxpar.exciterParams[scrxPreset, scrxpar.exciterParamNames.Tb],
    Te = scrxpar.exciterParams[scrxPreset, scrxpar.exciterParamNames.Te], 
    URef0Pu = generatorSynchronous.UStator0Pu + generatorSynchronous.Efd0Pu / U0Pu / scrx.K, 
    Ut0Pu = U0Pu
  ) annotation(
    Placement(visible = true, transformation(origin = {-62, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
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

  // Misc
  Modelica.Blocks.Sources.Constant UuelConst(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPuConst(k(fixed = false)) annotation(
    Placement(visible = true, transformation(origin = {140, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-29, 7}, extent = {{-5, 5}, {5, -5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = generatorSynchronous.Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {-55, 65}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = generatorSynchronous.Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {71, 63}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {27, 19}, extent = {{5, 5}, {-5, -5}}, rotation = 0)));
  Util.GeneratorSynchronousThreeWindingsInterface generatorSynchronous(DPu = genpar.genParamValues[gen, genpar.genParamNames.DPu], ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad, H = genpar.genParamValues[gen, genpar.genParamNames.H], P0Pu = P0Pu, PNomAlt = genpar.genParamValues[gen, genpar.genParamNames.PNom], PNomTurb = genpar.genParamValues[gen, genpar.genParamNames.PNom], Q0Pu = Q0Pu, RTfPu = 0, RaPu = genpar.genParamValues[gen, genpar.genParamNames.RaPu], SNom = genpar.genParamValues[gen, genpar.genParamNames.SNom], SnTfo = genpar.genParamValues[gen, genpar.genParamNames.SNom], Tpd0 = genpar.genParamValues[gen, genpar.genParamNames.Tpd0], Tppd0 = genpar.genParamValues[gen, genpar.genParamNames.Tppd0], Tppq0 = genpar.genParamValues[gen, genpar.genParamNames.Tppq0], Tpq0 = genpar.genParamValues[gen, genpar.genParamNames.Tpq0], U0Pu = U0Pu, UBaseHV = UNom, UBaseLV = UNom, UNom = UNom, UNomHV = UNom, UNomLV = UNom, UPhase0 = UPhase0, XTfPu = 0, XdPu = genpar.genParamValues[gen, genpar.genParamNames.XdPu], XlPu = genpar.genParamValues[gen, genpar.genParamNames.XlPu], XpdPu = genpar.genParamValues[gen, genpar.genParamNames.XpdPu], XppdPu = genpar.genParamValues[gen, genpar.genParamNames.XppdPu], XppqPu = genpar.genParamValues[gen, genpar.genParamNames.XppqPu], XpqPu = genpar.genParamValues[gen, genpar.genParamNames.XpqPu], XqPu = genpar.genParamValues[gen, genpar.genParamNames.XqPu], md = genpar.genParamValues[gen, genpar.genParamNames.md], mq = genpar.genParamValues[gen, genpar.genParamNames.mq], nd = genpar.genParamValues[gen, genpar.genParamNames.nd], nq = genpar.genParamValues[gen, genpar.genParamNames.nq]) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

initial algorithm
  hygov.Pm0Pu := generatorSynchronous.Pm0Pu;
  scrx.Efd0Pu := generatorSynchronous.Efd0Pu;
  scrx.UStator0Pu := generatorSynchronous.UStator0Pu;
  scrx.IRotor0Pu := generatorSynchronous.IRotor0Pu;
  PmRefPuConst.k := hygov.PmRef0Pu;
  
equation
  switch.u2 = AvrInService;
  switch1.u2 = GovInService;
  scrx.URefPu = generatorSynchronous.UStator0Pu + generatorSynchronous.Efd0Pu / U0Pu / scrx.K;
  connect(UuelConst.y, scrx.UuelPu) annotation(
    Line(points = {{-118, 50}, {-78, 50}, {-78, 24}}, color = {0, 0, 127}));
  connect(PmRefPuConst.y, hygov.PmRefPu) annotation(
    Line(points = {{130, 20}, {114, 20}, {114, 9}, {92, 9}}, color = {0, 0, 127}));
  connect(UuelConst.y, scrx.UPssPu) annotation(
    Line(points = {{-118, 50}, {-100, 50}, {-100, -12}, {-86, -12}}, color = {0, 0, 127}));
  connect(maxex2.UoelPu, scrx.UoelPu) annotation(
    Line(points = {{-120, 90}, {-66, 90}, {-66, 24}}, color = {0, 0, 127}));
  connect(hygov.PmPu, switch1.u1) annotation(
    Line(points = {{39, 1}, {36, 1}, {36, 15}, {33, 15}}, color = {0, 0, 127}));
  connect(constant2.y, switch1.u3) annotation(
    Line(points = {{66, 64}, {36, 64}, {36, 23}, {33, 23}}, color = {0, 0, 127}));
  connect(generatorSynchronous.IRotorPu_out, maxex2.XfdPu) annotation(
    Line(points = {{-18, -10}, {-24, -10}, {-24, -30}, {-154, -30}, {-154, 90}, {-140, 90}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UPu_out, scrx.UtPu) annotation(
    Line(points = {{-18, 14}, {-30, 14}, {-30, 34}, {-46, 34}, {-46, 24}}, color = {0, 0, 127}));
  connect(generatorSynchronous.IRotorPu_out, scrx.IRotorPu) annotation(
    Line(points = {{-18, -10}, {-24, -10}, {-24, -16}, {-38, -16}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaRefPu_out, hygov.omegaRefPu) annotation(
    Line(points = {{10, -18}, {10, -48}, {102, -48}, {102, -7}, {92, -7}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, hygov.omegaPu) annotation(
    Line(points = {{0, -18}, {0, -72}, {114, -72}, {114, 1}, {92, 1}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UStatorPu_out, scrx.UStatorPu) annotation(
    Line(points = {{-6, 18}, {-6, 54}, {-40, 54}, {-40, 124}, {-168, 124}, {-168, -16}, {-110, -16}, {-110, 0}, {-86, 0}}, color = {0, 0, 127}));
  connect(generatorSynchronous.terminal, terminal) annotation(
    Line(points = {{0, 0}, {0, 100}}, color = {0, 0, 255}));
  connect(switch1.y, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{21.5, 19}, {20, 19}, {20, 0}, {16, 0}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u3) annotation(
    Line(points = {{-50, 66}, {-44, 66}, {-44, 42}, {-38, 42}, {-38, 11}, {-35, 11}}, color = {0, 0, 127}));
  connect(scrx.EfdPu, switch.u1) annotation(
    Line(points = {{-40, 0}, {-38, 0}, {-38, 3}, {-35, 3}}, color = {0, 0, 127}));
  connect(switch.y, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{-23.5, 7}, {-22, 7}, {-22, 0}, {-16, 0}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Line(points = {{-35.9986, -20}, {-34.0014, -5.4116}, {-30.0014, 9.5884}, {-23.0014, 22.0884}, {-16.0014, 26.5884}, {-6.00142, 21.5884}, {-1, 8.4116}, {0, 0}, {1, -8.4116}, {6.00142, -21.5884}, {16.0014, -26.5884}, {23.0014, -22.0884}, {30.0014, -9.5884}, {34.0014, 5.4116}, {35.9986, 20}}), Line(origin = {-110, 55}, points = {{42, -15}}), Ellipse(origin = {0, -1}, extent = {{-60, 61}, {60, -59}}), Text(origin = {0, 80}, lineColor = {0, 0, 255}, extent = {{-80, 10}, {80, -10}}, textString = "%name"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end HydroFrame;
