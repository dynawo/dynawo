within Dynawo.Electrical.Sources;

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

model ConverterVoltageSourceIEC63406

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

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

  //Communication Interface Parameters
  parameter Types.Time Tcom "Time constant for communication delay between the plant-level controller and the generating unit-level controller" annotation(
    Dialog(tab = "PlantCommunication"));
  parameter Types.Time Tlead "Time constant for communication lead between the plant-level controller and the generating unit-level controller" annotation(
    Dialog(tab = "PlantCommunication"));
  parameter Types.Time Tlag "Time constant for communication lag between the plant-level controller and the generating unit-level controller" annotation(
    Dialog(tab = "PlantCommunication"));
  parameter Integer ComFlag "0 if the communication delay is relatively long and affects the control, 1 if accurate modeling of the communication delay is provided, 2 for linear communication and 3 for 1st order lag communication" annotation(
    Dialog(tab = "PlantCommunication"));

  //Storage parameters
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
  parameter Types.Time Tess "Equivalent time constant for the battery, supercapacitor,
  or flywheel energy storage systems" annotation(
    Dialog(tab = "Storage"));
  parameter Types.Time Tconv "Equivalent time for primary energy conversion" annotation(
    Dialog(tab = "Storage"));
  parameter Types.PerUnit PMaxPu "Maximum capacity of the CBGU" annotation(
    Dialog(tab = "General"));

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
  parameter Types.PerUnit Pi11 = -1 annotation(
    Dialog(tab = "FFR tables"));
  parameter Types.PerUnit Pi12 = -1 annotation(
    Dialog(tab = "FFR tables"));
  parameter Types.PerUnit Pi21 = 1 annotation(
    Dialog(tab = "FFR tables"));
  parameter Types.PerUnit Pi22 = 1 annotation(
    Dialog(tab = "FFR tables"));
  parameter Types.PerUnit Pf11 = -1 annotation(
    Dialog(tab = "FFR tables"));
  parameter Types.PerUnit Pf12 = -1 annotation(
    Dialog(tab = "FFR tables"));
  parameter Types.PerUnit Pf21 = 1 annotation(
    Dialog(tab = "FFR tables"));
  parameter Types.PerUnit Pf22 = 1 annotation(
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
  parameter Real TanPhi = Q0Pu / P0Pu "Power factor used in the power factor control" annotation(
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

  //Circuit parameters
  parameter Types.PerUnit ResPu "Serial resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit XesPu "Serial reactance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.Time Tg "Time constant to represent the control delay effect of the inner current control loop (larger than twice of the time step of 1/20 cycle [3]. Alternatively set it to zero to bypass this delay." annotation(
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
  parameter Types.Frequency fref "Rated frequency (50/60 Hz)" annotation(
    Dialog(tab = "PLL"));
  parameter Real KPpll "Proportional gain in PI controller" annotation(
    Dialog(tab = "PLL"));
  parameter Real KIpll "Integral gain in PI controller" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit UpllPu "Voltage below which the frequency of the voltage is filtered and the angle of the voltage is possibly frozen" annotation(
    Dialog(tab = "PLL"));
  parameter Types.AngularVelocity Wref = 2 * Modelica.Constants.pi * fref "Rated angular velocity" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit WMaxPu "Maximum PLL frequency deviation" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit WMinPu "Minimum PLL frequency deviation" annotation(
    Dialog(tab = "PLL"));
  parameter Types.AngularVelocityPu DfMaxPu = Wref "Maximum angle rotation ramp rate in rad/s" annotation(
    Dialog(tab = "PLL"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput pCmdPu(start = -P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-250, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-260, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qCmdPu(start = -Q0Pu) annotation(
    Placement(visible = true, transformation(origin = {-250, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-260, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uCmdPu(start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-250, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-260, -180}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pPrimPu(start = -P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-260, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-260, 180}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Interfaces
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {260, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.IEC.IEC63406.Measurement.GridMeasurement gridMeasurement(DeltaT = DeltaT, DfMaxPu = DfMaxPu, KIpll = KIpll, KPpll = KPpll, P0Pu = P0Pu, PLLFlag = PLLFlag, Q0Pu = Q0Pu, SNom = SNom, TfFilt = TfFilt, TpllFilt = TpllFilt, U0Pu = U0Pu, UPhase0 = UPhase0, UpllPu = UpllPu, WMaxPu = WMaxPu, WMinPu = WMinPu, fref = fref, i0Pu = i0Pu, tIFilt = TiFilt, tPFilt = TpFilt, tQFilt = TqFilt, tS = tS, tUFilt = TuFilt, thetaPLL(start = UPhase0), u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {150, 70}, extent = {{50, -50}, {-50, 50}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.ControlAndProtection controlAndProtection(DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, FFRflag = FFRflag, HVRTinQFlag = HVRTinQFlag, IMaxPu = IMaxPu, IPMax0Pu = IPMax0Pu, IPMaxPu = IPMaxPu, IPMin0Pu = IPMin0Pu, IPMinPu = IPMinPu, IQMax0Pu = IQMax0Pu, IQMaxPu = IQMaxPu, IQMin0Pu = IQMin0Pu, IQMinPu = IQMinPu, K1IpHV = K1IpHV, K1IpLV = K1IpLV, K1IqHV = K1IqHV, K1IqLV = K1IqLV, K2IpHV = K2IpHV, K2IpLV = K2IpLV, K2IqHV = K2IqHV, K2IqLV = K2IqLV, KDroop = KDroop, KIp = KIp, KIqi = KIqi, KIqu = KIqu, KIui = KIui, KIuq = KIuq, KPp = KPp, KPqi = KPqi, KPqu = KPqu, KPui = KPui, KPuq = KPuq, KpHVRT = KpHVRT, KpLVRT = KpLVRT, KqHVRT = KqHVRT, KqLVRT = KqLVRT, LFlag = LFlag, LVRTinQFlag = LVRTinQFlag, P0Pu = P0Pu, PAvailIn0Pu = PAvailIn0Pu, PFFlag = PFFlag, PFlag = PFlag, PMaxPu = PMaxPu, Pf11 = Pf11, Pf12 = Pf12, Pf21 = Pf21, Pf22 = Pf22, PffrMaxPu = PffrMaxPu, PffrMinPu = PffrMinPu, Pi11 = Pi11, Pi12 = Pi12, Pi21 = Pi21, Pi22 = Pi22, PriorityFlag = PriorityFlag, Q0Pu = Q0Pu, QLimFlag = QLimFlag, QMax0Pu = QMax0Pu, QMaxUd = QMaxUd, QMin0Pu = QMin0Pu, QMinUd = QMinUd, SNom = SNom, TanPhi = TanPhi, Tiq = Tiq, TpRef = TpRef, Trocof = Trocof, U0Pu = U0Pu, UFlag = UFlag, UMaxPu = UMaxPu, UMinPu = UMinPu, UPhase0 = UPhase0, f0Pu = f0Pu, fThresholdPu = fThresholdPu, iPSetHVPu = iPSetHVPu, iPSetLVPu = iPSetLVPu, iQSetHVPu = iQSetHVPu, iQSetLVPu = iQSetLVPu, pSetHVPu = pSetHVPu, pSetLVPu = pSetLVPu, pqFRTFlag = pqFRTFlag, qSetHVPu = qSetHVPu, qSetLVPu = qSetLVPu, uHVRTPu = uHVRTPu, uLVRTPu = uLVRTPu) annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, -80}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.PrimaryEnergy.EnergyConversion energyConversion(P0Pu = P0Pu, PMaxPu = PMaxPu, SNom = SNom, SOCFlag = SOCFlag, SOCInit = SOCInit, SOCMax = SOCMax, SOCMin = SOCMin, StorageFlag = StorageFlag, Tconv = Tconv, Tess = Tess) annotation(
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
  parameter Types.PerUnit PAvailIn0Pu "Initial minimum output electrical power available to the active power control module" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.Angle UPhase0 "Initial Phase angle outputted by phase-locked loop" annotation(
    Dialog(group = "Operating point"));
  parameter Types.PerUnit IPMin0Pu annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit IPMax0Pu annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit IQMax0Pu "Initial maximum reactive current" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit IQMin0Pu "Initial minimum reactive current" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit QMax0Pu "Initial maximum reactive power" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit QMin0Pu "Initial minimum reactive power" annotation(
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
    Line(points = {{95, 110}, {-80, 110}, {-80, -62}, {-44, -62}}, color = {0, 0, 127}));
  connect(gridMeasurement.QFiltPu, controlAndProtection.qMeasPu) annotation(
    Line(points = {{95, 100}, {-120, 100}, {-120, -80}, {-44, -80}}, color = {0, 0, 127}));
  connect(gridMeasurement.UFiltPu, controlAndProtection.uMeasPu) annotation(
    Line(points = {{95, 60}, {-100, 60}, {-100, -71}, {-44, -71}}, color = {0, 0, 127}));
  connect(gridMeasurement.fFiltPu, controlAndProtection.fMeasPu) annotation(
    Line(points = {{95, 40}, {-60, 40}, {-60, -53}, {-44, -53}}, color = {0, 0, 127}));
  connect(gridMeasurement.thetaPLL, controlAndProtection.thetaPLL) annotation(
    Line(points = {{95, 30}, {-20, 30}, {-20, -36}}, color = {0, 0, 127}));
  connect(plantCommunication.pRefPu, controlAndProtection.pRefPu) annotation(
    Line(points = {{-136, -120}, {-100, -120}, {-100, -89}, {-44, -89}}, color = {0, 0, 127}));
  connect(plantCommunication.qRefPu, controlAndProtection.qRefPu) annotation(
    Line(points = {{-136, -140}, {-80, -140}, {-80, -98}, {-44, -98}}, color = {0, 0, 127}));
  connect(gridMeasurement.PFiltPu, energyConversion.pMeasPu) annotation(
    Line(points = {{95, 110}, {-120, 110}, {-120, 140}, {-106, 140}}, color = {0, 0, 127}));
  connect(energyConversion.pAvailOutPu, controlAndProtection.pAvailOutPu) annotation(
    Line(points = {{-36, 140}, {20, 140}, {20, -36}}, color = {0, 0, 127}));
  connect(energyConversion.pAvailInPu, controlAndProtection.pAvailInPu) annotation(
    Line(points = {{-36, 160}, {0, 160}, {0, -36}}, color = {0, 0, 127}));
  connect(plantCommunication.uRefPu, controlAndProtection.uRefPu) annotation(
    Line(points = {{-136, -160}, {-60, -160}, {-60, -106}, {-44, -106}}, color = {0, 0, 127}));
  connect(controlAndProtection.ipRefPu, injectorVoltageSource.ipRefPu) annotation(
    Line(points = {{44, -72}, {80, -72}, {80, -60}, {112, -60}}, color = {0, 0, 127}));
  connect(controlAndProtection.iqRefPu, injectorVoltageSource.iqRefPu) annotation(
    Line(points = {{44, -88}, {80, -88}, {80, -100}, {112, -100}}, color = {0, 0, 127}));
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
