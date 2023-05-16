within Dynawo.Examples.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model GeneratorSynchronousThreeWindingsInterfaces "Synchronous generator with real interfaces (inputs, outputs)"
  import Modelica;
  import Dynawo;

  extends Dynawo.Examples.BaseClasses.InitializedGeneratorSynchronousThreeWindings;

  //Input variables
  Modelica.Blocks.Interfaces.RealInput efdPu_in annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmPu_in annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput omegaPu_out annotation(
    Placement(visible = true, transformation(origin = {-10, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput PGenPu_out annotation(
    Placement(visible = true, transformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput omegaRefPu_out annotation(
    Placement(visible = true, transformation(origin = {30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput IRotorPu_out annotation(
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-90, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UPu_out annotation(
    Placement(visible = true, transformation(origin = {-90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput UStatorPu_out annotation(
    Placement(visible = true, transformation(origin = {-32, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-30, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  PmPu.value = PmPu_in;
  efdPu.value = efdPu_in;
  omegaPu_out = omegaPu.value;
  PGenPu_out = PGenPu;
  omegaRefPu_out = omegaRefPu.value;
  IRotorPu_out = IRotorPu.value;
  UPu_out = UPu;
  UStatorPu_out = UStatorPu.value;

  annotation(preferredView = "text");
end GeneratorSynchronousThreeWindingsInterfaces;
