within Dynawo.Electrical.Sources.IEC;

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

model WT3AInjector "Converter model and grid interface according to IEC N°61400-27-1 standard for type 3A
 wind turbines"
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.BaseWTInjector;

  // Control parameters
  parameter Types.PerUnit DipMaxPu "Maximum active current ramp rate in pu/s (base UNom, SNom) (generator convention), example value = 9999 (Type 3A) or = 1 (Type 3B)" annotation(
    Dialog(tab = "genSystem"));
  parameter Types.PerUnit DiqMaxPu "Maximum reactive current ramp rate in pu/s (base UNom, SNom) (generator convention), example value = 9999 (Type 3A) or = 100 (Type 3B)" annotation(
    Dialog(tab = "genSystem"));
  parameter Types.PerUnit KPc "Current PI controller proportional gain, example value = 40" annotation(
    Dialog(tab = "genSystem"));
  parameter Types.Time tIc "Current PI controller integration time constant, example value = 0.02" annotation(
    Dialog(tab = "genSystem"));
  parameter Types.PerUnit XEqv "Transient reactance (should be calculated from the transient inductance as defined in 'New Generic Model of DFG-Based Wind Turbines for RMS-Type Simulation', Fortmann et al., 2014 (base UNom, SNom), example value = 0.4 (Type 3A) or = 10 (Type 3B)" annotation(
    Dialog(tab = "genSystem"));

  Dynawo.Electrical.Sources.IEC.BaseConverters.GenSystem3a genSystem3a(DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, KPc = KPc, XEqv = XEqv, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, tIc = tIc) annotation(
    Placement(visible = true, transformation(origin = {-38, -2.22045e-16}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));

equation
  genSystem3a.running = running.value;

  connect(genSystem3a.terminal, elecSystem.terminal1) annotation(
    Line(points = {{-18, 0}, {18, 0}}, color = {0, 0, 255}));
  connect(fOCB, genSystem3a.fOCB) annotation(
    Line(points = {{40, 110}, {40, 54}, {-30, 54}, {-30, 20}}, color = {255, 0, 255}));
  connect(theta, genSystem3a.theta) annotation(
    Line(points = {{-40, 110}, {-40, 44}, {-38, 44}, {-38, 20}}, color = {0, 0, 127}));
  connect(ipMaxPu, genSystem3a.ipMaxPu) annotation(
    Line(points = {{-110, 40}, {-74, 40}, {-74, 14}, {-58, 14}}, color = {0, 0, 127}));
  connect(ipCmdPu, genSystem3a.ipCmdPu) annotation(
    Line(points = {{-110, 20}, {-80, 20}, {-80, 8}, {-58, 8}}, color = {0, 0, 127}));
  connect(iqMaxPu, genSystem3a.iqMaxPu) annotation(
    Line(points = {{-110, 0}, {-58, 0}}, color = {0, 0, 127}));
  connect(iqCmdPu, genSystem3a.iqCmdPu) annotation(
    Line(points = {{-110, -20}, {-80, -20}, {-80, -8}, {-58, -8}}, color = {0, 0, 127}));
  connect(iqMinPu, genSystem3a.iqMinPu) annotation(
    Line(points = {{-110, -40}, {-74, -40}, {-74, -14}, {-58, -14}}, color = {0, 0, 127}));
  connect(genSystem3a.PAgPu, PAgPu) annotation(
    Line(points = {{-18, -14}, {-8, -14}, {-8, -58}, {-80, -58}, {-80, -110}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Text(origin = {58, 22}, extent = {{-20, -20}, {20, 20}}, textString = "3A")}));
end WT3AInjector;
