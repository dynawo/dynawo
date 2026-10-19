within Dynawo.Electrical.Sources;

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

model ConverterCurrentSourceIEC63406 "Converter model for the IEC 63406 standard with current source interface and for grid following applications"

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

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
  parameter String TableFileName "Name given to the general file containing all tables" annotation(
    Dialog(tab = "General"));

  //Communication interface parameters
  parameter Integer ComFlag "0 if the communication delay is relatively long and affects the control, 1 if accurate modeling of the communication delay is provided, 2 for linear communication and 3 for 1st order lag communication" annotation(
    Dialog(tab = "PlantCommunication"));
  parameter Types.Time tCom "Time constant for communication delay between the plant-level controller and the generating unit-level controller in s" annotation(
    Dialog(tab = "PlantCommunication"));
  parameter Types.Time tLead "Time constant for communication lead between the plant-level controller and the generating unit-level controller in s" annotation(
    Dialog(tab = "PlantCommunication"));
  parameter Types.Time tLag "Time constant for communication lag between the plant-level controller and the generating unit-level controller in s" annotation(
    Dialog(tab = "PlantCommunication"));

  //Storage parameters
  parameter Types.ActivePowerPu PMaxPu "Maximum active power at converter terminal in pu (base SNom)" annotation(
    Dialog(tab = "General"));
  parameter Boolean StorageFlag "If true, it is a storage unit, if false, it is not" annotation(
    Dialog(tab = "Storage"));
  parameter Boolean SOCFlag "If false, battery energy storage systems, if true, supercapacitor energy storage systems and flywheel energy storage systems" annotation(
    Dialog(tab = "Storage"));
  parameter Types.Percent SOCInit "Initial SOC amount in %" annotation(
    Dialog(tab = "Storage"));
  parameter Types.Percent SOCMax "Maximum SOC amount for charging in %" annotation(
    Dialog(tab = "StorageSys"));
  parameter Types.Percent SOCMin "Minimum SOC amount for discharging in %" annotation(
    Dialog(tab = "StorageSys"));
  parameter Types.Time tESS "Equivalent time constant in s for the battery, supercapacitor or flywheel energy storage systems (if you have tESS = 10, a system with 100% SOC and P = Pmax, the system will discharge completely in 10 s)" annotation(
    Dialog(tab = "Storage"));
  parameter Types.Time tConv "Equivalent time for primary energy conversion in s" annotation(
    Dialog(tab = "Storage"));

  //PControl parameters
  parameter Types.PerUnit fThresholdPu "Deadband threshold for FFR response in pu (base fNom)" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit f0Pu "Frequency setpoint for FFR control in pu (base fNom)" annotation(
    Dialog(tab = "FFR"));
  parameter String FFRTableName "Name given to the FFR table in the table file" annotation(
    Dialog(tab = "FFR"));
  parameter Boolean FFRFlag "If true, fast frequency response enabled, if false, disabled" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit KIp "Integral gain in the active power PI controller" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit KPp "Proportional gain in the active power PI controller" annotation(
    Dialog(tab = "PControl"));
  parameter String InertialTableName "Name given to the inertial table in the table file" annotation(
    Dialog(tab = "FFR"));
  parameter Boolean PFlag "If true, closed-loop active power control, if false, open-loop active power control" annotation(
    Dialog(tab = "PControl"));
  parameter Types.ActivePowerPu PffrMaxPu "Maximum active power utilized for FFR control in pu (base SNom)" annotation(
    Dialog(tab = "FFR"));
  parameter Types.ActivePowerPu PffrMinPu "Maximum absorbing active power utilized for FFR control in pu (base SNom)" annotation(
    Dialog(tab = "FFR"));
  parameter Boolean PriorityFlag "If false, active current priority, if true, reactive current priority";
  parameter Types.Time tRocof "Time constant for frequency differential operation in s" annotation(
    Dialog(tab = "FFR"));
  parameter Types.Time tPRef "Time constant in the active power filter in s" annotation(
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
  parameter Integer LFlag "One of the 3 reactive control flags, possible values : 0, 1 and 2" annotation(
    Dialog(tab = "QControl"));
  parameter Integer PFFlag "One of the 3 reactive control flags, possible values : 0, 1, 2 and 3" annotation(
    Dialog(tab = "QControl"));
  parameter Boolean QLimFlag "If false, use of the defined lookup tables, if true, use of the constant values" annotation(
    Dialog(tab = "QControl"));
  parameter String QMaxtoPTableName "Table giving the maximum reactive power depending on the measured active power" annotation(
    Dialog(tab = "QControl"));
  parameter String QMintoPTableName "Table giving the minimum reactive power depending on the measured active power" annotation(
    Dialog(tab = "QControl"));
  parameter String QMaxtoUTableName "Table giving the maximum reactive power depending on the measured voltage" annotation(
    Dialog(tab = "QControl"));
  parameter String QMintoUTableName "Table giving the minimum reactive power depending on the measured voltage" annotation(
    Dialog(tab = "QControl"));
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power defined by users in pu (base SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power defined by users in pu (base SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Real TanPhi = Q0Pu / P0Pu "Power factor used in the power factor control" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tIq "Time constant in reactive power order lag in s" annotation(
    Dialog(tab = "QControl"));
  parameter Boolean UFlag "One of the 3 reactive control flags" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit UMaxPu "Maximum voltage defined by users at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit UMinPu "Minimum voltage defined by users at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));

  //LVRT and HVRT parameters
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
  parameter Boolean HVRTinPFlag "Active current flag during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean HVRTinQFlag "Reactive current flag during HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit iPSetHVPu "Active current setting during HVRT in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit iPSetLVPu "Active current setting during LVRT in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit iQSetHVPu "Reactive current setting during HVRT in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit iQSetLVPu "Reactive current setting during LVRT in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean LVRTinPFlag "Active current flag during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean LVRTinQFlag "Reactive current flag during LVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Boolean pqFRTFlag "Active/reactive control priority during FRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.ActivePowerPu pSetHVPu "Active power setting during HVRT (base SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.ActivePowerPu pSetLVPu "Active power setting during LVRT (base SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.ReactivePowerPu qSetHVPu "Reactive power setting during HVRT (base SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.ReactivePowerPu qSetLVPu "Reactive power setting during LVRT (base SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit uHVRTPu "HVRT threshold value in pu (base UNom)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit uLVRTPu "LVRT threshold value in pu (base UNom)" annotation(
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

  //Circuit parameters
  parameter Types.PerUnit BesPu "Shunt susceptance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit GesPu "Shunt conductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit ResPu "Serial resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit XesPu "Serial reactance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.Time tG "Time constant in s to represent the control delay effect of the inner current control loop. Alternatively set it to zero to bypass this delay." annotation(
    Dialog(tab = "CurrentSource"));

  //Grid measurement parameters
  parameter Types.Time tIFilt "Filter time constant for current measurement in s" annotation(
    Dialog(tab = "GridMeasurement"));
  parameter Types.Time tPFilt "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "GridMeasurement"));
  parameter Types.Time tQFilt "Filter time constant for reactive power measurement in s" annotation(
    Dialog(tab = "GridMeasurement"));
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "GridMeasurement"));

  //PLL parameters
  parameter Types.Time DeltaT "Integral time step in s" annotation(
    Dialog(tab = "PLL"));
  parameter Types.AngularVelocityPu DfMaxPu = Dynawo.Electrical.SystemBase.omegaNom "Maximum angle rotation ramp rate in rad/s" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit KPpll "Proportional gain in PI controller" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit KIpll "Integral gain in PI controller" annotation(
    Dialog(tab = "PLL"));
  parameter Integer PLLFlag "0 for the case when the phase angle can be read from the calculation result of the simulation program, 1 for the case of adding a filter based on case 1, 2 for the case where the dynamics of the PLL need to be considered" annotation(
    Dialog(tab = "PLL"));
  parameter Types.Time tPllFilt "Time constant in PLL angle filter, in s. Put 0 if no filter for the PLL (PLLFlag=2 in the norm)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.Time tFFilt "Time constant in PLL angle filter, in s. Put 0 if no filter for the PLL (PLLFlag=2 in the norm)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit UPllPu "Voltage below which the frequency of the voltage is filtered and the angle of the voltage is possibly frozen, in pu (base UNom)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit WMaxPu "Maximum PLL frequency deviation in pu (base rated frequency)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit WMinPu "Minimum PLL frequency deviation in pu (base rated frequency)" annotation(
    Dialog(tab = "PLL"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput pPrimPu(start = -P0Pu * SystemBase.SnRef / SNom) "Power from the primary energy in pu (base SNom), which should be specified by model users and can be time-varying to represent the variations of primary energy" annotation(
    Placement(visible = true, transformation(origin = {-260, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-260, 180}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pCmdPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power command from the plant controller in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-250, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-260, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qCmdPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power command from the plant controller in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-250, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-260, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uCmdPu(start = U0Pu) "Voltage command from the plant controller in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-250, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-260, -180}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Interfaces
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {260, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.IEC.IEC63406.Measurement.GridMeasurement gridMeasurement(DeltaT = DeltaT, DfMaxPu = DfMaxPu, KIpll = KIpll, KPpll = KPpll, P0Pu = P0Pu, PLLFlag = PLLFlag, Q0Pu = Q0Pu, SNom = SNom, tFFilt = tFFilt, tPllFilt = tPllFilt, U0Pu = U0Pu, UPhase0 = UPhase0, UPllPu = UPllPu, WMaxPu = WMaxPu, WMinPu = WMinPu, i0Pu = i0Pu, tIFilt = tIFilt, tPFilt = tPFilt, tQFilt = tQFilt, tS = tS, tUFilt = tUFilt, thetaPLL(start = UPhase0), u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {150, 70}, extent = {{50, -50}, {-50, 50}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.ControlAndProtection controlAndProtection(DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, DerThetaMax = DerThetaMax, DerfMaxPu = DerfMaxPu, FFRTableName = FFRTableName, FFRFlag = FFRFlag, HVRTinQFlag = HVRTinQFlag, IMaxPu = IMaxPu, IpMaxPu = IpMaxPu, IpMinPu = IpMinPu, IqMaxPu = IqMaxPu, IqMinPu = IqMinPu, InertialTableName = InertialTableName, K1IpHV = K1IpHV, K1IpLV = K1IpLV, K1IqHV = K1IqHV, K1IqLV = K1IqLV, K2IpHV = K2IpHV, K2IpLV = K2IpLV, K2IqHV = K2IqHV, K2IqLV = K2IqLV, KDroop = KDroop, KIp = KIp, KIqi = KIqi, KIqu = KIqu, KIui = KIui, KIuq = KIuq, KPp = KPp, KPqi = KPqi, KPqu = KPqu, KPui = KPui, KPuq = KPuq, KpHVRT = KpHVRT, KpLVRT = KpLVRT, KqHVRT = KqHVRT, KqLVRT = KqLVRT, LFlag = LFlag, LVRTinQFlag = LVRTinQFlag, P0Pu = P0Pu, PFFlag = PFFlag, PFlag = PFlag, PMaxPu = PMaxPu, PffrMaxPu = PffrMaxPu, PffrMinPu = PffrMinPu, PriorityFlag = PriorityFlag, Q0Pu = Q0Pu, QLimFlag = QLimFlag, QMaxPu = QMaxPu, QMaxtoPTableName = QMaxtoPTableName, QMaxtoUTableName = QMaxtoUTableName, QMinPu = QMinPu, QMintoPTableName = QMintoPTableName, QMintoUTableName = QMintoUTableName, SNom = SNom, StorageFlag = StorageFlag, tDerThetaMax = tDerThetaMax, tDerfMax = tDerfMax, tHvP1 = tHvP1, tHvP2 = tHvP2, tHvP3 = tHvP3, tHfP1 = tHfP1, tHfP2 = tHfP2, tHfP3 = tHfP3, tLvP1 = tLvP1, tLvP2 = tLvP2, tLvP3 = tLvP3, tLfP1 = tLfP1, tLfP2 = tLfP2, tLfP3 = tLfP3, TableFileName = TableFileName, TanPhi = TanPhi, tIq = tIq, tPRef = tPRef, tRocof = tRocof, U0Pu = U0Pu, UFlag = UFlag, UHvP1 = UHvP1, UHvP2 = UHvP2, UHvP3 = UHvP3, ULvP1 = ULvP1, ULvP2 = ULvP2, ULvP3 = ULvP3, UMaxPu = UMaxPu, UMinPu = UMinPu, UPhase0 = UPhase0, f0Pu = f0Pu, fHfP1 = fHfP1, fHfP2 = fHfP2, fHfP3 = fHfP3, fLfP1 = fLfP1, fLfP2 = fLfP2, fLfP3 = fLfP3, fThresholdPu = fThresholdPu, iPSetHVPu = iPSetHVPu, iPSetLVPu = iPSetLVPu, iQSetHVPu = iQSetHVPu, iQSetLVPu = iQSetLVPu, pSetHVPu = pSetHVPu, pSetLVPu = pSetLVPu, pqFRTFlag = pqFRTFlag, qSetHVPu = qSetHVPu, qSetLVPu = qSetLVPu, uHVRTPu = uHVRTPu, uLVRTPu = uLVRTPu) annotation(
    Placement(visible = true, transformation(origin = {0, -80}, extent = {{-40, -52}, {40, 52}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.PrimaryEnergy.EnergyConversion energyConversion(P0Pu = P0Pu, PMaxPu = PMaxPu, SNom = SNom, SOCFlag = SOCFlag, SOCInit = SOCInit, SOCMax = SOCMax, SOCMin = SOCMin, StorageFlag = StorageFlag, tConv = tConv, tESS = tESS) annotation(
    Placement(visible = true, transformation(origin = {-70, 150}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.PlantCommunication plantCommunication(ComFlag = ComFlag, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, tCom = tCom, tLag = tLag, tLead = tLead, U0Pu = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-180, -140}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));
  Dynawo.Electrical.Sources.IEC.InjectorCurrentSource injectorCurrentSource(BesPu = BesPu, GesPu = GesPu, IsIm0Pu = IsIm0Pu, IsRe0Pu = IsRe0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, ResPu = ResPu, SNom = SNom, tG = tG, U0Pu = U0Pu, UPhase0 = UPhase0, UsIm0Pu = UsIm0Pu, UsRe0Pu = UsRe0Pu, XesPu = XesPu, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {160, -80}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.PerUnit IsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.PerUnit IsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.Angle UPhase0 "Initial Phase angle outputted by phase-locked loop (in rad)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.PerUnit UsIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.PerUnit UsRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));

equation
  connect(pCmdPu, plantCommunication.pCmdPu) annotation(
    Line(points = {{-250, -120}, {-224, -120}}, color = {0, 0, 127}));
  connect(qCmdPu, plantCommunication.qCmdPu) annotation(
    Line(points = {{-250, -140}, {-224, -140}}, color = {0, 0, 127}));
  connect(uCmdPu, plantCommunication.uCmdPu) annotation(
    Line(points = {{-250, -160}, {-224, -160}}, color = {0, 0, 127}));
  connect(pPrimPu, energyConversion.pPrimPu) annotation(
    Line(points = {{-260, 160}, {-106, 160}}, color = {0, 0, 127}));
  connect(gridMeasurement.PMeasPu, controlAndProtection.pMeasPu) annotation(
    Line(points = {{95, 110}, {-80, 110}, {-80, -57}, {-43, -57}}, color = {0, 0, 127}));
  connect(gridMeasurement.QMeasPu, controlAndProtection.qMeasPu) annotation(
    Line(points = {{95, 100}, {-120, 100}, {-120, -80}, {-43, -80}}, color = {0, 0, 127}));
  connect(gridMeasurement.UMeasPu, controlAndProtection.uMeasPu) annotation(
    Line(points = {{95, 60}, {-100, 60}, {-100, -68}, {-43, -68}}, color = {0, 0, 127}));
  connect(gridMeasurement.fMeasPu, controlAndProtection.fMeasPu) annotation(
    Line(points = {{95, 40}, {-60, 40}, {-60, -45}, {-43, -45}}, color = {0, 0, 127}));
  connect(gridMeasurement.thetaPLL, controlAndProtection.thetaPLL) annotation(
    Line(points = {{95, 30}, {-19.5, 30}, {-19.5, -22}}, color = {0, 0, 127}));
  connect(plantCommunication.pRefPu, controlAndProtection.pRefPu) annotation(
    Line(points = {{-136, -120}, {-100, -120}, {-100, -92}, {-43, -92}}, color = {0, 0, 127}));
  connect(plantCommunication.qRefPu, controlAndProtection.qRefPu) annotation(
    Line(points = {{-136, -140}, {-80, -140}, {-80, -103}, {-43, -103}}, color = {0, 0, 127}));
  connect(gridMeasurement.PMeasPu, energyConversion.pMeasPu) annotation(
    Line(points = {{95, 110}, {-120, 110}, {-120, 140}, {-106, 140}}, color = {0, 0, 127}));
  connect(energyConversion.pAvailOutPu, controlAndProtection.pAvailOutPu) annotation(
    Line(points = {{-36, 140}, {19, 140}, {19, -22}}, color = {0, 0, 127}));
  connect(energyConversion.pAvailInPu, controlAndProtection.pAvailInPu) annotation(
    Line(points = {{-36, 160}, {0, 160}, {0, -22}}, color = {0, 0, 127}));
  connect(injectorCurrentSource.terminal, terminal) annotation(
    Line(points = {{204, -80}, {260, -80}}, color = {0, 0, 255}));
  connect(gridMeasurement.thetaPLL, injectorCurrentSource.thetaPLL) annotation(
    Line(points = {{96, 30}, {80, 30}, {80, 0}, {160, 0}, {160, -32}}, color = {0, 0, 127}));
  connect(controlAndProtection.ipRefPu, injectorCurrentSource.ipRefPu) annotation(
    Line(points = {{43, -68}, {80, -68}, {80, -60}, {112, -60}}, color = {0, 0, 127}));
  connect(controlAndProtection.iqRefPu, injectorCurrentSource.iqRefPu) annotation(
    Line(points = {{43, -92}, {80, -92}, {80, -100}, {112, -100}}, color = {0, 0, 127}));
  connect(injectorCurrentSource.iPu, gridMeasurement.iPu) annotation(
    Line(points = {{204, -48}, {220, -48}, {220, 70}, {206, 70}}, color = {85, 170, 255}));
  connect(injectorCurrentSource.uPu, gridMeasurement.uPu) annotation(
    Line(points = {{204, -60}, {230, -60}, {230, 100}, {206, 100}}, color = {85, 170, 255}));
  connect(plantCommunication.uRefPu, controlAndProtection.uRefPu) annotation(
    Line(points = {{-136, -160}, {-60, -160}, {-60, -115}, {-43, -115}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-240, 240}, {240, -240}}), Text(extent = {{-240, 240}, {240, -240}}, textString = "Converter
Based
Generating
Unit")}, coordinateSystem(extent = {{-240, -240}, {240, 240}})),
    Diagram(coordinateSystem(extent = {{-240, -240}, {240, 240}})));
end ConverterCurrentSourceIEC63406;
