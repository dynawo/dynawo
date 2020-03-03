within Dynawo.Electrical.Photovoltaics.WECC;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/



model PVVoltageSource
  import Modelica.Blocks;
  import Modelica.ComplexBlocks;
  import Complex;
  import Dynawo.Electrical.Controls.PLL;
  import Dynawo.Electrical.Sources.SourceURI;
  import Dynawo.Electrical.Lines.Line;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Connectors;
  import Dynawo.Types;

  parameter Types.PerUnit UReg0Pu "Initial value of voltage magnitude at regulated bus in p.u.";
  parameter Types.PerUnit PReg0Pu "Initial value of active power reception at regulated bus (pu base SnRef)";
  parameter Types.PerUnit QReg0Pu "Initial value of power reception at regulated bus (pu base SnRef)";
  parameter Types.Angle URegPhase0 "Initial phase angle of voltage at regulated bus";
  parameter Types.PerUnit Omega0Pu "Initial value value of omega at regulated bus";
  parameter Types.PerUnit Rsource "Source resistance (typically set to zero, typical: 0..0.01)";
  parameter Types.PerUnit Xsource "Source reactance (typical: 0.05..0.2)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.PerUnit Rtfo "Resistance of step-up transformer connected to inverter terminal in p.u. (base SnRef)";
  parameter Types.PerUnit Xtfo "Reactance of step-up transformer connected to inverter terminal in p.u. (base SnRef)";
  parameter Types.PerUnit Btfo "Susceptance of step-up transformer connected to inverter terminal in p.u. (base SnRef)";
  parameter Types.PerUnit Gtfo "Conductance of step-up transformer connected to inverter terminal in p.u. (base SnRef)";
  parameter Types.PerUnit Rlne "Resistance of equivalent line connected to step-up transformer in p.u. (base SnRef)";
  parameter Types.PerUnit Xlne "Reactance of equivalent line connected to step-up transformer in p.u.  (base SnRef)";
  parameter Types.PerUnit Blne "Half-susceptance of equivalent line connected to step-up transformer in p.u. (base SnRef)";
  parameter Types.PerUnit Glne "Half-conductance of equivalent line connected to step-up transformer in p.u. (base SnRef)";

  // Terminal
  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

  // Inputs_setpoints:
  Blocks.Interfaces.RealInput PRefPu(start = PReg0Pu) "Reference of active power reception at regulated bus (pu base SnRef)" annotation(
    Placement(visible = true, transformation(origin = {-103, 24}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-100, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Blocks.Interfaces.RealInput QRefPu(start = QReg0Pu) "Reference of reactive power reception at regulated bus (pu base SnRef)" annotation(
    Placement(visible = true, transformation(origin = {-103, 10}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-100, 18}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Blocks.Interfaces.RealInput OmegaRefPu "Reference value of omega at regulated bus" annotation(
    Placement(visible = true, transformation(origin = {-103, -2}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-100, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

  // Inputs_measurements at regulated bus: (receptor convention, p.u. base: SnRef)
  ComplexBlocks.Interfaces.ComplexInput uRegPu(re(start = uReg0Pu.re),im(start = uReg0Pu.im)) "Complex voltage at regulated bus" annotation(
    Placement(visible = true, transformation(origin = {-49, -54}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-60, -52}, extent = {{-6, -6}, {6, 6}}, rotation = 90)));
  ComplexBlocks.Interfaces.ComplexInput iRegPu_SnRef(re(start = iReg0Pu.re),im(start = iReg0Pu.im)) "Complex current at regulated bus (pu base SnRef)" annotation(
    Placement(visible = true, transformation(origin = {-67, -54}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-30, -52}, extent = {{-6, -6}, {6, 6}}, rotation = 90)));
  Blocks.Interfaces.RealInput PRegPu_SnRef(start = PReg0Pu) "Received active power at regulated bus (pu base SnRef)" annotation(
    Placement(visible = true, transformation(origin = {-19, -54}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {0, -52}, extent = {{-6, -6}, {6, 6}}, rotation = 90)));
  Blocks.Interfaces.RealInput QRegPu_SnRef(start = QReg0Pu) "Received inductive reactive power at regulated bus (pu base SnRef)" annotation(
    Placement(visible = true, transformation(origin = {-33, -54}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {30, -52}, extent = {{-6, -6}, {6, 6}}, rotation = 90)));

  // Internal variables, change from pu base at regulated bus (SnRef) to local (SNom), for connection with plant level control, injector convention:
  Types.ComplexCurrentPu iRegInjPu "complex injected current at regulated bus (pu base SNom)";
  Types.PerUnit PRegInjPu "Injected active power at regulated bus (pu base SNom)";
  Types.PerUnit QRegInjPu "Injected inductive reactive power at regulated bus (pu base SNom)";
  Types.PerUnit PRefInjPu "Setpoint injected active power at regulated bus (pu base SNom)";
  Types.PerUnit QRefInjPu "Setpoint injected inductive reactive power at regulated bus (pu base SNom)";

  // Blocks:
  BaseControls.REPC_plantControl wecc_repc(
    Ddn = 20,
    Dup = 0.001,
    FreqFlag = true,
    Kc = 0,
    Ki = 1.5,
    Kig = 2.36,
    Kp = 0.1,
    Kpg = 0.05,
    Omega0Pu = Omega0Pu, P0Pu = P0InjPu,
    PMax = 1, PMin = 0, PRefPu_EC(fixed = true, start = P0InjPu), PReg0Pu = PReg0InjPu,
    PRegPu(start = PReg0InjPu), Q0Pu = Q0InjPu, QMax = 0.4, QMin = -0.4, QReg0Pu = QReg0InjPu,
    QRegPu(start = QReg0InjPu), Q_VRefPu_EC(fixed = true, start = Q0InjPu),
    Rc = 0, RefFlag = true, Tfltr = 0.04, Tft = 0, Tfv = 0.1, Tlag = 0.1, Tp = 0.04,
    UReg0Pu = UReg0Pu, VcompFlag = true, Vfrz = 0.0, Xc = 0.000025 + 0.05, dbd = 0.01, eMax = 999, eMin = -999, fdbd1 = 0.004, fdbd2 = 1, feMax = 999, feMin = -999, iReg0Pu = iReg0InjPu, uReg0Pu = uReg0Pu) annotation(
    Placement(visible = true, transformation(origin = {-45, 6}, extent = {{-15, -10}, {10, 10}}, rotation = 0)));

  BaseControls.REEC_electricalControl wecc_reec(
    Imax = 1.05, Iqh1 = 2, Iql1 = -2, Kqi = 0.5, Kqp = 1, Kqv = 2, Kvi = 1, Kvp = 1,
    P0Pu = P0InjPu, PFref = PFref0, PInjPu(start = P0InjPu), PRefPu_EC(start = P0InjPu), PfFlag = false,
    Pmax = 1, Pmin = 0, PqFlag = false,
    Q0Pu = Q0InjPu, QFlag = true, QInjPu(start = Q0InjPu), Q_VRefPu_EC(start = Q0InjPu),
    Qmax = 0.4, Qmin = -0.4, Tiq = 0.02, Tp = 0.04, Tpord = 0.02, Trv = 0.02,
    U0Pu = U0Pu, VFlag = true, Vdip = 0.9, Vmax = 1.1, Vmin = 0.9, Vref0 = 1, Vup = 1.1, dPmax = 999, dPmin = -999, dbd1 = -0.1, dbd2 = 0.1)  annotation(
  Placement(visible = true, transformation(origin = {-17.6983, 5.65529}, extent = {{-15.9149, -10.3447}, {4.77448, 10.3447}}, rotation = 0)));

  SourceURI injector_uir(
    P0Pu = P0Pu, PInjPu(start = P0InjPu), Q0Pu = Q0Pu, QInjPu(start = Q0InjPu), Rsource = Rsource, SNom = SNom,
    U0Pu = U0Pu, UPu(fixed = true), UiSource0Pu = UiSource0Pu, UrSource0Pu = UrSource0Pu, Xsource = Xsource, i0Pu = i0Pu, u0Pu = u0Pu,
    uSource0Pu = uSource0Pu) annotation(
    Placement(visible = true, transformation(origin = {72, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  BaseControls.REGC_generatorControl wecc_regc(
    Id0Pu = Id0Pu, Iq0Pu = Iq0Pu,
    Iqrmax = 20, Iqrmin = -20, P0Pu = P0InjPu, RateFlag = false, Tfltr = 0.02, Tg = 0.02, U0Pu = U0Pu, rrpwr = 10)  annotation(
    Placement(visible = true, transformation(origin = {19.8052, 7.68416}, extent = {{-9.80516, -8.4978}, {9.80516, 11.7662}}, rotation = 0)));

  Utilities.VSourceRef vsourceref(R = Rsource, Te = 0.005, Ui0Pu = UiSource0Pu, Ur0Pu = UrSource0Pu, X = Xsource, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {46, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Blocks.Sources.Constant OmegaRef(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {19, -39}, extent = {{-5, -5}, {5, 5}}, rotation = 180)));
  PLL.PLL pll(Ki = 20, Kp = 3, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, u0Pu = uReg0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-4, -26}, extent = {{-10, -10}, {15, 10}}, rotation = 90)));
  Line Zsource(BPu = 0, GPu = 0, NbSwitchOffSignals = 2,RPu = Rsource, XPu = Xsource, state(start = Dynawo.Electrical.Constants.state.Closed)) annotation(
    Placement(visible = true, transformation(origin = {90, -2}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));

protected

  // At regulated bus (receptor convention, Base SnRef):
  parameter Types.PerUnit PRef0Pu = PReg0Pu;
  parameter Types.PerUnit QRef0Pu = QReg0Pu;
  final parameter Types.ComplexPerUnit uReg0Pu = ComplexMath.fromPolar(UReg0Pu, URegPhase0);
  final parameter Types.ComplexPerUnit sReg0Pu = Complex(PReg0Pu, QReg0Pu);
  final parameter Types.ComplexPerUnit iReg0Pu = ComplexMath.conj(sReg0Pu/uReg0Pu);

  // At regulated bus (injector convention, Base SNom):
  final parameter Types.PerUnit PReg0InjPu = -PReg0Pu*(SystemBase.SnRef/SNom);
  final parameter Types.PerUnit QReg0InjPu = -QReg0Pu*(SystemBase.SnRef/SNom);
  final parameter Types.ComplexPerUnit iReg0InjPu = -iReg0Pu*(SystemBase.SnRef/SNom);
  final parameter Types.ComplexPerUnit sReg0InjPu = uReg0Pu * ComplexMath.conj(iReg0InjPu);

  // For REPC output, REEC inputs at inverter terminal (injector convention, Base SNom):
  //final parameter Types.ComplexPerUnit i0InjPu = iReg0InjPu;  // for calculation see below detailed equations
  //final parameter Types.ComplexPerUnit u0Pu = uReg0Pu + i0InjPu*Complex(wecc_repc.Rc, wecc_repc.Xc); // for calculation see below detailed equations
  final parameter Types.ComplexPerUnit s0InjPu= u0Pu * ComplexMath.conj(i0InjPu);
  final parameter Types.PerUnit U0Pu = ComplexMath.'abs'(u0Pu);
  final parameter Types.PerUnit P0InjPu = ComplexMath.real(s0InjPu);
  final parameter Types.PerUnit Q0InjPu = ComplexMath.imag(s0InjPu);
  final parameter Types.PerUnit PFref0 = P0InjPu / max(ComplexMath.'abs'(s0InjPu), 0.001);

  // For injector at inverter terminal (receptor convention, Base SnRef):
  final parameter Types.ComplexPerUnit i0Pu = -i0InjPu * (SNom/SystemBase.SnRef);
  final parameter Types.ComplexPerUnit s0Pu = u0Pu * ComplexMath.conj(i0Pu);
  final parameter Types.Angle UPhase0 = ComplexMath.arg(u0Pu);
  final parameter Types.PerUnit P0Pu = ComplexMath.real(s0Pu);
  final parameter Types.PerUnit Q0Pu = ComplexMath.imag(s0Pu);

  // Setpoints injector (inner voltage source)
  final parameter Types.PerUnit Id0Pu =  cos(UPhase0)*i0InjPu.re + sin(UPhase0)*i0InjPu.im;
  final parameter Types.PerUnit Iq0Pu = -sin(UPhase0)*i0InjPu.re + cos(UPhase0)*i0InjPu.im;
  final parameter Types.PerUnit UdSource0Pu = U0Pu + Id0Pu * Rsource - Iq0Pu * Xsource;
  final parameter Types.PerUnit UqSource0Pu = 0 + Iq0Pu * Rsource + Id0Pu * Xsource;
  final parameter Types.PerUnit UrSource0Pu = cos(UPhase0) * UdSource0Pu - sin(UPhase0) * UqSource0Pu;
  final parameter Types.PerUnit UiSource0Pu = sin(UPhase0) * UdSource0Pu + cos(UPhase0) * UqSource0Pu;
  final parameter Types.ComplexPerUnit uSource0Pu = Complex(UrSource0Pu, UiSource0Pu);

  // Init with consideration of B and G from plant elements:
  /*
                        I1                                    I2
   (inverter terminal) -->--Rtfo+jXtfo-------Rlne+jXlne-------<-- (regulated bus)
                                         |               |
                                   (Glne+jBlne)   (Glne+jBlne)
                                  +(Gtfo+jBtfo)          |
                                         |               |
                                        ---             ---
  Calculation of I1 and U1 with:
  ------------------------------

  Ztfo = Rtfo+jXfto;
  Ytfo = Gtfo+jBtfo;
  Zlne = Rlne+jXlne;
  Ylne = Glne+jBlne "Half-conductance and half-susceptance as defined in line element";

  U1 = A*U2 - B*I2 - Ztfo*I1;
  I1 = C*U2 - D*I2;

  A = 1 + Zlne*Ytfo;
  B = Zlne;
  C = (Ylne+Ytfo)*(1+Zlne*Ylne) + Ylne;
  D = 1 + Zlne * (Ylne+Ytfo);
  */

  final parameter Types.ComplexPerUnit Zlne = Complex(Rlne, Xlne);
  final parameter Types.ComplexPerUnit Ylne = Complex(Glne, Blne);
  final parameter Types.ComplexPerUnit Ztfo = Complex(Rtfo, Xtfo);
  final parameter Types.ComplexPerUnit Ytfo = Complex(Gtfo, Btfo);

  final parameter Types.ComplexPerUnit A = 1 + Zlne*Ytfo;
  final parameter Types.ComplexPerUnit B = Zlne;
  final parameter Types.ComplexPerUnit C = (Ylne+Ytfo)*(1+Zlne*Ylne) + Ylne;
  final parameter Types.ComplexPerUnit D = 1 + Zlne * (Ylne+Ytfo);

  final parameter Types.ComplexPerUnit i0InjPu = C*uReg0Pu - D*iReg0Pu;
  final parameter Types.ComplexPerUnit u0Pu = A*uReg0Pu - B*iReg0Pu + Ztfo*i0InjPu;

equation

  // Base change from SnRef to SNom, convention change from receptor to injector:
  iRegInjPu.re = -iRegPu_SnRef.re * SystemBase.SnRef / SNom;
  iRegInjPu.im = -iRegPu_SnRef.im * SystemBase.SnRef / SNom;
  PRegInjPu = -PRegPu_SnRef*SystemBase.SnRef/SNom;
  QRegInjPu = -QRegPu_SnRef*SystemBase.SnRef/SNom;
  PRefInjPu = -PRefPu*SystemBase.SnRef/SNom;
  QRefInjPu = -QRefPu*SystemBase.SnRef/SNom;

  connect(OmegaRefPu, wecc_repc.OmegaRefPu_PC) annotation(
    Line(points = {{-103, -2}, {-58, -2}}, color = {0, 0, 127}));
  connect(injector_uir.uPu, vsourceref.uPu) annotation(
    Line(points = {{82, 12}, {90, 12}, {90, 28}, {32, 28}, {32, 14}, {36, 14}, {36, 14}}, color = {85, 170, 255}));
  connect(injector_uir.UPu, wecc_regc.UPu) annotation(
    Line(points = {{82, 14}, {88, 14}, {88, 26}, {2, 26}, {2, 14}, {10, 14}, {10, 14}}, color = {0, 0, 127}));
  connect(injector_uir.UPu, wecc_reec.UPu) annotation(
    Line(points = {{82, 14}, {88, 14}, {88, 26}, {-26, 26}, {-26, 14}, {-22, 14}, {-22, 14}}, color = {0, 0, 127}));
  connect(injector_uir.QInjPu, wecc_reec.QInjPu) annotation(
    Line(points = {{82, 8}, {92, 8}, {92, 30}, {-28, 30}, {-28, 10}, {-22, 10}, {-22, 10}}, color = {0, 0, 127}));
  connect(injector_uir.PInjPu, wecc_reec.PInjPu) annotation(
    Line(points = {{82, 4}, {94, 4}, {94, 32}, {-30, 32}, {-30, 6}, {-22, 6}}, color = {0, 0, 127}));
  connect(wecc_reec.FRTon, wecc_regc.FRTon) annotation(
    Line(points = {{-1, 11}, {4, 11}, {4, 8}, {10, 8}}, color = {255, 0, 255}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{-1, -1}, {5, -1}, {5, 0}, {10, 0}}, color = {0, 0, 127}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{-1, 6}, {2, 6}, {2, 4}, {10, 4}}, color = {0, 0, 127}));
  connect(wecc_repc.PRefPu_EC, wecc_reec.PRefPu_EC) annotation(
    Line(points = {{-32, -2}, {-22, -2}}, color = {0, 0, 127}));
  connect(wecc_repc.Q_VRefPu_EC, wecc_reec.Q_VRefPu_EC) annotation(
    Line(points = {{-32, 2}, {-22, 2}}, color = {0, 0, 127}));
  connect(vsourceref.uiSource, injector_uir.uiSourcePu) annotation(
    Line(points = {{56, 0}, {62, 0}, {62, 0}, {62, 0}}, color = {0, 0, 127}));
  connect(vsourceref.urSource, injector_uir.urSourcePu) annotation(
    Line(points = {{56, 6}, {62, 6}, {62, 6}, {62, 6}}, color = {0, 0, 127}));
  connect(wecc_regc.idRef, vsourceref.idPu) annotation(
    Line(points = {{30, 0}, {34, 0}, {34, 0}, {36, 0}}, color = {0, 0, 127}));
  connect(wecc_regc.iqRef, vsourceref.iqPu) annotation(
    Line(points = {{30, 6}, {34, 6}, {34, 6}, {36, 6}}, color = {0, 0, 127}));
  connect(uRegPu, pll.uPu) annotation(
    Line(points = {{-48, -54}, {-50, -54}, {-50, -42}, {-10, -42}, {-10, -36}, {-10, -36}}, color = {85, 170, 255}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{14, -38}, {0, -38}, {0, -36}, {0, -36}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, wecc_repc.OmegaPu) annotation(
    Line(points = {{-8, -16}, {-10, -16}, {-10, -12}, {-38, -12}, {-38, -4}, {-38, -4}}, color = {0, 0, 127}));
  connect(PRegInjPu, wecc_repc.PRegPu) annotation(
    Line(points = {{-18, -54}, {-20, -54}, {-20, -32}, {-42, -32}, {-42, -4}, {-42, -4}}, color = {0, 0, 127}));
  connect(QRegInjPu, wecc_repc.QRegPu) annotation(
    Line(points = {{-32, -54}, {-34, -54}, {-34, -36}, {-46, -36}, {-46, -4}, {-46, -4}}, color = {0, 0, 127}));
  connect(uRegPu, wecc_repc.uRegPu) annotation(
    Line(points = {{-48, -54}, {-50, -54}, {-50, -4}, {-50, -4}}, color = {85, 170, 255}));
  connect(iRegInjPu, wecc_repc.iRegPu) annotation(
    Line(points = {{-66, -54}, {-68, -54}, {-68, -14}, {-54, -14}, {-54, -4}, {-56, -4}}, color = {85, 170, 255}));
  connect(QRefInjPu, wecc_repc.QRefPu_PC) annotation(
    Line(points = {{-102, 10}, {-58, 10}, {-58, 8}, {-58, 8}}, color = {0, 0, 127}));
  connect(PRefInjPu, wecc_repc.PRefPu_PC) annotation(
    Line(points = {{-102, 24}, {-80, 24}, {-80, 14}, {-58, 14}, {-58, 14}}, color = {0, 0, 127}));
  connect(injector_uir.terminal, Zsource.terminal1) annotation(
    Line);
  connect(terminal, Zsource.terminal2) annotation(
    Line);

  Zsource.switchOffSignal1.value = false;
  Zsource.switchOffSignal2.value = false;

annotation(
    Documentation(info = "<html>
<p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p> The overall model is structured as follows:
<ul>
<li> Main model: WECC_PV with terminal connection and measurement inputs for P/Q/U/I. </li>
<li> Plant level control. </li>
<li> Electrical inverter control.</li>
<li> Generator control. </li>
<li> VoltageSource reference calculation. </li>
<li> Injector (ui, ur). </li>
<li> Source impedance. </li>
</ul> </p></html>"),
    Diagram(coordinateSystem(extent = {{-100, -50}, {100, 50}})),
    Icon(coordinateSystem(extent = {{-100, -50}, {100, 50}}, initialScale = 0.1), graphics = {Text(origin = {7, -1}, extent = {{-85, 43}, {71, -39}}, textString = "WECC_PV"), Rectangle(origin = {-8, 5}, extent = {{-92, 45}, {108, -55}})}),
    version = "",
    uses(Dynawo(version = "0.1")),
    __OpenModelica_commandLineOptions = "",
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));

end PVVoltageSource;
