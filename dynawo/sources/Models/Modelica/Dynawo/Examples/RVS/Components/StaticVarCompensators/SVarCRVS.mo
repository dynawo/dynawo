within Dynawo.Examples.RVS.Components.StaticVarCompensators;

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

model SVarCRVS
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Examples.RVS.Components.StaticVarCompensators.BaseClasses.ParametersSVC;

  parameter Boolean ControlInService = true;
  parameter Types.PerUnit K;
  parameter Types.ApparentPowerModule SBase = 1 "Base apparent power in MVA";
  parameter Dynawo.Examples.RVS.Components.StaticVarCompensators.BaseClasses.ParametersSVC.svcFramePreset svcPreset;

  //Terminal
  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variable
  Modelica.Blocks.Interfaces.RealInput URefPu(start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {120, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));

  Dynawo.Electrical.StaticVarCompensators.SVarCPV_INIT sVarCPV_INIT(P0Pu = 0, Q0Pu = Q0Pu, U0Pu = U0Pu, UPhase0 = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.StaticVarCompensators.BaseClasses.SVarCVPropInterface sVarCVPropInterface(
    B0Pu(fixed = false),
    BShuntPu = ParametersSVC.svcParamValues[svcPreset, ParametersSVC.svcParamNames.BShuntPu],
    i0Pu(re(fixed = false), im(fixed = false)),
    u0Pu(re(fixed = false), im(fixed = false)),
    U0Pu = U0Pu,
    UNom = ParametersSVC.svcParamValues[svcPreset, ParametersSVC.svcParamNames.UNom]) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.StaticVarCompensators.Controls.CSSCST csscst(
    BMax = ParametersSVC.svcParamValues[svcPreset, ParametersSVC.svcParamNames.BMax],
    BMin = ParametersSVC.svcParamValues[svcPreset, ParametersSVC.svcParamNames.BMin],
    BVar0Pu(fixed = false),
    K = K,
    SBase = SBase,
    t3 = ParametersSVC.svcParamValues[svcPreset, ParametersSVC.svcParamNames.t3],
    t5 = ParametersSVC.svcParamValues[svcPreset, ParametersSVC.svcParamNames.t5],
    U0Pu = U0Pu,
    UOvPu = ParametersSVC.svcParamValues[svcPreset, ParametersSVC.svcParamNames.UOvPu],
    VMax = ParametersSVC.svcParamValues[svcPreset, ParametersSVC.svcParamNames.VMax],
    VMin = ParametersSVC.svcParamValues[svcPreset, ParametersSVC.svcParamNames.VMin]) annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant otherSignalsConst(k = 0) annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant BRefPuConst(k = csscst.BRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = sVarCVPropInterface.B0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = ControlInService) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal in rad";

initial algorithm
  sVarCVPropInterface.B0Pu := sVarCPV_INIT.B0Pu;
  sVarCVPropInterface.u0Pu.re := sVarCPV_INIT.u0Pu.re;
  sVarCVPropInterface.u0Pu.im := sVarCPV_INIT.u0Pu.im;
  sVarCVPropInterface.i0Pu.re := sVarCPV_INIT.i0Pu.re;
  sVarCVPropInterface.i0Pu.im := sVarCPV_INIT.i0Pu.im;
  csscst.BVar0Pu := sVarCPV_INIT.B0Pu;

equation
  connect(terminal, sVarCVPropInterface.terminal) annotation(
    Line(points = {{0, 100}, {0, 0}}));
  connect(sVarCVPropInterface.UPu_out, csscst.UPu) annotation(
    Line(points = {{22, 0}, {40, 0}, {40, -45}, {24, -45}}, color = {0, 0, 127}));
  connect(otherSignalsConst.y, csscst.UOtherPu) annotation(
    Line(points = {{79, -80}, {60, -80}, {60, -75}, {24, -75}}, color = {0, 0, 127}));
  connect(BRefPuConst.y, csscst.BRefPu) annotation(
    Line(points = {{79, -40}, {60, -40}, {60, -65}, {24, -65}}, color = {0, 0, 127}));
  connect(URefPu, csscst.URefPu) annotation(
    Line(points = {{140, 0}, {50, 0}, {50, -55}, {24, -55}}, color = {0, 0, 127}));
  connect(csscst.BVarPu, switch.u1) annotation(
    Line(points = {{-22, -60}, {-80, -60}, {-80, -8}, {-62, -8}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u3) annotation(
    Line(points = {{-99, 40}, {-80, 40}, {-80, 8}, {-62, 8}}, color = {0, 0, 127}));
  connect(switch.y, sVarCVPropInterface.BVarPu_in) annotation(
    Line(points = {{-39, 0}, {-24, 0}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch.u2) annotation(
    Line(points = {{-98, 0}, {-62, 0}}, color = {255, 0, 255}));

  annotation(preferredView = "diagram",
    Icon(graphics = {Rectangle(origin = {-20, -18}, fillPattern = FillPattern.Solid, extent = {{-20, 2}, {60, -2}}), Line(origin = {49.6216, 39.4941}, points = {{0, -10}, {0, 10}}, thickness = 1), Line(origin = {-0.0916367, -80.3386}, points = {{-40, 0}, {40, 0}}), Line(origin = {0, -21}, points = {{0, 81}, {0, -59}}), Line(origin = {39.2032, 49.0758}, points = {{-10, 0}, {10, 0}}, thickness = 1), Text(origin = {-1, -120}, lineColor = {0, 0, 255}, extent = {{-81, 10}, {81, -10}}, textString = "%name"), Line(origin = {-2.83665, -2.96415}, points = {{-44, -44}, {52, 52}}, thickness = 1), Rectangle(origin = {0, 18}, fillPattern = FillPattern.Solid, extent = {{-40, 2}, {40, -2}})}),
    Diagram(coordinateSystem(extent = {{-120, -100}, {120, 100}})));
end SVarCRVS;
