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
    Placement(visible = true, transformation(origin = {-180, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput it0Pu "Initial complex current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput ut0Pu "Initial complex voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));

  //Output parameter
  Modelica.Blocks.Interfaces.RealOutput Vb0Pu "Initial available exciter field voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));

  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.PotentialCircuit potentialCircuitInit(Ki = Ki, Kp = Kp, Theta = Thetap, X = XlPu) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min1Init annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constInit(k = VbMaxPu) annotation(
    Placement(visible = true, transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.RectifierRegulationCharacteristic rectifierRegulationCharacteristicInit annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1Init annotation(
    Placement(visible = true, transformation(origin = {70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1Init(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1Init(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchInit annotation(
    Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstantInit(k = Sw1) annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(rectifierRegulationCharacteristicInit.y, product1Init.u1) annotation(
    Line(points = {{21, 0}, {40, 0}, {40, -14}, {58, -14}}, color = {0, 0, 127}));
  connect(product1Init.y, min1Init.u2) annotation(
    Line(points = {{81, -20}, {100, -20}, {100, -6}, {118, -6}}, color = {0, 0, 127}));
  connect(constInit.y, min1Init.u1) annotation(
    Line(points = {{81, 40}, {100, 40}, {100, 6}, {118, 6}}, color = {0, 0, 127}));
  connect(ut0Pu, potentialCircuitInit.uT) annotation(
    Line(points = {{-180, 20}, {-140, 20}, {-140, 4}, {-122, 4}}, color = {85, 170, 255}));
  connect(it0Pu, potentialCircuitInit.iT) annotation(
    Line(points = {{-180, -20}, {-140, -20}, {-140, -4}, {-122, -4}}, color = {85, 170, 255}));
  connect(Ir0Pu, gain1Init.u) annotation(
    Line(points = {{-180, 60}, {-122, 60}}, color = {0, 0, 127}));
  connect(gain1Init.y, rectifierRegulationCharacteristicInit.u1) annotation(
    Line(points = {{-99, 60}, {-20, 60}, {-20, 6}, {-2, 6}}, color = {0, 0, 127}));
  connect(booleanConstantInit.y, switchInit.u2) annotation(
    Line(points = {{-99, -40}, {-62, -40}}, color = {255, 0, 255}));
  connect(const1Init.y, switchInit.u3) annotation(
    Line(points = {{-99, -80}, {-80, -80}, {-80, -48}, {-62, -48}}, color = {0, 0, 127}));
  connect(potentialCircuitInit.vE, switchInit.u1) annotation(
    Line(points = {{-99, 0}, {-80, 0}, {-80, -32}, {-63, -32}}, color = {0, 0, 127}));
  connect(switchInit.y, rectifierRegulationCharacteristicInit.u2) annotation(
    Line(points = {{-39, -40}, {-20, -40}, {-20, -6}, {-2, -6}}, color = {0, 0, 127}));
  connect(switchInit.y, product1Init.u2) annotation(
    Line(points = {{-39, -40}, {40, -40}, {40, -26}, {58, -26}}, color = {0, 0, 127}));
  connect(min1Init.y, Vb0Pu) annotation(
    Line(points = {{141, 0}, {170, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})));
end Stxc_INIT;
