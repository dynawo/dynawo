within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

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

model Ac78c_INIT "IEEE exciter types AC7C and AC8C initialization model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.Ac16c_INIT;

  //Regulation parameters
  parameter Types.PerUnit Kc1 "Rectifier loading factor proportional to commutating reactance (exciter)";
  parameter Types.PerUnit Ki "Potential circuit (current) gain coefficient";
  parameter Types.PerUnit Kp "Potential source gain";
  parameter Boolean Sw1 "If true, power source derived from terminal voltage, if false, independent from terminal voltage";
  parameter Types.Angle Thetap "Potential circuit phase angle in rad";
  parameter Types.PerUnit XlPu "Reactance associated with potential source in pu (base SNom, UNom)";

  //Input parameters
  Modelica.ComplexBlocks.Interfaces.ComplexInput it0Pu "Initial complex current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput ut0Pu "Initial complex voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));

  //Output parameter
  Modelica.Blocks.Interfaces.RealOutput Vb0Pu "Initial available exciter field voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));

  Modelica.Blocks.Math.Product productInit annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.RectifierRegulationCharacteristic rectifierRegulationCharacteristicInit annotation(
    Placement(visible = true, transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1Init(k = Kc1) annotation(
    Placement(visible = true, transformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division divisionInit annotation(
    Placement(visible = true, transformation(origin = {30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpressionInit(y = Efe0Pu) annotation(
    Placement(visible = true, transformation(origin = {-90, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstantInit(k = Sw1) annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchInit annotation(
    Placement(visible = true, transformation(origin = {-30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.PotentialCircuit potentialCircuitInit(Ki = Ki, Kp = Kp, Theta = Thetap, X = XlPu) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1Init(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-90, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(divisionInit.y, rectifierRegulationCharacteristicInit.u) annotation(
    Line(points = {{41, 40}, {58, 40}}, color = {0, 0, 127}));
  connect(gain1Init.y, divisionInit.u1) annotation(
    Line(points = {{-19, 80}, {0, 80}, {0, 46}, {18, 46}}, color = {0, 0, 127}));
  connect(rectifierRegulationCharacteristicInit.y, productInit.u1) annotation(
    Line(points = {{81, 40}, {100, 40}, {100, 6}, {118, 6}}, color = {0, 0, 127}));
  connect(productInit.y, Vb0Pu) annotation(
    Line(points = {{141, 0}, {169, 0}}, color = {0, 0, 127}));
  connect(realExpressionInit.y, gain1Init.u) annotation(
    Line(points = {{-79, 80}, {-42, 80}}, color = {0, 0, 127}));
  connect(ut0Pu, potentialCircuitInit.uT) annotation(
    Line(points = {{-160, 20}, {-120, 20}, {-120, 4}, {-102, 4}}, color = {85, 170, 255}));
  connect(it0Pu, potentialCircuitInit.iT) annotation(
    Line(points = {{-160, -20}, {-120, -20}, {-120, -4}, {-102, -4}}, color = {85, 170, 255}));
  connect(potentialCircuitInit.vE, switchInit.u1) annotation(
    Line(points = {{-78, 0}, {-60, 0}, {-60, -32}, {-42, -32}}, color = {0, 0, 127}));
  connect(booleanConstantInit.y, switchInit.u2) annotation(
    Line(points = {{-78, -40}, {-42, -40}}, color = {255, 0, 255}));
  connect(const1Init.y, switchInit.u3) annotation(
    Line(points = {{-78, -80}, {-60, -80}, {-60, -48}, {-42, -48}}, color = {0, 0, 127}));
  connect(switchInit.y, divisionInit.u2) annotation(
    Line(points = {{-18, -40}, {0, -40}, {0, 34}, {18, 34}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-140, -100}, {160, 100}})));
end Ac78c_INIT;
