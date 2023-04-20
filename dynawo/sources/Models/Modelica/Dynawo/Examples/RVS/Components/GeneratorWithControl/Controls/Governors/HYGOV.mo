within Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Governors;

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

model HYGOV
  import Modelica;
  import Dynawo;
  import Dynawo.Types;

  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base SNom)";
  parameter Types.AngularVelocityPu omega0Pu "Initial speed difference in pu";
  parameter Types.AngularVelocityPu omegaRef0Pu;

  parameter Types.ApparentPowerPu SNom "Rated apparent power of the generator";
  parameter Types.ActivePowerPu PNomTurb "Rated power of the generator";
  parameter Types.PerUnit R "Permanent Droop in pu";
  parameter Types.PerUnit r "Temporary Droop";
  parameter Types.PerUnit DTurb "Turbine Damping in pu";
  parameter Types.PerUnit At "Turbine Gain";
  parameter Types.PerUnit Hdam = 1 "Head available at dam in pu";
  parameter Types.PerUnit qNL "Water Flow at No Load in pu";
  parameter Types.PerUnit Velm "Gate Opening/Closing Velocity Limit in pu/s";
  parameter Types.PerUnit GMin "Min. Gate Limit";
  parameter Types.PerUnit GMax "Max. Gate Limit";
  parameter Types.Time Tf "Filter Time Constant in s";
  parameter Types.Time Tg "Gate Servo Time Constant in s";
  parameter Types.Time Tw "Water Inertia Time Constant in s";
  parameter Types.Time Tr "Governor Time Constant in s";

  Modelica.Blocks.Interfaces.RealInput omegaPu(start = omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-200, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = PmRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-200, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {230, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Add add1(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-100, 114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain permDroop(k = R)  annotation(
    Placement(visible = true, transformation(origin = {-114, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Continuous.FirstOrder filter(T = Tf, initType = Modelica.Blocks.Types.Init.InitialState, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-70, 114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder gateServo(T = Tg, initType = Modelica.Blocks.Types.Init.InitialState, y_start = gateOpening0)  annotation(
    Placement(visible = true, transformation(origin = {52, 114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain turbineDamping(k = DTurb) annotation(
    Placement(visible = true, transformation(origin = {116, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-130, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction turbineFlow(a = {Tw, 0}, b = {1}, initType = Modelica.Blocks.Types.Init.InitialOutput, x_start = {turbineFlow0}, y_start = turbineFlow0)  annotation(
    Placement(visible = true, transformation(origin = {-10, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant HdamConst(k = Hdam)  annotation(
    Placement(visible = true, transformation(origin = {-90, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {40, -96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {78, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain turbineGain(k = At) annotation(
    Placement(visible = true, transformation(origin = {110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add4(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {150, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant qNLConst(k = qNL) annotation(
    Placement(visible = true, transformation(origin = {-10, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add dOmegaPu(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-150, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {80, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constant1(k = 1e-6) annotation(
    Placement(visible = true, transformation(origin = {100, 114}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  parameter Types.ActivePowerPu PmRef0Pu(fixed=false) "calculated: Initial mechanical power reference in pu (base PNom)";
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Governors.Util.velocityLimits velocityLimits(GMax = GMax, GMin = GMin, Tr = Tr, Velm = Velm, initType = Modelica.Blocks.Types.Init.InitialState, r = r, x_start = gateOpening0)  annotation(
    Placement(visible = true, transformation(origin = {-10, 114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k =  SNom /PNomTurb) annotation(
    Placement(visible = true, transformation(origin = {190, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  parameter Types.PerUnit gateOpening0(fixed = false);
  parameter Types.PerUnit turbineFlow0(fixed = false);

initial algorithm
  gateOpening0 := if At * Hdam > 0 then (Pm0Pu * PNomTurb / SNom + qNL * Hdam * At) / (Hdam * sqrt(Hdam) * At - DTurb * (omega0Pu - omegaRef0Pu)) else 0;
// do not factor out the "qNL * HDam * At" term, this will result in a marginally different output
  turbineFlow0 := if At * Hdam > 0 then (Pm0Pu * PNomTurb / SNom + gateOpening0 * DTurb * (omega0Pu - omegaRef0Pu) + qNL * Hdam * At) / (At * Hdam) else 0;
  PmRef0Pu := R * gateOpening0 + omega0Pu - omegaRef0Pu;
equation
  connect(PmRefPu, add1.u1) annotation(
    Line(points = {{-200, 120}, {-112, 120}}, color = {0, 0, 127}));
  connect(add.y, add1.u2) annotation(
    Line(points = {{-120, 91}, {-120, 108}, {-112, 108}}, color = {0, 0, 127}));
  connect(permDroop.y, add.u2) annotation(
    Line(points = {{-114, 61}, {-114, 68}}, color = {0, 0, 127}));
  connect(add1.y, filter.u) annotation(
    Line(points = {{-89, 114}, {-83, 114}}, color = {0, 0, 127}));
  connect(turbineDamping.y, product.u1) annotation(
    Line(points = {{116, -21}, {116, -38}}, color = {0, 0, 127}));
  connect(division.y, product1.u1) annotation(
    Line(points = {{-119, -90}, {-115, -90}, {-115, -84}, {-103, -84}}, color = {0, 0, 127}));
  connect(division.y, product1.u2) annotation(
    Line(points = {{-119, -90}, {-115, -90}, {-115, -96}, {-103, -96}}, color = {0, 0, 127}));
  connect(product1.y, add2.u1) annotation(
    Line(points = {{-79, -90}, {-75, -90}, {-75, -84}, {-63, -84}}, color = {0, 0, 127}));
  connect(add2.y, turbineFlow.u) annotation(
    Line(points = {{-39, -90}, {-23, -90}}, color = {0, 0, 127}));
  connect(turbineFlow.y, add3.u1) annotation(
    Line(points = {{1, -90}, {27, -90}}, color = {0, 0, 127}));
  connect(product1.y, product2.u1) annotation(
    Line(points = {{-79, -90}, {-75, -90}, {-75, -66}, {57, -66}, {57, -84}, {65, -84}}, color = {0, 0, 127}));
  connect(add3.y, product2.u2) annotation(
    Line(points = {{51, -96}, {66, -96}}, color = {0, 0, 127}));
  connect(turbineGain.u, product2.y) annotation(
    Line(points = {{98, -90}, {90, -90}}, color = {0, 0, 127}));
  connect(turbineGain.y, add4.u2) annotation(
    Line(points = {{121, -90}, {137, -90}}, color = {0, 0, 127}));
  connect(product.y, add4.u1) annotation(
    Line(points = {{110, -61}, {110, -70}, {128, -70}, {128, -78}, {138, -78}}, color = {0, 0, 127}));
  connect(HdamConst.y, add2.u2) annotation(
    Line(points = {{-79, -120}, {-75, -120}, {-75, -96}, {-63, -96}}, color = {0, 0, 127}));
  connect(qNLConst.y, add3.u2) annotation(
    Line(points = {{1, -120}, {19, -120}, {19, -102}, {27, -102}}, color = {0, 0, 127}));
  connect(dOmegaPu.y, add.u1) annotation(
    Line(points = {{-139, 10}, {-126, 10}, {-126, 68}}, color = {0, 0, 127}));
  connect(dOmegaPu.y, turbineDamping.u) annotation(
    Line(points = {{-139, 10}, {116, 10}, {116, 2}}, color = {0, 0, 127}));
  connect(omegaPu, dOmegaPu.u1) annotation(
    Line(points = {{-200, 42}, {-172, 42}, {-172, 16}, {-162, 16}}, color = {0, 0, 127}));
  connect(max.y, product.u2) annotation(
    Line(points = {{80, 20}, {80, -26}, {104, -26}, {104, -38}}, color = {0, 0, 127}));
  connect(gateServo.y, max.u2) annotation(
    Line(points = {{64, 114}, {74, 114}, {74, 42}}, color = {0, 0, 127}));
  connect(constant1.y, max.u1) annotation(
    Line(points = {{100, 103}, {100, 60}, {86, 60}, {86, 42}}, color = {0, 0, 127}));
  connect(max.y, division.u2) annotation(
    Line(points = {{80, 20}, {80, -26}, {-160, -26}, {-160, -96}, {-142, -96}}, color = {0, 0, 127}));
  connect(turbineFlow.y, division.u1) annotation(
    Line(points = {{2, -90}, {12, -90}, {12, -140}, {-158, -140}, {-158, -84}, {-142, -84}}, color = {0, 0, 127}));
  connect(omegaRefPu, dOmegaPu.u2) annotation(
    Line(points = {{-200, 0}, {-170, 0}, {-170, 4}, {-162, 4}}, color = {0, 0, 127}));
  connect(filter.y, velocityLimits.u) annotation(
    Line(points = {{-58, 114}, {-22, 114}}, color = {0, 0, 127}));
  connect(velocityLimits.y, gateServo.u) annotation(
    Line(points = {{2, 114}, {40, 114}}, color = {0, 0, 127}));
  connect(velocityLimits.y, permDroop.u) annotation(
    Line(points = {{2, 114}, {20, 114}, {20, 22}, {-114, 22}, {-114, 38}}, color = {0, 0, 127}));
  connect(gain.y, PmPu) annotation(
    Line(points = {{202, -84}, {230, -84}}, color = {0, 0, 127}));
  connect(add4.y, gain.u) annotation(
    Line(points = {{162, -84}, {178, -84}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-180, -150}, {180, 150}})),
    Icon(coordinateSystem(extent = {{-180, -150}, {180, 150}}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-180, 150}, {180, -150}}), Text(origin = {0, 1}, extent = {{-160, 121}, {160, -121}}, textString = "HYGOV")}));
end HYGOV;
