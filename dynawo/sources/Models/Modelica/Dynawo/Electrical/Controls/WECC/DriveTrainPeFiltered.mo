within Dynawo.Electrical.Controls.WECC;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model DriveTrainPeFiltered "Drive train control with a mechanical power derived from filtered electrical power"
  extends BaseControls.BaseDriveTrain;

  parameter Types.Time tP "Filter time constant for mechanical power calculation in seconds (typical:0.01..0.02)";

  Modelica.Blocks.Continuous.FirstOrder Pmech(T = tP, y_start = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-170, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  connect(PePu, Pmech.u) annotation(
    Line(points = {{-214, -54}, {-170, -54}, {-170, -8}}, color = {0, 0, 127}));
  connect(Pmech.y, TorqueM.u1) annotation(
    Line(points = {{-170, 16}, {-170, 54}, {-162, 54}}, color = {0, 0, 127}));

  annotation(Documentation(info = "<html>
    <p> This block contains the updated drive train model for generic WECC WTG type 4 model according to (in case page cannot be found, copy link in browser): <br><a href=\"https://www.wecc.org/Administrative/Memo%20RES%20Modeling%20Updates-%20Pourbeik.pdf\" >https://www.wecc.org/Administrative/Memo%20RES%20Modeling%20Updates-%20Pourbeik.pdf</a> </p>
    <p> This model is a simplified model for the purpose of emulating the behavior of torsional mode oscillations. The shaft damping coefficient (Dshaft) in the drive-train model is fitted to capture the net damping of the torsional mode seen in the post fault electrical power response. In the actual equipment, the drive train oscillations are damped through filtered signals and active damping controllers, which obviously are significantly different from the simple generic two mass drive train model used here. Therefore, the
    parameters (and variables) of this simple drive-train model cannot necessarily be compared with
    actual physical quantities directly. </p>
    <p>In this updated version B of the drive train, the mechanical power is derived from the electrical power by filtering with first order delay. </p></html>"));
end DriveTrainPeFiltered;
