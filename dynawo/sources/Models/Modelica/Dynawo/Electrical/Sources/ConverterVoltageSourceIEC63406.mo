within Dynawo.Electrical.Sources;

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

model ConverterVoltageSourceIEC63406 "Converter model for the IEC 63406 standard with voltage source interface and for grid following applications"

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

  //General parameters
  parameter Types.PerUnit IMaxPu "Maximum current at converter terminal in pu (base in UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "General"));
  parameter Types.PerUnit IPMaxPu "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IPMinPu "Minimum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IQMaxPu "Maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit IQMinPu "Minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "FRT"));
  parameter String TableFileName "Name given to the general file containing all tables" annotation(
    Dialog(tab = "General"));

  //Communication Interface Parameters
  parameter Integer ComFlag "0 if the communication delay is relatively long and affects the control, 1 if accurate modeling of the communication delay is provided, 2 for linear communication and 3 for 1st order lag communication" annotation(
    Dialog(tab = "PlantCommunication"));
  parameter Types.Time Tcom "Time constant for communication delay between the plant-level controller and the generating unit-level controller" annotation(
    Dialog(tab = "PlantCommunication"));
  parameter Types.Time Tlead "Time constant for communication lead between the plant-level controller and the generating unit-level controller" annotation(
    Dialog(tab = "PlantCommunication"));
  parameter Types.Time Tlag "Time constant for communication lag between the plant-level controller and the generating unit-level controller" annotation(
    Dialog(tab = "PlantCommunication"));

  //Storage parameters
  parameter Types.PerUnit PMaxPu "Maximum active power at converter terminal in pu (base SNom)" annotation(
    Dialog(tab = "General"));
  parameter Boolean StorageFlag "1 if it is a storage unit, 0 if not" annotation(
    Dialog(tab = "General"));
  parameter Boolean SOCFlag "0 for battery energy storage systems, 1 for supercapacitor energy storage systems and flywheel energy storage systems" annotation(
    Dialog(tab = "Storage"));
  parameter Real SOCInit(unit = "%") "Initial SOC amount" annotation(
    Dialog(tab = "Storage"));
  parameter Real SOCMax(unit = "%") "Maximum SOC amount for charging" annotation(
    Dialog(tab = "Storage"));
  parameter Real SOCMin(unit = "%") "Minimum SOC amount for charging" annotation(
    Dialog(tab = "Storage"));
  parameter Types.Time Tess "Equivalent time constant (in s) for the battery, supercapacitor or flywheel energy storage systems (if you have Tess = 10, a system with 100% SOC and P = Pmax, the system will discharge completely in 10s)" annotation(
    Dialog(tab = "Storage"));
  parameter Types.Time Tconv "Equivalent time for primary energy conversion" annotation(
    Dialog(tab = "Storage"));

  //PControl Parameters
  parameter Types.PerUnit fThresholdPu "Deadband threshold for FFR response in pu (base nominal frequency)" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit f0Pu "Frequency setpoint for FFR control in pu (base nominal frequency)" annotation(
    Dialog(tab = "FFR"));
  parameter String FFRTableName "Name given to the FFR table in the table file" annotation(
    Dialog(tab = "FFR"));
  parameter Boolean FFRflag "1 to enable the fast frequency response, 0 to disable the fast frequency response" annotation(
    Dialog(tab = "FFR"));
  parameter Real KIp "Integral gain in the active power PI controller" annotation(
    Dialog(tab = "PControl"));
  parameter Real KPp "Proportional gain in the active power PI controller" annotation(
    Dialog(tab = "PControl"));
  parameter String InertialTableName "Name given to the inertial table in the table file" annotation(
    Dialog(tab = "FFR"));
  parameter Boolean PFlag "1 for closed-loop active power control, 0 for open-loop active power control" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit PffrMaxPu "Maximum active power utilized for FFR control in pu (base SNom)" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit PffrMinPu "Maximum absorbing active power utilized for FFR control in pu (base SNom)" annotation(
    Dialog(tab = "FFR"));
  parameter Boolean PriorityFlag "0 for active current priority, 1 for reactive current priority";
  parameter Types.Time Trocof "Time constant for frequency differential operation" annotation(
    Dialog(tab = "FFR"));
  parameter Types.Time TpRef "Time constant in the active power filter" annotation(
    Dialog(tab = "PControl"));

  //QControl Parameters
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
  parameter Integer PFFlag "One of the 3 reactive control flags" annotation(
    Dialog(tab = "QControl"));
  parameter Integer LFlag "One of the 3 reactive control flags" annotation(
    Dialog(tab = "QControl"));
  parameter Boolean QLimFlag "0 to use the defined lookup tables, 1 to use the constant values" annotation(
    Dialog(tab = "QControl"));
  parameter String QMaxtoPTableName "Table giving the maximum reactive power depending on the measured active power" annotation(
    Dialog(tab = "QControl"));
  parameter String QMintoPTableName "Table giving the minimum reactive power depending on the measured active power" annotation(
    Dialog(tab = "QControl"));
  parameter String QMaxtoUTableName "Table giving the maximum reactive power depending on the measured voltage" annotation(
    Dialog(tab = "QControl"));
  parameter String QMintoUTableName "Table giving the minimum reactive power depending on the measured voltage" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit QMaxPu "Maximum reactive power defined by users in pu (base SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit QMinPu "Minimum reactive power defined by users in pu (base SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Real TanPhi = Q0Pu / P0Pu "Power factor used in the power factor control" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time Tiq "Time constant in reactive power order lag" annotation(
    Dialog(tab = "QControl"));
  parameter Boolean UFlag "One of the 3 reactive control flags" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit UMaxPu "Maximum voltage defined by users at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit UMinPu "Minimum voltage defined by users at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));

  //LVRT and HVRT parameters
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
  parameter Boolean HVRTinPFlag "Active current flag during HVRT, 0/1" annotation(
      Dialog(tab = "FRT"));
  parameter Boolean HVRTinQFlag "Reactive current flag during HVRT, 0/1" annotation(
      Dialog(tab = "FRT"));
  parameter Types.PerUnit iPSetHVPu "Active current setting during HVRT" annotation(
      Dialog(tab = "FRT"));
  parameter Types.PerUnit iPSetLVPu "Active current setting during LVRT" annotation(
      Dialog(tab = "FRT"));
  parameter Types.PerUnit iQSetHVPu "Reactive current setting during HVRT" annotation(
      Dialog(tab = "FRT"));
  parameter Types.PerUnit iQSetLVPu "Reactive current setting during LVRT" annotation(
      Dialog(tab = "FRT"));
  parameter Boolean LVRTinPFlag "Active current flag during LVRT, 0/1" annotation(
      Dialog(tab = "FRT"));
  parameter Boolean LVRTinQFlag "Reactive current flag during LVRT, 0/1" annotation(
      Dialog(tab = "FRT"));
  parameter Types.PerUnit pSetHVPu "Active power setting during HVRT" annotation(
      Dialog(tab = "FRT"));
  parameter Types.PerUnit pSetLVPu "Active power setting during LVRT" annotation(
      Dialog(tab = "FRT"));
  parameter Types.PerUnit qSetHVPu "Reactive power setting during HVRT" annotation(
      Dialog(tab = "FRT"));
  parameter Types.PerUnit qSetLVPu "Reactive power setting during LVRT" annotation(
      Dialog(tab = "FRT"));
  parameter Types.PerUnit uHVRTPu "HVRT threshold value" annotation(
      Dialog(tab = "FRT"));
  parameter Types.PerUnit uLVRTPu "LVRT threshold value" annotation(
      Dialog(tab = "FRT"));
  parameter Boolean pqFRTFlag "Active/reactive control priority during FRT, 0/1" annotation(
    Dialog(tab = "FRT"));

  // Voltage protection parameters
  parameter Real TLVP3 "Disconnection time for high voltage level 3" annotation(
    Dialog(tab = "Protection"));
  parameter Real TLVP2 "Disconnection time for high voltage level 2" annotation(
    Dialog(tab = "Protection"));
  parameter Real TLVP1 "Disconnection time for high voltage level 1" annotation(
    Dialog(tab = "Protection"));
  parameter Real THVP1 "Disconnection time for low voltage level 1" annotation(
    Dialog(tab = "Protection"));
  parameter Real THVP2 "Disconnection time for low voltage level 2" annotation(
    Dialog(tab = "Protection"));
  parameter Real THVP3 "Disconnection time for low voltage level 3" annotation(
    Dialog(tab = "Protection"));
  parameter Real ULVP3 "Low voltage level 3 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real ULVP2 "Low voltage level 2 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real ULVP1 "Low voltage level 1 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real UHVP1 "High voltage level 1 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real UHVP2 "High voltage level 2 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Real UHVP3 "High voltage level 3 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));

  // Frequency protection parameters
  parameter Real fLfP3 "Low frequency level 3 in pu (base nominal frequency)" annotation(
    Dialog(tab = "Protection"));
  parameter Real fLfP2 "Low frequency level 2 in pu (base nominal frequency)" annotation(
    Dialog(tab = "Protection"));
  parameter Real fLfP1 "Low frequency level 1 in pu (base nominal frequency)" annotation(
    Dialog(tab = "Protection"));
  parameter Real fHfP1 "High frequency level 1 in pu (base nominal frequency)" annotation(
    Dialog(tab = "Protection"));
  parameter Real fHfP2 "High frequency level 2 in pu (base nominal frequency)" annotation(
    Dialog(tab = "Protection"));
  parameter Real fHfP3 "High frequency level 3 in pu (base nominal frequency)" annotation(
    Dialog(tab = "Protection"));
  parameter Real TLfP3 "Disconnection time for low frequency level 3" annotation(
    Dialog(tab = "Protection"));
  parameter Real TLfP2 "Disconnection time for low frequency level 3" annotation(
    Dialog(tab = "Protection"));
  parameter Real TLfP1 "Disconnection time for low frequency level 3" annotation(
    Dialog(tab = "Protection"));
  parameter Real THfP1 "Disconnection time for high frequency level 3" annotation(
    Dialog(tab = "Protection"));
  parameter Real THfP2 "Disconnection time for high frequency level 3" annotation(
    Dialog(tab = "Protection"));
  parameter Real THfP3 "Disconnection time for high frequency level 3" annotation(
    Dialog(tab = "Protection"));

  // Other protection parameters
  parameter Real DerfMaxPu "Maximum level of frequency variation in pu (base nominal frequency per second)" annotation(
    Dialog(tab = "Protection"));
  parameter Real DerThetaMax "Maximum level of angle variation in rad/s" annotation(
    Dialog(tab = "Protection"));
  parameter Real TDerfMax "Disconnection time for high level of frequency variation" annotation(
    Dialog(tab = "Protection"));
  parameter Real TDerThetaMax "Disconnection time for high level of angle variation" annotation(
    Dialog(tab = "Protection"));

  //Circuit parameters
  parameter Types.PerUnit ResPu "Serial resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit XesPu "Serial reactance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.Time Tg "Time constant to represent the control delay effect of the inner current control loop. Alternatively set it to zero to bypass this delay." annotation(
    Dialog(tab = "Source"));
  parameter Types.Time Te "Time constant to represent the delay in the pulse width modulation/switching process." annotation(Dialog(tab = "Source"));

  //Grid measurement Parameters
  parameter Types.Time TpFilt "Time constant in active power measurement filter" annotation(
    Dialog(tab = "GridMeasurement"));
  parameter Types.Time TqFilt "Time constant in reactive power measurement filter" annotation(
    Dialog(tab = "GridMeasurement"));
  parameter Types.Time TiFilt "Time constant in current measurement filter" annotation(
    Dialog(tab = "GridMeasurement"));
  parameter Types.Time TuFilt "Time constant in voltage measurement filter" annotation(
    Dialog(tab = "GridMeasurement"));

  //PLL parameters
  parameter Integer PLLFlag "0 for the case when the phase angle can be read from the calculation result of the simulation program, 1 for the case of adding a filter based on case 1, 2 for the case where the dynamics of the PLL need to be considered" annotation(
    Dialog(tab = "PLL"));
  parameter Types.Time TpllFilt "Time constant in PLL angle filter. Put 0 if no filter for the PLL (PLLFlag=2 in the norm)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.Time TfFilt "Time constant in PLL angle filter. Put 0 if no filter for the PLL (PLLFlag=2 in the norm)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.Time DeltaT "Integral time step" annotation(
    Dialog(tab = "PLL"));
  parameter Real KPpll "Proportional gain in PI controller" annotation(
    Dialog(tab = "PLL"));
  parameter Real KIpll "Integral gain in PI controller" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit UpllPu "Voltage below which the frequency of the voltage is filtered and the angle of the voltage is possibly frozen" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit WMaxPu "Maximum PLL frequency deviation in pu (base rated frequency)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit WMinPu "Minimum PLL frequency deviation in pu (base rated frequency)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.AngularVelocityPu DfMaxPu = Dynawo.Electrical.SystemBase.omegaNom "Maximum angle rotation ramp rate in rad/s" annotation(
    Dialog(tab = "PLL"));


  //Input variables
  Modelica.Blocks.Interfaces.RealInput pPrimPu(start = -P0Pu * SystemBase.SnRef / SNom) "Power from the primary energy in pu (base SNom), which should be specified by model users and can be time-varying to represent the variations of primary energy" annotation(
    Placement(visible = true, transformation(origin = {-260, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-260, 180}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pCmdPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power command from the plant controller in pu (base SNom (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-250, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-260, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qCmdPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power command from the plant controller in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-250, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-260, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uCmdPu(start = U0Pu) "Voltage command from the plant controller in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-250, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-260, -180}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Interfaces
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {260, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

   Dynawo.Electrical.Controls.IEC.IEC63406.Measurement.GridMeasurement gridMeasurement(DeltaT = DeltaT, DfMaxPu = DfMaxPu, KIpll = KIpll, KPpll = KPpll, P0Pu = P0Pu, PLLFlag = PLLFlag, Q0Pu = Q0Pu, SNom = SNom, TfFilt = TfFilt, TpllFilt = TpllFilt, U0Pu = U0Pu, UPhase0 = UPhase0, UpllPu = UpllPu, WMaxPu = WMaxPu, WMinPu = WMinPu, i0Pu = i0Pu, tIFilt = TiFilt, tPFilt = TpFilt, tQFilt = TqFilt, tS = tS, tUFilt = TuFilt, thetaPLL(start = UPhase0), u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {150, 70}, extent = {{50, -50}, {-50, 50}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.ControlAndProtection controlAndProtection(DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, FFRTableName = FFRTableName, FFRflag = FFRflag, HVRTinQFlag = HVRTinQFlag, IMaxPu = IMaxPu, IPMax0Pu = IPMax0Pu, IPMaxPu = IPMaxPu, IPMin0Pu = IPMin0Pu, IPMinPu = IPMinPu, IQMax0Pu = IQMax0Pu, IQMaxPu = IQMaxPu, IQMin0Pu = IQMin0Pu, IQMinPu = IQMinPu, InertialTableName = InertialTableName, K1IpHV = K1IpHV, K1IpLV = K1IpLV, K1IqHV = K1IqHV, K1IqLV = K1IqLV, K2IpHV = K2IpHV, K2IpLV = K2IpLV, K2IqHV = K2IqHV, K2IqLV = K2IqLV, KDroop = KDroop, KIp = KIp, KIqi = KIqi, KIqu = KIqu, KIui = KIui, KIuq = KIuq, KPp = KPp, KPqi = KPqi, KPqu = KPqu, KPui = KPui, KPuq = KPuq, KpHVRT = KpHVRT, KpLVRT = KpLVRT, KqHVRT = KqHVRT, KqLVRT = KqLVRT, LFlag = LFlag, LVRTinQFlag = LVRTinQFlag, P0Pu = P0Pu, PAvailIn0Pu = PAvailIn0Pu, PFFlag = PFFlag, PFlag = PFlag, PMaxPu = PMaxPu, PffrMaxPu = PffrMaxPu, PffrMinPu = PffrMinPu, PriorityFlag = PriorityFlag, Q0Pu = Q0Pu, QLimFlag = QLimFlag, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMaxtoPTableName = QMaxtoPTableName, QMaxtoUTableName = QMaxtoUTableName, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QMintoPTableName = QMintoPTableName, QMintoUTableName = QMintoUTableName, SNom = SNom, TableFileName = TableFileName, TanPhi = TanPhi, Tiq = Tiq, TpRef = TpRef, Trocof = Trocof, U0Pu = U0Pu, UFlag = UFlag, UMaxPu = UMaxPu, UMinPu = UMinPu, UPhase0 = UPhase0, f0Pu = f0Pu, fThresholdPu = fThresholdPu, iPSetHVPu = iPSetHVPu, iPSetLVPu = iPSetLVPu, iQSetHVPu = iQSetHVPu, iQSetLVPu = iQSetLVPu, pSetHVPu = pSetHVPu, pSetLVPu = pSetLVPu, pqFRTFlag = pqFRTFlag, qSetHVPu = qSetHVPu, qSetLVPu = qSetLVPu, uHVRTPu = uHVRTPu, uLVRTPu = uLVRTPu, DerThetaMax = DerThetaMax, DerfMaxPu = DerfMaxPu, TDerThetaMax = TDerThetaMax, TDerfMax = TDerfMax, THVP1 = THVP1, THVP2 = THVP2, THVP3 = THVP3, THfP1 = THfP1, THfP2 = THfP2, THfP3 = THfP3, TLVP1 = TLVP1, TLVP2 = TLVP2, TLVP3 = TLVP3, TLfP1 = TLfP1, TLfP2 = TLfP2, TLfP3 = TLfP3, UHVP1 = UHVP1, UHVP2 = UHVP2, UHVP3 = UHVP3, ULVP1 = ULVP1, ULVP2 = ULVP2, ULVP3 = ULVP3, fHfP1 = fHfP1, fHfP2 = fHfP2, fHfP3 = fHfP3, fLfP1 = fLfP1, fLfP2 = fLfP2, fLfP3 = fLfP3) annotation(
    Placement(visible = true, transformation(origin = {-6.21725e-15, -80}, extent = {{-52, -52}, {52, 52}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.PrimaryEnergy.EnergyConversion energyConversion(P0Pu = P0Pu, PAvailIn0Pu = PAvailIn0Pu, PMaxPu = PMaxPu, SNom = SNom, SOCFlag = SOCFlag, SOCInit = SOCInit, SOCMax = SOCMax, SOCMin = SOCMin, StorageFlag = StorageFlag, Tconv = Tconv, Tess = Tess) annotation(
    Placement(visible = true, transformation(origin = {-70, 150}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.PlantCommunication plantCommunication(ComFlag = ComFlag, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, Tcom = Tcom, Tlag = Tlag, Tlead = Tlead, U0Pu = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-180, -140}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));
  Dynawo.Electrical.Sources.IEC.InjectorVoltageSource injectorVoltageSource(IsIm0Pu = IsIm0Pu, IsRe0Pu = IsRe0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, ResPu = ResPu, SNom = SNom, Te = Te, Tg = Tg, U0Pu = U0Pu, UPhase0 = UPhase0, UeIm0Pu = UeIm0Pu, UeRe0Pu = UeRe0Pu, Ued0Pu = Ued0Pu, Ueq0Pu = Ueq0Pu, XesPu = XesPu, i0Pu = i0Pu, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {160, -80}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.ComplexCurrentPu i0Pu "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.PerUnit IsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.PerUnit IsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.PerUnit PAvailIn0Pu "Initial minimum output electrical power available to the active power control module in pu (base SNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.Angle UPhase0 "Initial Phase angle outputted by phase-locked loop" annotation(
    Dialog(group = "Operating point"));
  parameter Types.PerUnit IPMin0Pu "Initial minimum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit IPMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit IQMax0Pu "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit IQMin0Pu "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit QMax0Pu "Initial maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit QMin0Pu "Initial minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit Ued0Pu "Initial direct component of the voltage at converter terminal in pu (base UNom)";
  parameter Types.PerUnit Ueq0Pu "Initial direct component of the voltage at converter terminal in pu (base UNom)";
  parameter Types.PerUnit UeIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)";
  parameter Types.PerUnit UeRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)";

equation
  connect(pCmdPu, plantCommunication.pCmdPu) annotation(
    Line(points = {{-250, -120}, {-224, -120}}, color = {0, 0, 127}));
  connect(qCmdPu, plantCommunication.qCmdPu) annotation(
    Line(points = {{-250, -140}, {-224, -140}}, color = {0, 0, 127}));
  connect(uCmdPu, plantCommunication.uCmdPu) annotation(
    Line(points = {{-250, -160}, {-224, -160}}, color = {0, 0, 127}));
  connect(pPrimPu, energyConversion.pPrimPu) annotation(
    Line(points = {{-260, 160}, {-106, 160}}, color = {0, 0, 127}));
  connect(gridMeasurement.PFiltPu, controlAndProtection.pMeasPu) annotation(
    Line(points = {{95, 110}, {-80, 110}, {-80, -57}, {-43, -57}}, color = {0, 0, 127}));
  connect(gridMeasurement.QFiltPu, controlAndProtection.qMeasPu) annotation(
    Line(points = {{95, 100}, {-120, 100}, {-120, -80}, {-43, -80}}, color = {0, 0, 127}));
  connect(gridMeasurement.UFiltPu, controlAndProtection.uMeasPu) annotation(
    Line(points = {{95, 60}, {-100, 60}, {-100, -68}, {-43, -68}}, color = {0, 0, 127}));
  connect(gridMeasurement.fFiltPu, controlAndProtection.fMeasPu) annotation(
    Line(points = {{95, 40}, {-60, 40}, {-60, -45}, {-43, -45}}, color = {0, 0, 127}));
  connect(gridMeasurement.thetaPLL, controlAndProtection.thetaPLL) annotation(
    Line(points = {{95, 30}, {-20, 30}, {-20, -22}}, color = {0, 0, 127}));
  connect(plantCommunication.pRefPu, controlAndProtection.pRefPu) annotation(
    Line(points = {{-136, -120}, {-100, -120}, {-100, -92}, {-43, -92}}, color = {0, 0, 127}));
  connect(plantCommunication.qRefPu, controlAndProtection.qRefPu) annotation(
    Line(points = {{-136, -140}, {-80, -140}, {-80, -103}, {-43, -103}}, color = {0, 0, 127}));
  connect(gridMeasurement.PFiltPu, energyConversion.pMeasPu) annotation(
    Line(points = {{95, 110}, {-120, 110}, {-120, 140}, {-106, 140}}, color = {0, 0, 127}));
  connect(energyConversion.pAvailOutPu, controlAndProtection.pAvailOutPu) annotation(
    Line(points = {{-36, 140}, {19, 140}, {19, -22}}, color = {0, 0, 127}));
  connect(energyConversion.pAvailInPu, controlAndProtection.pAvailInPu) annotation(
    Line(points = {{-36, 160}, {0, 160}, {0, -22}}, color = {0, 0, 127}));
  connect(plantCommunication.uRefPu, controlAndProtection.uRefPu) annotation(
    Line(points = {{-136, -160}, {-60, -160}, {-60, -115}, {-43, -115}}, color = {0, 0, 127}));
  connect(controlAndProtection.ipRefPu, injectorVoltageSource.ipRefPu) annotation(
    Line(points = {{43, -68}, {80, -68}, {80, -60}, {112, -60}}, color = {0, 0, 127}));
  connect(controlAndProtection.iqRefPu, injectorVoltageSource.iqRefPu) annotation(
    Line(points = {{43, -92}, {80, -92}, {80, -100}, {112, -100}}, color = {0, 0, 127}));
  connect(gridMeasurement.thetaPLL, injectorVoltageSource.thetaPLL) annotation(
    Line(points = {{96, 30}, {80, 30}, {80, 0}, {160, 0}, {160, -32}}, color = {0, 0, 127}));
  connect(injectorVoltageSource.terminal, terminal) annotation(
    Line(points = {{204, -80}, {260, -80}}, color = {0, 0, 255}));
  connect(injectorVoltageSource.iPu, gridMeasurement.iPu) annotation(
    Line(points = {{204, -48}, {220, -48}, {220, 70}, {206, 70}}, color = {85, 170, 255}));
  connect(injectorVoltageSource.uPu, gridMeasurement.uPu) annotation(
    Line(points = {{204, -60}, {230, -60}, {230, 100}, {206, 100}}, color = {85, 170, 255}));
  annotation(
    Icon(graphics = {Rectangle(extent = {{-240, 240}, {240, -240}}), Text(extent = {{-240, 240}, {240, -240}}, textString = "Converter
Based
Generating
Unit")}, coordinateSystem(extent = {{-240, -240}, {240, 240}})),
    Diagram(coordinateSystem(extent = {{-240, -240}, {240, 240}})));
end ConverterVoltageSourceIEC63406;
