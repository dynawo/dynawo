within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.DCLine;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model DCLine "DC line model"
  /*
    Equivalent circuit and conventions:

             I1dcPu                   I2dcPu
     U1dcPu ----<------------RdcPu------->----U2dcPu
     P1Pu               |           |         P2Pu
                      CdcPu       CdcPu
                        |           |
                       ---         ---
  */
  import Modelica;
  import Dynawo.Electrical.HVDC;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_DCLine;
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  Modelica.Blocks.Interfaces.RealInput P1Pu(start = P10Pu) "Active power at terminal 1 in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput P2Pu(start = P20Pu) "Active power at terminal 2 in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput U1dcPu(start = U1dc0Pu) "DC Voltage at terminal 1 in pu (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-73, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput U2dcPu(start = U2dc0Pu) "DC Voltage at terminal 2 in pu (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {67, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu U1dc0Pu "Start value of dc voltage at terminal 1 in pu (base UdcNom)";
  parameter Types.ActivePowerPu P20Pu "Start value of active power at terminal 2 in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu U2dc0Pu "Start value of dc voltage at terminal 2 in pu (base UdcNom)";

protected
  Types.PerUnit I1dcPu(start = P10Pu * (SNom / SystemBase.SnRef) / U1dc0Pu) "DC current at terminal 1 in pu (base SnRef, UdcNom)";
  Types.PerUnit I2dcPu(start = P20Pu * (SNom / SystemBase.SnRef) / U2dc0Pu) "DC current at terminal 2 in pu (base SnRef, UdcNom)";

equation
  I1dcPu = P1Pu * (SNom / SystemBase.SnRef) / U1dcPu;
  I2dcPu = P2Pu * (SNom / SystemBase.SnRef) / U2dcPu;
  CdcPu * der(U2dcPu) = (1 / RdcPu) * (U1dcPu - U2dcPu) - I2dcPu;
  CdcPu * der(U1dcPu) = (1 / RdcPu) * (U2dcPu - U1dcPu) - I1dcPu;

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end DCLine;
