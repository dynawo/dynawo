within Dynawo.Electrical.Controls.PEIR.Converters.Average;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model DynGridFormingControlCCVSM

  // VSM parameters
  parameter Types.PerUnit kVSM "Virtual Synchronous Machine gain";
  parameter Types.Time H "Inertia constant in s";
  parameter Types.PerUnit KDampingAngle "Proportional gain of the PI action on theta (angle-damping term) in s";
  // Voltage reference control parameters
  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.AngularVelocity Omegaf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.AngularVelocity Omegaff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";
  // QSEM parameter
  parameter Types.PerUnit XVIPu "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control";
  // Current loop parameters
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit Kfd "Feedforward gain on the d-axis";
  parameter Types.PerUnit Kfq "Feedforward gain on the q-axis";
  // Virtual impedance parameters
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.CurrentModulePu IMaxVIPu "Maximum current before activating the virtual impedance in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu DeltaIConvMaxPu "Maximum extra current module used to compute RVIPu/XVIPu, in pu (base UNom, SNom): bounds the virtual impedance correction regardless of how large the measured current becomes";
  parameter Types.CurrentModulePu EpsVIUpPu "Upper half-width of the dead band around IMaxVI, to avoid chattering at the activation threshold";
  parameter Types.CurrentModulePu EpsVIDownPu "Lower half-width of the dead band around IMaxVI, to avoid chattering at the activation threshold";
  // Filter parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LFilterPu "Filter inductance in pu (base UNom, SNom)";
  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LTransformerPu "Transformer inductance in pu (base UNom, SNom)";
  //PLL parameters
  parameter Types.PerUnit Ki "PLL integrator gain";
  parameter Types.PerUnit Kp "PLL proportional gain";
  parameter Types.AngularVelocityPu OmegaMaxPLLPu "Upper frequency limit of the PLL in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaMinPLLPu "Lower frequency limit of the PLL in pu (base omegaNom)";
  //Current Saturation parameters
  parameter Types.CurrentModulePu ImaxPu "Current max threshold to limit a current's module";
  parameter Types.CurrentModulePu IminPu "Current min threshold to limit a current's module";
  parameter Types.CurrentModulePu EpsUpPu "Upper half-width of the dead band around Imax/Imin, to avoid chattering at the activation threshold";
  parameter Types.CurrentModulePu EpsDownPu "Lower half-width of the dead band around Imax/Imin, to avoid chattering at the activation threshold";
  parameter Types.Time tSat "Time constant of the first-order filter on the dq reference currents (in s)";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = PFilter0Pu) "Active power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-109, -73}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = QFilter0Pu) "Reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-109, -93}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-85, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-65, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(transformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-37, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(transformation(origin = {50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-17, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilteredPccPu(start = UdPcc0Pu) "Filtered d-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {37, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilteredPccPu(start = UqPcc0Pu) "Filtered q-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-10, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {17, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {67, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {87, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = PFilterRef0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 84}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-109, 77}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput iqFilteredPccPu(start = IqPcc0Pu) "q-axis filtered current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {109, -89}, extent = {{-9, -9}, {9, 9}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput idFilteredPccPu(start = IdPcc0Pu) "d-axis current filtered in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {10, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {109, -69}, extent = {{-9, -9}, {9, 9}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = OmegaRef0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-109, 33}, extent = {{-9, -9}, {9, 9}})));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPccPu(re(start = u0Pu.re), im(start = u0Pu.im)) annotation(
    Placement(transformation(origin = {-110, 56}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-109, 55}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage module reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-109, 3}, extent = {{-9, -9}, {9, 9}})));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = QFilterRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-109, -19}, extent = {{-9, -9}, {9, 9}})));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, 1.77636e-15}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPLL(start = Omega0Pu) "Measured frequency from the grid (base omegaNom)" annotation(
    Placement(transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls.CCVSM VSM(H = H, PFilter0Pu = PFilter0Pu, PFilterRef0Pu = PFilterRef0Pu, kVSM = kVSM, Omega0Pu = Omega0Pu, Theta0 = Theta0, KDampingAngle = KDampingAngle, omegaRefPu(start = OmegaRef0Pu), integrator1(y_start = Theta0 - KDampingAngle*SystemBase.omegaNom*(Omega0Pu - OmegaRef0Pu))) annotation(
    Placement(transformation(origin = {-10, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder PLLFilter(T = 0.01, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = Omega0Pu) annotation(
    Placement(transformation(origin = {-40, 60}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.VoltageReferenceControl voltageReferenceControl(Mq = Mq, Omegaf = Omegaf, Omegaff = Omegaff, Kff = Kff, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, DeltaVVId0Pu = VICC.DeltaVVId0Pu, DeltaVVIq0Pu = VICC.DeltaVVIq0Pu, QFilter0Pu = QFilter0Pu, QFilterRef0Pu = QFilterRef0Pu, URef0Pu = URef0Pu) annotation(
    Placement(transformation(origin = {-50, 10}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.DynQSEM QSEM(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, LFilterPu = LTransformerPu, Omega0Pu = Omega0Pu, RFilterPu = RTransformerPu, UdFilter0Pu = voltageReferenceControl.UdRef0Pu, UdPcc0Pu = UdPcc0Pu, UqFilter0Pu = voltageReferenceControl.UqRef0Pu, UqPcc0Pu = UqPcc0Pu, XVIPu = XVIPu) annotation(
    Placement(transformation(origin = {-10, 10}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.InnerControls.CurrentSaturation currentSaturation(ImaxPu = ImaxPu, IminPu = IminPu, CurrentAngle0 = CurrentAngle0, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, IdConvRef0Pu = IdConv0Pu, IqConvRef0Pu = IqConv0Pu, IdConvSatRef0Pu = IdConv0Pu, IqConvSatRef0Pu = IqConv0Pu, IPcc0Pu = IPcc0Pu, EpsUpPu = EpsUpPu, EpsDownPu = EpsDownPu, tSat = tSat) annotation(
    Placement(transformation(origin = {30, 10}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.VirtualImpedance2CC VICC(KpVI = KpVI, XRratio = XRratio, IMaxVIPu = IMaxVIPu, DeltaIConvMaxPu = DeltaIConvMaxPu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, EpsVIUpPu = EpsVIUpPu, EpsVIDownPu = EpsVIDownPu) annotation(
    Placement(transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.CurrentLoops.DynCurrentLoop currentLoop(Kpc = Kpc, Kic = Kic, RFilterPu = RFilterPu, LFilterPu = LFilterPu, Kfd = Kfd, Kfq = Kfq, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, UdConv0Pu = UdConv0Pu, UqConv0Pu = UqConv0Pu, IdConvRef0Pu = IdConvSatRef0Pu, IqConvRef0Pu = IqConvSatRef0Pu, Omega0Pu = Omega0Pu) annotation(
    Placement(transformation(origin = {70, 10}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PLL.PLL pll(Kp = Kp, Ki = Ki, u0Pu = u0Pu, OmegaMaxPu = OmegaMaxPLLPu, OmegaMinPu = OmegaMinPLLPu, omegaPLLPu(start = Omega0Pu), omegaRefPu(start = OmegaRef0Pu), limIntegrator(y_start = Omega0Pu - OmegaRef0Pu)) annotation(
    Placement(transformation(origin = {-70, 50}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal/PCC in rad";
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
  parameter Types.CurrentModulePu IdConvSatRef0Pu "Start value of the satured value of id";
  parameter Types.CurrentModulePu IqConvSatRef0Pu "Start value of the satured value of iq";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at the PCC in pu (base UNom)";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of converter's frequency in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaRef0Pu = SystemBase.omegaRef0Pu "Start value of the rotation speed of the RI reference frame (omegaRefPu input) in pu (base omegaNom)";
  parameter Types.ActivePowerPu PFilter0Pu "Start value of active power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ActivePowerPu PFilterRef0Pu "Start value of active power reference at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QFilterRef0Pu "Start value of reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu URef0Pu "Start value of voltage module reference in pu (base UNom): module of the internal EMF, consistent with QFilterRefPu = QFilter0Pu";

  final parameter Types.CurrentModulePu IPcc0Pu = sqrt(IdConv0Pu*IdConv0Pu + IqConv0Pu*IqConv0Pu) "Start value of the module of the current in dq representation IdConv0Pu,IqConv0Pu";
  final parameter Types.CurrentModulePu CurrentAngle0 = atan2(IqConv0Pu, IdConv0Pu) "Start value of the phase angle of the current in dq representation IdConv0Pu,IqConv0Pu";

equation
  connect(idConvPu, VICC.idConvPu) annotation(
    Line(points = {{-110, -20}, {-110, -19.5}, {-90, -19.5}, {-90, -19}, {-84.5, -19}, {-84.5, -25}, {-81, -25}}, color = {245, 121, 0}, thickness = 0.5));
  connect(iqConvPu, VICC.iqConvPu) annotation(
    Line(points = {{-110, -50}, {-110, -49}, {-86.5, -49}, {-86.5, -35}, {-81, -35}}, color = {245, 121, 0}, thickness = 0.5));
  connect(pll.omegaPLLPu, PLLFilter.u) annotation(
    Line(points = {{-59, 55}, {-59, 59.25}, {-53, 59.25}, {-53, 59.5}, {-52, 59.5}, {-52, 60}}, color = {0, 0, 127}));
  connect(omegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{-110, 100}, {-89.75, 100}, {-89.75, 44}, {-81, 44}}, color = {0, 0, 127}));
  connect(uPccPu, pll.uPu) annotation(
    Line(points = {{-110, 56}, {-81, 56}}, color = {85, 170, 255}));
  connect(pll.omegaPLLPu, omegaPLL) annotation(
    Line(points = {{-59, 55}, {-57, 55}, {-57, 40}, {110, 40}}, color = {0, 0, 127}));
  connect(VICC.DeltaVVIdPu, voltageReferenceControl.DeltaVVIdPu) annotation(
    Line(points = {{-59, -25}, {-59, -1}, {-60, -1}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(VICC.DeltaVVIqPu, voltageReferenceControl.DeltaVVIqPu) annotation(
    Line(points = {{-59, -35}, {-59, -34}, {-55, -34}, {-55, -1}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(idPccPu, voltageReferenceControl.idPccPu) annotation(
    Line(points = {{-70, -110}, {-70, -60.5}, {-50, -60.5}, {-50, -1}}, color = {85, 170, 255}, thickness = 0.5));
  connect(iqPccPu, voltageReferenceControl.iqPccPu) annotation(
    Line(points = {{-50, -110}, {-50, -80.5}, {-46, -80.5}, {-46, -1}, {-45, -1}}, color = {85, 170, 255}, thickness = 0.5));
  connect(omegaRefPu, VSM.omegaRefPu) annotation(
    Line(points = {{-110, 100}, {-65.5, 100}, {-65.5, 98}, {-21, 98}}, color = {0, 0, 127}));
  connect(PFilterRefPu, VSM.PFilterRefPu) annotation(
    Line(points = {{-110, 84}, {-64.5, 84}, {-64.5, 94}, {-21, 94}}, color = {0, 0, 127}));
  connect(PFilterPu, VSM.PFilterPu) annotation(
    Line(points = {{-110, 70}, {-60.5, 70}, {-60.5, 86}, {-21, 86}}, color = {0, 0, 127}));
  connect(PLLFilter.y, VSM.omegaSetPu) annotation(
    Line(points = {{-29, 60}, {-26.5, 60}, {-26.5, 82}, {-21, 82}}, color = {0, 0, 127}));
  connect(VSM.theta, theta) annotation(
    Line(points = {{1, 94}, {59.5, 94}, {59.5, 80}, {110, 80}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, omegaPu) annotation(
    Line(points = {{1, 86}, {39.25, 86}, {39.25, 60}, {110, 60}}, color = {0, 0, 127}));
  connect(QFilterPu, voltageReferenceControl.QFilterPu) annotation(
    Line(points = {{-110, 40}, {-110, 40.5}, {-86, 40.5}, {-86, 29}, {-55.5, 29}, {-55.5, 21}, {-55, 21}}, color = {0, 0, 127}));
  connect(URefPu, voltageReferenceControl.URefPu) annotation(
    Line(points = {{-110, 20}, {-80.5, 20}, {-80.5, 10}, {-61, 10}}, color = {0, 0, 127}));
  connect(QFilterRefPu, voltageReferenceControl.QFilterRefPu) annotation(
    Line(points = {{-110, 0}, {-61, 0}}, color = {0, 0, 127}));
  connect(voltageReferenceControl.udFilterRefPu, QSEM.udFilterRefPu) annotation(
    Line(points = {{-39, 14}, {-21, 14}}, color = {85, 170, 0}, thickness = 0.5));
  connect(voltageReferenceControl.uqFilterRefPu, QSEM.uqFilterRefPu) annotation(
    Line(points = {{-39, 6}, {-21, 6}}, color = {85, 170, 0}, thickness = 0.5));
  connect(QSEM.idConvRefPu, currentSaturation.idConvRefPu) annotation(
    Line(points = {{1, 14}, {19, 14}}, color = {245, 121, 0}, thickness = 0.5));
  connect(QSEM.iqConvRefPu, currentSaturation.iqConvRefPu) annotation(
    Line(points = {{1, 6}, {4, 6}, {4, 10}, {19, 10}}, color = {245, 121, 0}, thickness = 0.5));
  connect(currentSaturation.idConvSatRefPu, currentLoop.idConvRefPu) annotation(
    Line(points = {{41, 14}, {59, 14}}, color = {245, 121, 0}, thickness = 0.5));
  connect(currentSaturation.iqConvSatRefPu, currentLoop.iqConvRefPu) annotation(
    Line(points = {{41, 8}, {51, 8}, {51, 6}, {59, 6}}, color = {245, 121, 0}, thickness = 0.5));
  connect(VSM.omegaPu, currentLoop.omegaPu) annotation(
    Line(points = {{1, 86}, {1, 85}, {40.5, 85}, {40.5, 59}, {69.25, 59}, {69.25, 21}, {70, 21}}, color = {0, 0, 127}));
  connect(VSM.omegaPu, QSEM.omegaPu) annotation(
    Line(points = {{1, 86}, {14, 86}, {14, 29}, {-9, 29}, {-9, 21}, {-10, 21}}, color = {0, 0, 127}));
  connect(currentLoop.udConvRefPu, udConvRefPu) annotation(
    Line(points = {{81, 14}, {94.5, 14}, {94.5, 20}, {110, 20}}, color = {245, 121, 0}, thickness = 0.5));
  connect(currentLoop.uqConvRefPu, uqConvRefPu) annotation(
    Line(points = {{81, 6}, {95.5, 6}, {95.5, 0}, {110, 0}}, color = {245, 121, 0}, thickness = 0.5));
  connect(udFilterPu, currentLoop.udFilterPu) annotation(
    Line(points = {{50, -110}, {50, -60.5}, {60, -60.5}, {60, -1}}, color = {85, 170, 0}, thickness = 0.5));
  connect(uqFilterPu, currentLoop.uqFilterPu) annotation(
    Line(points = {{70, -110}, {70, -60.5}, {64, -60.5}, {64, -1}, {65, -1}}, color = {85, 170, 0}, thickness = 0.5));
  connect(idConvPu, currentLoop.idConvPu) annotation(
    Line(points = {{-110, -20}, {-110, -19}, {74.5, -19}, {74.5, -1}, {75, -1}}, color = {245, 121, 0}, pattern = LinePattern.Dash, thickness = 0.5));
  connect(iqConvPu, currentLoop.iqConvPu) annotation(
    Line(points = {{-110, -50}, {-110, -49.5}, {80, -49.5}, {80, -1}}, color = {245, 121, 0}, pattern = LinePattern.Dash, thickness = 0.5));
  connect(udFilteredPccPu, QSEM.udFilteredPCCPu) annotation(
    Line(points = {{-30, -110}, {-30, -41}, {-13.5, -41}, {-13.5, -1}, {-13, -1}}, color = {85, 170, 255}, thickness = 0.5));
  connect(uqFilteredPccPu, QSEM.uqFilteredPCCPu) annotation(
    Line(points = {{-10, -110}, {-10, -39}, {-6.5, -39}, {-6.5, -1}, {-7, -1}}, color = {85, 170, 255}, thickness = 0.5));
  connect(idFilteredPccPu, currentSaturation.idFilteredPccPu) annotation(
    Line(points = {{10, -110}, {10, -80.5}, {26, -80.5}, {26, -1}, {27, -1}}, color = {85, 170, 255}, thickness = 0.5));
  connect(iqFilteredPccPu, currentSaturation.iqFilteredPccPu) annotation(
    Line(points = {{30, -110}, {30, -80.5}, {38, -80.5}, {38, -1}, {37, -1}}, color = {85, 170, 255}, thickness = 0.5));

  annotation(
    preferredView = "diagram",
    Diagram,
    Documentation);
end DynGridFormingControlCCVSM;
