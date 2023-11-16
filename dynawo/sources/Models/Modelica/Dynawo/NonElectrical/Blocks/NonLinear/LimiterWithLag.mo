within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

block LimiterWithLag "Limiter that enforces saturations only after they were violated without interruption during a certain amount of time. No lag when switching from saturated to non saturated mode though"
  import Modelica.Constants;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends Modelica.Blocks.Icons.Block;

  parameter Real UMin "Minimum allowed u";
  parameter Real UMax "Maximum allowed u";
  parameter Types.Time LagMin "Time lag before taking action when going below uMin";
  parameter Types.Time LagMax "Time lag before taking action when going above uMax";

  Modelica.Blocks.Interfaces.RealInput u(start = u0) "Input signal connector" annotation(Placement(
        transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y(start = y0) "Output signal connector" annotation(Placement(
        transformation(extent={{100,-10},{120,10}})));

  discrete Types.Time tUMinReached(start = tUMinReached0) "Last time when u went below EfdMin";
  discrete Types.Time tUMaxReached(start = tUMaxReached0) "Last time when u went above EfdMax";

  parameter Real u0 "Initial input";
  parameter Real y0 "Initial output";
  parameter Types.Time tUMinReached0 "Initial time when u went below UMin";
  parameter Types.Time tUMaxReached0 "Initial time when u went above UMax";

  Boolean initSaturatedMin(start = (tUMinReached0 == - Constants.inf) ) "Whether we start in min saturated mode. Boolean used to prevent the model from resetting tUMinReached when in saturated mode at the beginning of the simulation";
  Boolean initSaturatedMax(start = (tUMaxReached0 == - Constants.inf) ) "Whether we start in max saturated mode. Boolean used to prevent the model from resetting tUMaxReached when in saturated mode at the beginning of the simulation";

equation
  y = if (time - tUMinReached >= LagMin) then UMin else if (time - tUMaxReached >= LagMax) then UMax else u;

  // Assessing that u is within limits
  when (u < UMin) then
    tUMinReached = if initSaturatedMin then - Constants.inf else time; // If we start in saturated state, tUMinReached should not be reset to time at time = 0 because we assume that u crossed UMin a long time ago
    initSaturatedMin = false; // For the next when triggerings, back to classic behaviour
  elsewhen (u >= UMin) then
    tUMinReached = Constants.inf;
    initSaturatedMin = false;
  end when;

  when (u > UMax) then
    tUMaxReached = if initSaturatedMax then - Constants.inf else time; // If we start in saturated state, tUMaxReached should not be reset to time at time = 0 because we assume that u crossed UMax a long time ago
    initSaturatedMax = false; // For the next when triggerings, back to classic behaviour
  elsewhen (u <= UMax) then
    tUMaxReached = Constants.inf;
    initSaturatedMax = false;
  end when;

  annotation(preferredView = "text",
    Icon(coordinateSystem(
      preserveAspectRatio=true,
      extent={{-100,-100},{100,100}}), graphics={
      Line(points={{-80,-56},{-60,-56},{-60,-22},{38,-22},{38,-56},{66,-56}},color={0,0,192}),
      Line(points={{-80,32},{18,32},{18,66},{38,66},{38,32},{66,32}},color={0,192,0}),
      Line(points={{0,-90},{0,68}}, color={192,192,192}),
      Polygon(
        points={{0,90},{-8,68},{8,68},{0,90}},
        lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-90,0},{68,0}}, color={192,192,192}),
      Polygon(
        points={{90,0},{68,-8},{68,8},{90,0}},
        lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-80,-70},{-50,-70},{50,70},{80,70}}),
      Text(
        extent={{-150,-150},{150,-110}},
        lineColor={0,0,0},
        textString="uMax=%uMax"),
      Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
      Line(
        visible=strict,
        points={{50,70},{80,70}},
        color={255,0,0}),
      Line(
        visible=strict,
        points={{-80,-70},{-50,-70}},
        color={255,0,0})}),
    Diagram(coordinateSystem(
      preserveAspectRatio=true,
      extent={{-100,-100},{100,100}}), graphics={
      Line(points={{0,-60},{0,50}}, color={192,192,192}),
      Polygon(
        points={{0,60},{-5,50},{5,50},{0,60}},
        lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-60,0},{50,0}}, color={192,192,192}),
      Polygon(
        points={{60,0},{50,-5},{50,5},{60,0}},
        lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-50,-40},{-30,-40},{30,40},{50,40}}),
      Text(
        extent={{46,-6},{68,-18}},
        lineColor={128,128,128},
        textString="u"),
      Text(
        extent={{-30,70},{-5,50}},
        lineColor={128,128,128},
        textString="y"),
      Text(
        extent={{58,-54},{28,-42}},
        lineColor={128,128,128},
        textString="%delayTimes s"),
      Text(
        extent={{-58,-54},{-28,-42}},
        lineColor={128,128,128},
        textString="uMin"),
      Text(
        extent={{26,40},{66,56}},
        lineColor={128,128,128},
        textString="uMax")}));
end LimiterWithLag;
