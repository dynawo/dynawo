within Dynawo.Electrical.Controls.IEC.IEC63406.Controls;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model Control "Global control (IEC 63406)"

  //Nominal parameter
  parameter Types.PerUnit PMaxPu "Maximum active power at converter terminal in pu (base SNom)" annotation(
    Dialog(tab = "StorageSys"));
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter String TableFileName "Name given to the general file containing all tables" annotation(
    Dialog(tab = "General"));

  //FFR parameters
  parameter String FFRTableName "Name given to the FFR table in the table file" annotation(
    Dialog(tab = "FFR"));
  parameter Boolean FFRflag "1 to enable the fast frequency response, 0 to disable the fast frequency response" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit fThresholdPu "Deadband threshold for FFR response in pu (base nominal frequency)" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit f0Pu "Frequency setpoint for FFR control in pu (base nominal frequency)" annotation(
    Dialog(tab = "FFR"));
  parameter String InertialTableName "Name given to the inertial table in the table file" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit PffrMaxPu "Maximum active power utilized for FFR control in pu (base SNom)" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit PffrMinPu "Maximum absorbing active power utilized for FFR control in pu (base SNom)" annotation(
    Dialog(tab = "FFR"));
  parameter Types.Time Trocof "Time constant for frequency differential operation" annotation(
    Dialog(tab = "FFR"));

  //FRT parameters
  parameter Types.PerUnit uHVRTPu "HVRT threshold value" annotation(
    Dialog(tab = "FRT"));
parameter Types.PerUnit uLVRTPu "LVRT threshold value" annotation(
    Dialog(tab = "FRT"));

  //PControl parameters
  parameter Real KIp "Integral gain in the active power PI controller" annotation(
    Dialog(tab = "PControl"));
  parameter Real KPp "Proportional gain in the active power PI controller" annotation(
    Dialog(tab = "PControl"));
  parameter Boolean PFlag "1 for closed-loop active power control, 0 for open-loop active power control" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time TpRef "Time constant in the active power filter" annotation(
    Dialog(tab = "PControl"));

  //QControl parameters
  parameter Types.PerUnit DUdb1Pu "Voltage change dead band lower limit (typically negative) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit DUdb2Pu "Voltage change dead band upper limit (typically positive) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KPqu "Proportional gain in the reactive power PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KIqu "Integral gain in the reactive power PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KPuq "Proportional gain in the outer voltage PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KIuq "Integral gain in the outer voltage PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KPui "Proportional gain in the inner voltage PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KIui "Integral gain in the inner voltage PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KPqi "Proportional gain in the inner reactive power PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KIqi "Integral gain in the inner reactive power PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KDroop "Q/U droop gain" annotation(
    Dialog(tab = "QControl"));
  parameter Integer LFlag "One of the 3 reactive control flags" annotation(
    Dialog(tab = "QControl"));
  parameter Integer PFFlag "One of the 3 reactive control flags" annotation(
    Dialog(tab = "QControl"));
  parameter String QMaxtoPTableName "Table giving the maximum reactive power depending on the measured active power" annotation(
    Dialog(tab = "QControl"));
  parameter String QMintoPTableName "Table giving the minimum reactive power depending on the measured active power" annotation(
    Dialog(tab = "QControl"));
  parameter String QMaxtoUTableName "Table giving the maximum reactive power depending on the measured voltage" annotation(
    Dialog(tab = "QControl"));
  parameter String QMintoUTableName "Table giving the minimum reactive power depending on the measured voltage" annotation(
    Dialog(tab = "QControl"));
  parameter Real TanPhi "Power factor used in the power factor control" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time Tiq "Time constant in reactive power order lag" annotation(
    Dialog(tab = "QControl"));
  parameter Boolean UFlag "One of the 3 reactive control flags" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit UMaxPu "Maximum voltage defined by users at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit UMinPu "Minimum voltage defined by users at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));

  //Current and Q limitation parameters
  parameter Types.PerUnit IMaxPu "Maximum current at converter terminal in pu (base in UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Current and Q limitation"));
  parameter Boolean PriorityFlag "0 for active current priority, 1 for reactive current priority" annotation(
    Dialog(tab = "Current and Q limitation"));
  parameter Boolean QLimFlag "0 to use the defined lookup tables, 1 to use the constant values" annotation(
    Dialog(tab = "Current and Q limitation"));
  parameter Types.PerUnit QMaxPu "Maximum reactive power defined by users in pu (base SNom)" annotation(
    Dialog(tab = "Current and Q limitation"));
  parameter Types.PerUnit QMinPu "Minimum reactive power defined by users in pu (base SNom)" annotation(
    Dialog(tab = "Current and Q limitation"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput fMeasPu(start = 1) "Measured frequency outputted by the phase-locked loop  in pu (base nominal frequency in Hz)" annotation(
    Placement(visible = true, transformation(origin = {-120, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pAvailInPu(start = PAvailIn0Pu) "Minimum output electrical power available to the active power control module in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-9, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90), iconTransformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput pAvailOutPu(start = PMaxPu) "Maximum output electrical power available to the active power control module in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {7, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90), iconTransformation(origin = {30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput pRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference provided by the plant controller in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pMeasPu(start = -P0Pu * SystemBase.SnRef / SNom) "Measured (and filtered) active power component in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qMeasPu(start =- Q0Pu * SystemBase.SnRef / SNom) "Measured (and filtered) reactive power component at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, -90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference provided by the plant controller in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uMeasPu(start = U0Pu) "Measured (and filtered) voltage component in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uRefPu(start = U0Pu) "Voltage reference provided by the plant controller in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput iPcmdPu(start = P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {115, 61}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iQcmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {115, -41}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  //Variables
  Boolean FFlag(start = false) "Flag indicating the generating unit operating condition";

  Dynawo.Electrical.Controls.IEC.IEC63406.Controls.BaseControls.PControl pControl(IPMax0Pu = IPMax0Pu, IPMin0Pu = IPMin0Pu, KIp = KIp, KPp = KPp, P0Pu = P0Pu, PAvailIn0Pu = PAvailIn0Pu, PFlag = PFlag, PMaxPu = PMaxPu, SNom = SNom, TpRef = TpRef, U0Pu = U0Pu)  annotation(
    Placement(visible = true, transformation(origin = {20.2, 59.2223}, extent = {{-40.2, -22.3333}, {40.2, 22.3333}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.Controls.BaseControls.QControl qControl(DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, IQMax0Pu = IQMax0Pu, IQMin0Pu = IQMin0Pu, KDroop = KDroop, KIqi = KIqi, KIqu = KIqu, KIui = KIui, KIuq = KIuq, KPqi = KPqi, KPqu = KPqu, KPui = KPui, KPuq = KPuq, LFlag = LFlag, P0Pu = P0Pu, PFFlag = PFFlag, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMin0Pu = QMin0Pu, SNom = SNom, TanPhi = TanPhi, Tiq = Tiq, U0Pu = U0Pu, UFlag = UFlag, UMaxPu = UMaxPu, UMinPu = UMinPu)  annotation(
    Placement(visible = true, transformation(origin = {0.8, -60}, extent = {{-59.6, -18.625}, {59.6, 18.625}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.Controls.BaseControls.CurrentLimitation currentLimitation(IMaxPu = IMaxPu, IPMax0Pu = IPMax0Pu, IPMin0Pu = IPMin0Pu, IQMax0Pu = IQMax0Pu, IQMin0Pu = IQMin0Pu, P0Pu = P0Pu, PriorityFlag = PriorityFlag, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMin0Pu = QMin0Pu, SNom = SNom, U0Pu = U0Pu)  annotation(
    Placement(visible = true, transformation(origin = {20, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.Controls.BaseControls.QLimitation qLimitation(IQMax0Pu = IQMax0Pu, IQMin0Pu = IQMin0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, QLimFlag = QLimFlag, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMaxtoPTableName = QMaxtoPTableName, QMaxtoUTableName = QMaxtoUTableName, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QMintoPTableName = QMintoPTableName, QMintoUTableName = QMintoUTableName, SNom = SNom, TableFileName = TableFileName, U0Pu = U0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.Controls.BaseControls.FFR ffr(FFRTableName = FFRTableName,FFRflag = FFRflag, InertialTableName = InertialTableName, PffrMaxPu = PffrMaxPu, PffrMinPu = PffrMinPu, TableFileName = TableFileName, Trocof = Trocof, f0Pu = f0Pu, fThresholdPu = fThresholdPu)  annotation(
    Placement(visible = true, transformation(origin = {-70, 90}, extent = {{-12, -10}, {12, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y = FFlag)  annotation(
    Placement(visible = true, transformation(origin = {110, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit IPMin0Pu "Initial minimum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit IPMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit IQMax0Pu "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit IQMin0Pu "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit PAvailIn0Pu "Initial minimum output electrical power available to the active power control module in pu (base SNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit QMax0Pu "Initial maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit QMin0Pu "Initial minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group="Operating point"));

equation
  FFlag = if uMeasPu < uLVRTPu or uMeasPu > uHVRTPu then true else false;

  connect(fMeasPu, ffr.fMeasPu) annotation(
    Line(points = {{-120, 90}, {-82, 90}}, color = {0, 0, 127}));
  connect(pRefPu, pControl.pRefPu) annotation(
    Line(points = {{-120, 60}, {-40, 60}, {-40, 70}, {-22, 70}}, color = {0, 0, 127}));
  connect(pMeasPu, pControl.pMeasPu) annotation(
    Line(points = {{-120, 30}, {-90, 30}, {-90, 48}, {-22, 48}}, color = {0, 0, 127}));
  connect(pMeasPu, qLimitation.pMeasPu) annotation(
    Line(points = {{-120, 30}, {-90, 30}, {-90, -8}, {-84, -8}}, color = {0, 0, 127}));
  connect(uRefPu, qControl.uRefPu) annotation(
    Line(points = {{-120, -30}, {-80, -30}, {-80, -45}, {-61, -45}}, color = {0, 0, 127}));
  connect(uMeasPu, qControl.uMeasPu) annotation(
    Line(points = {{-120, 0}, {-96, 0}, {-96, -52}, {-61, -52}}, color = {0, 0, 127}));
  connect(uMeasPu, qLimitation.uMeasPu) annotation(
    Line(points = {{-120, 0}, {-96, 0}, {-96, 8}, {-84, 8}}, color = {0, 0, 127}));
  connect(qRefPu, qControl.qRefPu) annotation(
    Line(points = {{-120, -60}, {-61, -60}}, color = {0, 0, 127}));
  connect(qMeasPu, qControl.qMeasPu) annotation(
    Line(points = {{-120, -90}, {-80, -90}, {-80, -67}, {-61, -67}}, color = {0, 0, 127}));
  connect(pMeasPu, qControl.pMeasPu) annotation(
    Line(points = {{-120, 30}, {-90, 30}, {-90, -75}, {-61, -75}}, color = {0, 0, 127}));
  connect(qLimitation.qMaxPu, currentLimitation.qMaxPu) annotation(
    Line(points = {{-38, 8}, {-2, 8}, {-2, 6}}, color = {0, 0, 127}));
  connect(qLimitation.qMinPu, currentLimitation.qMinPu) annotation(
    Line(points = {{-38, -8}, {-2, -8}, {-2, -6}}, color = {0, 0, 127}));
  connect(uMeasPu, currentLimitation.uMeasPu) annotation(
    Line(points = {{-120, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(ffr.pFFRPu, pControl.pFFRPu) annotation(
    Line(points = {{-58, 90}, {-16, 90}, {-16, 84}}, color = {0, 0, 127}));
  connect(currentLimitation.iPMaxPu, pControl.iPMaxPu) annotation(
    Line(points = {{42, 14}, {58, 14}, {58, 35}}, color = {0, 0, 127}));
  connect(currentLimitation.iPMinPu, pControl.iPMinPu) annotation(
    Line(points = {{42, 6}, {51, 6}, {51, 35}}, color = {0, 0, 127}));
  connect(qLimitation.qMaxPu, qControl.qMaxPu) annotation(
    Line(points = {{-38, 8}, {-18, 8}, {-18, -39}}, color = {0, 0, 127}));
  connect(qLimitation.qMinPu, qControl.qMinPu) annotation(
    Line(points = {{-38, -8}, {-25, -8}, {-25, -39}}, color = {0, 0, 127}));
  connect(currentLimitation.iQMaxPu, qControl.iQMaxPu) annotation(
    Line(points = {{42, -6}, {53, -6}, {53, -39}}, color = {0, 0, 127}));
  connect(currentLimitation.iQMinPu, qControl.iQMinPu) annotation(
    Line(points = {{42, -14}, {45, -14}, {45, -39}}, color = {0, 0, 127}));
  connect(pControl.iPcmdPu, currentLimitation.iPcmdPu) annotation(
    Line(points = {{62, 60}, {80, 60}, {80, 28}, {-20, 28}, {-20, 16}, {-4, 16}}, color = {0, 0, 127}));
  connect(qControl.iQcmdPu, currentLimitation.iQcmdPu) annotation(
    Line(points = {{64, -60}, {80, -60}, {80, -28}, {-12, -28}, {-12, -16}, {-4, -16}}, color = {0, 0, 127}));
  connect(pControl.iPcmdPu, iPcmdPu) annotation(
    Line(points = {{62, 60}, {110, 60}}, color = {0, 0, 127}));
  connect(qControl.iQcmdPu, iQcmdPu) annotation(
    Line(points = {{64, -60}, {110, -60}}, color = {0, 0, 127}));
  connect(pAvailInPu, pControl.pAvailInPu) annotation(
    Line(points = {{-8, 112}, {-8, 84}, {0, 84}}, color = {0, 0, 127}));
  connect(pAvailOutPu, pControl.pAvailOutPu) annotation(
    Line(points = {{8, 112}, {6, 112}, {6, 84}}, color = {0, 0, 127}));
  connect(uMeasPu, pControl.uMeasPu) annotation(
    Line(points = {{-120, 0}, {-96, 0}, {-96, 120}, {20, 120}, {20, 84}}, color = {0, 0, 127}));
  connect(booleanExpression.y, pControl.FFlag) annotation(
    Line(points = {{100, 30}, {-6, 30}, {-6, 34}}, color = {255, 0, 255}));
  connect(booleanExpression.y, qLimitation.FFlag) annotation(
    Line(points = {{100, 30}, {-60, 30}, {-60, 24}}, color = {255, 0, 255}));
  connect(booleanExpression.y, currentLimitation.FFlag) annotation(
    Line(points = {{100, 30}, {20, 30}, {20, 24}}, color = {255, 0, 255}));
  connect(booleanExpression.y, qControl.FFlag) annotation(
    Line(points = {{100, 30}, {84, 30}, {84, -32}, {1, -32}, {1, -38}}, color = {255, 0, 255}));

  annotation(
    Icon(graphics = {Rectangle(extent = {{100, 100}, {-100, -100}}), Text(extent = {{-100, 100}, {100, -100}}, textString = "Control")}));
end Control;
