within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.DCVoltageControl;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BaseDCVoltageControl "Base DC Voltage Control for the HVDC VSC model"
  import Modelica;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.HVDC;
  import Dynawo.NonElectrical.Blocks;
  import Dynawo.Types;

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_BaseDCVoltageControl;

  parameter Types.PerUnit IpMaxCstPu "Maximum value of the active current in pu (base SNom, UNom)";
  parameter Types.PerUnit RdcPu "DC line resistance in pu (base UdcNom, SnRef)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  Modelica.Blocks.Interfaces.RealInput UdcRefPu(start = UdcRef0Pu) "Reference DC voltage in pu (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-189, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 17}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcPu(start = Udc0Pu) "DC voltage in pu (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -43}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "AC voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IpMaxPu(start = IpMaxCstPu) "Max active current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-189, 110}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput IpMinPu(start = - IpMaxCstPu) "Min active current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -110}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput ipRefUdcPu(start = Ip0Pu) "Active current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {170, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = UdcRefMaxPu, uMin = UdcRefMinPu) annotation(
    Placement(visible = true, transformation(origin = {40, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {70, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {130, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.PIAntiWindupVariableLimits PI(Ki = Kidc, Kp = Kpdc, integrator(y_start = -Ip0Pu)) annotation(
    Placement(visible = true, transformation(origin = {100, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division iDCCalc annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product pCalc annotation(
    Placement(visible = true, transformation(origin = {-140, 6}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {10, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = 0, uMin = -0.15) annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain convention(k = -1) annotation(
    Placement(visible = true, transformation(origin = {-110, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain deltaVDCCalc(k = RdcPu * SNom / SystemBase.SnRef) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 1e-4, y_start = Ip0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu Udc0Pu "Start value of dc voltage in pu (base UdcNom)";
  parameter Types.VoltageModulePu UdcRef0Pu "Start value of dc voltage reference in pu (base UdcNom)";
  parameter Types.VoltageModulePu U0Pu "Start value of ac voltage in pu (base UNom)";
  parameter Types.PerUnit Ip0Pu "Start value of active current in pu (base SNom)";

equation
  connect(limiter.y, feedback.u1) annotation(
    Line(points = {{51, -6}, {62, -6}}, color = {0, 0, 127}));
  connect(gain1.y, ipRefUdcPu) annotation(
    Line(points = {{141, -6}, {170, -6}}, color = {0, 0, 127}));
  connect(feedback.y, PI.u) annotation(
    Line(points = {{79, -6}, {88, -6}}, color = {0, 0, 127}));
  connect(PI.y, gain1.u) annotation(
    Line(points = {{111, -6}, {118, -6}}, color = {0, 0, 127}));
  connect(UdcPu, feedback.u2) annotation(
    Line(points = {{-190, -80}, {70, -80}, {70, -14}}, color = {0, 0, 127}));
  connect(convention.u, pCalc.y) annotation(
    Line(points = {{-122, 6}, {-129, 6}}, color = {0, 0, 127}));
  connect(convention.y, iDCCalc.u1) annotation(
    Line(points = {{-99, 6}, {-92, 6}}, color = {0, 0, 127}));
  connect(UdcRefPu, add.u2) annotation(
    Line(points = {{-189, -50}, {-10, -50}, {-10, -12}, {-2, -12}}, color = {0, 0, 127}));
  connect(limiter1.y, add.u1) annotation(
    Line(points = {{-9, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(limiter.u, add.y) annotation(
    Line(points = {{28, -6}, {21, -6}}, color = {0, 0, 127}));
  connect(UPu, pCalc.u1) annotation(
    Line(points = {{-190, 0}, {-152, 0}}, color = {0, 0, 127}));
  connect(iDCCalc.y, deltaVDCCalc.u) annotation(
    Line(points = {{-69, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(deltaVDCCalc.y, limiter1.u) annotation(
    Line(points = {{-39, 0}, {-32, 0}}, color = {0, 0, 127}));
  connect(UdcRefPu, iDCCalc.u2) annotation(
    Line(points = {{-189, -50}, {-100, -50}, {-100, -6}, {-92, -6}}, color = {0, 0, 127}));
  connect(gain1.y, firstOrder.u) annotation(
    Line(points = {{141, -6}, {150, -6}, {150, 50}, {-68, 50}}, color = {0, 0, 127}));
  connect(firstOrder.y, pCalc.u2) annotation(
    Line(points = {{-91, 50}, {-160, 50}, {-160, 12}, {-152, 12}}, color = {0, 0, 127}));
  connect(IpMaxPu, PI.limitMax) annotation(
    Line(points = {{-189, 110}, {80, 110}, {80, 0}, {88, 0}}, color = {0, 0, 127}));
  connect(IpMinPu, PI.limitMin) annotation(
    Line(points = {{-190, -110}, {80, -110}, {80, -12}, {88, -12}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-170, -130}, {160, 130}})),
    Icon(coordinateSystem(grid = {1, 1})));
end BaseDCVoltageControl;
