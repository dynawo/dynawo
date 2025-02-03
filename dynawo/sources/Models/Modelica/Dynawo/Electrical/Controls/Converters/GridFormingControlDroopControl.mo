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
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model GridFormingControlDroopControl "Grid forming control with droop control"

  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.PerUnit Wf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.PerUnit Mp "Active power droop control coefficient";
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.CurrentModulePu IMaxVI "Maximum current before activating the virtual impedance in pu (base UNom, SNom)";
  parameter Types.PerUnit Kpdc "Proportional gain of the dc voltage control";
  parameter Types.PerUnit Kpv "Proportional gain of the voltage loop";
  parameter Types.PerUnit Kiv "Integral gain of the voltage loop";
  parameter Types.PerUnit CFilter "Filter capacitance in pu (base UNom, SNom)";
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit LFilter "Filter inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit RFilter "Filter resistance in pu (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "grid frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90,-105}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {87, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-93, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current created by the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current created by the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { -33, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { -105, 100}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { -105, 60}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = UFilterRef0Pu) "Reference voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { -105, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IdcSourceRefPu(start = IdcSourceRef0Pu) "Reference DC Current generated by the DC current source in pu (base UdcNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-105, -60}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcSourceRefPu(start = UdcSourceRef0Pu) "Reference DC voltage on the DC side in pu (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { -105, -100}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcSourcePu(start = UdcSource0Pu) "DC voltage on the DC side in pu (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-129, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = PFilter0Pu) "Active power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {75, -105}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = QFilter0Pu) "Reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-75, -105}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {130, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {105, 90}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "Reference d-axis modulated voltage created by the converter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {130, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {105, 40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "Reference q-axis modulated voltage created by the converter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {130, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {105, -40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IdcSourcePu(start = IdcSource0Pu) "DC Current generated by the DC current source in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {130, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {105, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UdcSourceRefOutPu(start = UdcSourceRef0Pu) "Reference DC voltage on the DC side in pu (base UNdcom)" annotation(
    Placement(visible = true, transformation(origin = {0, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {105, -70}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {130, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {105, -90}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.CurrentLoop currentLoop(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, Kic = Kic, Kpc = Kpc, LFilter = LFilter, RFilter = RFilter, UdConv0Pu = UdConv0Pu, UdFilter0Pu = UdFilter0Pu, UqConv0Pu = UqConv0Pu, UqFilter0Pu = UqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {80, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.VoltageLoop voltageLoop(CFilter = CFilter, IdConv0Pu = IdConv0Pu, IdPcc0Pu = IdPcc0Pu, IqConv0Pu = IqConv0Pu, IqPcc0Pu = IqPcc0Pu, Kiv = Kiv, Kpv = Kpv, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {20, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.VirtualImpedance virtualImpedance(DeltaIConvSquare0Pu = DeltaIConvSquare0Pu, DeltaVVId0 = DeltaVVId0, DeltaVVIq0 = DeltaVVIq0, IConvSquare0Pu = IConvSquare0Pu, IMaxVI = IMaxVI, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, KpVI = KpVI, RVI0 = RVI0, XRratio = XRratio, XVI0 = XVI0) annotation(
    Placement(visible = true, transformation(origin = {-90, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.DroopControl droopControl(DeltaVVId0 = DeltaVVId0, DeltaVVIq0 = DeltaVVIq0, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, Kff = Kff, Mp = Mp, Mq = Mq, PFilter0Pu = PFilter0Pu, PRef0Pu = PRef0Pu, QFilter0Pu = QFilter0Pu, QRef0Pu = QRef0Pu, Theta0 = Theta0, UFilterRef0Pu = UFilterRef0Pu, UdFilter0Pu = UdFilter0Pu, UqFilter0Pu = UqFilter0Pu, Wf = Wf, Wff = Wff) annotation(
    Placement(visible = true, transformation(origin = {-40, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.DCVoltageControl dCVoltageControl(IdcSource0Pu = IdcSource0Pu, IdcSourceRef0Pu = IdcSourceRef0Pu, Kpdc = Kpdc, UdcSource0Pu = UdcSource0Pu, UdcSourceRef0Pu = UdcSourceRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {80, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  parameter Types.PerUnit IdcSourceRef0Pu "Start value of DC current reference in pu (base UdcNom, SNom)";
  parameter Types.PerUnit IdcSource0Pu "Start value of DC current in pu (base UdcNom, SNom)";
  parameter Types.PerUnit UdcSource0Pu "Start value of DC voltage in pu (base UdcNom)";
  parameter Types.PerUnit UdcSourceRef0Pu "Start value of DC voltage reference in pu (base UdcNom)";
  parameter Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage in pu (base UNom)";
  parameter Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage in pu (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.ActivePowerPu PRef0Pu "Start value of the active power reference at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QRef0Pu "Start value of the reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  parameter Types.ActivePowerPu PFilter0Pu "Start value of active power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu UFilterRef0Pu "Start value of voltage module reference at the converter's capacitor in pu (base UNom)";
  parameter Types.CurrentModulePu IConvSquare0Pu "Start value of square current in the converter in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu DeltaIConvSquare0Pu "Start value of extra square current in the converter in pu (base UNom, SNom)";
  parameter Types.PerUnit RVI0 "Start value of virtual resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XVI0 "Start value of virtual reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit DeltaVVId0 "Start value of d-axis virtual impedance output in pu (base UNom)";
  parameter Types.PerUnit DeltaVVIq0 "Start value of q-axis virtual impedance output in pu (base UNom)";

equation
  connect(voltageLoop.idConvRefPu, currentLoop.idConvRefPu) annotation(
    Line(points = {{42, 100}, {58, 100}}, color = {0, 0, 127}));
  connect(voltageLoop.iqConvRefPu, currentLoop.iqConvRefPu) annotation(
    Line(points = {{42, 60}, {58, 60}}, color = {0, 0, 127}));
  connect(droopControl.uqFilterRefPu, voltageLoop.uqFilterRefPu) annotation(
    Line(points = {{-18, 60.2}, {-2, 60.2}}, color = {0, 0, 127}));
  connect(droopControl.udFilterRefPu, voltageLoop.udFilterRefPu) annotation(
    Line(points = {{-18, 100}, {-2, 100}}, color = {0, 0, 127}));
  connect(droopControl.omegaPu, voltageLoop.omegaPu) annotation(
    Line(points = {{-18, 79.8}, {-2, 79.8}}, color = {0, 0, 127}));
  connect(droopControl.omegaPu, currentLoop.omegaPu) annotation(
    Line(points = {{-18, 79.8}, {58, 79.8}}, color = {0, 0, 127}));
  connect(udFilterPu, voltageLoop.udFilterPu) annotation(
    Line(points = {{-130, -60}, {0, -60}, {0, 58}}, color = {0, 0, 127}));
  connect(uqFilterPu, voltageLoop.uqFilterPu) annotation(
    Line(points = {{-130, -80}, {10, -80}, {10, 58}}, color = {0, 0, 127}));
  connect(idPccPu, voltageLoop.idPccPu) annotation(
    Line(points = {{-130, 0}, {30, 0}, {30, 58}}, color = {0, 0, 127}, pattern = LinePattern.DashDot));
  connect(iqPccPu, voltageLoop.iqPccPu) annotation(
    Line(points = {{-130, -20}, {40, -20}, {40, 58}}, color = {0, 0, 127}, pattern = LinePattern.DashDot));
  connect(udFilterPu, currentLoop.udFilterPu) annotation(
    Line(points = {{-130, -60}, {60, -60}, {60, 58}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(uqFilterPu, currentLoop.uqFilterPu) annotation(
    Line(points = {{-130, -80}, {70, -80}, {70, 58}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(idConvPu, currentLoop.idConvPu) annotation(
    Line(points = {{-130, 40}, {90, 40}, {90, 58}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(iqConvPu, currentLoop.iqConvPu) annotation(
    Line(points = {{-130, 20}, {100, 20}, {100, 58}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(QRefPu, droopControl.QRefPu) annotation(
    Line(points = {{-130, 60}, {-62, 60}}, color = {0, 0, 127}));
  connect(UFilterRefPu, droopControl.UFilterRefPu) annotation(
    Line(points = {{-130, 80}, {-62, 80}}, color = {0, 0, 127}));
  connect(PRefPu, droopControl.PRefPu) annotation(
    Line(points = {{-130, 100}, {-62, 100}}, color = {0, 0, 127}));
  connect(UdcSourceRefPu, dCVoltageControl.UdcSourceRefPu) annotation(
    Line(points = {{-130, -120}, {58, -120}}, color = {0, 0, 127}));
  connect(dCVoltageControl.IdcSourcePu, IdcSourcePu) annotation(
    Line(points = {{102, -120}, {130, -120}}, color = {0, 0, 127}));
  connect(UdcSourceRefPu, UdcSourceRefOutPu) annotation(
    Line(points = {{-130, -120}, {0, -120}}, color = {0, 0, 127}));
  connect(idConvPu, virtualImpedance.idConvPu) annotation(
    Line(points = {{-130, 40}, {-112, 40}}, color = {0, 0, 127}));
  connect(iqConvPu, virtualImpedance.iqConvPu) annotation(
    Line(points = {{-130, 20}, {-112, 20}}, color = {0, 0, 127}));
  connect(IdcSourceRefPu, dCVoltageControl.IdcSourceRefPu) annotation(
    Line(points = {{-130, -100}, {58, -100}}, color = {0, 0, 127}));
  connect(UdcSourcePu, dCVoltageControl.UdcSourcePu) annotation(
    Line(points = {{-129, -140}, {58, -140}}, color = {0, 0, 127}));
  connect(QFilterPu, droopControl.QFilterPu) annotation(
    Line(points = {{-130, 120}, {-50, 120}, {-50, 102}}, color = {0, 0, 127}));
  connect(PFilterPu, droopControl.PFilterPu) annotation(
    Line(points = {{-130, 140}, {-30, 140}, {-30, 102}}, color = {0, 0, 127}));
  connect(omegaRefPu, droopControl.omegaRefPu) annotation(
    Line(points = {{-130, -40}, {-20, -40}, {-20, 58}}, color = {0, 0, 127}));
  connect(iqPccPu, droopControl.iqPccPu) annotation(
    Line(points = {{-130, -20}, {-30, -20}, {-30, 58}}, color = {0, 0, 127}));
  connect(idPccPu, droopControl.idPccPu) annotation(
    Line(points = {{-130, 0}, {-40, 0}, {-40, 58}}, color = {0, 0, 127}));
  connect(virtualImpedance.DeltaVVId, droopControl.DeltaVVId) annotation(
    Line(points = {{-68, 40}, {-60, 40}, {-60, 58}}, color = {0, 0, 127}));
  connect(virtualImpedance.DeltaVVIq, droopControl.DeltaVVIq) annotation(
    Line(points = {{-68, 20}, {-50, 20}, {-50, 58}}, color = {0, 0, 127}));
  connect(currentLoop.udConvRefPu, udConvRefPu) annotation(
    Line(points = {{102, 100}, {110, 100}, {110, 120}, {130, 120}}, color = {0, 0, 127}));
  connect(currentLoop.uqConvRefPu, uqConvRefPu) annotation(
    Line(points = {{102, 60}, {110, 60}, {110, 40}, {130, 40}}, color = {0, 0, 127}));
  connect(droopControl.theta, theta) annotation(
    Line(points = {{-18, 90}, {130, 90}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(droopControl.omegaPu, omegaPu) annotation(
    Line(points = {{-18, 80}, {110, 80}, {110, 70}, {130, 70}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-120, -150}, {120, 150}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1})));
end GridFormingControlDroopControl;
