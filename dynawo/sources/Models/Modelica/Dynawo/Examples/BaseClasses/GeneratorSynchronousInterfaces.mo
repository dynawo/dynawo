within Dynawo.Examples.BaseClasses;

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

model GeneratorSynchronousInterfaces "Synchronous generator with real interfaces (inputs, outputs)"
  extends Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous;

  //Input variables
  Modelica.Blocks.Interfaces.RealInput efdPu_in annotation(
    Placement(visible = true, transformation(origin = {-60, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-60, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PmPu_in annotation(
    Placement(visible = true, transformation(origin = {60, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {60, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput IRotorPu_out annotation(
    Placement(visible = true, transformation(origin = {40, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {40, 90},extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput iStatorPu_out annotation(
    Placement(visible = true, transformation(origin = {-40, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-40, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu_out annotation(
    Placement(visible = true, transformation(origin = {90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{80, -40}, {100, -20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PGenPu_out annotation(
    Placement(visible = true, transformation(origin = {90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{80, 40}, {100, 60}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QGenPu_out annotation(
    Placement(visible = true, transformation(origin = {90, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{80, 0}, {100, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uPu_out annotation(
    Placement(visible = true, transformation(origin = {-80, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-80, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput UsPu_out annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{80, 80}, {100, 100}}, rotation = 0)));

equation
  PmPu.value = PmPu_in;
  efdPu.value = efdPu_in;
  UsPu_out = UStatorPu.value;
  omegaPu_out = omegaPu.value;
  PGenPu_out = PGenPu;
  QGenPu_out = QGenPu;
  uPu_out = uPu;
  iStatorPu_out = iStatorPu;
  IRotorPu_out = IRotorPu.value;

  annotation(preferredView = "text");
end GeneratorSynchronousInterfaces;
