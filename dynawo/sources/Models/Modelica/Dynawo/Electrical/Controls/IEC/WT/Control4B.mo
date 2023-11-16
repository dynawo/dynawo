within Dynawo.Electrical.Controls.IEC.WT;

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

model Control4B "Whole generator control module for type 4B wind turbines (IEC N°61400-27-1)"
  extends Dynawo.Electrical.Controls.IEC.BaseClasses.BaseControl4;

  //PControl parameters
  parameter Types.PerUnit DPMaxP4BPu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMax4BPu "Maximum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMin4BPu "Minimum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPAero "Aerodynamic power response time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4B "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PAeroPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Aerodynamic power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Dynawo.Electrical.Controls.IEC.BaseControls.WT.PControl4B pControl4B(DPMaxP4BPu = DPMaxP4BPu, DPRefMax4BPu = DPRefMax4BPu, DPRefMin4BPu = DPRefMin4BPu,IpMax0Pu = IpMax0Pu, Kpaw = Kpaw, MpUScale = MpUScale, P0Pu = P0Pu, SNom = SNom, U0Pu = U0Pu, UpDipPu = UpDipPu, tPAero = tPAero, tPOrdP4B = tPOrdP4B, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {20, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  connect(PWTRefPu, pControl4B.PWTRefPu) annotation(
    Line(points = {{-180, 140}, {-100, 140}, {-100, 112}, {-2, 112}}, color = {0, 0, 127}));
  connect(UWTCPu, pControl4B.UWTCPu) annotation(
    Line(points = {{-180, 60}, {-80, 60}, {-80, 104}, {-2, 104}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, pControl4B.UWTCFiltPu) annotation(
    Line(points = {{-180, 20}, {-60, 20}, {-60, 96}, {-2, 96}}, color = {0, 0, 127}));
  connect(currentLimiter.ipMaxPu, pControl4B.ipMaxPu) annotation(
    Line(points = {{122, 12}, {140, 12}, {140, 60}, {-20, 60}, {-20, 88}, {-2, 88}}, color = {0, 0, 127}));
  connect(pControl4B.ipCmdPu, ipCmdPu) annotation(
    Line(points = {{42, 100}, {170, 100}}, color = {0, 0, 127}));
  connect(pControl4B.ipCmdPu, currentLimiter.ipCmdPu) annotation(
    Line(points = {{42, 100}, {60, 100}, {60, 16}, {78, 16}}, color = {0, 0, 127}));
  connect(pControl4B.PAeroPu, PAeroPu) annotation(
    Line(points = {{42, 112}, {60, 112}, {60, 140}, {170, 140}}, color = {0, 0, 127}));
  connect(omegaGenPu, pControl4B.omegaGenPu) annotation(
    Line(points = {{-180, 100}, {-100, 100}, {-100, 108}, {-2, 108}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, -160}, {160, 160}})),
  Icon(graphics = {Text(origin = {75, 31}, extent = {{-76, -18}, {92, 28}}, textString = "B")}));
end Control4B;
