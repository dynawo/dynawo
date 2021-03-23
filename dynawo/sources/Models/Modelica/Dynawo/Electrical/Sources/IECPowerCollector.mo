within Dynawo.Electrical.Sources;

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

model IECPowerCollector

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.PerUnit Rpc "Electrical system serial resistance in pu (base UNom, SNom)" annotation(
  Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Xpc "Electrical system serial reactance in pu (base UNom, SNom)" annotation(
  Dialog(group = "group", tab = "Electrical"));

  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle UPhase0 "Start value of voltage angle at plan terminal (PCC) in radians" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));

  /*Parameters for internal initialization*/
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in pu (base UNom)";
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.PerUnit UGsRe0Pu "Start value of the real component of the voltage at the converter's terminals (generator system) in pu (base UNom)";
  parameter Types.PerUnit UGsIm0Pu "Start value of the imaginary component of the voltage at the converter's terminals (generator system) in pu (base UNom)";
  parameter Types.PerUnit IGsRe0Pu "Start value of the real component of the current at the converter's terminals (generator system) in pu (Ubase, SNom) (generator convention)";
  parameter Types.PerUnit IGsIm0Pu "Start value of the imaginary component of the current at the converter's terminals (generator system) in pu (Ubase, SNom) (generator convention)";

  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput uWtRePu(start = u0Pu.re) "Real component of the voltage at the wind turbine terminals (electrical system) in pu (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { -110, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput uWtImPu(start = u0Pu.im) "Imaginary component of the voltage at the wind turbine terminals (electrical system) in pu (base UNom) " annotation(
    Placement(visible = true, transformation(origin = {-110, 29}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { -110, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));

  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput iWtRePu(start = -i0Pu.re* SystemBase.SnRef / SNom) "Real component of the current at the wind turbine terminals in pu (Ubase, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {-100, -31}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { -110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iWtImPu(start = -i0Pu.im* SystemBase.SnRef / SNom) "Imaginary component of the current at the wind turbine terminals in pu (Ubase, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {-100, -69}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { -110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  /*Blocks*/
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the converter to the grid" annotation(
        Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {106, -6.66134e-16}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

equation

    iWtRePu = -terminal.i.re * (SystemBase.SnRef / SNom);

    iWtImPu = -terminal.i.im * (SystemBase.SnRef / SNom);

    max(terminal.V.re, 0.001) = uWtRePu - Rpc * iWtRePu + Xpc * iWtImPu;

    terminal.V.im = uWtImPu - Rpc * iWtImPu - Xpc * iWtRePu;

annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(origin = {1, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-101, 101}, {99, -99}}), Text(origin = {-39, 1}, extent = {{129, -107}, {-45, 41}}, textString = "Collection"), Text(origin = {-45, 71}, extent = {{95, -71}, {-5, -9}}, textString = "Power")}));

end IECPowerCollector;
