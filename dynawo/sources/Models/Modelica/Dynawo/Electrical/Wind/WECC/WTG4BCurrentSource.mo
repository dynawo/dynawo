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
  import Dynawo.Electrical.Controls.WECC.Parameters;

  extends Parameters.Params_PlantControl;
  extends Parameters.Params_ElectricalControl;
  extends Parameters.Params_GeneratorControl;
  extends Parameters.Params_PLL;

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
    Placement(visible = true, transformation(origin = {180, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 8.88178e-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = - P0Pu * SystemBase.SnRef / SNom) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = - Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Lines.Line line(RPu = RPu, XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {120, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.PlantControl wecc_repc(DDn = DDn, DUp = DUp, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PGen0Pu = - P0Pu * SystemBase.SnRef / SNom, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, QGen0Pu = - Q0Pu * SystemBase.SnRef / SNom, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, U0Pu = U0Pu, UInj0Pu = UInj0Pu, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, Dbd = Dbd, EMax = EMax, EMin = EMin, FDbd1 = FDbd1, FDbd2 = FDbd2, FEMax = FEMax, FEMin = FEMin, iInj0Pu = iInj0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.ElectricalControlWind wecc_reec(Id0Pu = Id0Pu, IMaxPu = IMaxPu, Iq0Pu = Iq0Pu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PInj0Pu = PInj0Pu, PPriority = PPriority, PFlag = PFlag, PfFlag = PfFlag, PMaxPu = PMaxPu, PMinPu = PMinPu, QFlag = QFlag, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, Tiq = Tiq, tP = tP, tPord = tPord, tRv = tRv, HoldIpMax = HoldIpMax, HoldIq = HoldIq, UInj0Pu = UInj0Pu, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22,  VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, UMaxPu = UMaxPu, UMinPu = UMinPu, VFlag = VFlag, VMaxPu = VMaxPu, VMinPu = VMinPu, VRef0Pu = VRef0Pu, VRef1Pu = VRef1Pu, DPMax = DPMax, DPMin = DPMin, Dbd1 = Dbd1, Dbd2 = Dbd2, IqFrzPu = IqFrzPu) annotation(
    Placement(visible = true, transformation(origin = {-5.13151, -18.1384}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.GeneratorControl wecc_regc(IqrMaxPu = IqrMaxPu, IqrMinPu = IqrMinPu, RateFlag = RateFlag, tFilterGC = tFilterGC, tG = tG, Rrpwr = Rrpwr, UInj0Pu = UInj0Pu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {40, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = - PInj0Pu * (SNom / SystemBase.SnRef), Q0Pu = - QInj0Pu * (SNom / SystemBase.SnRef), SNom = SNom, U0Pu = UInj0Pu, UPhase0 = UPhaseInj0, i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {80, -18}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaG(k = 1) annotation(
    Placement(visible = true, transformation(origin = {40, -45}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom)  annotation(
    Placement(visible = true, transformation(origin = {150, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit P0Pu "Start value of active power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit iInj0Pu "Start value of complex current at injector in pu (base UNom, SNom) (generator convention)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.Angle UPhaseInj0 "Start value of voltage angle at injector";

equation
  line.switchOffSignal1.value = injector.switchOffSignal1.value;
  connect(wecc_repc.QInjRefPu, wecc_reec.QInjRefPu) annotation(
    Line(points = {{-29, -24}, {-16, -24}}, color = {0, 0, 127}));
  connect(line.terminal2, injector.terminal) annotation(
    Line(points = {{110, -10}, {91.5, -10}}, color = {0, 0, 255}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{6, -24}, {29, -24}}, color = {0, 0, 127}));
  connect(wecc_reec.frtOn, wecc_regc.frtOn) annotation(
    Line(points = {{6, -18}, {29, -18}}, color = {255, 0, 255}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{6, -12}, {29, -12}}, color = {0, 0, 127}));
  connect(wecc_repc.PInjRefPu, wecc_reec.PInjRefPu) annotation(
    Line(points = {{-29, -12}, {-16, -12}}, color = {0, 0, 127}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{-99, 30}, {-91, 30}}, color = {0, 0, 127}));
  connect(wecc_regc.idRefPu, injector.idPu) annotation(
    Line(points = {{51, -24}, {68.5, -24}}, color = {0, 0, 127}));
  connect(wecc_regc.iqRefPu, injector.iqPu) annotation(
    Line(points = {{51, -14}, {68.5, -14}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, wecc_repc.omegaPu) annotation(
    Line(points = {{-69, 41}, {-60, 41}, {-60, -10}, {-51, -10}}, color = {0, 0, 127}));
  connect(omegaRefPu, wecc_repc.omegaRefPu) annotation(
    Line(points = {{-110, 0}, {-70, 0}, {-70, -14}, {-51, -14}, {-51, -14}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_regc.UPu) annotation(
    Line(points = {{92, -26}, {97, -26}, {97, -34}, {34, -34}, {34, -29}, {34, -29}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_reec.UPu) annotation(
    Line(points = {{92, -26}, {97, -26}, {97, -34}, {1, -34}, {1, -29}}, color = {0, 0, 127}));
  connect(injector.PInjPuSn, wecc_reec.PInjPu) annotation(
    Line(points = {{92, -22}, {99, -22}, {99, -36}, {-5, -36}, {-5, -29}}, color = {0, 0, 127}));
  connect(injector.QInjPuSn, wecc_reec.QInjPu) annotation(
    Line(points = {{92, -18}, {101, -18}, {101, -56}, {-14, -56}, {-14, -29}}, color = {0, 0, 127}));
  connect(line.terminal1, measurements.terminal1) annotation(
    Line(points = {{130, -10}, {140, -10}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{160, -10}, {180, -10}}, color = {0, 0, 255}));
  connect(measurements.PPu, wecc_repc.PRegPu) annotation(
    Line(points = {{144, 1}, {144, 10}, {-32, 10}, {-32, -7}}, color = {0, 0, 127}));
  connect(measurements.QPu, wecc_repc.QRegPu) annotation(
    Line(points = {{148, 1}, {148, 12}, {-37, 12}, {-37, -7}}, color = {0, 0, 127}));
  connect(measurements.uPu, wecc_repc.uPu) annotation(
    Line(points = {{152, 1}, {152, 14}, {-43, 14}, {-43, -7}}, color = {85, 170, 255}));
  connect(measurements.iPu, wecc_repc.iPu) annotation(
    Line(points = {{156, 1}, {156, 16}, {-48, 16}, {-48, -7}}, color = {85, 170, 255}));
  connect(measurements.uPu, pll.uPu) annotation(
    Line(points = {{152, 1}, {152, 49}, {-95, 49}, {-95, 42}, {-91, 42}}, color = {85, 170, 255}));
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-110, -20}, {-51, -20}}, color = {0, 0, 127}));
  connect(QRefPu, wecc_repc.QRefPu) annotation(
    Line(points = {{-110, -40}, {-58, -40}, {-58, -24}, {-51, -24}}, color = {0, 0, 127}));
  connect(omegaG.y, wecc_reec.omegaGPu) annotation(
    Line(points = {{34.5, -45}, {-10, -45}, {-10, -29}}, color = {0, 0, 127}));

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
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC WT 4B")}, coordinateSystem(initialScale = 0.1)),
  Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -60}, {170, 50}})));
end WTG4BCurrentSource;
