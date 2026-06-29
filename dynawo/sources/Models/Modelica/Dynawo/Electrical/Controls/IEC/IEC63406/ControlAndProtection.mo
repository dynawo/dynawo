within Dynawo.Electrical.Controls.IEC.IEC63406;

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

model ControlAndProtection "Global control and protection module (IEC63406)"

  //General parameters
  parameter Types.PerUnit IMaxPu "Maximum current at converter terminal in pu (base in UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "General"));
  parameter Types.PerUnit IpMaxPu "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IpMinPu "Minimum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IqMaxPu "Maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IqMinPu "Minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.ActivePowerPu PMaxPu "Maximum active power at converter terminal in pu (base SNom)" annotation(
    Dialog(tab = "StorageSys"));
  parameter Boolean PriorityFlag "If false, active current priority, if true, reactive current priority";
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Boolean StorageFlag "If true, it is a storage unit, if false, it is not";
  parameter String TableFileName "Name given to the general file containing all tables" annotation(
    Dialog(tab = "General"));

  //PControl parameters
  parameter Types.PerUnit KIp "Integral gain in the active power PI controller" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit KPp "Proportional gain in the active power PI controller" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPRef "Time constant in the active power filter in s" annotation(
    Dialog(tab = "PControl"));
  parameter Boolean PFlag "If true, closed-loop active power control, if false, open-loop active power control" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tRocof "Time constant for frequency differential operation in s" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit fThresholdPu "Deadband threshold for FFR response in pu (base fNom)" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit f0Pu "Frequency setpoint for FFR control in pu (base fNom)" annotation(
    Dialog(tab = "FFR"));
  parameter Types.ActivePowerPu PffrMaxPu "Maximum active power utilized for FFR control in pu (base SNom)" annotation(
    Dialog(tab = "FFR"));
  parameter Types.ActivePowerPu PffrMinPu "Maximum absorbing active power utilized for FFR control in pu (base SNom)" annotation(
    Dialog(tab = "FFR"));
  parameter Boolean FFRFlag "If true, fast frequency response enabled, if false, disabled" annotation(
    Dialog(tab = "FFR"));
  parameter String InertialTableName "Name given to the inertial table in the table file" annotation(
    Dialog(tab = "FFR"));
  parameter String FFRTableName "Name given to the FFR table in the table file" annotation(
    Dialog(tab = "FFR"));

  //QControl Parameters
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power defined by users in pu (base SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power defined by users in pu (base SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit UMaxPu "Maximum voltage defined by users at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit UMinPu "Minimum voltage defined by users at converter terminal in pu (base UNom)" annotation(
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
  parameter Integer PFFlag "One of the 3 reactive control flags, possible values : 0, 1, 2 and 3" annotation(
    Dialog(tab = "QControl"));
  parameter Integer LFlag "One of the 3 reactive control flags, possible values : 0, 1 and 2" annotation(
    Dialog(tab = "QControl"));
  parameter Boolean QLimFlag "If false, use of the defined lookup tables, if true, use of the constant values" annotation(
    Dialog(tab = "QControl"));
  parameter Boolean UFlag "One of the 3 reactive control flags" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tIq "Time constant in reactive power order lag" annotation(
    Dialog(tab = "QControl"));
  parameter String QMaxtoPTableName "Table giving the maximum reactive power depending on the measured active power" annotation(
    Dialog(tab = "QControl"));
  parameter String QMintoPTableName "Table giving the minimum reactive power depending on the measured active power" annotation(
    Dialog(tab = "QControl"));
  parameter String QMaxtoUTableName "Table giving the maximum reactive power depending on the measured voltage" annotation(
    Dialog(tab = "QControl"));
  parameter String QMintoUTableName "Table giving the minimum reactive power depending on the measured voltage" annotation(
    Dialog(tab = "QControl"));

  //LVRT and HVRT parameters
  parameter Types.PerUnit uLVRTPu "LVRT threshold value in pu (base UNom)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit uHVRTPu "HVRT threshold value in pu (base UNom)" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean LVRTinPFlag = PFlag "Active current flag during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean LVRTinQFlag "Reactive current flag during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean HVRTinPFlag = PFlag "Active current flag during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean HVRTinQFlag "Reactive current flag during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit K1IpLV "Active current factor 1 during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit K2IpLV "Active current factor 2 during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit K1IqLV "Reactive current factor 1 during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit K2IqLV "Reactive current factor 2 during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit KpLVRT "Active power factor during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit KqLVRT "Reactive power factor during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit iPSetLVPu "Active current setting during LVRT in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit iQSetLVPu "Reactive current setting during LVRT in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.ActivePowerPu pSetLVPu "Active power setting during LVRT (base SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.ReactivePowerPu qSetLVPu "Reactive power setting during LVRT (base SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit K1IpHV "Active current factor 1 during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit K2IpHV "Active current factor 2 during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit K1IqHV "Reactive current factor 1 during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit K2IqHV "Reactive current factor 2 during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit KpHVRT "Active power factor during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit KqHVRT "Reactive power factor during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit iPSetHVPu "Active current setting during HVRT in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit iQSetHVPu "Reactive current setting during HVRT in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.ActivePowerPu pSetHVPu "Active power setting during HVRT (base SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.ReactivePowerPu qSetHVPu "Reactive power setting during HVRT (base SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean pqFRTFlag "Active/reactive control priority during FRT" annotation(
    Dialog(tab = "FRT"));

  // Voltage protection parameters
  parameter Types.Time tLvP3 "Disconnection time for low voltage level 3 in s" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time tLvP2 "Disconnection time for low voltage level 2 in s" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time tLvP1 "Disconnection time for low voltage level 1 in s" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time tHvP1 "Disconnection time for high voltage level 1 in s" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time tHvP2 "Disconnection time for high voltage level 2 in s" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time tHvP3 "Disconnection time for high voltage level 3 in s" annotation(
    Dialog(tab = "Protection"));
  parameter Real ULvP3 "Low voltage level 3 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real ULvP2 "Low voltage level 2 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real ULvP1 "Low voltage level 1 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real UHvP1 "High voltage level 1 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real UHvP2 "High voltage level 2 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real UHvP3 "High voltage level 3 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));

  // Frequency protection parameters
  parameter Real fLfP3 "Low frequency level 3 in pu (base fNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real fLfP2 "Low frequency level 2 in pu (base fNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real fLfP1 "Low frequency level 1 in pu (base fNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real fHfP1 "High frequency level 1 in pu (base fNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real fHfP2 "High frequency level 2 in pu (base fNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real fHfP3 "High frequency level 3 in pu (base fNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time tLfP3 "Disconnection time for low frequency level 3 in s" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time tLfP2 "Disconnection time for low frequency level 2 in s" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time tLfP1 "Disconnection time for low frequency level 1 in s" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time tHfP1 "Disconnection time for high frequency level 1 in s" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time tHfP2 "Disconnection time for high frequency level 2 in s" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time tHfP3 "Disconnection time for high frequency level 3 in s" annotation(
    Dialog(tab = "Protection"));

  // Other protection parameters
  parameter Real DerfMaxPu "Maximum level of frequency variation in pu/s (base fNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real DerThetaMax "Maximum level of angle variation in rad/s" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time tDerfMax "Disconnection time for high level of frequency variation, in s" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time tDerThetaMax "Disconnection time for high level of angle variation, in s" annotation(
    Dialog(tab = "Protection"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput fMeasPu(start = 1) "Measured frequency outputted by the phase-locked loop in pu (base fNom)" annotation(
    Placement(visible = true, transformation(origin = {-260, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pAvailInPu(start = PAvailIn0Pu) "Minimum output electrical power available to the active power control module in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 200}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 200}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput pAvailOutPu(start = PMaxPu) "Maximum output electrical power available to the active power control module in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-80, 200}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {90, 200}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput pMeasPu(start = -P0Pu * SystemBase.SnRef / SNom) "Measured (and filtered) active power component in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-260, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference provided by the plant controller in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-260, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{-220, -60}, {-180, -20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qMeasPu(start =- Q0Pu * SystemBase.SnRef / SNom) "Measured (and filtered) reactive power component at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-260, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference provided by the plant controller in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-260, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput thetaPLL(start = UPhase0) "Phase angle outputted by phase-locked loop (in rad)" annotation(
    Placement(visible = true, transformation(origin = {-260, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-90, 200}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uMeasPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-260, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uRefPu(start = U0Pu) "Voltage reference provided by the plant controller in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-260, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput ipRefPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current reference order in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {260, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {200, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current reference order in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {260, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {200, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Dynawo.Electrical.Controls.IEC.IEC63406.Protections.FRTControl fRTControl(StorageFlag=StorageFlag, HVRTinPFlag = HVRTinPFlag, HVRTinQFlag = HVRTinQFlag, IMaxPu = IMaxPu, IpMaxPu = IpMaxPu, IpMinPu = IpMinPu, IqMaxPu = IqMaxPu, IqMinPu = IqMinPu, K1IpHV = K1IpHV, K1IpLV = K1IpLV, K1IqHV = K1IqHV, K1IqLV = K1IqLV, K2IpHV = K2IpHV, K2IpLV = K2IpLV, K2IqHV = K2IqHV, K2IqLV = K2IqLV, KpHVRT = KpHVRT, KpLVRT = KpLVRT, KqHVRT = KqHVRT, KqLVRT = KqLVRT, LVRTinPFlag = LVRTinPFlag, LVRTinQFlag = LVRTinQFlag, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, iPSetHVPu = iPSetHVPu, iPSetLVPu = iPSetLVPu, iQSetHVPu = iQSetHVPu, iQSetLVPu = iQSetLVPu, pSetHVPu = pSetHVPu, pSetLVPu = pSetLVPu, pqFRTFlag = pqFRTFlag, qSetHVPu = qSetHVPu, qSetLVPu = qSetLVPu, uHVRTPu = uHVRTPu, uLVRTPu = uLVRTPu) annotation(
    Placement(visible = true, transformation(origin = {60, 80}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.Protections.Protection protection(DerThetaMax = DerThetaMax, DerfMaxPu = DerfMaxPu, tDerThetaMax = tDerThetaMax, tDerfMax = tDerfMax, tHvP1 = tHvP1, tHvP2 = tHvP2, tHvP3 = tHvP3, tHfP1 = tHfP1, tHfP2 = tHfP2, tHfP3 = tHfP3, tLvP1 = tLvP1, tLvP2 = tLvP2, tLvP3 = tLvP3, tLfP1 = tLfP1, tLfP2 = tLfP2, tLfP3 = tLfP3,U0Pu = U0Pu, UHvP1 = UHvP1, UHvP2 = UHvP2, UHvP3 = UHvP3, ULvP1 = ULvP1, ULvP2 = ULvP2, ULvP3 = ULvP3, UPhase0 = UPhase0, fHfP1 = fHfP1, fHfP2 = fHfP2, fHfP3 = fHfP3, fLfP1 = fLfP1, fLfP2 = fLfP2, fLfP3 = fLfP3) annotation(
    Placement(visible = true, transformation(origin = {40.5294, -114.4}, extent = {{-32.4706, -55.2}, {32.4706, 55.2}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.Controls.Control control(DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, FFRTableName = FFRTableName, FFRFlag = FFRFlag, IMaxPu = IMaxPu, InertialTableName = InertialTableName, KDroop = KDroop, KIp = KIp, KIqi = KIqi, KIqu = KIqu, KIui = KIui, KIuq = KIuq, KPp = KPp, KPqi = KPqi, KPqu = KPqu, KPui = KPui, KPuq = KPuq, LFlag = LFlag, P0Pu = P0Pu, PFFlag = PFFlag, PFlag = PFlag, PMaxPu = PMaxPu, PffrMaxPu = PffrMaxPu, PffrMinPu = PffrMinPu, PriorityFlag = PriorityFlag, Q0Pu = Q0Pu, QLimFlag = QLimFlag, QMaxPu = QMaxPu, QMaxtoPTableName = QMaxtoPTableName, QMaxtoUTableName = QMaxtoUTableName, QMinPu = QMinPu, QMintoPTableName = QMintoPTableName, QMintoUTableName = QMintoUTableName, SNom = SNom, StorageFlag = StorageFlag, TableFileName = TableFileName, TanPhi = TanPhi, tIq = tIq, tPRef = tPRef, tRocof = tRocof, U0Pu = U0Pu, UFlag = UFlag, UMaxPu = UMaxPu, UMinPu = UMinPu, f0Pu = f0Pu, fThresholdPu = fThresholdPu, uHVRTPu = uHVRTPu, uLVRTPu = uLVRTPu) annotation(
    Placement(visible = true, transformation(origin = {-100, 20}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {210, 100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch11 annotation(
    Placement(visible = true, transformation(origin = {210, 20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {150, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {150, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu PAvailIn0Pu = if StorageFlag then -PMaxPu else 0 "Initial minimum output electrical power available to the active power control module in pu (base SNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.Angle UPhase0 "Initial phase angle outputted by phase-locked loop" annotation(
    Dialog(group = "Operating point"));

equation
  connect(thetaPLL, protection.thetaPLL) annotation(
    Line(points = {{-260, -140}, {-5, -140}}, color = {0, 0, 127}));
  connect(fMeasPu, protection.fMeasPu) annotation(
    Line(points = {{-260, 140}, {-160, 140}, {-160, -115}, {-5, -115}}, color = {0, 0, 127}));
  connect(uMeasPu, fRTControl.uMeasPu) annotation(
    Line(points = {{-260, -20}, {-220, -20}, {-220, -80}, {-20, -80}, {-20, 80}, {15, 80}}, color = {0, 0, 127}));
  connect(pMeasPu, fRTControl.pMeasPu) annotation(
    Line(points = {{-260, 60}, {-200, 60}, {-200, 65}, {15, 65}}, color = {0, 0, 127}));
  connect(qMeasPu, fRTControl.qMeasPu) annotation(
    Line(points = {{-260, -100}, {-178, -100}, {-178, -50}, {2, -50}, {2, 50}, {15, 50}}, color = {0, 0, 127}));
  connect(uMeasPu, protection.uMeasPu) annotation(
    Line(points = {{-260, -20}, {-220, -20}, {-220, -80}, {-20, -80}, {-20, -88}, {-6, -88}}, color = {0, 0, 127}));
  connect(control.iPcmdPu, fRTControl.iPcmdPu) annotation(
    Line(points = {{-54, 44.4}, {-40, 44.4}, {-40, 110}, {15, 110}}, color = {0, 0, 127}));
  connect(pAvailInPu, control.pAvailInPu) annotation(
    Line(points = {{-120, 200}, {-120, 80}, {-112, 80}, {-112, 64}}, color = {0, 0, 127}));
  connect(qMeasPu, control.qMeasPu) annotation(
    Line(points = {{-260, -100}, {-178, -100}, {-178, -16}, {-142, -16}}, color = {0, 0, 127}));
  connect(qRefPu, control.qRefPu) annotation(
    Line(points = {{-260, -60}, {-200, -60}, {-200, -4}, {-144, -4}}, color = {0, 0, 127}));
  connect(uMeasPu, control.uMeasPu) annotation(
    Line(points = {{-260, -20}, {-220, -20}, {-220, 8}, {-144, 8}}, color = {0, 0, 127}));
  connect(uRefPu, control.uRefPu) annotation(
    Line(points = {{-260, 20}, {-144, 20}}, color = {0, 0, 127}));
  connect(pMeasPu, control.pMeasPu) annotation(
    Line(points = {{-260, 60}, {-200, 60}, {-200, 32}, {-144, 32}}, color = {0, 0, 127}));
  connect(pRefPu, control.pRefPu) annotation(
    Line(points = {{-260, 100}, {-180, 100}, {-180, 44}, {-144, 44}}, color = {0, 0, 127}));
  connect(fMeasPu, control.fMeasPu) annotation(
    Line(points = {{-260, 140}, {-160, 140}, {-160, 56}, {-144, 56}}, color = {0, 0, 127}));
  connect(pAvailOutPu, control.pAvailOutPu) annotation(
    Line(points = {{-80, 200}, {-80, 80}, {-88, 80}, {-88, 64}}, color = {0, 0, 127}));
  connect(control.iQcmdPu, fRTControl.iQcmdPu) annotation(
    Line(points = {{-54, 3.6}, {-30, 3.6}, {-30, 95}, {15, 95}}, color = {0, 0, 127}));
  connect(switch11.y, iqRefPu) annotation(
    Line(points = {{222, 20}, {260, 20}}, color = {0, 0, 127}));
  connect(switch1.y, ipRefPu) annotation(
    Line(points = {{222, 100}, {260, 100}}, color = {0, 0, 127}));
  connect(const.y, switch1.u1) annotation(
    Line(points = {{162, 92}, {198, 92}}, color = {0, 0, 127}));
  connect(constant1.y, switch11.u1) annotation(
    Line(points = {{161, 12}, {198, 12}}, color = {0, 0, 127}));
  connect(fRTControl.ippPu, switch1.u3) annotation(
    Line(points = {{106, 106}, {120, 106}, {120, 120}, {180, 120}, {180, 108}, {198, 108}}, color = {0, 0, 127}));
  connect(fRTControl.iqqPu, switch11.u3) annotation(
    Line(points = {{106, 96}, {120, 96}, {120, 28}, {198, 28}}, color = {0, 0, 127}));
  connect(protection.tripFlag, switch11.u2) annotation(
    Line(points = {{80, -114}, {180, -114}, {180, 20}, {198, 20}}, color = {255, 0, 255}));
  connect(protection.tripFlag, switch1.u2) annotation(
    Line(points = {{80, -114}, {180, -114}, {180, 100}, {198, 100}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-180, 180}, {180, -180}}), Text(extent = {{-180, 180}, {180, -180}}, textString = "Control
&
Protection")}, coordinateSystem(extent = {{-180, -180}, {180, 180}})),
    Diagram(coordinateSystem(extent = {{-240, -180}, {240, 180}})),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end ControlAndProtection;
