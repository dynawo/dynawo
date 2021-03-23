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

model DCbusIdcSource

/*
Equivalent circuit and conventions:
                       __________
IdcSourcePu     IdcPu |          |
-------->-------->----|          |----> Pconv (AC)
              |       |          |
      UdcPu (Cdc)     |  DC/AC   |
              |       |          |
              |       |  Ploss   | Ploss=ConvFixLoss+ConvVarLoss*Idc
----------------------|__________|
Pdc=Pconv + Ploss
*/

  import Modelica;
  import Dynawo.Types;

  parameter Types.PerUnit ConvFixLossPu "Converter fix losses in pu (base SNom), such that PlossPu=ConvFixLossPu+Plvar";
  parameter Types.PerUnit ConvVarLossPu "Converter variable losses in pu (base UNom, SNom), such that Plvar=ConvVarLossPu*Idc";
  parameter Types.PerUnit Cdc           "DC bus capacitance in pu (base UNom, SNom)";
  parameter Types.PerUnit Udc0Pu  "Start value of the DC bus voltage in pu (base UNom)";
  parameter Types.PerUnit IdcSource0Pu  "Start value of the DC source current in pu (base UNom, SNom)";

  Modelica.Blocks.Interfaces.BooleanInput running(start = true) annotation(
        Placement(visible = true, transformation(origin = {-70, 40}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput IdcSourcePu(start = IdcSource0Pu) "DC source current in pu  (base UNom, SNom)" annotation(
        Placement(visible = true, transformation(origin = {-70, -40}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PConvPu(start = IdcSource0Pu*Udc0Pu) "Active Power at converter side, before filter (base SNom)" annotation(
        Placement(visible = true, transformation(origin = {-70.5, -0.5}, extent = {{-15.5, -15.5}, {15.5, 15.5}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UdcPu(start = Udc0Pu) "DC bus voltage in pu (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {79.5, -0.5}, extent = {{-15.5, -15.5}, {15.5, 15.5}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));

  Types.PerUnit IdcPu(start = IdcSource0Pu) "DC Current entering the converter in pu (base UNom, SNom)";
  Types.PerUnit PlossPu(start = ConvFixLossPu + ConvVarLossPu*abs(IdcSource0Pu)) "Converter losses in pu (base SNom)";

equation

  if running then

    /* DC Side Voltage */
    Cdc * der(UdcPu) = IdcSourcePu - IdcPu;

    /* Power Conservation */
    PConvPu = UdcPu * IdcPu - PlossPu;

    /* Converter losses */
    PlossPu= ConvFixLossPu + ConvVarLossPu*abs(IdcPu);

  else

    IdcPu = 0;
    UdcPu = 0;
    PlossPu = 0;

  end if;

annotation(
        preferredView = "text",
        Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
        Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {5, 6}, extent = {{-66, 43}, {54, -55}}, textString = "DC")}));

end DCbusIdcSource;
