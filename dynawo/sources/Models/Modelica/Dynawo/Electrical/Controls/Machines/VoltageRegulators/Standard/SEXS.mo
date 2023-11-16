within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com) and UPC/Citcea (https://www.citcea.upc.edu/)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SEXS "IEEE Automatic Voltage Regulator type SEXS (Simplified excitation system)"

  parameter Types.PerUnit K "Controller gain";
  parameter Types.Time Ta "Filter derivative time constant in s";
  parameter Types.Time Tb "Filter delay time constant in s";
  parameter Types.Time Te "Exciter time constant in s";
  parameter Types.VoltageModulePu EMin "Controller minimum output in pu (base UNom)";
  parameter Types.VoltageModulePu EMax "Controller maximum output in pu (base UNom)";
  parameter Types.VoltageModulePu Upss0Pu = 0 "Initial PSS output voltage in pu (base UNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Control voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-114, 40}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-114, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UpssPu(start = Upss0Pu) "PSS output voltage (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-114, -40}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-120, -62}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) " Voltage output un pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(tFilter = Te, K = K, YMax = EMax, YMin = EMin, Y0 = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction leadLag(a = {Tb, 1}, b = {Ta, 1}, x_scaled(start = {Efd0Pu / K}), x_start = {Efd0Pu / K}, y_start = Efd0Pu / K) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu Efd0Pu "Initial voltage output in pu (base UNom)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UsRef0Pu "Initial control voltage in pu (base UNom)";

equation
  connect(UpssPu, add3.u3) annotation(
    Line(points = {{-114, -40}, {-70, -40}, {-70, -8}, {-62, -8}}, color = {0, 0, 127}));
  connect(UsPu, add3.u2) annotation(
    Line(points = {{-114, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(UsRefPu, add3.u1) annotation(
    Line(points = {{-114, 40}, {-70, 40}, {-70, 8}, {-62, 8}}, color = {0, 0, 127}));
  connect(add3.y, leadLag.u) annotation(
    Line(points = {{-38, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(leadLag.y, limitedFirstOrder.u) annotation(
    Line(points = {{11, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, EfdPu) annotation(
    Line(points = {{61, 0}, {110, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    uses(Modelica(version = "3.2.3")),
  Documentation(info = "<html><head></head><body>The simplified excitation system SEXS (<u>CIM name</u>: ExcSEXS) is a simplified version of the IEEE AC4A excitation system, defined in the IEEE Std 421.5-2005 \"IEEE Recommended Practice for Excitation System Models for Power System Stabilities\" document in the chapter 6.4.&nbsp;</body></html>"));
end SEXS;
