within Dynawo.Electrical.Sources.IEC;

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

model WT4Injector "Converter model and grid interface according to IEC N°61400-27-1 standard for type 4A wind turbines"
  extends BaseConverters.BaseWTInjector;

  extends Dynawo.Electrical.Wind.IEC.Parameters.GenSystem4;

  Dynawo.Electrical.Sources.IEC.BaseConverters.GenSystem4 genSystem4(DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, DiqMinPu = DiqMinPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kipaw = Kipaw, Kiqaw = Kiqaw, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, tG = tG) annotation(
    Placement(visible = true, transformation(origin = {-44, 0}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));

equation
  genSystem4.running = running.value;
  connect(genSystem4.ipMaxPu, ipMaxPu) annotation(
    Line(points = {{-64, 14}, {-78, 14}, {-78, 40}, {-110, 40}}, color = {0, 0, 127}));
  connect(genSystem4.ipCmdPu, ipCmdPu) annotation(
    Line(points = {{-64, 8}, {-86, 8}, {-86, 20}, {-110, 20}}, color = {0, 0, 127}));
  connect(genSystem4.iqMaxPu, iqMaxPu) annotation(
    Line(points = {{-64, 0}, {-110, 0}}, color = {0, 0, 127}));
  connect(genSystem4.iqCmdPu, iqCmdPu) annotation(
    Line(points = {{-64, -8}, {-86, -8}, {-86, -20}, {-110, -20}}, color = {0, 0, 127}));
  connect(genSystem4.iqMinPu, iqMinPu) annotation(
    Line(points = {{-64, -14}, {-78, -14}, {-78, -40}, {-110, -40}}, color = {0, 0, 127}));
  connect(genSystem4.theta, theta) annotation(
    Line(points = {{-44, 20}, {-44, 86}, {-40, 86}, {-40, 110}}, color = {0, 0, 127}));
  connect(genSystem4.fOCB, fOCB) annotation(
    Line(points = {{-36, 20}, {-36, 74}, {40, 74}, {40, 110}}, color = {255, 0, 255}));
  connect(genSystem4.terminal, elecSystem.terminal1) annotation(
    Line(points = {{-24, 0}, {18, 0}}, color = {0, 0, 255}));
  connect(genSystem4.PAgPu, PAgPu) annotation(
    Line(points = {{-24, -14}, {-20, -14}, {-20, -76}, {-80, -76}, {-80, -110}}, color = {0, 0, 127}));

annotation(
    Icon(graphics = {Text(origin = {48, 22}, extent = {{-20, -20}, {20, 20}}, textString = "4")}));
end WT4Injector;
