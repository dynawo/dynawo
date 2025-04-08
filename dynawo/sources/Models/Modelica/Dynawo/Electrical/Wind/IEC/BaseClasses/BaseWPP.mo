within Dynawo.Electrical.Wind.IEC.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BaseWPP "Base model for Wind Power Plants from IEC 61400-27-1 standard"
  extends Dynawo.Electrical.Wind.IEC.Parameters.TableCurrentLimit;
  extends Dynawo.Electrical.Wind.IEC.Parameters.TableGridProtection;
  extends Dynawo.Electrical.Wind.IEC.Parameters.TablePControl;
  extends Dynawo.Electrical.Wind.IEC.Parameters.TableQLimit;

  //Nominal parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.SNom_;
  extends Dynawo.Electrical.Wind.IEC.Parameters.IntegrationTimeStep;

  //Circuit parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.Circuit;
    
  //PLL parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.Pll;
  
  //Current limiter parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.CurrentLimiter;
  
  //WT QControl parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.QControlWTBase;
  
  //QLimiter parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.QLimiter;
  
  //Grid protection parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.GridProtection;
  
  //WPP PControl parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.PControlWPP;
  
  //WPP QControl parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.QControlWPP;
  
  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference frame for grid angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-140, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWPRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Reference active power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-140, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tanPhi(start = Q0Pu / P0Pu) "Tangent phi (can be figured as QPu / PPu)" annotation(
    Placement(visible = true, transformation(origin = {-20, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.ElecMeasurements elecMeasurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Initial parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialComplexUiGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialIGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialPqGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialGenSystem;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialQLimits;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialQSetpointWPP;
  
equation
  connect(elecMeasurements.terminal2, terminal) annotation(
    Line(points = {{102, 0}, {130, 0}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-1.5, 39}, extent = {{-66.5, 32}, {66.5, -32}}, textString = "IEC WPP")}),
    Diagram(coordinateSystem(extent = {{-120, -100}, {120, 100}})));
end BaseWPP;
