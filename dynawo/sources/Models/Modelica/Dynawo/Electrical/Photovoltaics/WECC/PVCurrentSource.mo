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


model PVCurrentSource

  import Modelica.Blocks;
  import Modelica.ComplexBlocks;

  import Complex;
  import Dynawo.Electrical.Controls.PLL;
  import Dynawo.Electrical.Sources;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Types;
  import Dynawo.Connectors;

  parameter Types.PerUnit UReg0Pu "Initial value of voltage magnitude at regulated bus in p.u.";
  parameter Types.PerUnit PReg0Pu "Initial value of active power reception at regulated bus (pu base SnRef)";
  parameter Types.PerUnit QReg0Pu "Initial value of power reception at regulated bus (pu base SnRef)";
  parameter Types.Angle URegPhase0 "Initial phase angle of voltage at regulated bus";
  parameter Types.PerUnit Omega0Pu "Initial value value of omega at regulated bus";
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
    Placement(visible = true, transformation(origin = {-103, 12}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-100, 18}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Blocks.Interfaces.RealInput OmegaRefPu "Reference value of omega at regulated bus" annotation(
    Placement(visible = true, transformation(origin = {-103, -12}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-100, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

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
    UReg0Pu = UReg0Pu, VcompFlag = true, Vfrz = 0.0, Xc = 0.000025 + 0.05, dbd = 0.01,
    eMax = 999, eMin = -999, fdbd1 = 0.004, fdbd2 = 1, feMax = 999, feMin = -999,
    iReg0Pu = iReg0InjPu, uReg0Pu = uReg0Pu) annotation(
    Placement(visible = true, transformation(origin = {-45, 6}, extent = {{-15, -10}, {10, 10}}, rotation = 0)));

  BaseControls.REEC_electricalControl wecc_reec(
    Imax = 1.05, Iqh1 = 2, Iql1 = -2, Kqi = 0.5, Kqp = 1, Kqv = 2, Kvi = 1, Kvp = 1,
    P0Pu = P0InjPu, PFref = PFref0, PRefPu_EC(start = P0InjPu), PfFlag = false, PInjPu(start = P0InjPu),
    Pmax = 1, Pmin = 0, PqFlag = false,
    Q0Pu = Q0InjPu, QFlag = true, Q_VRefPu_EC(start = Q0InjPu), QInjPu(start = Q0InjPu),
    Qmax = 0.4, Qmin = -0.4, Tiq = 0.02, Tp = 0.04, Tpord = 0.02, Trv = 0.02,
    U0Pu = U0Pu, VFlag = true, Vdip = 0.9, Vmax = 1.1, Vmin = 0.9, Vref0 = 1, Vup = 1.1, dPmax = 999, dPmin = -999, dbd1 = -0.1, dbd2 = 0.1)  annotation(
  Placement(visible = true, transformation(origin = {-1.69825, 5.65529}, extent = {{-15.9149, -10.3447}, {4.77448, 10.3447}}, rotation = 0)));

  Sources.InjectorIDQ injector(
    Id0Pu = Id0Pu, Iq0Pu = -Iq0Pu,
    P0Pu = P0Pu, PInjPu(start = P0InjPu), Q0Pu = Q0Pu, QInjPu(start = Q0InjPu), SNom = SNom,
    U0Pu = U0Pu,
    UPhase0 = UPhase0,
    i0Pu = i0Pu,
    s0Pu = s0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {72, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  BaseControls.REGC_generatorControl wecc_regc(
    Id0Pu = Id0Pu, Iq0Pu = Iq0Pu,
    Iqrmax = 20, Iqrmin = -20, P0Pu = P0InjPu, RateFlag = false, Tfltr = 0.02, Tg = 0.02, U0Pu = U0Pu, rrpwr = 10)  annotation(
    Placement(visible = true, transformation(origin = {41.8052, 7.68416}, extent = {{-9.80516, -8.4978}, {9.80516, 11.7662}}, rotation = 0)));

  Blocks.Sources.Constant OmegaRef(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {19, -39}, extent = {{-5, -5}, {5, 5}}, rotation = 180)));
  PLL.PLL pll(Ki = 20, Kp = 3, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, u0Pu = uReg0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-4, -26}, extent = {{-10, -10}, {15, 10}}, rotation = 90)));

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
  //final parameter Types.ComplexPerUnit i0InjPu = iReg0InjPu; //  See below for detailed calculation considering B and G of plant elements
  //final parameter Types.ComplexPerUnit u0Pu = uReg0Pu + i0InjPu*Complex(wecc_repc.Rc, wecc_repc.Xc); //  See below for detailed calculation considering B and G of plant elements
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

  // Setpoints injector (injector convention, Base SNom)
  final parameter Types.PerUnit Id0Pu =  cos(UPhase0)*i0InjPu.re + sin(UPhase0)*i0InjPu.im;
  final parameter Types.PerUnit Iq0Pu = -sin(UPhase0)*i0InjPu.re + cos(UPhase0)*i0InjPu.im;

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

  connect(wecc_reec.FRTon, wecc_regc.FRTon) annotation(
    Line(points = {{15, 11}, {24, 11}, {24, 9}, {31, 9}}, color = {255, 0, 255}));
  connect(wecc_repc.Q_VRefPu_EC, wecc_reec.Q_VRefPu_EC) annotation(
    Line(points = {{-32, 2}, {-6, 2}}, color = {0, 0, 127}));
  connect(wecc_repc.PRefPu_EC, wecc_reec.PRefPu_EC) annotation(
    Line(points = {{-32, -2}, {-6, -2}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_reec.UPu) annotation(
    Line(points = {{82, 14}, {84, 14}, {84, 22}, {-12, 22}, {-12, 13}, {-6, 13}}, color = {0, 0, 127}));
  connect(injector.PInjPu, wecc_reec.PInjPu) annotation(
    Line(points = {{82, 4}, {90.2, 4}, {90.2, 30}, {-15.8, 30}, {-15.8, 6}, {-6, 6}}, color = {0, 0, 127}));
  connect(injector.QInjPu, wecc_reec.QInjPu) annotation(
    Line(points = {{82, 8}, {86.2, 8}, {86.2, 26}, {-13.8, 26}, {-13.8, 9}, {-6, 9}}, color = {0, 0, 127}));
  connect(wecc_reec.iqCmdPu, wecc_regc.iqCmdPu) annotation(
    Line(points = {{15, 6}, {24, 6}, {24, 4}, {31, 4}}, color = {0, 0, 127}));
  connect(wecc_reec.idCmdPu, wecc_regc.idCmdPu) annotation(
    Line(points = {{15, -1}, {22, -1}, {22, 0}, {31, 0}}, color = {0, 0, 127}));
  connect(OmegaRef.y, pll.omegaRefPu) annotation(
    Line(points = {{13.5, -39}, {0, -39}, {0, -36}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, wecc_repc.OmegaPu) annotation(
    Line(points = {{-10, -16}, {-10, -16}, {-10, -8}, {-38, -8}, {-38, -4}, {-38, -4}}, color = {0, 0, 127}));
  connect(uRegPu, pll.uPu) annotation(
    Line(points = {{-48, -54}, {-50, -54}, {-50, -42}, {-10, -42}, {-10, -36}, {-10, -36}}, color = {85, 170, 255}));
  connect(iRegInjPu, wecc_repc.iRegPu) annotation(
    Line(points = {{-66, -54}, {-66, -54}, {-66, -24}, {-54, -24}, {-54, -4}, {-54, -4}}, color = {85, 170, 255}));
  connect(uRegPu, wecc_repc.uRegPu) annotation(
    Line(points = {{-48, -54}, {-48, -47}, {-50, -47}, {-50, -4}}, color = {85, 170, 255}));
  connect(OmegaRefPu, wecc_repc.OmegaRefPu_PC) annotation(
    Line(points = {{-102, -12}, {-80, -12}, {-80, -2}, {-57, -2}}, color = {0, 0, 127}));
  connect(PRefInjPu, wecc_repc.PRefPu_PC) annotation(
    Line(points = {{-102, 24}, {-80, 24}, {-80, 14}, {-57, 14}}, color = {0, 0, 127}));
  connect(QRefInjPu, wecc_repc.QRefPu_PC) annotation(
    Line(points = {{-102, 12}, {-88, 12}, {-88, 9}, {-57, 9}}, color = {0, 0, 127}));
  connect(PRegInjPu, wecc_repc.PRegPu) annotation(
    Line(points = {{-16, -54}, {-18, -54}, {-18, -12}, {-42, -12}, {-42, -4}}, color = {0, 0, 127}));
  connect(QRegInjPu, wecc_repc.QRegPu) annotation(
    Line(points = {{-32, -54}, {-32, -29}, {-46, -29}, {-46, -4}}, color = {0, 0, 127}));
  connect(wecc_regc.iqRef, injector.iqPu) annotation(
    Line(points = {{53, 6}, {62, 6}}, color = {0, 0, 127}));
  connect(wecc_regc.idRef, injector.idPu) annotation(
    Line(points = {{53, 0}, {62, 0}}, color = {0, 0, 127}));
  connect(injector.UPu, wecc_regc.UPu) annotation(
    Line(points = {{82, 14}, {84, 14}, {84, 22}, {26, 22}, {26, 13}, {31, 13}}, color = {0, 0, 127}));
  connect(injector.terminal, terminal) annotation(
    Line(points = {{82, 0}, {102, 0}}, color = {0, 0, 255}));

annotation(
    Documentation(info = "<html>
<p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p> The overall model is structured as follows:
<ul>
<li> Main model: WECC_PV with terminal connection and measurement inputs for P/Q/U/I. </li>
<li> Plant level control. </li>
<li> Electrical inverter control.</li>
<li> Generator control. </li>
<li> Injector (id,iq). </li>
</ul> </p></html>"),
    Diagram(coordinateSystem(extent = {{-100, -50}, {100, 50}})),
    Icon(coordinateSystem(extent = {{-100, -50}, {100, 50}}, initialScale = 0.1), graphics = {Text(origin = {7, -1}, extent = {{-85, 43}, {71, -39}}, textString = "WECC_PV"), Rectangle(origin = {-8, 5}, extent = {{-92, 45}, {108, -55}})}),
    version = "",
    uses(Dynawo(version = "0.1")),
    __OpenModelica_commandLineOptions = "",
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));

end PVCurrentSource;
