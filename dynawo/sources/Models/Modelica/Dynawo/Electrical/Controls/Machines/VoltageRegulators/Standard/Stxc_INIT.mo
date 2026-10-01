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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model Stxc_INIT "IEEE exciter types ST4C, ST6C and ST9C initialization model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Exciter_INIT;

  //Regulation parameters
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance";
  parameter Types.PerUnit Ki "Potential circuit (current) gain coefficient";
  parameter Types.PerUnit Kp "Potential circuit gain";
  parameter Boolean Sw1 "If true, power source derived from terminal voltage, if false, independent from terminal voltage";
  parameter Types.Angle Thetap "Potential circuit phase angle in rad";
  parameter Types.VoltageModulePu VbMaxPu "Maximum available exciter field voltage in pu (base UNom)";
  parameter Types.PerUnit XlPu "Reactance associated with potential source in pu (base SNom, UNom)";

  //Input parameters
  Modelica.Blocks.Interfaces.RealInput Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-220, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput it0Pu "Initial complex current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput ut0Pu "Initial complex voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));

  //Output parameter
  Modelica.Blocks.Interfaces.RealOutput Vb0Pu "Initial available exciter field voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));

  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.PotentialCircuit potentialCircuitInit(Ki = Ki, Kp = Kp, Theta = Thetap, X = XlPu) annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.Min2 min1Init annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constInit(k = VbMaxPu) annotation(
    Placement(visible = true, transformation(origin = {90, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.RectifierRegulationCharacteristic rectifierRegulationCharacteristicInit annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division divisionInit annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1Init annotation(
    Placement(visible = true, transformation(origin = {90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1Init(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {-130, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1Init(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-130, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchInit annotation(
    Placement(visible = true, transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstantInit(k = Sw1) annotation(
    Placement(visible = true, transformation(origin = {-130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1Init(k = true) annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(rectifierRegulationCharacteristicInit.y, product1Init.u1) annotation(
    Line(points = {{41, 0}, {60, 0}, {60, -14}, {78, -14}}, color = {0, 0, 127}));
  connect(product1Init.y, min1Init.u2) annotation(
    Line(points = {{101, -20}, {120, -20}, {120, -6}, {138, -6}}, color = {0, 0, 127}));
  connect(divisionInit.y, rectifierRegulationCharacteristicInit.u) annotation(
    Line(points = {{1, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(constInit.y, min1Init.u1) annotation(
    Line(points = {{101, 40}, {120, 40}, {120, 6}, {138, 6}}, color = {0, 0, 127}));
  connect(ut0Pu, potentialCircuitInit.uT) annotation(
    Line(points = {{-220, 40}, {-160, 40}, {-160, 6}, {-142, 6}}, color = {85, 170, 255}));
  connect(it0Pu, potentialCircuitInit.iT) annotation(
    Line(points = {{-220, -40}, {-160, -40}, {-160, -6}, {-142, -6}}, color = {85, 170, 255}));
  connect(Ir0Pu, gain1Init.u) annotation(
    Line(points = {{-220, 80}, {-142, 80}}, color = {0, 0, 127}));
  connect(gain1Init.y, divisionInit.u1) annotation(
    Line(points = {{-119, 80}, {-40, 80}, {-40, 6}, {-22, 6}}, color = {0, 0, 127}));
  connect(booleanConstantInit.y, switchInit.u2) annotation(
    Line(points = {{-119, -40}, {-82, -40}}, color = {255, 0, 255}));
  connect(const1Init.y, switchInit.u3) annotation(
    Line(points = {{-119, -80}, {-100, -80}, {-100, -48}, {-82, -48}}, color = {0, 0, 127}));
  connect(potentialCircuitInit.vE, switchInit.u1) annotation(
    Line(points = {{-119, 0}, {-100, 0}, {-100, -32}, {-83, -32}}, color = {0, 0, 127}));
  connect(switchInit.y, divisionInit.u2) annotation(
    Line(points = {{-59, -40}, {-40, -40}, {-40, -6}, {-23, -6}}, color = {0, 0, 127}));
  connect(switchInit.y, product1Init.u2) annotation(
    Line(points = {{-59, -40}, {60, -40}, {60, -26}, {77, -26}}, color = {0, 0, 127}));
  connect(min1Init.y, Vb0Pu) annotation(
    Line(points = {{162, 0}, {190, 0}}, color = {0, 0, 127}));
  connect(booleanConstant1Init.y, potentialCircuitInit.running) annotation(
    Line(points = {{-178, 0}, {-142, 0}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-200, -100}, {180, 100}})));
end Stxc_INIT;
