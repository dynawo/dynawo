within Dynawo.Electrical.Controls.Machines.Governors.Standard.Hydraulic;

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

model HyGov "Governor type HYGOV"

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
  parameter Types.PerUnit VelMaxPu "Gate maximum opening/closing velocity in pu/s (base PNomTurb)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = PmRef0Pu) "Reference mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {-380, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {370, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tF) annotation(
    Placement(visible = true, transformation(origin = {-230, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tG, y_start = OpeningGate0) annotation(
    Placement(visible = true, transformation(origin = {-50, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = DTurb) annotation(
    Placement(visible = true, transformation(origin = {-50, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {270, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {70, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {170, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / tW, y_start = FlowTurbine0) annotation(
    Placement(visible = true, transformation(origin = {210, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = HDam) annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {270, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = At, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {330, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = FlowNoLoad) annotation(
    Placement(visible = true, transformation(origin = {190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-310, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max1 annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = 1e-6) annotation(
    Placement(visible = true, transformation(origin = {-50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = -KDroopPerm, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-270, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Power power(N = 2, NInteger = true) annotation(
    Placement(visible = true, transformation(origin = {110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {240, -20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = VelMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-190, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimitedPI limitedPI(Ki = 1 / tR, Kp = 1, Y0 = OpeningGate0, YMax = OpeningGateMax, YMin = OpeningGateMin) annotation(
    Placement(visible = true, transformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = 1 / KDroopTemp) annotation(
    Placement(visible = true, transformation(origin = {-150, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameter
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base PNomTurb)";

  final parameter Types.PerUnit FlowTurbine0 = FlowNoLoad + Pm0Pu / (At * HDam) "Initial flow through turbine";
  final parameter Types.PerUnit OpeningGate0 = FlowTurbine0 / sqrt(HDam) "Initial gate opening";
  final parameter Types.ActivePowerPu PmRef0Pu = KDroopPerm * OpeningGate0 "Initial reference mechanical power in pu (base PNomTurb)";

equation
  connect(add2.y, integrator.u) annotation(
    Line(points = {{181, 40}, {198, 40}}, color = {0, 0, 127}));
  connect(const.y, add2.u2) annotation(
    Line(points = {{121, -20}, {140, -20}, {140, 34}, {158, 34}}, color = {0, 0, 127}));
  connect(add1.y, gain.u) annotation(
    Line(points = {{-299, -20}, {-280, -20}, {-280, -160}, {-62, -160}}, color = {0, 0, 127}));
  connect(omegaPu, add1.u1) annotation(
    Line(points = {{-380, 0}, {-340, 0}, {-340, -14}, {-322, -14}}, color = {0, 0, 127}));
  connect(integrator.y, division.u1) annotation(
    Line(points = {{221, 40}, {240, 40}, {240, 140}, {40, 140}, {40, 106}, {58, 106}}, color = {0, 0, 127}));
  connect(omegaRefPu, add1.u2) annotation(
    Line(points = {{-380, -40}, {-340, -40}, {-340, -26}, {-322, -26}}, color = {0, 0, 127}));
  connect(PmRefPu, add3.u2) annotation(
    Line(points = {{-380, 100}, {-282, 100}}, color = {0, 0, 127}));
  connect(add1.y, add3.u3) annotation(
    Line(points = {{-299, -20}, {-280, -20}, {-280, 40}, {-300, 40}, {-300, 92}, {-282, 92}}, color = {0, 0, 127}));
  connect(add3.y, firstOrder1.u) annotation(
    Line(points = {{-259, 100}, {-242, 100}}, color = {0, 0, 127}));
  connect(firstOrder.y, max1.u1) annotation(
    Line(points = {{-39, 100}, {-20, 100}, {-20, 66}, {-2, 66}}, color = {0, 0, 127}));
  connect(const2.y, max1.u2) annotation(
    Line(points = {{-39, 20}, {-20, 20}, {-20, 54}, {-2, 54}}, color = {0, 0, 127}));
  connect(power.y, product1.u2) annotation(
    Line(points = {{121, 100}, {140, 100}, {140, 60}, {80, 60}, {80, -100}, {240, -100}, {240, -66}, {258, -66}}, color = {0, 0, 127}));
  connect(power.y, add2.u1) annotation(
    Line(points = {{121, 100}, {140, 100}, {140, 46}, {158, 46}}, color = {0, 0, 127}));
  connect(division.y, power.u) annotation(
    Line(points = {{81, 100}, {98, 100}}, color = {0, 0, 127}));
  connect(product1.y, add.u1) annotation(
    Line(points = {{281, -60}, {300, -60}, {300, -94}, {318, -94}}, color = {0, 0, 127}));
  connect(product.y, add.u2) annotation(
    Line(points = {{281, -140}, {300, -140}, {300, -106}, {317, -106}}, color = {0, 0, 127}));
  connect(max1.y, product.u1) annotation(
    Line(points = {{21, 60}, {40, 60}, {40, -120}, {240, -120}, {240, -134}, {258, -134}}, color = {0, 0, 127}));
  connect(gain.y, product.u2) annotation(
    Line(points = {{-39, -160}, {240, -160}, {240, -146}, {258, -146}}, color = {0, 0, 127}));
  connect(max1.y, division.u2) annotation(
    Line(points = {{21, 60}, {40, 60}, {40, 94}, {58, 94}}, color = {0, 0, 127}));
  connect(const1.y, feedback.u2) annotation(
    Line(points = {{201, -20}, {231, -20}}, color = {0, 0, 127}));
  connect(integrator.y, feedback.u1) annotation(
    Line(points = {{221, 40}, {240, 40}, {240, -12}}, color = {0, 0, 127}));
  connect(feedback.y, product1.u1) annotation(
    Line(points = {{240, -29}, {240, -54}, {258, -54}}, color = {0, 0, 127}));
  connect(firstOrder1.y, limiter.u) annotation(
    Line(points = {{-219, 100}, {-203, 100}}, color = {0, 0, 127}));
  connect(limiter.y, gain2.u) annotation(
    Line(points = {{-179, 100}, {-163, 100}}, color = {0, 0, 127}));
  connect(gain2.y, limitedPI.u) annotation(
    Line(points = {{-139, 100}, {-123, 100}}, color = {0, 0, 127}));
  connect(add.y, PmPu) annotation(
    Line(points = {{342, -100}, {370, -100}}, color = {0, 0, 127}));
  connect(limitedPI.y, firstOrder.u) annotation(
    Line(points = {{-98, 100}, {-62, 100}}, color = {0, 0, 127}));
  connect(limitedPI.y, add3.u1) annotation(
    Line(points = {{-98, 100}, {-80, 100}, {-80, 140}, {-300, 140}, {-300, 108}, {-282, 108}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-360, -180}, {360, 180}})));
end HyGov;
