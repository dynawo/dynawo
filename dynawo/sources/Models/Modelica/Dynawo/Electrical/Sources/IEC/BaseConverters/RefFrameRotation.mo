within Dynawo.Electrical.Sources.IEC.BaseConverters;

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

model RefFrameRotation "Reference frame rotation module (IEC N°61400-27-1)"
  extends Dynawo.Electrical.Wind.IEC.Parameters.SNom_;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialIGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialPqGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGrid;
   
  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput theta(start = UPhase0) "Phase shift between the converter and the grid rotating frames in rad" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, -90}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput iGsImPu(start = IGsIm0Pu) "Imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iGsRePu(start = IGsRe0Pu) "Real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));

equation
  [iGsRePu; iGsImPu] = [cos(theta), -sin(theta); sin(theta), cos(theta)] * [ipCmdPu; iqCmdPu];

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(extent = {{-30, -100}, {30, 100}}, initialScale = 0.1), graphics = {Rectangle(origin = {1, 1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-31, 99}, {29, -101}}), Text(origin = {52, 58}, rotation = 90, extent = {{-141, 127}, {38, -33}}, textString = "Reference Frame Rotation")}));
end RefFrameRotation;
