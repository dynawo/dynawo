within Dynawo.Electrical.Controls.Machines.OverExcitationLimiters.Standard;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model Oel3c "IEEE (2016) overexcitation limiter type OEL3C model"

  //Regulation parameters
  parameter Types.CurrentModulePu ITfPu "OEL timed field current limiter pick up level";
  parameter Types.PerUnit K1 "Exponent for OEL error calculation";
  parameter Types.PerUnit KOel "OEL gain";
  parameter Types.PerUnit KpOel "OEL proportional gain";
  parameter Types.PerUnit KScale = ITfPu / Input0Pu "OEL input signal scaling factor";
  parameter Types.Time tF "OEL field current measurement time constant in s";
  parameter Types.Time tOel "OEL integral time constant in s";
  parameter Types.VoltageModulePu VOel1MaxPu "OEL integrator maximum output in pu (base UNom)";
  parameter Types.VoltageModulePu VOel1MinPu "OEL integrator minimum output in pu (base UNom)";
  parameter Types.VoltageModulePu VOel2MaxPu "OEL maximum output in pu (base UNom)";
  parameter Types.VoltageModulePu VOel2MinPu "OEL minimum output in pu (base UNom)";

  //Input variable
  Modelica.Blocks.Interfaces.RealInput inputPu(start = Input0Pu) "Input signal" annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput UOelPu(start = 0) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tF, k = KScale, y_start = KScale * Input0Pu) annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Power power1(N = K1, NInteger = true) annotation(
    Placement(visible = true, transformation(origin = {-130, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Power power(N = K1, NInteger = true) annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = ITfPu) annotation(
    Placement(visible = true, transformation(origin = {-170, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = VOel2MaxPu, uMin = VOel2MinPu) annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = 1 / tOel, outMax = VOel1MaxPu, outMin = VOel1MinPu) annotation(
    Placement(visible = true, transformation(origin = {30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = KOel) annotation(
    Placement(visible = true, transformation(origin = {-30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = KpOel) annotation(
    Placement(visible = true, transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameter
  parameter Types.PerUnit Input0Pu "Initial input signal";

equation
  connect(inputPu, firstOrder.u) annotation(
    Line(points = {{-220, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(const1.y, switch.u1) annotation(
    Line(points = {{-19, 80}, {0, 80}, {0, 48}, {17, 48}}, color = {0, 0, 127}));
  connect(firstOrder.y, power.u) annotation(
    Line(points = {{-159, 0}, {-142, 0}}, color = {0, 0, 127}));
  connect(const.y, power1.u) annotation(
    Line(points = {{-159, -80}, {-143, -80}}, color = {0, 0, 127}));
  connect(gain.y, limIntegrator.u) annotation(
    Line(points = {{-19, -40}, {17, -40}}, color = {0, 0, 127}));
  connect(gain.y, switch.u3) annotation(
    Line(points = {{-19, -40}, {0, -40}, {0, 32}, {18, 32}}, color = {0, 0, 127}));
  connect(switch.y, gain1.u) annotation(
    Line(points = {{41, 40}, {57, 40}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{81, 40}, {100, 40}, {100, 6}, {118, 6}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add.u2) annotation(
    Line(points = {{41, -40}, {100, -40}, {100, -6}, {118, -6}}, color = {0, 0, 127}));
  connect(add.y, limiter.u) annotation(
    Line(points = {{142, 0}, {158, 0}}, color = {0, 0, 127}));
  connect(limiter.y, UOelPu) annotation(
    Line(points = {{182, 0}, {210, 0}}, color = {0, 0, 127}));
  connect(limIntegrator.y, greaterEqualThreshold.u) annotation(
    Line(points = {{42, -40}, {60, -40}, {60, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(greaterEqualThreshold.y, switch.u2) annotation(
    Line(points = {{20, 0}, {-20, 0}, {-20, 40}, {18, 40}}, color = {255, 0, 255}));
  connect(power.y, add1.u1) annotation(
    Line(points = {{-118, 0}, {-100, 0}, {-100, -34}, {-82, -34}}, color = {0, 0, 127}));
  connect(power1.y, add1.u2) annotation(
    Line(points = {{-118, -80}, {-100, -80}, {-100, -46}, {-82, -46}}, color = {0, 0, 127}));
  connect(add1.y, gain.u) annotation(
    Line(points = {{-58, -40}, {-42, -40}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end Oel3c;
