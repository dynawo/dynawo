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

model WTG4ACurrentSource "WECC Wind Turbine model with a simplified drive train model (dual-mass model) and with a current source as interface with the grid"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BaseWT4A;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Params_PlantControl;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Params_PLL;

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = - P0Pu * SystemBase.SnRef / SNom) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = - Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -23}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 13}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.RealExpression OmegaRef1(y = OmegaRef.y) annotation(
    Placement(visible = true, transformation(origin = {-125, 30}, extent = {{-6.5, -5.5}, {6.5, 5.5}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.PlantControl wecc_repc(DDn = DDn, DUp = DUp, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PGen0Pu = - P0Pu * SystemBase.SnRef / SNom, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, QGen0Pu = - Q0Pu * SystemBase.SnRef / SNom, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, U0Pu = U0Pu, UInj0Pu = UInj0Pu, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, Dbd = Dbd, EMax = EMax, EMin = EMin, FDbd1 = FDbd1, FDbd2 = FDbd2, FEMax = FEMax, FEMin = FEMin, iInj0Pu = iInj0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-62, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-95, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit P0Pu "Start value of active power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  parameter Types.ComplexPerUnit iInj0Pu "Start value of complex current at injector in pu (base UNom, SNom) (generator convention)";

equation
  connect(wecc_repc.QInjRefPu, wecc_reec.QInjRefPu) annotation(
    Line(points = {{-51, -10}, {-32, -10}}, color = {0, 0, 127}));
  connect(wecc_repc.PInjRefPu, wecc_reec.PInjRefPu) annotation(
    Line(points = {{-51, 2}, {-32, 2}}, color = {0, 0, 127}));
  connect(omegaRefPu, wecc_repc.omegaRefPu) annotation(
    Line(points = {{-110, 13}, {-91.5, 13}, {-91.5, 0}, {-73, 0}}, color = {0, 0, 127}));
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-110, -6}, {-73, -6}}, color = {0, 0, 127}));
  connect(OmegaRef1.y, pll.omegaRefPu) annotation(
    Line(points = {{-118, 30}, {-106, 30}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, wecc_repc.omegaPu) annotation(
    Line(points = {{-84, 41}, {-76, 41}, {-76, 4}, {-73, 4}}, color = {0, 0, 127}));
  connect(measurements.uPu, pll.uPu) annotation(
    Line(points = {{135, 15}, {135, 51}, {-112, 51}, {-112, 42}, {-106, 42}}, color = {85, 170, 255}));
  connect(wecc_repc.QRefPu, QRefPu) annotation(
    Line(points = {{-73, -10}, {-92, -10}, {-92, -23}, {-110, -23}}, color = {0, 0, 127}));
  connect(measurements.PPu, wecc_repc.PRegPu) annotation(
    Line(points = {{127, 15}, {127, 18}, {-54, 18}, {-54, 7}}, color = {0, 0, 127}));
  connect(measurements.QPu, wecc_repc.QRegPu) annotation(
    Line(points = {{131, 15}, {131, 23}, {-59, 23}, {-59, 7}}, color = {0, 0, 127}));
  connect(wecc_repc.uPu, measurements.uPu) annotation(
    Line(points = {{-65, 7}, {-65, 30}, {135, 30}, {135, 15}}, color = {85, 170, 255}));
  connect(measurements.iPu, wecc_repc.iPu) annotation(
    Line(points = {{139, 15}, {139, 38}, {-70, 38}, {-70, 7}}, color = {85, 170, 255}));

  annotation(
    Documentation(preferredView = "diagram",
    info = "<html>
<p> This block contains the generic WECC WTG model according to (in case page cannot be found, copy link in browser): <br><a href=\"https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a> </p>
<p> The overall model is structured as follows:
<ul>
<li> Main model: WECC_Wind with terminal connection and measurement inputs for P/Q/U/I. </li>
<li> Plant level control. </li>
<li> Electrical inverter control.</li>
<li> Simplified drive train model, dual-mass model. </li>
<li> Generator control. </li>
<li> Injector (id,iq). </li>
</ul> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC WTG 4A")}, coordinateSystem(initialScale = 0.1)),
  Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -60}, {170, 50}})));
end WTG4ACurrentSource;
