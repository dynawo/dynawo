within Dynawo.Electrical.Controls.Machines.OverExcitationLimiters.Standard.BaseClasses;

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

model OelReferenceCurrent "IRef calculation for OEL2C"

  //Regulation parameters
  parameter Types.PerUnit C1 "OEL exponent for calculation of first error";
  parameter Types.PerUnit C2 "OEL exponent for calculation of second error";
  parameter Types.PerUnit FixedRd "OEL fixed cooling-down time output";
  parameter Types.PerUnit FixedRu "OEL fixed delay time output";
  parameter Types.CurrentModulePu IInstPu "OEL instantaneous field current limit";
  parameter Types.CurrentModulePu ILimPu "OEL thermal field current limit";
  parameter Types.CurrentModulePu ITfPu "OEL reference for inverse time calculations";
  parameter Types.PerUnit K1 "OEL gain for calculation of first error";
  parameter Types.PerUnit K2 "OEL gain for calculation of second error";
  parameter Types.PerUnit KFb "OEL timer feedback gain";
  parameter Types.PerUnit Krd "OEL reference ramp-down rate";
  parameter Types.PerUnit Kru "OEL reference ramp-up rate";
  parameter Types.PerUnit Kzru "OEL thermal reference release threshold";
  parameter Boolean Sw1 "If true, ramp rate depends on field current error, if false, ramp rates are fixed";
  parameter Types.Time tFcl "OEL timer reference in s";
  parameter Types.Time tMax "OEL timer maximum level in s";
  parameter Types.Time tMin "OEL timer minimum level in s";
  parameter Types.PerUnit VInvMaxPu "OEL maximum inverse time output";
  parameter Types.PerUnit VInvMinPu "OEL minimum inverse time output";

  //Input variable
  Modelica.Blocks.Interfaces.RealInput IPu(start = I0Pu) "Input current in pu" annotation(
    Placement(visible = true, transformation(origin = {-340, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput IRefPu(start = IRef0Pu) "Reference field current in pu" annotation(
    Placement(visible = true, transformation(origin = {330, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput tErr(start = tErr0) "OEL timer error in s" annotation(
    Placement(visible = true, transformation(origin = {330, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant const(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-230, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator1(outMax = IInstPu, outMin = ILimPu, y_start = IRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {290, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold(threshold = 1) annotation(
    Placement(visible = true, transformation(origin = {-150, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const5(k = Kru) annotation(
    Placement(visible = true, transformation(origin = {-30, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {120, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = K2) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = K1) annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const4(k = Krd) annotation(
    Placement(visible = true, transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-90, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-30, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-180, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MultiSwitch multiSwitch1(expr = {switch1.y, switch2.y}, nu = 2) annotation(
    Placement(visible = true, transformation(origin = {230, -60}, extent = {{-10, -10}, {30, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = tFcl) annotation(
    Placement(visible = true, transformation(origin = {70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Power power(N = C2, NInteger = true) annotation(
    Placement(visible = true, transformation(origin = {-230, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {30, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Power power1(N = C1, NInteger = true) annotation(
    Placement(visible = true, transformation(origin = {-230, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = FixedRu) annotation(
    Placement(visible = true, transformation(origin = {-150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold = Kzru * tFcl) annotation(
    Placement(visible = true, transformation(origin = {170, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / ITfPu) annotation(
    Placement(visible = true, transformation(origin = {-290, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {30, 100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {-180, -20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = Sw1) annotation(
    Placement(visible = true, transformation(origin = {-90, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold1(threshold = 0) annotation(
    Placement(visible = true, transformation(origin = {170, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = KFb) annotation(
    Placement(visible = true, transformation(origin = {70, -100}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = VInvMaxPu, uMin = VInvMinPu) annotation(
    Placement(visible = true, transformation(origin = {-90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = FixedRd) annotation(
    Placement(visible = true, transformation(origin = {-150, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(outMax = tMax, outMin = tMin, y_start = tInt0) annotation(
    Placement(visible = true, transformation(origin = {70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {20, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.CurrentModulePu I0Pu "Initial input current in pu";
  parameter Types.CurrentModulePu IRef0Pu "Initial reference field current in pu";
  parameter Types.Time tErr0 "Initial OEL timer error in s";
  parameter Types.Time tInt0 "Initial OEL timer output in s";

equation
  connect(limiter.y, add.u1) annotation(
    Line(points = {{-79, -20}, {-60, -20}, {-60, -54}, {-43, -54}}, color = {0, 0, 127}));
  connect(lessEqualThreshold.y, switch.u2) annotation(
    Line(points = {{-139, -100}, {-103, -100}}, color = {255, 0, 255}));
  connect(booleanConstant.y, switch2.u2) annotation(
    Line(points = {{-79, 20}, {17, 20}}, color = {255, 0, 255}));
  connect(const.y, feedback2.u2) annotation(
    Line(points = {{-219, 20}, {-180, 20}, {-180, -12}}, color = {0, 0, 127}));
  connect(power.y, feedback2.u1) annotation(
    Line(points = {{-219, -20}, {-189, -20}}, color = {0, 0, 127}));
  connect(add.y, feedback.u1) annotation(
    Line(points = {{-19, -60}, {11, -60}}, color = {0, 0, 127}));
  connect(const1.y, switch.u1) annotation(
    Line(points = {{-139, -60}, {-120, -60}, {-120, -92}, {-103, -92}}, color = {0, 0, 127}));
  connect(gain.y, power.u) annotation(
    Line(points = {{-279, -20}, {-243, -20}}, color = {0, 0, 127}));
  connect(feedback2.y, gain2.u) annotation(
    Line(points = {{-171, -20}, {-143, -20}}, color = {0, 0, 127}));
  connect(feedback3.y, lessEqualThreshold1.u) annotation(
    Line(points = {{129, -20}, {140, -20}, {140, -100}, {158, -100}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{-79, 20}, {-20, 20}, {-20, 100}, {17, 100}}, color = {255, 0, 255}));
  connect(lessEqualThreshold1.y, multiSwitch1.u[2]) annotation(
    Line(points = {{181, -100}, {200, -100}, {200, -60}, {219, -60}}, color = {255, 0, 255}));
  connect(const.y, feedback1.u2) annotation(
    Line(points = {{-219, 20}, {-180, 20}, {-180, 52}}, color = {0, 0, 127}));
  connect(limIntegrator.y, gain3.u) annotation(
    Line(points = {{81, -60}, {120, -60}, {120, -100}, {81, -100}}, color = {0, 0, 127}));
  connect(multiSwitch1.y, limIntegrator1.u) annotation(
    Line(points = {{261, -60}, {277, -60}}, color = {0, 0, 127}));
  connect(gain.y, lessEqualThreshold.u) annotation(
    Line(points = {{-279, -20}, {-260, -20}, {-260, -100}, {-162, -100}}, color = {0, 0, 127}));
  connect(gain3.y, feedback.u2) annotation(
    Line(points = {{59, -100}, {20, -100}, {20, -68}}, color = {0, 0, 127}));
  connect(power1.y, feedback1.u1) annotation(
    Line(points = {{-219, 60}, {-189, 60}}, color = {0, 0, 127}));
  connect(gain1.y, switch2.u1) annotation(
    Line(points = {{-119, 60}, {0, 60}, {0, 28}, {17, 28}}, color = {0, 0, 127}));
  connect(const2.y, switch.u3) annotation(
    Line(points = {{-139, -140}, {-120, -140}, {-120, -108}, {-103, -108}}, color = {0, 0, 127}));
  connect(feedback1.y, gain1.u) annotation(
    Line(points = {{-171, 60}, {-143, 60}}, color = {0, 0, 127}));
  connect(gain.y, power1.u) annotation(
    Line(points = {{-279, -20}, {-260, -20}, {-260, 60}, {-243, 60}}, color = {0, 0, 127}));
  connect(greaterEqualThreshold.y, multiSwitch1.u[1]) annotation(
    Line(points = {{181, -20}, {200, -20}, {200, -60}, {219, -60}}, color = {255, 0, 255}));
  connect(feedback3.y, greaterEqualThreshold.u) annotation(
    Line(points = {{129, -20}, {158, -20}}, color = {0, 0, 127}));
  connect(limIntegrator.y, feedback3.u2) annotation(
    Line(points = {{81, -60}, {120, -60}, {120, -28}}, color = {0, 0, 127}));
  connect(const5.y, switch1.u3) annotation(
    Line(points = {{-19, 140}, {0, 140}, {0, 108}, {17, 108}}, color = {0, 0, 127}));
  connect(const4.y, switch2.u3) annotation(
    Line(points = {{-19, -20}, {0, -20}, {0, 12}, {17, 12}}, color = {0, 0, 127}));
  connect(switch.y, add.u2) annotation(
    Line(points = {{-79, -100}, {-60, -100}, {-60, -66}, {-43, -66}}, color = {0, 0, 127}));
  connect(const3.y, feedback3.u1) annotation(
    Line(points = {{81, -20}, {112, -20}}, color = {0, 0, 127}));
  connect(feedback.y, limIntegrator.u) annotation(
    Line(points = {{29, -60}, {57, -60}}, color = {0, 0, 127}));
  connect(gain2.y, limiter.u) annotation(
    Line(points = {{-119, -20}, {-103, -20}}, color = {0, 0, 127}));
  connect(IPu, gain.u) annotation(
    Line(points = {{-340, -20}, {-302, -20}}, color = {0, 0, 127}));
  connect(limIntegrator1.y, IRefPu) annotation(
    Line(points = {{302, -60}, {330, -60}}, color = {0, 0, 127}));
  connect(gain1.y, switch1.u1) annotation(
    Line(points = {{-118, 60}, {0, 60}, {0, 92}, {18, 92}}, color = {0, 0, 127}));
  connect(feedback3.y, tErr) annotation(
    Line(points = {{129, -20}, {140, -20}, {140, 60}, {330, 60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-320, -160}, {320, 160}})));
end OelReferenceCurrent;
