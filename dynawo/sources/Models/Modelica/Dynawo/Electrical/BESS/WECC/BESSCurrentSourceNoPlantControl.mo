within Dynawo.Electrical.BESS.WECC;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BESSCurrentSourceNoPlantControl "WECC BESS with electrical control model type C and generator/converter model type A (without plant control)"
  extends Dynawo.Electrical.BESS.WECC.BaseClasses.BaseBESSCurrentSource;

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PInjRefPu(start = PInj0Pu) "Active power setpoint at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QInjRefPu(start = QInj0Pu) "Reactive power setpoint at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(PInjRefPu, reecC.PInjRefPu) annotation(
    Line(points = {{-190, 20}, {-160, 20}, {-160, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(QInjRefPu, reecC.QInjRefPu) annotation(
    Line(points = {{-190, -20}, {-160, -20}, {-160, -6}, {-91, -6}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end BESSCurrentSourceNoPlantControl;
