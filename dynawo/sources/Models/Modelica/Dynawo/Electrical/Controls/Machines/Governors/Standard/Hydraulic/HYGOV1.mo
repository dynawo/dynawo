within Dynawo.Electrical.Controls.Machines.Governors.Standard.Hydraulic;

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

model HYGOV1 "First implementation of governor type HYGOV"

  //Regulation parameters
  parameter Types.PerUnit At "Turbine gain";
  parameter Types.PerUnit DTurb "Turbine damping coefficient";
  parameter Types.PerUnit FlowNoLoad "No-load water flow at nominal head";
  parameter Types.PerUnit HDam = 1 "Head available at dam";
  parameter Types.PerUnit KDroopPerm "Permanent droop";
  parameter Types.PerUnit KDroopTemp "Temporary droop";
  parameter Types.PerUnit OpeningGateMax "Maximum gate opening";
  parameter Types.PerUnit OpeningGateMin "Minimum gate opening";
  parameter Types.Time tF "Filter time constant in s";
  parameter Types.Time tG "Gate servomotor time constant in s";
  parameter Types.Time tR "Governor time constant in s";
  parameter Types.Time tW "Water inertia time constant in s";
  parameter Types.PerUnit VelMax "Gate maximum opening/closing velocity in Hz";

  //Generator parameters
  parameter Types.ActivePower PNomTurb "Nominal turbine active power in MW";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-420, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-420, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = PmRef0Pu) "Reference mechanical power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-420, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {410, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tF, initType = Modelica.Blocks.Types.Init.InitialState, k = 1 / KDroopTemp) annotation(
    Placement(visible = true, transformation(origin = {-310, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tG, initType = Modelica.Blocks.Types.Init.InitialState, y_start = OpeningGate0) annotation(
    Placement(visible = true, transformation(origin = {-50, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = DTurb) annotation(
    Placement(visible = true, transformation(origin = {-50, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {270, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {70, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(initType = Modelica.Blocks.Types.Init.InitialOutput, k = 1 / tW, y_start = FlowTurbine0) annotation(
    Placement(visible = true, transformation(origin = {210, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = HDam) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {270, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = At, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {330, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = FlowNoLoad) annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-350, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max1 annotation(
    Placement(visible = true, transformation(origin = {10, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = 1e-6) annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = -KDroopPerm, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-350, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Power power(N = 2, NInteger = true) annotation(
    Placement(visible = true, transformation(origin = {110, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = tR * VelMax, tS = 1e-3, Y0 = 0) annotation(
    Placement(visible = true, transformation(origin = {-250, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(k = 1 / tR, y_start = OpeningGate0) annotation(
    Placement(visible = true, transformation(origin = {-210, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add4 annotation(
    Placement(visible = true, transformation(origin = {-150, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = OpeningGateMax, uMin = OpeningGateMin) annotation(
    Placement(visible = true, transformation(origin = {-110, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {240, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gain1(k = SNom / PNomTurb) annotation(
    Placement(visible = true, transformation(origin = {370, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base PNomTurb)";

  final parameter Types.PerUnit FlowTurbine0 = FlowNoLoad + Pm0Pu * (PNomTurb / SNom) / (At * HDam) "Initial flow through turbine";
  final parameter Types.PerUnit OpeningGate0 = FlowTurbine0 / sqrt(HDam) "Initial gate opening";
  final parameter Types.ActivePowerPu PmRef0Pu = KDroopPerm * OpeningGate0 "Initial reference mechanical power in pu (base PNomTurb)";

equation
  connect(add2.y, integrator.u) annotation(
    Line(points = {{181, 60}, {198, 60}}, color = {0, 0, 127}));
  connect(const.y, add2.u2) annotation(
    Line(points = {{121, 0}, {140, 0}, {140, 54}, {158, 54}}, color = {0, 0, 127}));
  connect(add1.y, gain.u) annotation(
    Line(points = {{-339, 0}, {-320, 0}, {-320, -140}, {-62, -140}}, color = {0, 0, 127}));
  connect(omegaPu, add1.u1) annotation(
    Line(points = {{-420, 20}, {-380, 20}, {-380, 6}, {-362, 6}}, color = {0, 0, 127}));
  connect(integrator.y, division.u1) annotation(
    Line(points = {{221, 60}, {240, 60}, {240, 160}, {40, 160}, {40, 126}, {58, 126}}, color = {0, 0, 127}));
  connect(omegaRefPu, add1.u2) annotation(
    Line(points = {{-420, -20}, {-380, -20}, {-380, -6}, {-362, -6}}, color = {0, 0, 127}));
  connect(PmRefPu, add3.u2) annotation(
    Line(points = {{-420, 120}, {-362, 120}}, color = {0, 0, 127}));
  connect(add1.y, add3.u3) annotation(
    Line(points = {{-339, 0}, {-320, 0}, {-320, 60}, {-380, 60}, {-380, 112}, {-362, 112}}, color = {0, 0, 127}));
  connect(add3.y, firstOrder1.u) annotation(
    Line(points = {{-339, 120}, {-322, 120}}, color = {0, 0, 127}));
  connect(firstOrder.y, max1.u1) annotation(
    Line(points = {{-39, 120}, {-20, 120}, {-20, 86}, {-2, 86}}, color = {0, 0, 127}));
  connect(const2.y, max1.u2) annotation(
    Line(points = {{-39, 40}, {-20, 40}, {-20, 74}, {-2, 74}}, color = {0, 0, 127}));
  connect(power.y, product1.u2) annotation(
    Line(points = {{121, 120}, {140, 120}, {140, 80}, {80, 80}, {80, -80}, {240, -80}, {240, -46}, {258, -46}}, color = {0, 0, 127}));
  connect(power.y, add2.u1) annotation(
    Line(points = {{121, 120}, {140, 120}, {140, 66}, {158, 66}}, color = {0, 0, 127}));
  connect(division.y, power.u) annotation(
    Line(points = {{81, 120}, {98, 120}}, color = {0, 0, 127}));
  connect(product1.y, add.u1) annotation(
    Line(points = {{281, -40}, {300, -40}, {300, -74}, {318, -74}}, color = {0, 0, 127}));
  connect(product.y, add.u2) annotation(
    Line(points = {{281, -120}, {300, -120}, {300, -86}, {317, -86}}, color = {0, 0, 127}));
  connect(max1.y, product.u1) annotation(
    Line(points = {{21, 80}, {40, 80}, {40, -100}, {240, -100}, {240, -114}, {258, -114}}, color = {0, 0, 127}));
  connect(gain.y, product.u2) annotation(
    Line(points = {{-39, -140}, {240, -140}, {240, -126}, {258, -126}}, color = {0, 0, 127}));
  connect(max1.y, division.u2) annotation(
    Line(points = {{21, 80}, {40, 80}, {40, 114}, {58, 114}}, color = {0, 0, 127}));
  connect(const1.y, feedback.u2) annotation(
    Line(points = {{201, 0}, {231, 0}}, color = {0, 0, 127}));
  connect(integrator.y, feedback.u1) annotation(
    Line(points = {{221, 60}, {240, 60}, {240, 8}}, color = {0, 0, 127}));
  connect(feedback.y, product1.u1) annotation(
    Line(points = {{240, -9}, {240, -35}, {258, -35}}, color = {0, 0, 127}));
  connect(firstOrder1.y, rampLimiter.u) annotation(
    Line(points = {{-299, 120}, {-280, 120}, {-280, 140}, {-263, 140}}, color = {0, 0, 127}));
  connect(rampLimiter.y, integrator1.u) annotation(
    Line(points = {{-239, 140}, {-223, 140}}, color = {0, 0, 127}));
  connect(integrator1.y, add4.u1) annotation(
    Line(points = {{-199, 140}, {-180, 140}, {-180, 126}, {-162, 126}}, color = {0, 0, 127}));
  connect(firstOrder1.y, add4.u2) annotation(
    Line(points = {{-299, 120}, {-280, 120}, {-280, 100}, {-180, 100}, {-180, 114}, {-163, 114}}, color = {0, 0, 127}));
  connect(add4.y, limiter.u) annotation(
    Line(points = {{-139, 120}, {-123, 120}}, color = {0, 0, 127}));
  connect(limiter.y, firstOrder.u) annotation(
    Line(points = {{-99, 120}, {-63, 120}}, color = {0, 0, 127}));
  connect(limiter.y, add3.u1) annotation(
    Line(points = {{-99, 120}, {-80, 120}, {-80, 180}, {-380, 180}, {-380, 128}, {-363, 128}}, color = {0, 0, 127}));
  connect(add.y, gain1.u) annotation(
    Line(points = {{342, -80}, {358, -80}}, color = {0, 0, 127}));
  connect(gain1.y, PmPu) annotation(
    Line(points = {{382, -80}, {410, -80}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-400, -200}, {400, 200}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(extent = {{-100, 100}, {100, -100}}, textString = "HYGOV")}));
end HYGOV1;
