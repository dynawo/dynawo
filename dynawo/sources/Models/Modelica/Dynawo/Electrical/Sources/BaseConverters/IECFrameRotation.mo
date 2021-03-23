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

model IECFrameRotation

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle UPhase0 "Start value of voltage angle at plan terminal (PCC) in radians" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));

  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-100, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput theta(start = UPhase0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {-100, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, -90}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

  /*Ouputs*/
  Modelica.Blocks.Interfaces.RealOutput iGsRePu(start = (-P0Pu * SystemBase.SnRef / (SNom * U0Pu))*cos(UPhase0) - (Q0Pu * SystemBase.SnRef / (SNom * U0Pu))*sin(UPhase0)) "Real component of the current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {100, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iGsImPu(start = (-P0Pu * SystemBase.SnRef / (SNom * U0Pu))*sin(UPhase0) + (Q0Pu * SystemBase.SnRef / (SNom * U0Pu))*cos(UPhase0)) "Imaginary component of the current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {100, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  //
equation
  /*Reference frame transformation*/
  [iGsRePu; iGsImPu] = [cos(theta), -sin(theta); sin(theta), cos(theta)] * [ipCmdPu; iqCmdPu];
  annotation(
    Diagram(coordinateSystem(extent = {{-80, -100}, {80, 100}})),
    Icon(coordinateSystem(extent = {{-30, -100}, {30, 100}}, initialScale = 0.1), graphics = {Rectangle(origin = {1, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-31, 100}, {29, -102}}), Text(origin = {46, 57}, rotation = 90, extent = {{-148, 127}, {34, -33}}, textString = "Reference Frame Rotation")}));
end IECFrameRotation;
