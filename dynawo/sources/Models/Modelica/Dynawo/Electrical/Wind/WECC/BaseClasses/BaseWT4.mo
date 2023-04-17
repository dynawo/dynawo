within Dynawo.Electrical.Wind.WECC.BaseClasses;

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

partial model BaseWT4 "Partial base model for the WECC Wind Turbine models including the electrical control, the generator control, the injector, the measurements and the equivalent branch connection to the grid"
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsElectricalControl;
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsGeneratorControl;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  parameter Real VDLIp11;
  parameter Real VDLIp12;
  parameter Real VDLIp21;
  parameter Real VDLIp22;
  parameter Real VDLIq11;
  parameter Real VDLIq12;
  parameter Real VDLIq21;
  parameter Real VDLIq22;
  parameter Types.PerUnit VRef1Pu "User-defined reference/bias on the inner-loop voltage control (typical: 0 pu)";
  parameter Types.Time HoldIpMax "Time delay for which the active current limit (ipMaxPu) is held after voltage dip vDip returns to zero for HoldIpMax seconds at its value during the voltage dip";
  parameter Real HoldIq "Absolute value of HoldIq defines seconds to hold current injection after voltage dip ended. HoldIq < 0 for constant, 0 for no injection after voltage dip, HoldIq > 0 for voltage-dependent injection (typical: -1 .. 1 s)";
  parameter Types.PerUnit IqFrzPu "Constant reactive current injection value (typical: -0.1 .. 0.1 pu)";
  parameter Boolean PFlag "Power reference flag: const. Pref (0) or consider generator speed (1)";

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {168, 4}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 8.88178e-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Lines.Line line(RPu = RPu, XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {103, 4}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.ElectricalControlWind wecc_reec(Id0Pu = Id0Pu, IMaxPu = IMaxPu, Iq0Pu = Iq0Pu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PInj0Pu = PInj0Pu, PPriority = PPriority, PFlag = PFlag, PfFlag = PfFlag, PMaxPu = PMaxPu, PMinPu = PMinPu, QFlag = QFlag, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, Tiq = Tiq, tP = tP, tPord = tPord, tRv = tRv, HoldIpMax = HoldIpMax, HoldIq = HoldIq, UInj0Pu = UInj0Pu, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22, VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, UMaxPu = UMaxPu, UMinPu = UMinPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VRef1Pu = VRef1Pu, DPMax = DPMax, DPMin = DPMin, Dbd1 = Dbd1, Dbd2 = Dbd2, IqFrzPu = IqFrzPu) annotation(
    Placement(visible = true, transformation(origin = {-22.1315, -4.1384}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.GeneratorControl wecc_regc(IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, RateFlag = RateFlag, tFilterGC = tFilterGC, tG = tG, Rrpwr = Rrpwr, UInj0Pu = UInj0Pu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {23, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = - PInj0Pu * (SNom / SystemBase.SnRef), Q0Pu = - QInj0Pu * (SNom / SystemBase.SnRef), SNom = SNom, U0Pu = UInj0Pu, UPhase0 = UPhaseInj0, i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {63, -4}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {133, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.Angle UPhaseInj0 "Start value of voltage angle at injector";

equation
  line.switchOffSignal1.value = injector.switchOffSignal1.value;
  line.switchOffSignal2.value = injector.switchOffSignal2.value;
  connect(line.terminal2, injector.terminal) annotation(
    Line(points = {{93, 4}, {74.5, 4}}, color = {0, 0, 255}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{-11.1315, -10.1384}, {11.8683, -10.1384}}, color = {0, 0, 127}));
  connect(wecc_reec.frtOn, wecc_regc.frtOn) annotation(
    Line(points = {{-11.1315, -4.1384}, {11.8683, -4.1384}}, color = {255, 0, 255}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{-11.1315, 1.8616}, {11.8683, 1.8616}}, color = {0, 0, 127}));
  connect(wecc_regc.idRefPu, injector.idPu) annotation(
    Line(points = {{34, -10}, {51.5, -10}}, color = {0, 0, 127}));
  connect(wecc_regc.iqRefPu, injector.iqPu) annotation(
    Line(points = {{34, 0}, {51.5, 0}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_regc.UPu) annotation(
    Line(points = {{74.5, -12.1}, {79.5, -12.1}, {79.5, -20.1}, {16.5, -20.1}, {16.5, -15.1}, {16.5, -15.1}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_reec.UPu) annotation(
    Line(points = {{74.5, -12.1}, {79.5, -12.1}, {79.5, -20.1}, {-16.5, -20.1}, {-16.5, -15.1}}, color = {0, 0, 127}));
  connect(injector.PInjPuSn, wecc_reec.PInjPu) annotation(
    Line(points = {{74.5, -8.3}, {81.5, -8.3}, {81.5, -22.3}, {-22.5, -22.3}, {-22.5, -15.3}}, color = {0, 0, 127}));
  connect(injector.QInjPuSn, wecc_reec.QInjPu) annotation(
    Line(points = {{74.5, -4.5}, {83.5, -4.5}, {83.5, -42.5}, {-31.5, -42.5}, {-31.5, -15.5}}, color = {0, 0, 127}));
  connect(line.terminal1, measurements.terminal1) annotation(
    Line(points = {{113, 4}, {123, 4}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{143, 4}, {137, 4}}, color = {0, 0, 255}));

  annotation(
    Documentation(info = "<html><head></head><body><p><br></p><ul>
</ul> <p></p></body></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)),
  Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -60}, {170, 50}})));
end BaseWT4;
