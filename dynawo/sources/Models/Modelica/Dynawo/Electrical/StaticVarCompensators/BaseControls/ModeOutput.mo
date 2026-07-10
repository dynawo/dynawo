within Dynawo.Electrical.StaticVarCompensators.BaseControls;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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

connector ModeOutput = output Mode "Static VAR compensator mode as output connector" annotation(
    defaultComponentName="y",
    Icon(coordinateSystem(
      preserveAspectRatio=true,
      extent={{-100,-100},{100,100}}), graphics={Polygon(
        points={{-100,100},{100,0},{-100,-100},{-100,100}},
        lineColor={255,127,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
      preserveAspectRatio=true,
      extent={{-100,-100},{100,100}}), graphics={Polygon(
        points={{-100,50},{0,0},{-100,-50},{-100,50}},
        lineColor={255,127,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{30,110},{30,60}},
        lineColor={255,127,0},
        textString="%name")}),
    Documentation(info="<html>
    <p>
    Connector with one output signal of type Mode (OFF, STANDBY or RUNNING_V).
    </p>
    </html>"));
