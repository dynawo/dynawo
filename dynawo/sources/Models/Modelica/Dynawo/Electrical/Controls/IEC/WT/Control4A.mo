within Dynawo.Electrical.Controls.IEC.WT;

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

model Control4A "Whole generator control module for type 4A wind turbines (IEC N°61400-27-1)"
  import Dynawo;
  import Dynawo.Types;

  extends Dynawo.Electrical.Controls.IEC.BaseClasses.BaseControl4;

  //PControl parameters
  parameter Types.PerUnit DPMaxP4APu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMax4APu "Maximum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMin4APu "Minimum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Boolean MpUScale "Voltage scaling for power reference during voltage dip (true: u scaling, false: no scaling)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit Kpaw "Antiwindup gain for the integrator of the ramp-limited first order" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4A "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPWTRef4A "Reference power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.VoltageModulePu UpDipPu "Voltage threshold to activate voltage scaling for power reference during voltage dip in pu (base UNom)" annotation(
    Dialog(tab = "PControl"));

  Dynawo.Electrical.Controls.IEC.BaseControls.WT.PControl4A pControl4A(DPMaxP4APu = DPMaxP4APu, DPRefMax4APu = DPRefMax4APu, DPRefMin4APu = DPRefMin4APu, IpMax0Pu = IpMax0Pu, Kpaw = Kpaw, MpUScale = MpUScale, P0Pu = P0Pu, SNom = SNom, U0Pu = U0Pu, UpDipPu = UpDipPu, tPOrdP4A = tPOrdP4A, tPWTRef4A = tPWTRef4A) annotation(
    Placement(visible = true, transformation(origin = {20, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  connect(PWTRefPu, pControl4A.PWTRefPu) annotation(
    Line(points = {{-180, 140}, {-100, 140}, {-100, 112}, {-2, 112}}, color = {0, 0, 127}));
  connect(UWTCPu, pControl4A.UWTCPu) annotation(
    Line(points = {{-180, 60}, {-80, 60}, {-80, 104}, {-2, 104}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, pControl4A.UWTCFiltPu) annotation(
    Line(points = {{-180, 20}, {-60, 20}, {-60, 96}, {-2, 96}}, color = {0, 0, 127}));
  connect(pControl4A.ipCmdPu, currentLimiter.ipCmdPu) annotation(
    Line(points = {{42, 100}, {60, 100}, {60, 16}, {78, 16}}, color = {0, 0, 127}));
  connect(currentLimiter.ipMaxPu, pControl4A.ipMaxPu) annotation(
    Line(points = {{122, 12}, {140, 12}, {140, 60}, {-20, 60}, {-20, 88}, {-2, 88}}, color = {0, 0, 127}));
  connect(pControl4A.ipCmdPu, ipCmdPu) annotation(
    Line(points = {{42, 100}, {170, 100}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {-16, 31}, extent = {{-76, -18}, {92, 28}}, textString = "IEC WT 4A"), Text(origin = {-11, -34}, extent = {{-77, -16}, {100, 30}}, textString = "Generator Control")}),
    Diagram(coordinateSystem(extent = {{-160, -160}, {160, 160}})));
end Control4A;
