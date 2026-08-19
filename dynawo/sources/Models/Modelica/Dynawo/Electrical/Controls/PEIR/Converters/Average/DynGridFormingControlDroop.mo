within Dynawo.Electrical.Controls.PEIR.Converters.Average;

model DynGridFormingControlDroop
  /*
  * Copyright (c) 2025, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
  */

  // Droop & Voltage reference control parameters
  parameter Types.PerUnit Mp "Active power droop control coefficient";
  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.PerUnit Wf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";
  // QSEM parameter
  parameter Real XVI "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control";
  // Current loop parameters
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit Kfd "Feedforward gain on the d-axis";
  parameter Types.PerUnit Kfq "Feedforward gain on the q-axis";
  // Virtual impedance parameters
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.CurrentModulePu IMaxVI "Maximum current before activating the virtual impedance in pu (base UNom, SNom)";
  // Filter parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LFilterPu "Filter inductance in pu (base UNom, SNom)";
  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LTransformerPu "Transformer inductance in pu (base UNom, SNom)";
  //PLL parameters
  parameter Types.PerUnit KpPLL "PLL Proportional gain";
  parameter Types.PerUnit KiPLL "PLL Integrator gain";
  //Operating Point
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal/PCC in rad";
  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = PFilter0Pu) "Active power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-32, 110}, extent = {{-8, -8}, {8, 8}}, rotation = -90), iconTransformation(origin = {-109, -73}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = QFilter0Pu) "Reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-46, 110}, extent = {{-8, -8}, {8, 8}}, rotation = -90), iconTransformation(origin = {-109, -93}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -34}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-85, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -16}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-65, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {88, -108}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-37, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, -108}, extent = {{-8, -8}, {8, 8}}, rotation = 90), iconTransformation(origin = {-17, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilteredPccPu(start = UdPcc0Pu) "Filtered d-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, -78}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {37, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilteredPccPu(start = UqPcc0Pu) "Filtered q-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, -92}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {17, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -64}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {67, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -52}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {87, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = PFilter0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-108, 86}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, 77}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, 96}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 33}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage module reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-108, 76}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, 3}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = QFilter0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 8}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -19}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {107, 31}, extent = {{-7, -7}, {7, 7}}), iconTransformation(origin = {110, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {107, 17}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(transformation(origin = {106, 86}, extent = {{-6, -6}, {6, 6}}), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {106, 76}, extent = {{-6, -6}, {6, 6}}), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPLL(start = Omega0Pu) "Measured frequency from the grid (base omegaNom)" annotation(
    Placement(transformation(origin = {106, 62}, extent = {{-6, -6}, {6, 6}}), iconTransformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.DynQSEM QSEM(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, LFilter = LTransformerPu, RFilter = RTransformerPu, UdFilter0Pu = UdFilter0Pu, UdPcc0Pu = UdPcc0Pu, UqFilter0Pu = UqFilter0Pu, UqPcc0Pu = UqPcc0Pu, XVI = XVI, Omega0Pu = Omega0Pu) annotation(
    Placement(transformation(origin = {18, 24}, extent = {{-16, -16}, {16, 16}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.CurrentLoops.DynCurrentLoop currentLoop(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, Kfd = Kfd, Kfq = Kfq, Kic = Kic, Kpc = Kpc, LFilter = LFilterPu, RFilter = RFilterPu, UdConv0Pu = UdConv0Pu, UdFilter0Pu = UdFilter0Pu, UqConv0Pu = UqConv0Pu, UqFilter0Pu = UqFilter0Pu, Omega0Pu = Omega0Pu, IdConvRef0Pu = IdConv0Pu, IqConvRef0Pu = IqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {76, 24}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Controls.PEIR.BaseControls.VirtualImpedance2 VI(IMaxVI = IMaxVI, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, KpVI = KpVI, XRratio = XRratio) annotation(
    Placement(visible = true, transformation(origin = {-75, -25}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  // Initial parameters
  parameter Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage reference in pu (base UNom)";
  parameter Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage reference in pu (base UNom)";
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UdPcc0Pu "Start value of d-axis voltage at the PCC in pu (base UNom)";
  parameter Types.PerUnit UqPcc0Pu "Start value of q-axis voltage at the PCC in pu (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at the PCC in pu (base UNom)";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of converter's frequency in pu (base omegaNom)";
  parameter Types.ActivePowerPu PFilter0Pu "Start value of active power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  final parameter Types.VoltageModulePu URef0Pu = sqrt(UdFilter0Pu*UdFilter0Pu + UqFilter0Pu*UqFilter0Pu) "Start value of voltage module reference in pu (base UNom)";
  PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = 2.0, OmegaMinPu = 0, u0Pu = u0Pu) annotation(
    Placement(transformation(origin = {-90, 42}, extent = {{-6, -6}, {6, 6}})));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPccPu(re(start = u0Pu.re), im(start = u0Pu.im)) annotation(
    Placement(transformation(origin = {-108, 54}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {-109, 55}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Continuous.FirstOrder PLLFilter(T = 0.01, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = Omega0Pu) annotation(
    Placement(transformation(origin = {-76, 64}, extent = {{-6, -6}, {6, 6}})));
  PLL.PLL_INIT pll_init(U0Pu = U0Pu, UPhase0 = UPhase0) annotation(
    Placement(transformation(origin = {-138, 14}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.Converters.BaseControls.DroopControl droopControl(IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, Kff = Kff, Mp = Mp, Mq = Mq, PFilter0Pu = PFilter0Pu, PRef0Pu = PFilter0Pu, QFilter0Pu = QFilter0Pu, QRef0Pu = QFilter0Pu, Theta0 = Theta0, UFilterRef0Pu = URef0Pu, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, Wf = Wf, Wff = Wff, DeltaVVId0 = VI.DeltaVVId0, DeltaVVIq0 = VI.DeltaVVIq0) annotation(
    Placement(transformation(origin = {-23, 77}, extent = {{-15, -15}, {15, 15}})));
equation
  connect(udConvRefPu, currentLoop.udConvRefPu) annotation(
    Line(points = {{107, 31}, {94, 31}, {94, 30}}, color = {245, 121, 0}, thickness = 0.5));
  connect(iqConvPu, VI.iqConvPu) annotation(
    Line(points = {{-108, -34}, {-94, -34}}, color = {0, 0, 127}));
  connect(idConvPu, currentLoop.idConvPu) annotation(
    Line(points = {{-108, -16}, {84, -16}, {84, 6}}, color = {245, 121, 0}, pattern = LinePattern.Dash));
  connect(iqConvPu, currentLoop.iqConvPu) annotation(
    Line(points = {{-108, -34}, {92, -34}, {92, 6}}, color = {245, 121, 0}, pattern = LinePattern.Dash));
  connect(udFilterPu, currentLoop.udFilterPu) annotation(
    Line(points = {{40, -108}, {40, -51}, {60, -51}, {60, 6}}, color = {85, 170, 0}));
  connect(QSEM.uqFilteredPCCPu, uqFilteredPccPu) annotation(
    Line(points = {{23, 6}, {23, -92}, {-108, -92}}, color = {85, 170, 255}));
  connect(currentLoop.uqFilterPu, uqFilterPu) annotation(
    Line(points = {{68, 6}, {68, -51}, {88, -51}, {88, -108}}, color = {85, 170, 0}));
  connect(currentLoop.uqConvRefPu, uqConvRefPu) annotation(
    Line(points = {{94, 18}, {94, 17}, {107, 17}}, color = {245, 121, 0}, thickness = 0.5));
  connect(udFilteredPccPu, QSEM.udFilteredPCCPu) annotation(
    Line(points = {{-108, -78}, {12, -78}, {12, 6}, {13, 6}}, color = {85, 170, 255}));
  connect(idConvPu, VI.idConvPu) annotation(
    Line(points = {{-108, -16}, {-94, -16}}, color = {245, 121, 0}));
  connect(QSEM.idConvRefPu, currentLoop.idConvRefPu) annotation(
    Line(points = {{36, 30}, {58, 30}}, color = {0, 0, 127}));
  connect(QSEM.iqConvRefPu, currentLoop.iqConvRefPu) annotation(
    Line(points = {{36, 18}, {58, 18}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, omegaPLL) annotation(
    Line(points = {{-83, 45}, {36, 45}, {36, 62}, {106, 62}}, color = {0, 0, 127}));
  connect(uPccPu, pll.uPu) annotation(
    Line(points = {{-108, 54}, {-103.5, 54}, {-103.5, 46}, {-97, 46}}, color = {85, 170, 255}));
  connect(droopControl.uqFilterRefPu, QSEM.uqFilterRefPu) annotation(
    Line(points = {{-6.5, 62}, {-13, 62}, {-13, 18}, {0, 18}}, color = {0, 0, 127}));
  connect(droopControl.udFilterRefPu, QSEM.udFilterRefPu) annotation(
    Line(points = {{-6.5, 92}, {0, 92}, {0, 31}, {1, 31}}, color = {0, 0, 127}));
  connect(droopControl.theta, theta) annotation(
    Line(points = {{-6.5, 84.5}, {39, 84.5}, {39, 86}, {106, 86}}, color = {0, 0, 127}));
  connect(droopControl.omegaPu, omegaPu) annotation(
    Line(points = {{-6.5, 77}, {39, 77}, {39, 76}, {106, 76}}, color = {0, 0, 127}));
  connect(omegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{-108, 96}, {-108, 94}, {-97, 94}, {-97, 38}}, color = {0, 0, 127}));
  connect(VI.DeltaVVId, droopControl.DeltaVVId) annotation(
    Line(points = {{-56, -16}, {-54, -16}, {-54, 60.5}, {-38, 60.5}}, color = {0, 0, 127}));
  connect(VI.DeltaVVIq, droopControl.DeltaVVIq) annotation(
    Line(points = {{-56, -34}, {-46.5, -34}, {-46.5, 60.5}, {-30.5, 60.5}}, color = {0, 0, 127}));
  connect(idPccPu, droopControl.idPccPu) annotation(
    Line(points = {{-108, -52}, {-39, -52}, {-39, 60.5}, {-23, 60.5}}, color = {0, 0, 127}));
  connect(iqPccPu, droopControl.iqPccPu) annotation(
    Line(points = {{-108, -64}, {-31.5, -64}, {-31.5, 60.5}, {-15.5, 60.5}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, PLLFilter.u) annotation(
    Line(points = {{-83, 45}, {-83, 64}}, color = {0, 0, 127}));
  connect(PFilterPu, droopControl.PFilterPu) annotation(
    Line(points = {{-32, 110}, {-32, 102}, {-15.5, 102}, {-15.5, 93.5}}, color = {0, 0, 127}));
  connect(QFilterPu, droopControl.QFilterPu) annotation(
    Line(points = {{-46, 110}, {-46, 102}, {-30.5, 102}, {-30.5, 93.5}}, color = {0, 0, 127}));
  connect(PFilterRefPu, droopControl.PRefPu) annotation(
    Line(points = {{-108, 86}, {-56, 86}, {-56, 92}, {-39.5, 92}}, color = {0, 0, 127}));
  connect(URefPu, droopControl.UFilterRefPu) annotation(
    Line(points = {{-108, 76}, {-108, 77}, {-39.5, 77}}, color = {0, 0, 127}));
  connect(QFilterRefPu, droopControl.QRefPu) annotation(
    Line(points = {{-108, 8}, {-56, 8}, {-56, 62}, {-39.5, 62}}, color = {0, 0, 127}));
  connect(droopControl.omegaPu, QSEM.omegaPu) annotation(
    Line(points = {{-6, 76}, {18, 76}, {18, 42}}, color = {0, 0, 127}));
  connect(droopControl.omegaPu, currentLoop.omegaPu) annotation(
    Line(points = {{-6, 76}, {76, 76}, {76, 42}}, color = {0, 0, 127}));
  connect(omegaRefPu, droopControl.omegaRefPu) annotation(
    Line(points = {{-108, 96}, {-8, 96}, {-8, 60}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Diagram(graphics = {Text(origin = {45, 35}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idConvRefPu", fontSize = 5, textStyle = {TextStyle.Bold}), Text(origin = {45, 23}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqConvRefPu", fontSize = 5, textStyle = {TextStyle.Bold}), Text(origin = {-11, 35}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udFilterRefPu", fontSize = 5, textStyle = {TextStyle.Bold}), Text(origin = {-11, 23}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqFilterRefPu", fontSize = 5, textStyle = {TextStyle.Bold})}),
    Documentation);
end DynGridFormingControlDroop;
