within Dynawo.Electrical.Controls.Converters;

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

model GlobalDroopControl "Global Droop Control"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.PerUnit Wf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.PerUnit Mp "Active power droop control coefficient";
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit Lfilter "Filter inductance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Kpv "Proportional gain of the voltage loop";
  parameter Types.PerUnit Kiv "Integral gain of the voltage loop";
  parameter Types.PerUnit Cfilter "Filter capacitance in p.u (base UNom, SNom)";
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.PerUnit Kpdc "Proportional gain of the dc voltage control";

  Dynawo.Electrical.Controls.Converters.BaseControls.CurrentLoop currentLoop(Kic = Kic, Kpc = Kpc, Lfilter = Lfilter, VConvdref0 = VConvdref0, VConvqref0 = VConvqref0, VFilterd0 = VFilterd0, VFilterq0 = VFilterq0, IConvd0=IConvd0, IConvq0=IConvq0, YIntegratord0 = YIntegratord_currentLoop0, YIntegratorq0 = YIntegratorq_currentLoop0)  annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.VoltageLoop voltageLoop(Cfilter = Cfilter, Kiv = Kiv, Kpv = Kpv, IConvd0 = IConvd0, IConvq0 = IConvq0, IPCCd0 = IPCCd0, IPCCq0 = IPCCq0, VFilterd0 = VFilterd0, VFilterq0 = VFilterq0, YIntegratord0 = YIntegratord_voltageLoop0, YIntegratorq0 = YIntegratorq_voltageLoop0)  annotation(
    Placement(visible = true, transformation(origin = {20, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.VirtualImpedance virtualImpedance(KpVI = KpVI, XRratio = XRratio, IConvd0 = IConvd0, IConvq0 = IConvq0)  annotation(
    Placement(visible = true, transformation(origin = {-30, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.DroopControl droopControl(Kff = Kff, Mp = Mp, Mq = Mq, Pref0 = Pref0, Qref0 = Qref0, Wf = Wf, Wff = Wff, Theta0 = Theta0, IPCCd0 = IPCCd0, IPCCq0 = IPCCq0, VFilterd0 = VFilterd0, VFilterq0 = VFilterq0)  annotation(
    Placement(visible = true, transformation(origin = {-10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.DCVoltageControl dCVoltageControl(Kpdc = Kpdc, Idc0 = Idc0, Idcref0 = Idcref0, Vdc0 = Vdc0)  annotation(
    Placement(visible = true, transformation(origin = {50, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput iPCCd (start = IPCCd0) annotation(
    Placement(visible = true, transformation(origin = {-53, -35}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-66, -19}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iPCCq (start = IPCCq0) annotation(
    Placement(visible = true, transformation(origin = {-53, -40}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-62, 15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu (start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-53, -45}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-62, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vFilterd (start = VFilterd0) annotation(
    Placement(visible = true, transformation(origin = {-53, -55}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-16, -36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vFilterq (start = VFilterq0) annotation(
    Placement(visible = true, transformation(origin = {-53, -50}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {25, -15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iConvd (start = IConvd0) annotation(
    Placement(visible = true, transformation(origin = {-53, -25}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-83, 6}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iConvq (start = IConvq0) annotation(
    Placement(visible = true, transformation(origin = {-53, -30}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-84, -12}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pref (start = Pref0) annotation(
    Placement(visible = true, transformation(origin = {-53, 29}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-120, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qref (start = Qref0) annotation(
    Placement(visible = true, transformation(origin = {-53, 11}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-61, 5}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput wref (start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-53, 24}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-80, 14}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Veffref (start = VFilterd0) annotation(
    Placement(visible = true, transformation(origin = {-53, 16}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-89, 1}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idcref (start = Idcref0) annotation(
    Placement(visible = true, transformation(origin = {-53, -62}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-68, -64}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vdcref (start = Vdc0) annotation(
    Placement(visible = true, transformation(origin = {-53, -70}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {21, -72}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vdc (start = Vdc0) annotation(
    Placement(visible = true, transformation(origin = {-53, -78}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {1, -76}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta (start = Theta0) annotation(
    Placement(visible = true, transformation(origin = {72, 24}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput vConvdref (start = VConvdref0) annotation(
    Placement(visible = true, transformation(origin = {72, 29}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput vConvqref (start = VConvqref0) annotation(
    Placement(visible = true, transformation(origin = {72, 11}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idc (start = Idc0) annotation(
    Placement(visible = true, transformation(origin = {72, -70}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu (start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {72, 20}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {71, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Connectors.ImPin vConvdrefPin(value(start=VConvdref0));
  Connectors.ImPin vConvqrefPin(value(start=VConvqref0));
  Connectors.ImPin omegaPuPin(value(start=SystemBase.omegaRef0Pu));
  Connectors.ImPin thetaPin(value(start=Theta0));
  Connectors.ImPin idcPin(value(start=Idc0));

protected

  parameter Types.PerUnit YIntegratord_voltageLoop0;
  parameter Types.PerUnit YIntegratorq_voltageLoop0;
  parameter Types.PerUnit IPCCd0;
  parameter Types.PerUnit IPCCq0;
  parameter Types.PerUnit VFilterd0;
  parameter Types.PerUnit VFilterq0;
  parameter Types.PerUnit IConvd0;
  parameter Types.PerUnit IConvq0;
  parameter Types.PerUnit YIntegratord_currentLoop0;
  parameter Types.PerUnit YIntegratorq_currentLoop0;
  parameter Types.PerUnit VConvdref0;
  parameter Types.PerUnit VConvqref0;
  parameter Types.Angle Theta0;
  parameter Types.PerUnit Pref0;
  parameter Types.PerUnit Qref0;
  parameter Types.PerUnit Idcref0;
  parameter Types.PerUnit Idc0;
  parameter Types.PerUnit Vdc0;

equation

  connect(vConvdrefPin.value, vConvdref);
  connect(vConvqrefPin.value, vConvqref);
  connect(idcPin.value, idc);
  connect(omegaPuPin.value, omegaPu);
  connect(thetaPin.value, theta);
  connect(voltageLoop.iConvdref, currentLoop.iConvdref) annotation(
    Line(points = {{31, 29}, {38, 29}, {38, 29}, {39, 29}}, color = {0, 0, 127}));
  connect(voltageLoop.iConvqref, currentLoop.iConvqref) annotation(
    Line(points = {{31, 11}, {39, 11}, {39, 11}, {39, 11}}, color = {0, 0, 127}));
  connect(droopControl.vFilterqref, voltageLoop.vFilterqref) annotation(
    Line(points = {{1, 11}, {9, 11}, {9, 11}, {9, 11}}, color = {0, 0, 127}));
  connect(droopControl.vFilterdref, voltageLoop.vFilterdref) annotation(
    Line(points = {{1, 29}, {9, 29}, {9, 29}, {9, 29}}, color = {0, 0, 127}));
  connect(droopControl.omegaPu, voltageLoop.omegaPu) annotation(
    Line(points = {{1, 20}, {8, 20}, {8, 20}, {9, 20}}, color = {0, 0, 127}));
  connect(droopControl.omegaPu, currentLoop.omegaPu) annotation(
    Line(points = {{1, 20}, {39, 20}, {39, 20}, {39, 20}}, color = {0, 0, 127}));
  connect(virtualImpedance.DeltaVVId, droopControl.DeltaVVId) annotation(
    Line(points = {{-19, -1}, {-19, 9}}, color = {0, 0, 127}));
  connect(virtualImpedance.DeltaVVIq, droopControl.DeltaVVIq) annotation(
    Line(points = {{-19, -19}, {-16, -19}, {-16, 9}}, color = {0, 0, 127}));
  connect(iConvd, virtualImpedance.iConvd) annotation(
    Line(points = {{-53, -25}, {-45, -25}, {-45, -1}, {-41, -1}, {-41, -1}}, color = {0, 0, 127}));
  connect(iConvq, virtualImpedance.iConvq) annotation(
    Line(points = {{-53, -30}, {-44, -30}, {-44, -19}, {-41, -19}, {-41, -19}}, color = {0, 0, 127}));
  connect(iPCCd, droopControl.iPCCd) annotation(
    Line(points = {{-53, -35}, {-13, -35}, {-13, 9}, {-13, 9}}, color = {0, 0, 127}));
  connect(iPCCq, droopControl.iPCCq) annotation(
    Line(points = {{-53, -40}, {-10, -40}, {-10, 9}, {-10, 9}}, color = {0, 0, 127}));
  connect(omegaRefPu, droopControl.omegaRefPu) annotation(
    Line(points = {{-53, -45}, {-7, -45}, {-7, 9}, {-7, 9}}, color = {0, 0, 127}));
  connect(vFilterq, droopControl.vFilterq) annotation(
    Line(points = {{-53, -50}, {-4, -50}, {-4, 9}, {-4, 9}}, color = {0, 0, 127}));
  connect(vFilterd, droopControl.vFilterd) annotation(
    Line(points = {{-53, -55}, {-1, -55}, {-1, 9}, {-1, 9}}, color = {0, 0, 127}));
  connect(vFilterd, voltageLoop.vFilterd) annotation(
    Line(points = {{-53, -55}, {12, -55}, {12, 9}, {12, 9}}, color = {0, 0, 127}));
  connect(vFilterq, voltageLoop.vFilterq) annotation(
    Line(points = {{-53, -50}, {16, -50}, {16, 9}, {16, 9}}, color = {0, 0, 127}));
  connect(iPCCd, voltageLoop.iPCCd) annotation(
    Line(points = {{-53, -35}, {24, -35}, {24, 9}, {24, 9}}, color = {0, 0, 127}));
  connect(iPCCq, voltageLoop.iPCCq) annotation(
    Line(points = {{-53, -40}, {28, -40}, {28, 9}, {28, 9}}, color = {0, 0, 127}));
  connect(vFilterd, currentLoop.vFilterd) annotation(
    Line(points = {{-53, -55}, {42, -55}, {42, 9}, {42, 9}}, color = {0, 0, 127}));
  connect(vFilterq, currentLoop.vFilterq) annotation(
    Line(points = {{-53, -50}, {46, -50}, {46, 9}, {46, 9}}, color = {0, 0, 127}));
  connect(iConvd, currentLoop.iConvd) annotation(
    Line(points = {{-53, -25}, {54, -25}, {54, 9}, {54, 9}}, color = {0, 0, 127}));
  connect(iConvq, currentLoop.iConvq) annotation(
    Line(points = {{-53, -30}, {58, -30}, {58, 9}, {58, 9}}, color = {0, 0, 127}));
  connect(qref, droopControl.qref) annotation(
    Line(points = {{-53, 11}, {-22, 11}, {-22, 11}, {-21, 11}}, color = {0, 0, 127}));
  connect(Veffref, droopControl.Veffref) annotation(
    Line(points = {{-53, 16}, {-22, 16}, {-22, 16}, {-21, 16}}, color = {0, 0, 127}));
  connect(wref, droopControl.wref) annotation(
    Line(points = {{-53, 24}, {-22, 24}, {-22, 24}, {-21, 24}}, color = {0, 0, 127}));
  connect(pref, droopControl.pref) annotation(
    Line(points = {{-53, 29}, {-22, 29}, {-22, 29}, {-21, 29}}, color = {0, 0, 127}));
  connect(vdcref, dCVoltageControl.vdcref) annotation(
    Line(points = {{-53, -70}, {39, -70}}, color = {0, 0, 127}));
  connect(idcref, dCVoltageControl.idcref) annotation(
    Line(points = {{-53, -62}, {39, -62}}, color = {0, 0, 127}));
  connect(vdc, dCVoltageControl.vdc) annotation(
    Line(points = {{-53, -78}, {39, -78}}, color = {0, 0, 127}));
  connect(droopControl.theta, theta) annotation(
    Line(points = {{1, 24}, {72, 24}}, color = {0, 0, 127}));
  connect(currentLoop.vConvdref, vConvdref) annotation(
    Line(points = {{61, 29}, {69, 29}, {69, 29}, {72, 29}}, color = {0, 0, 127}));
  connect(currentLoop.vConvqref, vConvqref) annotation(
    Line(points = {{61, 11}, {70, 11}, {70, 11}, {72, 11}}, color = {0, 0, 127}));
  connect(dCVoltageControl.idc, idc) annotation(
    Line(points = {{61, -70}, {70, -70}, {70, -70}, {72, -70}}, color = {0, 0, 127}));
  connect(droopControl.omegaPu, omegaPu) annotation(
    Line(points = {{1, 20}, {70, 20}, {70, 20}, {72, 20}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1})));

end GlobalDroopControl;
