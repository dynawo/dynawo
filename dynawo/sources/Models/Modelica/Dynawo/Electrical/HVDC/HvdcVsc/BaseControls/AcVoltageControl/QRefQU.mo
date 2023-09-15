within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.AcVoltageControl;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model QRefQU "Function that calculates QRef for the Q mode and the U mode depending on the setpoints for URef and QRef"
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsQRefQU;

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput iqModNeg(start = true) "If true, additional reactive current is negative" annotation(
    Placement(visible = true, transformation(origin = {-220, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = Q0Pu) "Reactive power in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-220, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefLimPu(start = Q0Pu) "Limited reference reactive power in pu (base SNom) (DC to AC) after applying the diagrams" annotation(
    Placement(visible = true, transformation(origin = {220, -80}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {120, -40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = Q0Pu) "Reference reactive power in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-220, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage module in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = U0Pu + LambdaPu * Q0Pu) "Reference voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput QRefQPu(start = Q0Pu) "Reference reactive power in Q mode in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {210, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QRefUPu(start = Q0Pu) "Reference reactive power in U mode in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-140, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = LambdaPu) annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Rising = SlopeURefPu, y(start = U0Pu + LambdaPu * Q0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-170, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter1(Rising = SlopeQRefPu, y(start = Q0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-170, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = KpAc) annotation(
    Placement(visible = true, transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-30, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = KiAc, y_start = Q0Pu) annotation(
    Placement(visible = true, transformation(origin = {70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {160, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-30, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SNom) (DC to AC)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in pu (base UNom)";

equation
  connect(feedback.y, feedback1.u1) annotation(
    Line(points = {{-131, 40}, {-88, 40}}, color = {0, 0, 127}));
  connect(QPu, gain.u) annotation(
    Line(points = {{-220, -80}, {-122, -80}}, color = {0, 0, 127}));
  connect(gain.y, feedback1.u2) annotation(
    Line(points = {{-99, -80}, {-80, -80}, {-80, 32}}, color = {0, 0, 127}));
  connect(QRefPu, slewRateLimiter1.u) annotation(
    Line(points = {{-220, 80}, {-183, 80}, {-183, 80}, {-182, 80}}, color = {0, 0, 127}));
  connect(slewRateLimiter1.y, QRefQPu) annotation(
    Line(points = {{-159, 80}, {210, 80}}, color = {0, 0, 127}));
  connect(URefPu, slewRateLimiter.u) annotation(
    Line(points = {{-220, 40}, {-182, 40}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, feedback.u1) annotation(
    Line(points = {{-159, 40}, {-148, 40}}, color = {0, 0, 127}));
  connect(UPu, feedback.u2) annotation(
    Line(points = {{-220, 0}, {-140, 0}, {-140, 32}}, color = {0, 0, 127}));
  connect(feedback1.y, add1.u1) annotation(
    Line(points = {{-71, 40}, {-60, 40}, {-60, 26}, {-42, 26}}, color = {0, 0, 127}));
  connect(feedback2.y, add1.u2) annotation(
    Line(points = {{151, -80}, {-60, -80}, {-60, 14}, {-42, 14}}, color = {0, 0, 127}));
  connect(add1.y, switch.u1) annotation(
    Line(points = {{-18, 20}, {0, 20}, {0, -12}, {18, -12}}, color = {0, 0, 127}));
  connect(feedback1.y, gain1.u) annotation(
    Line(points = {{-70, 40}, {58, 40}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{82, 40}, {100, 40}, {100, 6}, {118, 6}}, color = {0, 0, 127}));
  connect(switch.y, integrator.u) annotation(
    Line(points = {{42, -20}, {58, -20}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{82, -20}, {100, -20}, {100, -6}, {118, -6}}, color = {0, 0, 127}));
  connect(add.y, QRefUPu) annotation(
    Line(points = {{142, 0}, {210, 0}}, color = {0, 0, 127}));
  connect(add.y, feedback2.u2) annotation(
    Line(points = {{142, 0}, {160, 0}, {160, -72}}, color = {0, 0, 127}));
  connect(QRefLimPu, feedback2.u1) annotation(
    Line(points = {{220, -80}, {168, -80}}, color = {0, 0, 127}));
  connect(const.y, switch.u3) annotation(
    Line(points = {{-18, -60}, {0, -60}, {0, -28}, {18, -28}}, color = {0, 0, 127}));
  connect(iqModNeg, switch.u2) annotation(
    Line(points = {{-220, -40}, {-140, -40}, {-140, -20}, {18, -20}}, color = {255, 0, 255}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end QRefQU;
