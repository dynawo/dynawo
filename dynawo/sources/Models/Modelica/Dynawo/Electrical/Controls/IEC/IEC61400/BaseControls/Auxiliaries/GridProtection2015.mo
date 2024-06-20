within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries;

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

model GridProtection2015 "Grid protection system for wind turbines (IEC N°61400-27-1:2015)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseGridProtection;

  //Nominal parameter
  parameter Types.Time tS "Integration time step in s";

  //Uf measurement parameters
  parameter Types.AngularVelocityPu DfMaxPu "Maximum frequency ramp rate in pu/s (base omegaNom)" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Types.Time tfFilt "Filter time constant for frequency measurement in s" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "UfMeasurement"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uWtPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-170, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.UfMeasurement ufMeasurement(DfMaxPu = DfMaxPu, U0Pu = U0Pu, UPhase0 = UPhase0, tS = tS, tUFilt = tUFilt, tfFilt = tfFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-129.5, -1}, extent = {{-10, -90}, {10, 90}}, rotation = 0)));

  //Initial parameters
  parameter Dynawo.Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(omegaRefPu, ufMeasurement.omegaRefPu) annotation(
    Line(points = {{-180, -80}, {-144, -80}}, color = {0, 0, 127}));
  connect(ufMeasurement.UWTFiltPu, lessEqual.u2) annotation(
    Line(points = {{-116, 80}, {-80, 80}, {-80, 132}, {-62, 132}}, color = {0, 0, 127}));
  connect(ufMeasurement.UWTFiltPu, combiTable1D.u) annotation(
    Line(points = {{-116, 80}, {-20, 80}, {-20, 100}, {-2, 100}}, color = {0, 0, 127}));
  connect(ufMeasurement.UWTFiltPu, combiTable1D1.u) annotation(
    Line(points = {{-116, 80}, {-20, 80}, {-20, 60}, {-2, 60}}, color = {0, 0, 127}));
  connect(ufMeasurement.UWTFiltPu, lessEqual1.u1) annotation(
    Line(points = {{-116, 80}, {-80, 80}, {-80, 20}, {-62, 20}}, color = {0, 0, 127}));
  connect(ufMeasurement.omegaGenPu, lessEqual2.u2) annotation(
    Line(points = {{-116, -80}, {-80, -80}, {-80, -28}, {-62, -28}}, color = {0, 0, 127}));
  connect(ufMeasurement.omegaGenPu, combiTable1D2.u) annotation(
    Line(points = {{-116, -80}, {-20, -80}, {-20, -60}, {-2, -60}}, color = {0, 0, 127}));
  connect(ufMeasurement.omegaGenPu, combiTable1D3.u) annotation(
    Line(points = {{-116, -80}, {-20, -80}, {-20, -100}, {-2, -100}}, color = {0, 0, 127}));
  connect(ufMeasurement.omegaGenPu, lessEqual3.u1) annotation(
    Line(points = {{-116, -80}, {-80, -80}, {-80, -140}, {-62, -140}}, color = {0, 0, 127}));
  connect(uWtPu, ufMeasurement.uWTPu) annotation(
    Line(points = {{-170, 80}, {-144, 80}}, color = {85, 170, 255}));

  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {10, 5}, extent = {{-52, 43}, {32, 7}}, textString = "Grid"), Text(origin = {-10, -27}, extent = {{-76, 65}, {98, -71}}, textString = "Protection"), Text(origin = {-14, -73}, extent = {{-76, 20}, {100, -23}}, textString = "2015")}));
end GridProtection2015;
