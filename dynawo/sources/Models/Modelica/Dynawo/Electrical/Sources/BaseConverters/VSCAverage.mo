within Dynawo.Electrical.Sources.BaseConverters;

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

model VSCAverage

/*
Equivalent circuit and conventions:
 __________
|          |iConvPu & PConvPu               iPccPu
|          |---->---(Rfilter,Lfilter)---------->--
|                                           |
|  DC/AC   |  uConvPu         uFilterPu (Cfilter)
|          |                                |
|          |                                |
|__________|--------------------------------------

*/

  import Modelica;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit Rfilter       "Converter filter resistance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Lfilter       "Converter filter inductance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Cfilter       "Converter filter capacitance in p.u (base UNom, SNom)";

  parameter Types.PerUnit UdFilter0Pu   "Start value of the d-axis voltage at the converter terminal (filter) in p.u (base UNom)";
  parameter Types.PerUnit UdConv0Pu     "Start value of the d-axis converter modulated voltage in p.u (base UNom)";
  parameter Types.PerUnit UqConv0Pu     "Start value of the q-axis converter modulated voltage in p.u (base UNom)";
  parameter Types.PerUnit IdConv0Pu     "Start value of the d-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu     "Start value of the q-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IdPcc0Pu      "Start value of the d-axis current injected at the PCC in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu      "Start value of the q-axis current injected at the PCC in p.u (base UNom, SNom) (generator convention)";

  Modelica.Blocks.Interfaces.BooleanInput running(start = true) annotation(
        Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(origin = {-80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter angular frequency in p.u (base OmegaNom)" annotation(
        Placement(visible = true, transformation(origin = {-69, -30}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udConvPu(start = UdConv0Pu) "d-axis converter modulated voltage in p.u (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {-70, 50}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(origin = {-40, -111}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqConvPu(start = UqConv0Pu) "q-axis converter modulated voltage in p.u (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(origin = {43, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current injected at the PCC in p.u (base UNom, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {-70.5, 9.5}, extent = {{-15.5, -15.5}, {15.5, 15.5}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current injected at the PCC in p.u (base UNom, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {-70, -10}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(origin = {-110, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter terminal (filter) in p.u (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {74.5, 54.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0), iconTransformation(origin = {-110.5, 79.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterPu(start = 0) "q-axis voltage at the converter terminal (filter) in p.u (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {74.5, 34.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0), iconTransformation(origin = {-110.5, 39.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput idConvPu(start = IdConv0Pu) "d-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {75, 15}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {38, 110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = IqConv0Pu) "q-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {75, 0}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {78, 110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput PConvPu(start = UdConv0Pu * IdConv0Pu + UqConv0Pu * IqConv0Pu) "Active Power at converter side, before filter (generator convention) (base SNom)" annotation(
        Placement(visible = true, transformation(origin = {74.5, -15.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PFilterPu(start = UdFilter0Pu * IdConv0Pu) "Active Power at converter terminal, after filter  (generator convention) (base SNom)" annotation(
        Placement(visible = true, transformation(origin = {74, -35}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-39, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput QFilterPu(start =-UdFilter0Pu * IqConv0Pu) "Rective Power at converter terminal, after filter  (generator convention) (base SNom)" annotation(
        Placement(visible = true, transformation(origin = {74, -55}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));

  Types.PerUnit QConvPu(start = UqConv0Pu * IdConv0Pu - UdConv0Pu * IqConv0Pu) "Reactive Power at converter side, before filter (generator convention) (base SNom)";
  Types.PerUnit UFilterPu(start = UdFilter0Pu) "Module of the voltage at converter terminal, after filter (base UNom)";
  Types.PerUnit IConvPu(start = sqrt(IdConv0Pu ^ 2 + IqConv0Pu ^ 2)) "Module of the valve current (before filter) in p.u (base UNom, SNom)";

equation

  if running then

    /* RLC Filter */
    Cfilter / SystemBase.omegaNom * der(udFilterPu) = idConvPu + omegaPu * Cfilter * uqFilterPu - idPccPu;
    Cfilter / SystemBase.omegaNom * der(uqFilterPu) = iqConvPu - omegaPu * Cfilter * udFilterPu - iqPccPu;
    Lfilter / SystemBase.omegaNom * der(idConvPu) = udConvPu - Rfilter * idConvPu + omegaPu * Lfilter * iqConvPu - udFilterPu;
    Lfilter / SystemBase.omegaNom * der(iqConvPu) = uqConvPu - Rfilter * iqConvPu - omegaPu * Lfilter * idConvPu - uqFilterPu;

    /* Converter Power in p.u. (base SNom) */
    PConvPu = udConvPu * idConvPu + uqConvPu * iqConvPu;
    QConvPu = uqConvPu * idConvPu - udConvPu * iqConvPu;
    PFilterPu = udFilterPu * idConvPu + uqFilterPu * iqConvPu;
    QFilterPu = uqFilterPu * idConvPu - udFilterPu * iqConvPu;

    /* Converter terminal voltage module in p.u. (base UNom) */
    UFilterPu = sqrt(udFilterPu ^ 2 + uqFilterPu ^ 2);

    /* Valve current module in p.u. (base UNom, SNom) */
    IConvPu = sqrt(idConvPu ^ 2 + iqConvPu ^ 2);

  else

    udFilterPu = 0;
    uqFilterPu = 0;
    idConvPu = 0;
    iqConvPu = 0;
    PConvPu = 0;
    QConvPu = 0;
    PFilterPu = 0;
    QFilterPu = 0;
    UFilterPu = 0;
    IConvPu = 0;

  end if;

annotation(
        preferredView = "text",
        Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
        Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {1, -1}, extent = {{-70, 64}, {68, -64}}, textString = "VSC")}));

end VSCAverage;
