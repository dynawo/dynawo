within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.DcLine;

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

model DcLine "DC line model"
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsDcLine;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput P1Pu(start = P10Pu) "Active power at terminal 1 in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput P2Pu(start = P20Pu) "Active power at terminal 2 in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput UDc1Pu(start = UDc10Pu) "DC voltage at terminal 1 in pu (base UDcNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput UDc2Pu(start = UDc20Pu) "DC voltage at terminal 2 in pu (base UDcNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = 1, uMin = -1);
  Modelica.Blocks.Nonlinear.Limiter limiter2(uMax = 1, uMin = -1);

  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SNom) (DC to AC)";
  parameter Types.ActivePowerPu P20Pu "Start value of active power at terminal 2 in pu (base SNom) (DC to AC)";
  parameter Types.VoltageModulePu UDc10Pu "Start value of DC voltage at terminal 1 in pu (base UDcNom)";
  parameter Types.VoltageModulePu UDc20Pu "Start value of DC voltage at terminal 2 in pu (base UDcNom)";

protected
  Types.CurrentModulePu IDc1Pu(start = P10Pu * (SNom / SystemBase.SnRef) / UDc10Pu) "DC current at terminal 1 in pu (base SnRef, UDcNom) (DC to AC)";
  Types.CurrentModulePu IDc2Pu(start = P20Pu * (SNom / SystemBase.SnRef) / UDc20Pu) "DC current at terminal 2 in pu (base SnRef, UDcNom) (DC to AC)";

equation
  IDc1Pu = P1Pu * (SNom / SystemBase.SnRef) / UDc1Pu;
  IDc2Pu = P2Pu * (SNom / SystemBase.SnRef) / UDc2Pu;

  limiter1.u = (UDc2Pu - UDc1Pu) / (2 * RDcPu) - IDc1Pu;
  limiter2.u = (UDc1Pu - UDc2Pu) / (2 * RDcPu) - IDc2Pu;

  CDcPu * der(UDc1Pu) = limiter1.y;
  CDcPu * der(UDc2Pu) = limiter2.y;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
<pre><span>Equivalent circuit and conventions:</span></pre>
<pre><br></pre>
<pre><span>             IDc1Pu                   IDc2Pu</span></pre>
<pre>     UDc1Pu ----&lt;----------2*RDcPu-------&gt;----UDc2Pu</span></pre>
<pre>     P1Pu               |           |         P2Pu</span></pre>
<pre>                      CDcPu       CDcPu</span></pre>
<pre>                        |           |</span></pre>
<pre><span>                       ---         ---</span></pre></body></html>"));
end DcLine;
