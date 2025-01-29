within Dynawo.Electrical.Wind.IEC.BaseClasses;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/
      
partial model BaseWTCurrentSource2020 "Base for Wind Turbine Types 3 and 4 model from IEC 61400-27-1:2020 standard : measurement, PLL, protection, PControl, QControl, limiters, electrical, generator and mechanical modules"
  
  // Parameter imports
  //QControl parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.QControlWTBase;
  extends Dynawo.Electrical.Wind.IEC.Parameters.QControlWT2020;
  //Measurement parameters for control
  extends Dynawo.Electrical.Wind.IEC.Parameters.GridMeasurementControl;
  //Measurement parameters for protection
  extends Dynawo.Electrical.Wind.IEC.Parameters.GridMeasurementProtection;
  extends Dynawo.Electrical.Wind.IEC.Parameters.TableCurrentLimit;
  extends Dynawo.Electrical.Wind.IEC.Parameters.TableGridProtection;
  extends Dynawo.Electrical.Wind.IEC.Parameters.TableQLimit;
  extends Dynawo.Electrical.Wind.IEC.Parameters.SNom_;
  extends Dynawo.Electrical.Wind.IEC.Parameters.Circuit;
  extends Dynawo.Electrical.Wind.IEC.Parameters.Pll;
  extends Dynawo.Electrical.Wind.IEC.Parameters.CurrentLimiter;
  extends Dynawo.Electrical.Wind.IEC.Parameters.QLimiter;
  extends Dynawo.Electrical.Wind.IEC.Parameters.GridProtection;
  extends Dynawo.Electrical.Wind.IEC.Parameters.IntegrationTimeStep;
  
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
 
  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Grid terminal, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialComplexUiGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialIGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialGenSystem;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialPqGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialQLimits;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialQSetpoint;
  
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.Measurements protectionMeasurements(DfMaxPu = DfpMaxPu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, tIFilt = tIpFilt, tPFilt = tPpFilt, tQFilt = tQpFilt, tS = tS, tUFilt = tUpFilt, tfFilt = tfpFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {60, 80}, extent = {{20, 20}, {-20, -20}}, rotation = 90)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.Measurements controlMeasurements(DfMaxPu = DfcMaxPu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, tIFilt = tIcFilt, tPFilt = tPcFilt, tQFilt = tQcFilt, tS = tS, tUFilt = tUcFilt, tfFilt = tfcFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.GridProtection2020 gridProtection(U0Pu = U0Pu, UOverPu = UOverPu, UUnderPu = UUnderPu, fOverPu = fOverPu, fUnderPu = fUnderPu, TabletUoverUwtfilt = TabletUoverUwtfilt, TabletUoverUwtfilt11 = TabletUoverUwtfilt11, TabletUoverUwtfilt12 = TabletUoverUwtfilt12, TabletUoverUwtfilt21 = TabletUoverUwtfilt21, TabletUoverUwtfilt22 = TabletUoverUwtfilt22, TabletUoverUwtfilt31 = TabletUoverUwtfilt31, TabletUoverUwtfilt32 = TabletUoverUwtfilt32, TabletUoverUwtfilt41 = TabletUoverUwtfilt41, TabletUoverUwtfilt42 = TabletUoverUwtfilt42, TabletUoverUwtfilt51 = TabletUoverUwtfilt51, TabletUoverUwtfilt52 = TabletUoverUwtfilt52, TabletUoverUwtfilt61 = TabletUoverUwtfilt61, TabletUoverUwtfilt62 = TabletUoverUwtfilt62, TabletUoverUwtfilt71 = TabletUoverUwtfilt71, TabletUoverUwtfilt72 = TabletUoverUwtfilt72, TabletUoverUwtfilt81 = TabletUoverUwtfilt81, TabletUoverUwtfilt82 = TabletUoverUwtfilt82, TabletUunderUwtfilt = TabletUunderUwtfilt, TabletUunderUwtfilt11 = TabletUunderUwtfilt11, TabletUunderUwtfilt12 = TabletUunderUwtfilt12, TabletUunderUwtfilt21 = TabletUunderUwtfilt21, TabletUunderUwtfilt22 = TabletUunderUwtfilt22, TabletUunderUwtfilt31 = TabletUunderUwtfilt31, TabletUunderUwtfilt32 = TabletUunderUwtfilt32, TabletUunderUwtfilt41 = TabletUunderUwtfilt41, TabletUunderUwtfilt42 = TabletUunderUwtfilt42, TabletUunderUwtfilt51 = TabletUunderUwtfilt51, TabletUunderUwtfilt52 = TabletUunderUwtfilt52, TabletUunderUwtfilt61 = TabletUunderUwtfilt61, TabletUunderUwtfilt62 = TabletUunderUwtfilt62, TabletUunderUwtfilt71 = TabletUunderUwtfilt71, TabletUunderUwtfilt72 = TabletUunderUwtfilt72, Tabletfoverfwtfilt = Tabletfoverfwtfilt, Tabletfoverfwtfilt11 = Tabletfoverfwtfilt11, Tabletfoverfwtfilt12 = Tabletfoverfwtfilt12, Tabletfoverfwtfilt21 = Tabletfoverfwtfilt21, Tabletfoverfwtfilt22 = Tabletfoverfwtfilt22, Tabletfoverfwtfilt31 = Tabletfoverfwtfilt31, Tabletfoverfwtfilt32 = Tabletfoverfwtfilt32, Tabletfoverfwtfilt41 = Tabletfoverfwtfilt41, Tabletfoverfwtfilt42 = Tabletfoverfwtfilt42, Tabletfunderfwtfilt = Tabletfunderfwtfilt, Tabletfunderfwtfilt11 = Tabletfunderfwtfilt11, Tabletfunderfwtfilt12 = Tabletfunderfwtfilt12, Tabletfunderfwtfilt21 = Tabletfunderfwtfilt21, Tabletfunderfwtfilt22 = Tabletfunderfwtfilt22, Tabletfunderfwtfilt31 = Tabletfunderfwtfilt31, Tabletfunderfwtfilt32 = Tabletfunderfwtfilt32, Tabletfunderfwtfilt41 = Tabletfunderfwtfilt41, Tabletfunderfwtfilt42 = Tabletfunderfwtfilt42, Tabletfunderfwtfilt51 = Tabletfunderfwtfilt51, Tabletfunderfwtfilt52 = Tabletfunderfwtfilt52, Tabletfunderfwtfilt61 = Tabletfunderfwtfilt61, Tabletfunderfwtfilt62 = Tabletfunderfwtfilt62) annotation(
    Placement(visible = true, transformation(origin = {60, 20}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));

equation
  connect(omegaRefPu, protectionMeasurements.omegaRefPu) annotation(
    Line(points = {{0, 130}, {0, 116}, {48, 116}, {48, 102}}, color = {0, 0, 127}));
  connect(omegaRefPu, controlMeasurements.omegaRefPu) annotation(
    Line(points = {{0, 130}, {0, 116}, {-68, 116}, {-68, 102}}, color = {0, 0, 127}));
  connect(protectionMeasurements.omegaFiltPu, gridProtection.omegaFiltPu) annotation(
    Line(points = {{44, 58}, {44, 50}, {52, 50}, {52, 42}}, color = {0, 0, 127}));
  connect(protectionMeasurements.UFiltPu, gridProtection.UWTPFiltPu) annotation(
    Line(points = {{56, 58}, {56, 50}, {68, 50}, {68, 42}}, color = {0, 0, 127}));
  connect(controlMeasurements.UPu, pll.UWTPu) annotation(
    Line(points = {{-80, 58}, {-80, 52}, {-52, 52}, {-52, 102}, {-28, 102}, {-28, 98}}, color = {0, 0, 127}));
  connect(controlMeasurements.theta, pll.theta) annotation(
    Line(points = {{-68, 58}, {-68, 54}, {-54, 54}, {-54, 104}, {-12, 104}, {-12, 98}}, color = {0, 0, 127}));
  
  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-1.5, 47}, extent = {{-66.5, 32}, {66.5, -32}}, textString = "IEC WT 2020")}),
  Diagram(coordinateSystem(extent = {{-120, -120}, {120, 120}})));
end BaseWTCurrentSource2020;
