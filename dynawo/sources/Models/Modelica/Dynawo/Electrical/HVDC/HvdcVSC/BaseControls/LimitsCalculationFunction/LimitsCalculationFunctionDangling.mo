within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.LimitsCalculationFunction;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model LimitsCalculationFunctionDangling "Reactive and active currents limits calculation function for the HVDC VSC model that connects two different synchronous areas"

  import Modelica;
  import Dynawo.Types;

  parameter Types.PerUnit IpMaxCstPu "Maximum value of the active current in p.u (base SNom, UNom)";
  parameter Types.CurrentModulePu InPu "Nominal current in p.u (base SNom, UNom)";

  Modelica.Blocks.Interfaces.RealInput iqModPu(start = 0) "Additional reactive current in case of fault or overvoltage in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-60,-120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput ipRefPu(start = Ip0Pu) "Active current reference in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqRefPu(start = Iq0Pu) "Reactive current reference in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {0,-120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput IqMaxPu(start = sqrt(InPu ^ 2 - Ip0Pu ^ 2)) "Max reactive current reference in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput IqMinPu(start = - sqrt(InPu ^ 2 - Ip0Pu ^ 2)) "Min reactive current reference in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = { -110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput IpMaxPu(start = IpMaxCstPu) "Max active current reference in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 70}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput IpMinPu(start = - IpMaxCstPu) "Min active current reference in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

protected
  parameter Types.PerUnit Ip0Pu "Start value of active current in p.u (base SNom)";
  parameter Types.PerUnit Iq0Pu "Start value of reactive current in p.u (base SNom)";

equation
  if iqModPu == 0 then
    IpMaxPu = IpMaxCstPu;
    IpMinPu = - IpMaxPu;
    IqMaxPu = max(0.001, sqrt(InPu ^ 2 - min(InPu ^ 2, ipRefPu ^ 2)));
    IqMinPu = - IqMaxPu;
  else
    IpMaxPu = max(0.001, sqrt(InPu ^ 2 - min(InPu ^ 2, iqRefPu ^ 2)));
    IpMinPu = - IpMaxPu;
    IqMaxPu = InPu;
    IqMinPu = - IqMaxPu;
  end if;

  annotation(preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end LimitsCalculationFunctionDangling;
