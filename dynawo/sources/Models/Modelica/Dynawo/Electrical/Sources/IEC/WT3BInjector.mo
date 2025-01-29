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

model WT3BInjector "Converter model and grid interface according to IEC N°61400-27-1 standard for type 3B
 wind turbines"

  extends Dynawo.Electrical.Sources.IEC.BaseConverters.BaseWTInjector;
  extends Dynawo.Electrical.Wind.IEC.Parameters.GenSystem3b;
  
  Dynawo.Electrical.Sources.IEC.BaseConverters.GenSystem3b genSystem3b(tCrb = tCrb, tWo = tWo, tG = tG, MCrb = MCrb, DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, XEqv = XEqv, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {-38, 1.77636e-15}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));

equation
  genSystem3b.running = running.value;

  connect(ipMaxPu, genSystem3b.ipMaxPu) annotation(
    Line(points = {{-110, 40}, {-68, 40}, {-68, 14}, {-58, 14}}, color = {0, 0, 127}));
  connect(ipCmdPu, genSystem3b.ipCmdPu) annotation(
    Line(points = {{-110, 20}, {-78, 20}, {-78, 8}, {-58, 8}}, color = {0, 0, 127}));
  connect(iqMaxPu, genSystem3b.iqMaxPu) annotation(
    Line(points = {{-110, 0}, {-58, 0}}, color = {0, 0, 127}));
  connect(iqCmdPu, genSystem3b.iqCmdPu) annotation(
    Line(points = {{-110, -20}, {-78, -20}, {-78, -8}, {-58, -8}}, color = {0, 0, 127}));
  connect(iqMinPu, genSystem3b.iqMinPu) annotation(
    Line(points = {{-110, -40}, {-68, -40}, {-68, -14}, {-58, -14}}, color = {0, 0, 127}));
  connect(genSystem3b.PAgPu, PAgPu) annotation(
    Line(points = {{-18, -14}, {-8, -14}, {-8, -60}, {-80, -60}, {-80, -110}}, color = {0, 0, 127}));
  connect(theta, genSystem3b.theta) annotation(
    Line(points = {{-40, 110}, {-40, 52}, {-38, 52}, {-38, 20}}, color = {0, 0, 127}));
  connect(fOCB, genSystem3b.fOCB) annotation(
    Line(points = {{40, 110}, {40, 54}, {-30, 54}, {-30, 20}}, color = {255, 0, 255}));
  connect(genSystem3b.terminal, elecSystem.terminal1) annotation(
    Line(points = {{-18, 0}, {18, 0}}, color = {0, 0, 255}));
  
  annotation(
    Icon(graphics = {Text(origin = {58, 22}, extent = {{-20, -20}, {20, 20}}, textString = "3B")}));
end WT3BInjector;
