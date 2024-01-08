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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseWT4 "Partial base model for the WECC Wind Turbine models including the electrical control, the generator converter, the injector, the measurements and the equivalent branch connection to the grid"
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.REECaParameters;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.REGCaParameters;

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)" annotation(
    Dialog(tab = "Line"));
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)" annotation(
    Dialog(tab = "Line"));

  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variable
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-80, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Dynawo.Electrical.Lines.Line line(RPu = RPu, XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REEC.REECa reec( DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu,Ip0Pu = Ip0Pu, Iq0Pu = Iq0Pu, IqFrzPu = IqFrzPu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PFlag = PFlag, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, UDipPu = UDipPu, UFlag = UFlag, UInj0Pu = UInj0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UUpPu = UUpPu, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22, VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, VRef0Pu = VRef0Pu, VRef1Pu = VRef1Pu, tHld = tHld, tHld2 = tHld2, tIq = tIq, tP = tP, tPOrd = tPOrd, tRv = tRv) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.REGC.REGCa regc(Brkpt = Brkpt, Ip0Pu = Ip0Pu, Iq0Pu = Iq0Pu, IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, Lvpl1 = Lvpl1, LvplSw = LvplSw, PInj0Pu = PInj0Pu, QInj0Pu = QInj0Pu, RateFlag = RateFlag, RrpwrPu = RrpwrPu, SNom = SNom, UInj0Pu = UInj0Pu, UPhaseInj0 = UPhaseInj0, Zerox = Zerox, i0Pu = i0Pu, s0Pu = s0Pu, tFilterGC = tFilterGC, tG = tG, uInj0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-185, 34}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit Ip0Pu "Start value of active current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit Iq0Pu "Start value of reactive current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Real PF0 "Start value of cosinus of power factor angle" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu UInj0Pu "Start value of voltage module at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.Angle UPhaseInj0 "Start value of rotor angle in rad" annotation(
    Dialog(group = "Initialization"));

equation
  line.switchOffSignal1.value = regc.injectorIDQ.switchOffSignal1.value;
  line.switchOffSignal2.value = regc.injectorIDQ.switchOffSignal2.value;

  connect(reec.frtOn, regc.frtOn) annotation(
    Line(points = {{-69, 0}, {-51, 0}}, color = {255, 0, 255}));
  connect(line.terminal1, measurements.terminal1) annotation(
    Line(points = {{30, 0}, {50, 0}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{70, 0}, {110, 0}}, color = {0, 0, 255}));
  connect(PFaRef, reec.PFaRef) annotation(
    Line(points = {{-80, 70}, {-80, 11}}, color = {0, 0, 127}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-179.5, 34}, {-171, 34}}, color = {0, 0, 127}));
  connect(reec.ipCmdPu, regc.ipCmdPu) annotation(
    Line(points = {{-69, 6}, {-51, 6}}, color = {0, 0, 127}));
  connect(reec.iqCmdPu, regc.iqCmdPu) annotation(
    Line(points = {{-69, -6}, {-51, -6}}, color = {0, 0, 127}));
  connect(regc.terminal, line.terminal2) annotation(
    Line(points = {{-29, 0}, {10, 0}}, color = {0, 0, 255}));
  connect(regc.uInjPu, pll.uPu) annotation(
    Line(points = {{-29, -8}, {0, -8}, {0, 60}, {-180, 60}, {-180, 46}, {-171, 46}}, color = {85, 170, 255}));
  connect(pll.phi, regc.UPhaseInj) annotation(
    Line(points = {{-149, 46}, {-40, 46}, {-40, 11}}, color = {0, 0, 127}));
  connect(regc.PInjPu, reec.PInjPu) annotation(
    Line(points = {{-29, 8}, {-10, 8}, {-10, -30}, {-80, -30}, {-80, -11}}, color = {0, 0, 127}));
  connect(regc.QInjPu, reec.QInjPu) annotation(
    Line(points = {{-29, 4}, {-15, 4}, {-15, -25}, {-88, -25}, {-88, -11}}, color = {0, 0, 127}));
  connect(regc.UInjPu, reec.UInjPu) annotation(
    Line(points = {{-29, -4}, {-20, -4}, {-20, -20}, {-74, -20}, {-74, -11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p><br></p><ul>
</ul> <p></p></body></html>"),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {100, 60}})));
end BaseWT4;
