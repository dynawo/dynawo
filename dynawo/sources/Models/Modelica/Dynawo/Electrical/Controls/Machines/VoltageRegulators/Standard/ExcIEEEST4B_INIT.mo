within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
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

model ExcIEEEST4B_INIT "IEEE exciter type ST4B initialization model"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;

  extends AdditionalIcons.Init;

  //Regulation parameters
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance (>= 0). Typical value = 0.113";
  parameter Types.PerUnit Ki "Potential circuit gain coefficient applied to Real part of complex stator current (>= 0). Typical value = 0";
  parameter Types.PerUnit Kp "Potential circuit gain coefficient. Typical value = 9.3";
  parameter Types.Angle Thetap "Potential circuit phase angle. Typical value = 0";
  parameter Types.PerUnit XlPu "Reactance associated with potential source (>= 0) in pu (base SNom, UNom). Typical value = 0.124";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput Ifd0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-140, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput it0Pu "Initial complex current in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-140, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput ut0Pu "Initial complex voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-140, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput Ub0Pu "Initial voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {104, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.PotentialCircuit potentialCircuitInit(Ki = Ki, Kp = Kp, Theta = Thetap, X = XlPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product productInit annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.RectifierRegulationCharacteristic rectifierRegulationCharacteristicInit annotation(
    Placement(visible = true, transformation(origin = {30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1Init(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division divisionInit annotation(
    Placement(visible = true, transformation(origin = {-10, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

equation
  connect(productInit.y, Ub0Pu) annotation(
    Line(points = {{101, 0}, {130, 0}}, color = {0, 0, 127}));
  connect(potentialCircuitInit.vE, productInit.u1) annotation(
    Line(points = {{-60, 40}, {60, 40}, {60, 6}, {78.2, 6}}, color = {0, 0, 127}));
  connect(it0Pu, potentialCircuitInit.iT) annotation(
    Line(points = {{-140, 0}, {-100, 0}, {-100, 36}, {-82, 36}}, color = {85, 170, 255}));
  connect(ut0Pu, potentialCircuitInit.uT) annotation(
    Line(points = {{-140, 80}, {-100, 80}, {-100, 44}, {-82, 44}}, color = {85, 170, 255}));
  connect(rectifierRegulationCharacteristicInit.y, productInit.u2) annotation(
    Line(points = {{41, -40}, {60, -40}, {60, -6}, {77, -6}}, color = {0, 0, 127}));
  connect(divisionInit.y, rectifierRegulationCharacteristicInit.u) annotation(
    Line(points = {{1, -40}, {18, -40}}, color = {0, 0, 127}));
  connect(gain1Init.y, divisionInit.u1) annotation(
    Line(points = {{-59, -80}, {-40, -80}, {-40, -46}, {-23, -46}}, color = {0, 0, 127}));
  connect(potentialCircuitInit.vE, divisionInit.u2) annotation(
    Line(points = {{-60, 40}, {-40, 40}, {-40, -34}, {-21.8, -34}}, color = {0, 0, 127}));
  connect(Ifd0Pu, gain1Init.u) annotation(
    Line(points = {{-140, -80}, {-82, -80}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-120, -100}, {120, 100}})));
end ExcIEEEST4B_INIT;
