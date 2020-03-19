within Dynawo.Electrical.HVDC.Standard.DCLine;

model DCLine "DC line model"
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
  /*
    Equivalent circuit and conventions:

             I1dcPu                   I2dcPu
     U1dcPu ----<------------RdcPu------->----U2dcPu
                        |           |
                      CdcPu       CdcPu
                        |           |
                       ---         ---
  */

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit RdcPu "DC line resistance in p.u (base UNom, SNom)";
  parameter Types.PerUnit CdcPu "DC line capacitance in p.u (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput P1Pu(start = P10Pu) "Active power in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput P2Pu(start = P20Pu) "Active power in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput U1dcPu(start = U1dc0Pu) "DC Voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput U2dcPu(start = U2dc0Pu) "DC Voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.ActivePowerPu P10Pu;
  parameter Types.ActivePowerPu P20Pu;
  parameter Types.VoltageModulePu U1dc0Pu;
  parameter Types.VoltageModulePu U2dc0Pu;

equation

  CdcPu * der(U2dcPu) = (1 / RdcPu) * (U1dcPu - U2dcPu) - P2Pu / U2dcPu;
  CdcPu * der(U1dcPu) = (1 / RdcPu) * (U2dcPu - U1dcPu) - P1Pu / U1dcPu;

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1}))
    ,
  experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.002),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));

end DCLine;
