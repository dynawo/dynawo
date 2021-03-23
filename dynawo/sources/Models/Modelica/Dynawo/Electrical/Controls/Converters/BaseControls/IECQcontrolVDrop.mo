within Dynawo.Electrical.Controls.Converters.BaseControls;

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

block IECQcontrolVDrop

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  /*Control parameters*/
  parameter Types.PerUnit RDrop "Resistive component of voltage drop impedance in pu (base SNom, UNom)";
  parameter Types.PerUnit XDrop "Reactive component of voltage drop impedance in pu (base SNom, UNom)";

  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ActivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)";

  /*Parameters for internal initialization*/
  final parameter Types.PerUnit Uint0 = sqrt((U0Pu + RDrop * P0Pu * SystemBase.SnRef / (U0Pu * SNom) + XDrop * Q0Pu * SystemBase.SnRef / (U0Pu * SNom))^2 + (XDrop * P0Pu * SystemBase.SnRef / (U0Pu * SNom) - RDrop * Q0Pu * SystemBase.SnRef / (U0Pu * SNom))^2) "Initial value of the voltage at the point of control of WT in pu (base UNom)";

  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput pWTCfiltPu(start = -P0Pu * SystemBase.SnRef / SNom) "Filtered active power at PCC in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qWTCfiltPu(start = -Q0Pu * SystemBase.SnRef/SNom) "Filtered reactive power at PCC in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uWTCfiltPu(start = U0Pu) "Filtered voltage amplitude at wind turbine terminals in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput uWTCfiltDropPu(start = Uint0) "Calculated voltage at the point of control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {120, 4.44089e-16}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  uWTCfiltDropPu = sqrt((uWTCfiltPu - RDrop * pWTCfiltPu / uWTCfiltPu - XDrop * qWTCfiltPu / uWTCfiltPu)^2 + (XDrop * pWTCfiltPu / uWTCfiltPu - RDrop * qWTCfiltPu / uWTCfiltPu)^2);

annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-23, 23}, extent = {{-61, 49}, {107, -91}}, textString = "Voltage Droop")}));

end IECQcontrolVDrop;
