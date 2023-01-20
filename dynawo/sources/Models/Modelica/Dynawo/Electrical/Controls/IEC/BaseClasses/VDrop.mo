within Dynawo.Electrical.Controls.IEC.BaseClasses;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block VDrop "Calculates the voltage in the serial impedance distance r+jx from the grid terminal"

/*
  Equivalent circuit and conventions:

      i                                PPu
    --<--------RDropPu+jXDropPu--------<--
          |                        |   QPu
          |                        |
       UDropPu                    UPu
*/
  import Modelica;
  import Dynawo.Types;

  //VDrop parameters
  parameter Types.PerUnit RDropPu "Resistive component of voltage drop impedance in pu (base SNom, UNom)" annotation(
    Dialog(tab = "VDrop"));
  parameter Types.PerUnit XDropPu "Inductive component of voltage drop impedance in pu (base SNom, UNom)" annotation(
    Dialog(tab = "VDrop"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) "Active power at grid terminal in pu (base SNom) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = Q0Pu) "Reactive power at grid terminal in pu (base SNom) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput UDropPu(start = UDrop0Pu) "Calculated voltage amplitude at the point of control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SNom) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SNom) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));

  final parameter Types.VoltageModulePu UDrop0Pu = sqrt((U0Pu - RDropPu * P0Pu / U0Pu - XDropPu * Q0Pu / U0Pu) ^ 2 + (XDropPu * P0Pu / U0Pu - RDropPu * Q0Pu / U0Pu) ^ 2) "Initial voltage amplitude at the point of control in pu (base UNom)";

equation
  UDropPu = sqrt((UPu - RDropPu * PPu / UPu - XDropPu * QPu / UPu) ^ 2 + (XDropPu * PPu / UPu - RDropPu * QPu / UPu) ^ 2);

  annotation(
    preferredView = "text",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-23, 23}, extent = {{-61, 49}, {107, -91}}, textString = "Voltage Drop")}));
end VDrop;
