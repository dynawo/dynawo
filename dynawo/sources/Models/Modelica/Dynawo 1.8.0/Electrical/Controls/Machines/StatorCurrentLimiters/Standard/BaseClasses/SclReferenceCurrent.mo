within Dynawo.Electrical.Controls.Machines.StatorCurrentLimiters.Standard.BaseClasses;

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

model SclReferenceCurrent "IRef calculation for SCL2C"

  //Regulation parameters
  parameter Types.PerUnit C1 "SCL exponent for calculation of first error";
  parameter Types.PerUnit C2 "SCL exponent for calculation of second error";
  parameter Types.PerUnit FixedRd "SCL fixed cooling-down time output";
  parameter Types.PerUnit FixedRu "SCL fixed delay time output";
  parameter Types.CurrentModulePu IInstPu "SCL instantaneous stator current limit in pu (base SnRef, UNom)";
  parameter Types.CurrentModulePu ILimPu "SCL thermal stator current limit in pu (base SnRef, UNom)";
  parameter Types.CurrentModulePu ITfPu "SCL thermal reference for inverse time calculations in pu (base SnRef, UNom)";
  parameter Types.PerUnit K1 "SCL gain for calculation of first error";
  parameter Types.PerUnit K2 "SCL gain for calculation of second error";
  parameter Types.PerUnit KFb "SCL timer feedback gain";
  parameter Types.PerUnit KPRef "SCL reference scaling factor based on active current";
  parameter Types.PerUnit Krd "SCL reference ramp-down rate in pu/s (base SnRef, UNom)";
  parameter Types.PerUnit Kru "SCL reference ramp-up rate in pu/s (base SnRef, UNom)";
  parameter Types.PerUnit Kzru "SCL thermal reference release threshold";
  parameter Boolean Sw1 "If true, ramp rate depends on field current error, if false, ramp rates are fixed";
  parameter Types.Time tScl "SCL timer reference in s";
  parameter Types.Time tMax "SCL timer maximum level in s";
  parameter Types.Time tMin "SCL timer minimum level in s";
  parameter Types.PerUnit VInvMaxPu "SCL maximum inverse time output";
  parameter Types.PerUnit VInvMinPu "SCL minimum inverse time output";
  parameter Types.VoltageModulePu VtResetPu "SCL OEL voltage reset value in pu (base UNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IPRefPu(start = I0Pu) "Reference active current in pu (base SnRef, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IPu(start = I0Pu) "Stator current in pu (base SnRef, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput VtFiltPu(start = Vt0Pu) "Filtered stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, -160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput IRefPu(start = IRef0Pu) "Reference current in pu (base SnRef, UNom)" annotation(
    Placement(visible = true, transformation(origin = {370, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput tErr(start = tErr0) "SCL timer error in s" annotation(
    Placement(visible = true, transformation(origin = {370, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant const(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-270, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator1(outMax = IInstPu, outMin = ILimPu, y_start = IRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {310, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold(threshold = 1) annotation(
    Placement(visible = true, transformation(origin = {-190, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const5(k = Kru) annotation(
    Placement(visible = true, transformation(origin = {-70, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {80, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = K2) annotation(
    Placement(visible = true, transformation(origin = {-170, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = K1) annotation(
    Placement(visible = true, transformation(origin = {-170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const4(k = Krd) annotation(
    Placement(visible = true, transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-130, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-220, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MultiSwitch multiSwitch1(expr = {switch1.y, switch2.y}, nu = 2) annotation(
    Placement(visible = true, transformation(origin = {250, -60}, extent = {{-10, -10}, {30, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = tScl) annotation(
    Placement(visible = true, transformation(origin = {30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Power power(N = C2, NInteger = true) annotation(
    Placement(visible = true, transformation(origin = {-270, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {-10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Power power1(N = C1, NInteger = true) annotation(
    Placement(visible = true, transformation(origin = {-270, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = FixedRu) annotation(
    Placement(visible = true, transformation(origin = {-190, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold = Kzru * tScl) annotation(
    Placement(visible = true, transformation(origin = {130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / ITfPu) annotation(
    Placement(visible = true, transformation(origin = {-330, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-10, 100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {-220, -20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = Sw1) annotation(
    Placement(visible = true, transformation(origin = {-130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold1(threshold = 0) annotation(
    Placement(visible = true, transformation(origin = {130, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = KFb) annotation(
    Placement(visible = true, transformation(origin = {30, -100}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = VInvMaxPu, uMin = VInvMinPu) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = FixedRd) annotation(
    Placement(visible = true, transformation(origin = {-190, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(outMax = tMax, outMin = tMin, y_start = tInt0) annotation(
    Placement(visible = true, transformation(origin = {30, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-20, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {190, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = VtResetPu) annotation(
    Placement(visible = true, transformation(origin = {130, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.CurrentModulePu I0Pu "Initial stator current in pu (base SnRef, UNom)";
  parameter Types.CurrentModulePu IRef0Pu "Initial reference current in pu (base SnRef, UNom)";
  parameter Types.Time tErr0 "Initial SCL timer error in s";
  parameter Types.Time tInt0 "Initial SCL timer output in s";
  parameter Types.VoltageModulePu Vt0Pu "Initial stator voltage in pu (base UNom)";

equation
  IRefPu = noEvent(if KPRef > 0 and limIntegrator1.y ^ 2 > IPRefPu ^ 2 then sqrt(limIntegrator1.y ^ 2 - IPRefPu ^ 2) else limIntegrator1.y);

  connect(limiter.y, add.u1) annotation(
    Line(points = {{-119, -20}, {-100, -20}, {-100, -54}, {-82, -54}}, color = {0, 0, 127}));
  connect(lessEqualThreshold.y, switch.u2) annotation(
    Line(points = {{-179, -100}, {-142, -100}}, color = {255, 0, 255}));
  connect(booleanConstant.y, switch2.u2) annotation(
    Line(points = {{-119, 20}, {-22, 20}}, color = {255, 0, 255}));
  connect(const.y, feedback2.u2) annotation(
    Line(points = {{-259, 20}, {-220, 20}, {-220, -12}}, color = {0, 0, 127}));
  connect(power.y, feedback2.u1) annotation(
    Line(points = {{-259, -20}, {-228, -20}}, color = {0, 0, 127}));
  connect(add.y, feedback.u1) annotation(
    Line(points = {{-59, -60}, {-28, -60}}, color = {0, 0, 127}));
  connect(const1.y, switch.u1) annotation(
    Line(points = {{-179, -60}, {-160, -60}, {-160, -92}, {-142, -92}}, color = {0, 0, 127}));
  connect(gain.y, power.u) annotation(
    Line(points = {{-319, -20}, {-282, -20}}, color = {0, 0, 127}));
  connect(feedback2.y, gain2.u) annotation(
    Line(points = {{-211, -20}, {-182, -20}}, color = {0, 0, 127}));
  connect(feedback3.y, lessEqualThreshold1.u) annotation(
    Line(points = {{89, -20}, {100, -20}, {100, -100}, {118, -100}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{-119, 20}, {-60, 20}, {-60, 100}, {-22, 100}}, color = {255, 0, 255}));
  connect(or1.y, multiSwitch1.u[2]) annotation(
    Line(points = {{201, -100}, {220, -100}, {220, -60}, {239, -60}}, color = {255, 0, 255}));
  connect(const.y, feedback1.u2) annotation(
    Line(points = {{-259, 20}, {-220, 20}, {-220, 52}}, color = {0, 0, 127}));
  connect(limIntegrator.y, gain3.u) annotation(
    Line(points = {{41, -60}, {80, -60}, {80, -100}, {42, -100}}, color = {0, 0, 127}));
  connect(multiSwitch1.y, limIntegrator1.u) annotation(
    Line(points = {{281, -60}, {298, -60}}, color = {0, 0, 127}));
  connect(gain.y, lessEqualThreshold.u) annotation(
    Line(points = {{-319, -20}, {-300, -20}, {-300, -100}, {-202, -100}}, color = {0, 0, 127}));
  connect(gain3.y, feedback.u2) annotation(
    Line(points = {{19, -100}, {-20, -100}, {-20, -68}}, color = {0, 0, 127}));
  connect(power1.y, feedback1.u1) annotation(
    Line(points = {{-259, 60}, {-228, 60}}, color = {0, 0, 127}));
  connect(gain1.y, switch2.u1) annotation(
    Line(points = {{-159, 60}, {-40, 60}, {-40, 28}, {-22, 28}}, color = {0, 0, 127}));
  connect(const2.y, switch.u3) annotation(
    Line(points = {{-179, -140}, {-160, -140}, {-160, -108}, {-142, -108}}, color = {0, 0, 127}));
  connect(feedback1.y, gain1.u) annotation(
    Line(points = {{-211, 60}, {-182, 60}}, color = {0, 0, 127}));
  connect(gain.y, power1.u) annotation(
    Line(points = {{-319, -20}, {-300, -20}, {-300, 60}, {-282, 60}}, color = {0, 0, 127}));
  connect(greaterEqualThreshold.y, multiSwitch1.u[1]) annotation(
    Line(points = {{141, -20}, {220, -20}, {220, -60}, {240, -60}}, color = {255, 0, 255}));
  connect(feedback3.y, greaterEqualThreshold.u) annotation(
    Line(points = {{89, -20}, {118, -20}}, color = {0, 0, 127}));
  connect(limIntegrator.y, feedback3.u2) annotation(
    Line(points = {{41, -60}, {80, -60}, {80, -28}}, color = {0, 0, 127}));
  connect(const5.y, switch1.u3) annotation(
    Line(points = {{-59, 140}, {-40, 140}, {-40, 108}, {-22, 108}}, color = {0, 0, 127}));
  connect(const4.y, switch2.u3) annotation(
    Line(points = {{-59, -20}, {-40, -20}, {-40, 12}, {-22, 12}}, color = {0, 0, 127}));
  connect(switch.y, add.u2) annotation(
    Line(points = {{-119, -100}, {-100, -100}, {-100, -66}, {-82, -66}}, color = {0, 0, 127}));
  connect(const3.y, feedback3.u1) annotation(
    Line(points = {{41, -20}, {72, -20}}, color = {0, 0, 127}));
  connect(feedback.y, limIntegrator.u) annotation(
    Line(points = {{-11, -60}, {18, -60}}, color = {0, 0, 127}));
  connect(gain2.y, limiter.u) annotation(
    Line(points = {{-159, -20}, {-142, -20}}, color = {0, 0, 127}));
  connect(IPu, gain.u) annotation(
    Line(points = {{-380, -20}, {-342, -20}}, color = {0, 0, 127}));
  connect(gain1.y, switch1.u1) annotation(
    Line(points = {{-159, 60}, {-40, 60}, {-40, 92}, {-22, 92}}, color = {0, 0, 127}));
  connect(feedback3.y, tErr) annotation(
    Line(points = {{89, -20}, {100, -20}, {100, 60}, {370, 60}}, color = {0, 0, 127}));
  connect(lessEqualThreshold1.y, or1.u1) annotation(
    Line(points = {{141, -100}, {177, -100}}, color = {255, 0, 255}));
  connect(VtFiltPu, lessThreshold.u) annotation(
    Line(points = {{-380, -160}, {118, -160}}, color = {0, 0, 127}));
  connect(lessThreshold.y, or1.u2) annotation(
    Line(points = {{141, -160}, {160, -160}, {160, -108}, {178, -108}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-360, -180}, {360, 180}})));
end SclReferenceCurrent;
