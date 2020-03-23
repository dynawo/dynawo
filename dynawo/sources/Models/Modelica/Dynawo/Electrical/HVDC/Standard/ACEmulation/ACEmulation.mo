within Dynawo.Electrical.HVDC.Standard.ACEmulation;

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

model ACEmulation "AC Emulation for HVDC"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.Time tFilter "Time constant of the angle measurement filter";
  parameter Types.PerUnit KACEmulation "Inverse of the emulated AC reactance";

  Modelica.ComplexBlocks.Interfaces.ComplexInput u1Pu(re(start = u10Pu.re), im(start = u10Pu.im)) annotation(
    Placement(visible = true, transformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput u2Pu(re(start = u20Pu.re), im(start = u20Pu.im)) annotation(
    Placement(visible = true, transformation(origin = {-120, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefSetPu(start = PRefSet0Pu) "Raw reference active power in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput PRefPu(start = P0Pu) "Reference active power in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  Types.Angle Theta1 (start = Modelica.Math.atan2(u10Pu.im,u10Pu.re)) "Voltage angle at terminal 1 in rad";
  Types.Angle ThetaFiltered1 (start = Modelica.Math.atan2(u10Pu.im,u10Pu.re)) "Filtered voltage angle at terminal 1 in rad";
  Types.Angle Theta2 (start = Modelica.Math.atan2(u20Pu.im,u20Pu.re)) "Voltage angle at terminal 2 in rad";
  Types.Angle ThetaFiltered2 (start = Modelica.Math.atan2(u20Pu.im,u20Pu.re)) "Filtered voltage angle at terminal 2 in rad";
  parameter Types.ComplexVoltagePu u10Pu;
  parameter Types.ComplexVoltagePu u20Pu;
  parameter Types.ActivePowerPu P0Pu;
  parameter Types.ActivePowerPu PRefSet0Pu;

equation

  Theta1 = Modelica.Math.atan2(u1Pu.im,u1Pu.re);
  tFilter * der(ThetaFiltered1) = Theta1 - ThetaFiltered1;
  PRefPu = PRefSetPu + KACEmulation*(ThetaFiltered1 - ThetaFiltered2);
  Theta2 = Modelica.Math.atan2(u2Pu.im,u2Pu.re);
  tFilter * der(ThetaFiltered2) = Theta2 - ThetaFiltered2;

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end ACEmulation;
