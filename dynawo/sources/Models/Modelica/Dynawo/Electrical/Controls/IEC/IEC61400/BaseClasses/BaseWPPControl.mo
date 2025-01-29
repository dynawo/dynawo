within Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BaseWPPControl "Base control model for IEC N°61400-27-1 standard WPP"
  extends Dynawo.Electrical.Wind.IEC.Parameters.TablePControl;

  //Nominal parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.SNom_;
  extends Dynawo.Electrical.Wind.IEC.Parameters.IntegrationTimeStep;

  //PControl parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.PControlWPP;
  
  //QControl parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.QControlWPP;
  
  //Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput iPu(re(start = -i0Pu.re * SystemBase.SnRef / SNom), im(start = -i0Pu.im * SystemBase.SnRef / SNom)) "Complex current at grid terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-200, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWPRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Reference active power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-200, 86}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput y(start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = false, transformation(origin = {-8, -56}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));

  //Initial parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialComplexUiGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialPqGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialQSetpointWPP;
  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-65, 110}, extent = {{-35, 26}, {167, -132}}, textString = "WP control and"), Text(origin = {-68, 58}, extent = {{-36, 28}, {172, -140}}, textString = "communication"), Text(origin = {-23, -64}, extent = {{-41, 26}, {87, -6}}, textString = "module")}),
  Diagram(coordinateSystem(extent = {{-180, -120}, {180, 120}})));
end BaseWPPControl;
