within Dynawo.Electrical.Wind.WECC;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WTG4BCurrentSource "WECC Wind Turbine model with a current source as interface with the grid"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BaseWT4B;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Params_PlantControl;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Params_PLL;

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = - P0Pu * SystemBase.SnRef / SNom) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-111, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = - Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-111, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-111, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.WECC.PlantControl wecc_repc(DDn = DDn, DUp = DUp, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PGen0Pu = - P0Pu * SystemBase.SnRef / SNom, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, QGen0Pu = - Q0Pu * SystemBase.SnRef / SNom, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, U0Pu = U0Pu, UInj0Pu = UInj0Pu, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, Dbd = Dbd, EMax = EMax, EMin = EMin, FDbd1 = FDbd1, FDbd2 = FDbd2, FEMax = FEMax, FEMin = FEMin, iInj0Pu = iInj0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-61, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-96, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit P0Pu "Start value of active power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  parameter Types.ComplexPerUnit iInj0Pu "Start value of complex current at injector in pu (base UNom, SNom) (generator convention)";
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-125, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-125, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
equation
  connect(pll.omegaPLLPu, wecc_repc.omegaPu) annotation(
    Line(points = {{-85, 41}, {-80, 41}, {-80, 4}, {-72, 4}}, color = {0, 0, 127}));
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-111, -6}, {-72, -6}}, color = {0, 0, 127}));
  connect(wecc_repc.omegaRefPu, omegaRefPu) annotation(
    Line(points = {{-72, 0}, {-90, 0}, {-90, 10}, {-111, 10}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu) annotation(
    Line(points = {{-111, -19}, {-90, -19}, {-90, -10}, {-72, -10}}, color = {0, 0, 127}));
  connect(wecc_repc.PInjRefPu, wecc_reec.PInjRefPu) annotation(
    Line(points = {{-50, 2}, {-33, 2}}, color = {0, 0, 127}));
  connect(wecc_repc.QInjRefPu, wecc_reec.QInjRefPu) annotation(
    Line(points = {{-50, -10}, {-33, -10}}, color = {0, 0, 127}));
  connect(measurements.PPu, wecc_repc.PRegPu) annotation(
    Line(points = {{127, 15}, {127, 20}, {-53, 20}, {-53, 7}}, color = {0, 0, 127}));
  connect(measurements.QPu, wecc_repc.QRegPu) annotation(
    Line(points = {{131, 15}, {131, 24}, {-58, 24}, {-58, 7}}, color = {0, 0, 127}));
  connect(measurements.uPu, wecc_repc.uPu) annotation(
    Line(points = {{135, 15}, {135, 30}, {-64, 30}, {-64, 7}}, color = {85, 170, 255}));
  connect(measurements.iPu, wecc_repc.iPu) annotation(
    Line(points = {{139, 15}, {139, 35}, {-69, 35}, {-69, 7}}, color = {85, 170, 255}));
  connect(measurements.uPu, pll.uPu) annotation(
    Line(points = {{135, 15}, {135, 56}, {-115, 56}, {-115, 42}, {-107, 42}}, color = {85, 170, 255}));
  connect(constant1.y, pll.omegaRefPu) annotation(
    Line(points = {{-121, 30}, {-107, 30}}, color = {0, 0, 127}));
  annotation(
    Documentation(preferredView = "diagram",
    info = "<html>
<p> This block contains the generic WECC WTG model according to (in case page cannot be found, copy link in browser): <br><a href=\"https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a> </p>
<p> The overall model is structured as follows:
<ul>
<li> Main model: WECC_Wind with terminal connection and measurement inputs for P/Q/U/I. </li>
<li> Plant level control. </li>
<li> Electrical inverter control.</li>
<li> Constant speed of drive train represented by constant block (no drive train).</li>
<li> Generator control. </li>
<li> Injector (id,iq). </li>
</ul> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC WTG 4B")}, coordinateSystem(initialScale = 0.1)),
  Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -60}, {170, 50}})));
end WTG4BCurrentSource;
