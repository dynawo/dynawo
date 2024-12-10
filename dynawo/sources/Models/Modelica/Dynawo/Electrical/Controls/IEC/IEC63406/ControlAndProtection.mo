within Dynawo.Electrical.Controls.IEC.IEC63406;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model ControlAndProtection

  //General parameters
  parameter Types.PerUnit IMaxPu "Maximum current" annotation(
    Dialog(tab = "General"));
  parameter Types.PerUnit IPMaxPu "Maximum active current" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IQMaxPu "Maximum reactive current" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IPMinPu "Minimum active current" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IQMinPu "Minimum reactive current" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit PMaxPu "Maximum power capacity of the CBGU" annotation(
    Dialog(tab = "StorageSys"));

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //PControl Parameters
  parameter Real KIp "Integral gain in the active power PI controller" annotation(
    Dialog(tab = "PControl"));
  parameter Real KPp "Proportional gain in the active power PI controller" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time TpRef "Time constant in the active power filter" annotation(
    Dialog(tab = "PControl"));
  parameter Boolean PFlag "1 for closed-loop active power control, 0 for open-loop active power control" annotation(
    Dialog(tab = "PControl"));
  parameter Boolean PriorityFlag "0 for active current priority, 1 for reactive current priority";
  parameter Types.Time Trocof "Time constant for frequency differential operation" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit fThresholdPu "Threshold at which the frequency is considered" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit f0Pu "Frequency setpoint for FFR control" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit PffrMaxPu "Maximum output power utilized for FFR control" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit PffrMinPu "Maximum absorbing power utilized for FFR control" annotation(
    Dialog(tab = "FFR"));
  parameter Boolean FFRflag "1 to enable the fast frequency response, 0 to disable the fast frequency response" annotation(
    Dialog(tab = "FFR"));
  parameter Real InertialTable[:, :] = [Pi11, Pi12; Pi21, Pi22] "Pair of points for frequence dependant powers piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "FFR"));
  parameter Real FFRTable[:, :] = [Pf11, Pf12; Pf21, Pf22] "Pair of points for frequence dependant powers piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit Pi11 annotation(
    Dialog(tab = "FFR tables"));
  parameter Types.PerUnit Pi12 annotation(
    Dialog(tab = "FFR tables"));
  parameter Types.PerUnit Pi21 annotation(
    Dialog(tab = "FFR tables"));
  parameter Types.PerUnit Pi22 annotation(
    Dialog(tab = "FFR tables"));
  parameter Types.PerUnit Pf11 annotation(
    Dialog(tab = "FFR tables"));
  parameter Types.PerUnit Pf12 annotation(
    Dialog(tab = "FFR tables"));
  parameter Types.PerUnit Pf21 annotation(
    Dialog(tab = "FFR tables"));
  parameter Types.PerUnit Pf22 annotation(
    Dialog(tab = "FFR tables"));

  //QControl Parameters
  parameter Types.PerUnit QMaxUd "Maximum reactive power defined by users" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit QMinUd "Minimum reactive power defined by users" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit UMaxPu "Maximum voltage defined by users" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit UMinPu "Minimum voltage defined by users" annotation(
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
  parameter Types.PerUnit DUdb1Pu "Voltage change dead band lower limit (typically negative) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit DUdb2Pu "Voltage change dead band upper limit (typically positive) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Real TanPhi "Power factor used in the power factor control" annotation(
    Dialog(tab = "QControl"));
  parameter Integer PFFlag annotation(
    Dialog(tab = "QControl"));
  parameter Integer LFlag annotation(
    Dialog(tab = "QControl"));
  parameter Boolean QLimFlag "0 to use the defined lookup tables, 1 to use the constant values" annotation(
    Dialog(tab = "QControl"));
  parameter Boolean UFlag annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time Tiq "Time constant in reactive power order lag" annotation(
    Dialog(tab = "QControl"));

  //LVRT and HVRT parameters
  parameter Types.PerUnit uLVRTPu "LVRT threshold value" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit uHVRTPu "HVRT threshold value" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean LVRTinPFlag = PFlag "Active current flag during LVRT, 0/1" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean LVRTinQFlag "Reactive current flag during LVRT, 0/1" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean HVRTinPFlag = PFlag "Active current flag during HVRT, 0/1" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean HVRTinQFlag "Reactive current flag during HVRT, 0/1" annotation(
    Dialog(tab = "FRT"));
  parameter Real K1IpLV "Active current factor 1 during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Real K2IpLV "Active current factor 2 during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Real K1IqLV "Reactive current factor 1 during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Real K2IqLV "Reactive current factor 2 during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Real KpLVRT "Active power factor during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Real KqLVRT "Reactive power factor during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit iPSetLVPu "Active current setting during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit iQSetLVPu "Reactive current setting during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit pSetLVPu "Active power setting during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit qSetLVPu "Reactive power setting during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Real K1IpHV "Active current factor 1 during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Real K2IpHV "Active current factor 2 during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Real K1IqHV "Reactive current factor 1 during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Real K2IqHV "Reactive current factor 2 during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Real KpHVRT "Active power factor during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Real KqHVRT "Reactive power factor during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit iPSetHVPu "Active current setting during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit iQSetHVPu "Reactive current setting during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit pSetHVPu "Active power setting during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit qSetHVPu "Reactive power setting during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean pqFRTFlag "Active/reactive control priority, 0/1" annotation(
    Dialog(tab = "FRT"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput qRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Voltage reference provided by the plant controller" annotation(
    Placement(visible = true, transformation(origin = {-200, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uRefPu(start = U0Pu) "Voltage reference provided by the plant controller" annotation(
    Placement(visible = true, transformation(origin = {-200, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pAvailInPu(start = PAvailIn0Pu) "Maximum input electrical power available to the active power control module" annotation(
    Placement(visible = true, transformation(origin = {-60, 200}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 200}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput pAvailOutPu(start = PMaxPu) "Maximum output electrical power available to the active power control module" annotation(
    Placement(visible = true, transformation(origin = {-20, 200}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {90, 200}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput pMeasPu(start = -P0Pu * SystemBase.SnRef / SNom) "Measured (and filtered) active power component (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-200, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qMeasPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Measured (and filtered) reactive power component" annotation(
    Placement(visible = true, transformation(origin = {-202, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uMeasPu(start = U0Pu) "Measured (and filtered) voltage component" annotation(
    Placement(visible = true, transformation(origin = {-200, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput fMeasPu(start = 1) "Measured frequency outputted by the phase-locked loop" annotation(
    Placement(visible = true, transformation(origin = {-200, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput thetaPLL(start = UPhase0) "Phase angle outputted by phase-locked loop" annotation(
    Placement(visible = true, transformation(origin = {-200, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-90, 200}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput pRefPu(start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-200, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{-220, -60}, {-180, -20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput ipRefPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current reference" annotation(
    Placement(visible = true, transformation(origin = {220, 40}, extent = {{-40, -40}, {40, 40}}, rotation = 0), iconTransformation(origin = {200, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current reference" annotation(
    Placement(visible = true, transformation(origin = {220, -40}, extent = {{-40, -40}, {40, 40}}, rotation = 0), iconTransformation(origin = {200, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput tripFlag(start = false) annotation(
    Placement(visible = true, transformation(origin = {200, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {190, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ippPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) annotation(
    Placement(visible = true, transformation(origin = {200, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {190, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqqPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) annotation(
    Placement(visible = true, transformation(origin = {200, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {190, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.IEC.IEC63406.Protections.FRTControl fRTControl(HVRTinPFlag = HVRTinPFlag, HVRTinQFlag = HVRTinQFlag, IMaxPu = IMaxPu, IPMax0Pu = IPMax0Pu, IPMaxPu = IPMaxPu, IPMin0Pu = IPMin0Pu, IPMinPu = IPMinPu, IQMax0Pu = IQMax0Pu, IQMaxPu = IQMaxPu, IQMin0Pu = IQMin0Pu, IQMinPu = IQMinPu, K1IpHV = K1IpHV, K1IpLV = K1IpLV, K1IqHV = K1IqHV, K1IqLV = K1IqLV, K2IpHV = K2IpHV, K2IpLV = K2IpLV, K2IqHV = K2IqHV, K2IqLV = K2IqLV, KpHVRT = KpHVRT, KpLVRT = KpLVRT, KqHVRT = KqHVRT, KqLVRT = KqLVRT, LVRTinPFlag = LVRTinPFlag, LVRTinQFlag = LVRTinQFlag, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, iPSetHVPu = iPSetHVPu, iPSetLVPu = iPSetLVPu, iQSetHVPu = iQSetHVPu, iQSetLVPu = iQSetLVPu, pSetHVPu = pSetHVPu, pSetLVPu = pSetLVPu, pqFRTFlag = pqFRTFlag, qSetHVPu = qSetHVPu, qSetLVPu = qSetLVPu, uHVRTPu = uHVRTPu, uLVRTPu = uLVRTPu) annotation(
    Placement(visible = true, transformation(origin = {120, 100}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.Protections.Protection protection(U0Pu = U0Pu, UPhase0 = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {93.5294, -114.4}, extent = {{-32.4706, -55.2}, {32.4706, 55.2}}, rotation = 0)));

  //Initial parameters
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit QMax0Pu "Initial maximum reactive power" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit QMin0Pu "Initial minimum reactive power" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.Angle UPhase0 "Initial Phase angle outputted by phase-locked loop" annotation(
    Dialog(group = "Operating point"));
  parameter Types.PerUnit IPMin0Pu annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit IPMax0Pu annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit IQMin0Pu "Initial minimum reactive current" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit IQMax0Pu "Initial maximum reactive current" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit PAvailIn0Pu "Initial minimum output electrical power available to the active power control module" annotation(
    Dialog(tab = "Operating point"));

  Dynawo.Electrical.Controls.IEC.IEC63406.Controls.Control control(DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, FFRflag = FFRflag, IMaxPu = IMaxPu, IPMax0Pu = IPMax0Pu, IPMin0Pu = IPMin0Pu, IQMax0Pu = IQMax0Pu, IQMin0Pu = IQMin0Pu, KDroop = KDroop, KIp = KIp, KIqi = KIqi, KIqu = KIqu, KIui = KIui, KIuq = KIuq, KPp = KPp, KPqi = KPqi, KPqu = KPqu, KPui = KPui, KPuq = KPuq, LFlag = LFlag, P0Pu = P0Pu, PAvailIn0Pu = PAvailIn0Pu, PFFlag = PFFlag, PFlag = PFlag, PMaxPu = PMaxPu, PffrMaxPu = PffrMaxPu, PffrMinPu = PffrMinPu, PriorityFlag = PriorityFlag, Q0Pu = Q0Pu, QLimFlag = QLimFlag, QMax0Pu = QMax0Pu, QMaxUd = QMaxUd, QMin0Pu = QMin0Pu, QMinUd = QMinUd, SNom = SNom, TanPhi = TanPhi, Tiq = Tiq, TpRef = TpRef, Trocof = Trocof, U0Pu = U0Pu, UFlag = UFlag, UMaxPu = UMaxPu, UMinPu = UMinPu, f0Pu = f0Pu, fThresholdPu = fThresholdPu, uHVRTPu = uHVRTPu, uLVRTPu = uLVRTPu) annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));

equation
  //TripFlag equations
  ipRefPu = if tripFlag then 0 else ippPu;
  iqRefPu = if tripFlag then 0 else iqqPu;

  connect(thetaPLL, protection.thetaPLL) annotation(
    Line(points = {{-200, -140}, {55, -140}}, color = {0, 0, 127}));
  connect(fMeasPu, protection.fMeasPu) annotation(
    Line(points = {{-200, 140}, {-100, 140}, {-100, -115}, {55, -115}}, color = {0, 0, 127}));
  connect(protection.tripFlag, tripFlag) annotation(
    Line(points = {{132, -114}, {159, -114}, {159, -100}, {200, -100}}, color = {255, 0, 255}));
  connect(uMeasPu, fRTControl.uMeasPu) annotation(
    Line(points = {{-200, -20}, {-160, -20}, {-160, -80}, {40, -80}, {40, 100}, {76, 100}}, color = {0, 0, 127}));
  connect(pMeasPu, fRTControl.pMeasPu) annotation(
    Line(points = {{-200, 60}, {-140, 60}, {-140, 86}, {76, 86}}, color = {0, 0, 127}));
  connect(qMeasPu, fRTControl.qMeasPu) annotation(
    Line(points = {{-202, -100}, {-120, -100}, {-120, -50}, {60, -50}, {60, 70}, {76, 70}}, color = {0, 0, 127}));
  connect(uMeasPu, protection.uMeasPu) annotation(
    Line(points = {{-200, -20}, {-160, -20}, {-160, -80}, {40, -80}, {40, -88}, {54, -88}}, color = {0, 0, 127}));
  connect(fRTControl.ippPu, ippPu) annotation(
    Line(points = {{166, 126}, {170, 126}, {170, 140}, {200, 140}}, color = {0, 0, 127}));
  connect(fRTControl.iqqPu, iqqPu) annotation(
    Line(points = {{166, 116}, {170, 116}, {170, 100}, {200, 100}}, color = {0, 0, 127}));
  connect(control.iPcmdPu, fRTControl.iPcmdPu) annotation(
    Line(points = {{6, 44}, {20, 44}, {20, 130}, {75, 130}}, color = {0, 0, 127}));
  connect(pAvailInPu, control.pAvailInPu) annotation(
    Line(points = {{-60, 200}, {-60, 80}, {-52, 80}, {-52, 64}}, color = {0, 0, 127}));
  connect(qMeasPu, control.qMeasPu) annotation(
    Line(points = {{-202, -100}, {-120, -100}, {-120, -16}, {-84, -16}}, color = {0, 0, 127}));
  connect(qRefPu, control.qRefPu) annotation(
    Line(points = {{-200, -60}, {-140, -60}, {-140, -4}, {-84, -4}}, color = {0, 0, 127}));
  connect(uMeasPu, control.uMeasPu) annotation(
    Line(points = {{-200, -20}, {-160, -20}, {-160, 8}, {-84, 8}}, color = {0, 0, 127}));
  connect(uRefPu, control.uRefPu) annotation(
    Line(points = {{-200, 20}, {-84, 20}}, color = {0, 0, 127}));
  connect(pMeasPu, control.pMeasPu) annotation(
    Line(points = {{-200, 60}, {-140, 60}, {-140, 32}, {-84, 32}}, color = {0, 0, 127}));
  connect(pRefPu, control.pRefPu) annotation(
    Line(points = {{-200, 100}, {-120, 100}, {-120, 44}, {-84, 44}}, color = {0, 0, 127}));
  connect(fMeasPu, control.fMeasPu) annotation(
    Line(points = {{-200, 140}, {-100, 140}, {-100, 56}, {-84, 56}}, color = {0, 0, 127}));
  connect(pAvailOutPu, control.pAvailOutPu) annotation(
    Line(points = {{-20, 200}, {-20, 80}, {-28, 80}, {-28, 64}}, color = {0, 0, 127}));
  connect(control.iQcmdPu, fRTControl.iQcmdPu) annotation(
    Line(points = {{6, 4}, {30, 4}, {30, 116}, {76, 116}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(extent = {{-180, 180}, {180, -180}}), Text(extent = {{-180, 180}, {180, -180}}, textString = "Control
&
Protection")}, coordinateSystem(extent = {{-180, -180}, {180, 180}})),
    Diagram(coordinateSystem(extent = {{-180, -180}, {180, 180}})));
end ControlAndProtection;
