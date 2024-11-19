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

partial model BaseWT "Base model for Wind Turbine Type 4 from IEC 61400-27-1 standard"
  
  // Parameter imports
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.CurrentLimitParameters;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.GridProtectionParameters;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.QLimitParameters;
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.Nominal;
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.Circuit;
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.GenSystem4;
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.Pll;
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.ControlP;
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.CurrentLimiter;
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.ControlQ;
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.QLimiter;
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.GridProtection;
  // Nominal Parameters
  parameter Types.Time tS "Integration time step in s";
  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Grid terminal, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

//Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference frame for grid angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {0, 130}, extent = {{10, -10}, {-10, 10}}, rotation = 90), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWTRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tanPhi(start = Q0Pu / P0Pu) "Tangent phi (can be figured as QPu / PPu)" annotation(
    Placement(visible = true, transformation(origin = {-130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput xWTRefPu(start = XWT0Pu) "Reactive power loop reference : reactive power or voltage reference depending on the Q control mode (MqG), in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -19.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.PLL pll(U0Pu = U0Pu, UPhase0 = UPhase0, UPll1Pu = UPll1Pu, UPll2Pu = UPll2Pu, tPll = tPll, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-20, 76}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));

//Initial parameters
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.InitialUiGrid;
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.InitialIGs;
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.InitialGenSystem;
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.InitialPqGrid;
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.InitialUGrid;
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.InitialUGs;
  
  parameter Types.ReactivePowerPu QMax0Pu "Initial maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu QMin0Pu "Initial minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit XWT0Pu "Initial reactive power or voltage reference at grid terminal in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  
  replaceable Dynawo.Electrical.Sources.IEC.BaseConverters.WTInjector_base injector() annotation(
    Placement(visible = true, transformation(origin = {20, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  connect(injector.terminal, terminal) annotation(
    Line(points = {{42, -40}, {130, -40}}, color = {0, 0, 255}));
  connect(pll.thetaPll, injector.theta) annotation(
    Line(points = {{-20, 54}, {-20, 0}, {8, 0}, {8, -18}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-1.5, -1}, extent = {{-66.5, 32}, {66.5, -32}}, textString = "IEC WT4")}),
  Diagram(coordinateSystem(extent = {{-120, -120}, {120, 120}})));
end BaseWT;
