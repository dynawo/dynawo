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

model GridFormingControlDroopControl "Grid Forming Control with Droop Control"
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
  parameter Types.PerUnit Lfilter "Filter inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit Rfilter "Filter resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit Kpv "Proportional gain of the voltage loop";
  parameter Types.PerUnit Kiv "Integral gain of the voltage loop";
  parameter Types.PerUnit Cfilter "Filter capacitance in pu (base UNom, SNom)";
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.PerUnit Kpdc "Proportional gain of the dc voltage control";
  parameter Types.PerUnit Imax "Max current in pu (base SNom)";

  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-58, -11}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = { 60, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-58, -16}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-60, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "grid frequency in pu" annotation(
    Placement(visible = true, transformation(origin = {-58, -21}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {90,-105}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -31}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {87, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = 0) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -26}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-93, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current created by the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-58, -1}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = { 30, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current created by the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-58, -6}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = { -33, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "active power reference at the converter's capacitor in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, 53}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = { -105, 100}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QRef0Pu) "reactive power reference at the converter's capacitor in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, 35}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = { -105, 60}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = UdFilter0Pu) "reference voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, 40}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = { -105, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IdcSourceRefPu(start = IdcSourceRef0Pu) "reference DC Current generated by the DC current source in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -38}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, -60}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcSourceRefPu(start = UdcSource0Pu) "reference DC voltage on the DC side in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -46}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = { -105, -100}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcSourcePu(start = UdcSource0Pu) "DC voltage on the DC side in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -54}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = { 0, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame" annotation(
    Placement(visible = true, transformation(origin = {67, 48}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 90}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "reference d-axis modulated voltage created by the converter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {67, 53}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "reference q-axis modulated voltage created by the converter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {67, 35}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, -40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IdcSourcePu(start = IdcSource0Pu) "DC Current generated by the DC current source in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {67, -46}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency" annotation(
    Placement(visible = true, transformation(origin = {67, 44}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, -90}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UdcSourceRefOutPu(start = UdcSource0Pu) "reference DC voltage on the DC side in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = { -19, -43}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, -70}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.CurrentLoop currentLoop(Kic = Kic, Kpc = Kpc, Lfilter = Lfilter, Rfilter = Rfilter, UdConv0Pu = UdConv0Pu, UqConv0Pu = UqConv0Pu, UdFilter0Pu = UdFilter0Pu, IdConv0Pu=IdConv0Pu, IqConv0Pu=IqConv0Pu)  annotation(
    Placement(visible = true, transformation(origin = {45, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.VoltageLoop voltageLoop(Cfilter = Cfilter, Kiv = Kiv, Kpv = Kpv, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, UdFilter0Pu = UdFilter0Pu)  annotation(
    Placement(visible = true, transformation(origin = {15, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.VirtualImpedance virtualImpedance(KpVI = KpVI, XRratio = XRratio, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, Imax = Imax)  annotation(
    Placement(visible = true, transformation(origin = {-35, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.DroopControl droopControl(Kff = Kff, Mp = Mp, Mq = Mq, PRef0Pu = PRef0Pu, QRef0Pu = QRef0Pu, Wf = Wf, Wff = Wff, Theta0 = Theta0, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, UdFilter0Pu = UdFilter0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-15, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.DCVoltageControl dCVoltageControl(Kpdc = Kpdc, IdcSource0Pu = IdcSource0Pu, IdcSourceRef0Pu = IdcSourceRef0Pu, UdcSource0Pu = UdcSource0Pu)  annotation(
    Placement(visible = true, transformation(origin = {45, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit IdPcc0Pu;
  parameter Types.PerUnit IqPcc0Pu;
  parameter Types.PerUnit UdFilter0Pu;
  parameter Types.PerUnit IdConv0Pu;
  parameter Types.PerUnit IqConv0Pu;
  parameter Types.PerUnit UdConv0Pu;
  parameter Types.PerUnit UqConv0Pu;
  parameter Types.Angle Theta0;
  parameter Types.PerUnit PRef0Pu;
  parameter Types.PerUnit QRef0Pu;
  parameter Types.PerUnit IdcSourceRef0Pu;
  parameter Types.PerUnit IdcSource0Pu;
  parameter Types.PerUnit UdcSource0Pu;

equation
  connect(voltageLoop.idConvRefPu, currentLoop.idConvRefPu) annotation(
    Line(points = {{26, 53}, {34, 53}}, color = {0, 0, 127}));
  connect(voltageLoop.iqConvRefPu, currentLoop.iqConvRefPu) annotation(
    Line(points = {{26, 35}, {34, 35}}, color = {0, 0, 127}));
  connect(droopControl.uqFilterRefPu, voltageLoop.uqFilterRefPu) annotation(
    Line(points = {{-4, 35}, {4, 35}}, color = {0, 0, 127}));
  connect(droopControl.udFilterRefPu, voltageLoop.udFilterRefPu) annotation(
    Line(points = {{-4, 53}, {4, 53}}, color = {0, 0, 127}));
  connect(droopControl.omegaPu, voltageLoop.omegaPu) annotation(
    Line(points = {{-4, 44}, {4, 44}}, color = {0, 0, 127}));
  connect(droopControl.omegaPu, currentLoop.omegaPu) annotation(
    Line(points = {{-4, 44}, {34, 44}}, color = {0, 0, 127}));
  connect(virtualImpedance.DeltaVVId, droopControl.DeltaVVId) annotation(
    Line(points = {{-24, 21}, {-24, 33}}, color = {0, 0, 127}));
  connect(virtualImpedance.DeltaVVIq, droopControl.DeltaVVIq) annotation(
    Line(points = {{-24, 3}, {-21, 3}, {-21, 33}}, color = {0, 0, 127}));
  connect(idConvPu, virtualImpedance.idConvPu) annotation(
    Line(points = {{-58, -1}, {-50, -1}, {-50, 21}, {-46, 21}}, color = {0, 0, 127}));
  connect(iqConvPu, virtualImpedance.iqConvPu) annotation(
    Line(points = {{-58, -6}, {-49, -6}, {-49, 3}, {-46, 3}}, color = {0, 0, 127}));
  connect(idPccPu, droopControl.idPccPu) annotation(
    Line(points = {{-58, -11}, {-18, -11}, {-18, 33}}, color = {0, 0, 127}));
  connect(iqPccPu, droopControl.iqPccPu) annotation(
    Line(points = {{-58, -16}, {-15, -16}, {-15, 33}}, color = {0, 0, 127}));
  connect(omegaRefPu, droopControl.omegaRefPu) annotation(
    Line(points = {{-58, -21}, {-12, -21}, {-12, 33}}, color = {0, 0, 127}));
  connect(uqFilterPu, droopControl.uqFilterPu) annotation(
    Line(points = {{-58, -26}, {-9, -26}, {-9, 33}}, color = {0, 0, 127}));
  connect(udFilterPu, droopControl.udFilterPu) annotation(
    Line(points = {{-58, -31}, {-6, -31}, {-6, 33}}, color = {0, 0, 127}));
  connect(udFilterPu, voltageLoop.udFilterPu) annotation(
    Line(points = {{-58, -31}, {7, -31}, {7, 33}}, color = {0, 0, 127}));
  connect(uqFilterPu, voltageLoop.uqFilterPu) annotation(
    Line(points = {{-58, -26}, {11, -26}, {11, 33}}, color = {0, 0, 127}));
  connect(idPccPu, voltageLoop.idPccPu) annotation(
    Line(points = {{-58, -11}, {19, -11}, {19, 33}}, color = {0, 0, 127}));
  connect(iqPccPu, voltageLoop.iqPccPu) annotation(
    Line(points = {{-58, -16}, {23, -16}, {23, 33}}, color = {0, 0, 127}));
  connect(udFilterPu, currentLoop.udFilterPu) annotation(
    Line(points = {{-58, -31}, {37, -31}, {37, 33}}, color = {0, 0, 127}));
  connect(uqFilterPu, currentLoop.uqFilterPu) annotation(
    Line(points = {{-58, -26}, {41, -26}, {41, 33}}, color = {0, 0, 127}));
  connect(idConvPu, currentLoop.idConvPu) annotation(
    Line(points = {{-58, -1}, {49, -1}, {49, 33}}, color = {0, 0, 127}));
  connect(iqConvPu, currentLoop.iqConvPu) annotation(
    Line(points = {{-58, -6}, {53, -6}, {53, 33}}, color = {0, 0, 127}));
  connect(QRefPu, droopControl.QRefPu) annotation(
    Line(points = {{-58, 35}, {-26, 35}}, color = {0, 0, 127}));
  connect(UFilterRefPu, droopControl.UFilterRefPu) annotation(
    Line(points = {{-58, 40}, {-26, 40}}, color = {0, 0, 127}));
  connect(PRefPu, droopControl.PRefPu) annotation(
    Line(points = {{-58, 53}, {-26, 53}}, color = {0, 0, 127}));
  connect(UdcSourceRefPu, dCVoltageControl.UdcSourceRefPu) annotation(
    Line(points = {{-58, -46}, {34, -46}}, color = {0, 0, 127}));
  connect(IdcSourceRefPu, dCVoltageControl.IdcSourceRefPu) annotation(
    Line(points = {{-58, -38}, {34, -38}}, color = {0, 0, 127}));
  connect(UdcSourcePu, dCVoltageControl.UdcSourcePu) annotation(
    Line(points = {{-58, -54}, {34, -54}}, color = {0, 0, 127}));
  connect(droopControl.theta, theta) annotation(
    Line(points = {{-4, 48}, {67, 48}}, color = {0, 0, 127}));
  connect(currentLoop.udConvRefPu, udConvRefPu) annotation(
    Line(points = {{56, 53}, {67, 53}}, color = {0, 0, 127}));
  connect(currentLoop.uqConvRefPu, uqConvRefPu) annotation(
    Line(points = {{56, 35}, {67, 35}}, color = {0, 0, 127}));
  connect(dCVoltageControl.IdcSourcePu, IdcSourcePu) annotation(
    Line(points = {{56, -46}, {67, -46}}, color = {0, 0, 127}));
  connect(droopControl.omegaPu, omegaPu) annotation(
    Line(points = {{-4, 44}, {67, 44}}, color = {0, 0, 127}));
  connect(UdcSourceRefPu, UdcSourceRefOutPu) annotation(
    Line(points = {{-58, -46}, {-25, -46}, {-25, -43}, {-19, -43}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1})));
end GridFormingControlDroopControl;
