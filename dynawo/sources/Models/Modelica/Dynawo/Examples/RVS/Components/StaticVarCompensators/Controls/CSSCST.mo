within Dynawo.Examples.RVS.Components.StaticVarCompensators.Controls;

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

model CSSCST "Static var compensator control model with voltage override as susceptance command for switched shunts."
  import Modelica;
  import Modelica.Blocks;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Examples.RVS.Components.GeneratorWithControl;
  import Dynawo.Examples.RVS.Components.StaticVarCompensators;

  parameter Types.PerUnit K "Control gain constant. ";
  parameter Real BMin "Maximum capacitive range, negative, in MVAr";
  parameter Real BMax "Maximum reactive range, positive, in MVAr";
  parameter Real VMin "Phase margin lower limit";
  parameter Real VMax "Phase margin upper limit";
  parameter Real SBase = 1 "pu conversion base";
  parameter Types.Time T1 "Phase margin lead time constant in s";
  parameter Types.Time T2 "Phase margin lead time constant in s";
  parameter Types.Time T3 "Phase margin lag time constant in s";
  parameter Types.Time T4 "Phase margin lag time constant in s";
  parameter Types.Time T5 "Thyristor bridge time constant in s";
  parameter Types.PerUnit BRef0Pu = -BVar0Pu * 100 / K  "Susceptance reference in pu";
  parameter Types.PerUnit BVar0Pu "Initial value of susceptance command in pu (base SnRef)";
  parameter Types.VoltageModulePu UovPu "Overvoltage threshold (base UNom)";
  parameter Types.VoltageModulePu U0Pu = URef0Pu "Initial value of input terminal voltage in pu (base UNom)";
  parameter Types.VoltageModulePu URef0Pu "Initial value of input terminal voltage reference in pu (base UNom)";

  Blocks.Interfaces.RealOutput BVarPu(start = BVar0Pu) "Susceptance command in pu (base SnRef)" annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Input terminal voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -24}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Input terminal voltage reference in pu" annotation(
    Placement(visible = true, transformation(origin = {-160, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 26}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput BRefPu(start = BRef0Pu) "Input susceptance reference in pu" annotation(
    Placement(visible = true, transformation(origin = {-160, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 76}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput others(start = 0) "Input other signals" annotation(
    Placement(visible = true, transformation(origin = {-160, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -76}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Blocks.Math.Gain PuConversion(k = 1 / SBase) annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add UerrPu(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-110, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util.FirstOrderLimState thyristorBridge(T = T5, initType = Modelica.Blocks.Types.Init.InitialOutput, k = 1, yMax = BMax, yMin = BMin, y_start = BVar0Pu * 100) annotation(
    Placement(visible = true, transformation(origin = {80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.StaticVarCompensators.Controls.Util.VoltageOverride voltageOverride(BCommand0 = BVar0Pu * 100,BMax = BMax, BMin = BMin, Uerr0Pu = URef0Pu - U0Pu, UovPu = UovPu)  annotation(
    Placement(visible = true, transformation(origin = {50, -20}, extent = {{-15, -10}, {15, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = -1, k3 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-70, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = false, strict = false, uMax = VMax, uMin = VMin)  annotation(
    Placement(visible = true, transformation(origin = {50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.StaticVarCompensators.Util.LeadLagBlockPass leadLagBlockPass(Tb = T3, Tc = T1, initType = Modelica.Blocks.Types.Init.InitialState, x_start = BVar0Pu * 100, y_start = BVar0Pu * 100)  annotation(
    Placement(visible = true, transformation(origin = {-10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.StaticVarCompensators.Util.LeadLagBlockPass leadLagBlockPass1(Tb = T4, Tc = T2, initType = Modelica.Blocks.Types.Init.InitialState, x_start = BVar0Pu * 100, y_start = BVar0Pu * 100)  annotation(
    Placement(visible = true, transformation(origin = {20, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = K) annotation(
    Placement(visible = true, transformation(origin = {-40, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(PuConversion.y, BVarPu) annotation(
    Line(points = {{131, 0}, {149, 0}}, color = {0, 0, 127}));
  connect(URefPu, UerrPu.u1) annotation(
    Line(points = {{-160, 20}, {-132, 20}, {-132, 12}, {-122, 12}}, color = {0, 0, 127}));
  connect(UPu, UerrPu.u2) annotation(
    Line(points = {{-160, -20}, {-132, -20}, {-132, 0}, {-122, 0}}, color = {0, 0, 127}));
  connect(others, add3.u3) annotation(
    Line(points = {{-160, -60}, {-92, -60}, {-92, -2}, {-82, -2}}, color = {0, 0, 127}));
  connect(UerrPu.y, add3.u2) annotation(
    Line(points = {{-98, 6}, {-82, 6}}, color = {0, 0, 127}));
  connect(add3.y, gain.u) annotation(
    Line(points = {{-58, 6}, {-56, 6}, {-56, 50}, {-52, 50}}, color = {0, 0, 127}));
  connect(BRefPu, add3.u1) annotation(
    Line(points = {{-160, 60}, {-88, 60}, {-88, 14}, {-82, 14}}, color = {0, 0, 127}));
  connect(gain.y, leadLagBlockPass.u) annotation(
    Line(points = {{-28, 50}, {-22, 50}}, color = {0, 0, 127}));
  connect(leadLagBlockPass.y, leadLagBlockPass1.u) annotation(
    Line(points = {{2, 50}, {8, 50}}, color = {0, 0, 127}));
  connect(leadLagBlockPass1.y, limiter.u) annotation(
    Line(points = {{32, 50}, {38, 50}}, color = {0, 0, 127}));
  connect(limiter.y, thyristorBridge.u) annotation(
    Line(points = {{62, 50}, {68, 50}}, color = {0, 0, 127}));
  connect(thyristorBridge.y, voltageOverride.BCommand) annotation(
    Line(points = {{92, 50}, {98, 50}, {98, 6}, {14, 6}, {14, -16}, {34, -16}}, color = {0, 0, 127}));
  connect(UerrPu.y, voltageOverride.UerrPu) annotation(
    Line(points = {{-98, 6}, {-88, 6}, {-88, -24}, {34, -24}}, color = {0, 0, 127}));
  connect(voltageOverride.BVarRaw, PuConversion.u) annotation(
    Line(points = {{66, -20}, {90, -20}, {90, 0}, {108, 0}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})),
    Documentation(info = "<html><head></head><body>second order lead/lag block, phase margin, has been replaced by first order block, since all other time constants = 0.</body></html>"));
end CSSCST;
