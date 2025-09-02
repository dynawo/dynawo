within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

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

model PControl3AB2020 "Active power control module of type 3 wind turbine model from IEC 61400-27-1:2020 standard"

  parameter Boolean WT3Type "if true : type a, if false type b";

  //PControl parameters
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.PControlWT3Parameters;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical.TorquePiParameters;

  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";
  parameter Types.PerUnit XEqv "Transient reactance (should be calculated from the transient inductance as defined in 'New Generic Model of DFG-Based Wind Turbines for RMS-Type Simulation', Fortmann et al., 2014 (base UNom, SNom), example value = 0.4 (Type 3A) or = 10 (Type 3B)" annotation(
    Dialog(tab = "genSystem"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMax0Pu) "Maximum active current (base SNom/sqrt(3)/UNom) in pu" annotation(
    Placement(visible = true, transformation(origin = {-320, 180}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-320, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaGenPu(start = SystemBase.omega0Pu) "Angular velocity of generator in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-320, 110}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaWTRPu(start = SystemBase.omega0Pu) "Angular velocity of Wind Turbine Rotor (WTR) in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-320, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWTCFiltPu(start = -P0Pu*SystemBase.SnRef/SNom) "Measured (=filtered) active power for Wind Turbine Control (WTC) in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-320, -160}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-320, -160}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput PWTRefPu(start = -P0Pu*SystemBase.SnRef/SNom) "Wind Turbine (WT) active power reference in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-320, -60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-320, -60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput UTCHookPu(start = 0) "Optional voltage input (TC = turbine control) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, -280}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-320, -270}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCFiltPu(start = U0Pu) "Filtered voltage for Wind Turbine Control (WTC) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, 260}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-320, 260}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCPu(start = U0Pu) "Unfiltered voltage for Wind Turbine Control (WTC) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, 220}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-320, 210}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput ipCmdPu(start = POrd0Pu/U0Pu) "Active current command for generator system model in pu (base SNom/sqrt(3)/UNom)" annotation(
    Placement(visible = true, transformation(origin = {310, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {310, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaRefPu(start = OmegaRef0Pu) "Angular velocity reference value in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {310, -288}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {310, -240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput POrdPu(start = POrd0Pu) "Active power order from wind turbine controller in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {310, -180}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {310, 0}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Add addDtd annotation(
    Placement(transformation(origin = {230, -180}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add3 addOmegaErr(k2 = -1) annotation(
    Placement(transformation(origin = {-70, -160}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.And andUPdipMPuscale annotation(
    Placement(transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable1D combiTableOmegaP(table = TableOmegaPPu) annotation(
    Placement(transformation(origin = {-230, -160}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant constFalse(k = false) annotation(
    Placement(transformation(origin = {190, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constInftyNeg(k = -9999) annotation(
    Placement(transformation(origin = {150, -212}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant constMOmegaTMax(k = MOmegaTMax) annotation(
    Placement(transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant constMOmegaTqpi(k = MOmegaTqpi) annotation(
    Placement(transformation(origin = {-230, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant constMpUScale(k = MpUScale) annotation(
    Placement(transformation(origin = {-230, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constOmegaOffset(k = OmegaOffsetPu) annotation(
    Placement(transformation(origin = {-100, -190}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant constUPdip(k = UpDipPu) annotation(
    Placement(transformation(origin = {-250, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Division divisionIPcmd annotation(
    Placement(transformation(origin = {270, 240}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Math.Division divisionTauEmax annotation(
    Placement(transformation(origin = {-50, -90}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.NonLinear.FirstOrderVariableLimitsAntiWindup lagPOrd(DyMax = DPMaxPu, DyMin = -9999, Y0 = POrd0Pu, tI = tPord) annotation(
    Placement(transformation(origin = {190, -170}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder lagtOmegaFiltp3(T = tOmegafiltp3, y_start = SystemBase.omega0Pu) annotation(
    Placement(transformation(origin = {-90, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.FirstOrder lagtOmegaRef(T = tOmegaRef, y_start = OmegaRef0Pu) annotation(
    Placement(transformation(origin = {-170, -160}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Less lessUpdip annotation(
    Placement(transformation(origin = {-230, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limitDtd(limitsAtInit = true, uMax = PDtdMaxPu, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {150, -260}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limitLargerZero(limitsAtInit = true, uMax = 9999, uMin = 0.01, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {190, 260}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product productPmax annotation(
    Placement(transformation(origin = {130, 220}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product productPord annotation(
    Placement(transformation(origin = {130, -170}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product productPuScale annotation(
    Placement(transformation(origin = {-210, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.SlewRateLimiter ratelimPWtRef(Falling = DPRefMin4abPu, Rising = DPRefMax4abPu, y_start = PWTRef0Pu, y(start = PWTRef0Pu)) annotation(
    Placement(transformation(origin = {-250, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switchMOmegaTMax annotation(
    Placement(transformation(origin = {-110, 40}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Logical.Switch switchMOmegaTqpi annotation(
    Placement(transformation(origin = {-170, 100}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Logical.Switch switchUDip annotation(
    Placement(transformation(origin = {-150, -60}, extent = {{-10, 10}, {10, -10}})));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction tfDtd(a = {1, 2*Zeta*OmegaDtdPu, OmegaDtdPu*OmegaDtdPu}, b = {0, 2*Zeta*OmegaDtdPu*KDtd, 0}, x_start = {0, 0.007831467}) annotation(
    Placement(transformation(origin = {50, -260}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.TorquePi torquePi(DTauMaxPu = DTauMaxPu, DTauUvrtMaxPu = DTauUvrtMaxPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, KIp = KIp, KPp = KPp, MOmegaTMax = MOmegaTMax, MPUvrt = MPUvrt, P0Pu = P0Pu, PWTRef0Pu = PWTRef0Pu, SNom = SNom, TableOmegaPPu = TableOmegaPPu, TauEMinPu = TauEMinPu, TauUscalePu = TauUscalePu, U0Pu = U0Pu, UDvsPu = UDvsPu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, UpDipPu = UpDipPu, XEqv = XEqv, tDvs = tDvs, tOmegafiltp3 = tOmegafiltp3, tS = tS, WT3Type = WT3Type, OmegaRef0Pu = OmegaRef0Pu) annotation(
    Placement(transformation(origin = {39.2409, -169.192}, extent = {{-60.4935, -37.8084}, {31.7591, 30.2467}})));

  // Initial parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePower PWTRef0Pu "Initial upper power limit of the wind turbine (if less than PAvail then the turbine will be derated) in pu (base SNom), example value = 1.1" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit IGsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.PerUnit IGsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.PerUnit IpMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.PerUnit UGsIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.PerUnit UGsRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.ActivePowerPu POrd0Pu "Initial active power order in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.PerUnit OmegaRef0Pu "Initial value for omegaRef (output of omega(p) characteristic) in pu (base SystemBase.omegaRef0Pu)" annotation(
    Dialog(tab = "Initialization"));

//protected
//  parameter Types.PerUnit x_scaled_2 = 1/(OmegaDtdPu*OmegaDtdPu) "Transfer function state variable at initialization";

equation
  connect(limitLargerZero.y, divisionIPcmd.u2) annotation(
    Line(points = {{201, 260}, {240.5, 260}, {240.5, 246}, {258, 246}}, color = {0, 0, 127}));
  connect(divisionIPcmd.y, ipCmdPu) annotation(
    Line(points = {{281, 240}, {310, 240}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, limitLargerZero.u) annotation(
    Line(points = {{-320, 260}, {178, 260}}, color = {0, 0, 127}));
  connect(UWTCPu, productPmax.u1) annotation(
    Line(points = {{-320, 220}, {-276, 220}, {-276, 226}, {118, 226}}, color = {0, 0, 127}));
  connect(ipMaxPu, productPmax.u2) annotation(
    Line(points = {{-320, 180}, {100, 180}, {100, 214}, {118, 214}}, color = {0, 0, 127}));
  connect(productPmax.y, lagPOrd.yMax) annotation(
    Line(points = {{141, 220}, {160, 220}, {160, -164}, {178, -164}}, color = {0, 0, 127}));
  connect(lagPOrd.yMin, constInftyNeg.y) annotation(
    Line(points = {{178, -176}, {164, -176}, {164, -212}, {161, -212}}, color = {0, 0, 127}));
  connect(POrdPu, addDtd.y) annotation(
    Line(points = {{310, -180}, {241, -180}}, color = {0, 0, 127}));
  connect(lagPOrd.y, addDtd.u1) annotation(
    Line(points = {{201, -170}, {209.5, -170}, {209.5, -174}, {218, -174}}, color = {0, 0, 127}));
  connect(addDtd.y, divisionIPcmd.u1) annotation(
    Line(points = {{241, -180}, {252, -180}, {252, 234}, {258, 234}}, color = {0, 0, 127}));
  connect(productPord.y, lagPOrd.u) annotation(
    Line(points = {{141, -170}, {178, -170}}, color = {0, 0, 127}));
  connect(productPord.u1, omegaGenPu) annotation(
    Line(points = {{118, -164}, {88, -164}, {88, 140}, {-320, 140}}, color = {0, 0, 127}));
  connect(torquePi.tauOutPu, productPord.u2) annotation(
    Line(points = {{75, -173}, {96, -173}, {96, -176}, {118, -176}}, color = {0, 0, 127}));
  connect(tfDtd.y, limitDtd.u) annotation(
    Line(points = {{61, -260}, {138, -260}}, color = {0, 0, 127}));
  connect(limitDtd.y, addDtd.u2) annotation(
    Line(points = {{161, -260}, {208, -260}, {208, -186}, {218, -186}}, color = {0, 0, 127}));
  connect(constOmegaOffset.y, addOmegaErr.u3) annotation(
    Line(points = {{-100, -179}, {-100, -168}, {-82, -168}}, color = {0, 0, 127}));
  connect(lagtOmegaRef.y, addOmegaErr.u2) annotation(
    Line(points = {{-159, -160}, {-82, -160}}, color = {0, 0, 127}));
  connect(constMOmegaTMax.y, switchMOmegaTMax.u2) annotation(
    Line(points = {{-139, 40}, {-122, 40}}, color = {255, 0, 255}));
  connect(constMOmegaTqpi.y, switchMOmegaTqpi.u2) annotation(
    Line(points = {{-219, 100}, {-182, 100}}, color = {255, 0, 255}));
  connect(switchMOmegaTqpi.y, lagtOmegaFiltp3.u) annotation(
    Line(points = {{-159, 100}, {-90, 100}, {-90, -98}}, color = {0, 0, 127}));
  connect(omegaWTRPu, switchMOmegaTMax.u3) annotation(
    Line(points = {{-320, 60}, {-128, 60}, {-128, 48}, {-122, 48}, {-122, 48}}, color = {0, 0, 127}));
  connect(lagtOmegaRef.y, switchMOmegaTMax.u1) annotation(
    Line(points = {{-159, -160}, {-130, -160}, {-130, 31}, {-122, 31}, {-122, 32}}, color = {0, 0, 127}));
  connect(addOmegaErr.u1, lagtOmegaFiltp3.y) annotation(
    Line(points = {{-82, -152}, {-82, -151.125}, {-84, -151.125}, {-84, -152.5}, {-90, -152.5}, {-90, -121}}, color = {0, 0, 127}));
  connect(switchMOmegaTMax.y, divisionTauEmax.u2) annotation(
    Line(points = {{-99, 40}, {-44, 40}, {-44, -78}}, color = {0, 0, 127}));
  connect(divisionTauEmax.y, torquePi.tauEMaxPu) annotation(
    Line(points = {{-50, -101}, {-50, -147}, {-25, -147}}, color = {0, 0, 127}));
  connect(switchUDip.y, divisionTauEmax.u1) annotation(
    Line(points = {{-139, -60}, {-56, -60}, {-56, -78}}, color = {0, 0, 127}));
  connect(lessUpdip.u2, constUPdip.y) annotation(
    Line(points = {{-242, -8}, {-250, -8}, {-250, -13}}, color = {0, 0, 127}));
  connect(constMpUScale.y, andUPdipMPuscale.u1) annotation(
    Line(points = {{-219, 40}, {-212.4, 40}, {-212.4, 20}, {-202, 20}}, color = {255, 0, 255}));
  connect(lessUpdip.y, andUPdipMPuscale.u2) annotation(
    Line(points = {{-219, 0}, {-209.5, 0}, {-209.5, 12}, {-202, 12}}, color = {255, 0, 255}));
  connect(PWTRefPu, ratelimPWtRef.u) annotation(
    Line(points = {{-320, -60}, {-262, -60}}, color = {0, 0, 127}));
  connect(ratelimPWtRef.y, switchUDip.u3) annotation(
    Line(points = {{-239, -60}, {-200.5, -60}, {-200.5, -52}, {-162, -52}}, color = {0, 0, 127}));
  connect(lessUpdip.u1, UWTCPu) annotation(
    Line(points = {{-242, 0}, {-276, 0}, {-276, 220}, {-320, 220}}, color = {0, 0, 127}));
  connect(UWTCPu, productPuScale.u2) annotation(
    Line(points = {{-320, 220}, {-276, 220}, {-276, -106}, {-222, -106}}, color = {0, 0, 127}));
  connect(productPuScale.y, switchUDip.u1) annotation(
    Line(points = {{-199, -100}, {-180, -100}, {-180, -68}, {-162, -68}}, color = {0, 0, 127}));
  connect(combiTableOmegaP.y[1], lagtOmegaRef.u) annotation(
    Line(points = {{-219, -160}, {-182, -160}}, color = {0, 0, 127}));
  connect(torquePi.uTcHookPu, UTCHookPu) annotation(
    Line(points = {{-25, -199}, {-40, -199}, {-40, -280}, {-320, -280}}, color = {0, 0, 127}));
  connect(torquePi.uWtcPu, UWTCPu) annotation(
    Line(points = {{-25, -184}, {-50, -184}, {-50, -220}, {-276, -220}, {-276, 220}, {-320, 220}}, color = {0, 0, 127}));
  connect(switchMOmegaTqpi.u3, omegaGenPu) annotation(
    Line(points = {{-182, 108}, {-200, 108}, {-200, 140}, {-320, 140}}, color = {0, 0, 127}));
  connect(omegaWTRPu, switchMOmegaTqpi.u1) annotation(
    Line(points = {{-320, 60}, {-200, 60}, {-200, 92}, {-182, 92}}, color = {0, 0, 127}));
  connect(switchUDip.u2, andUPdipMPuscale.y) annotation(
    Line(points = {{-162, -60}, {-174, -60}, {-174, 20}, {-179, 20}}, color = {255, 0, 255}));
  connect(productPuScale.u1, ratelimPWtRef.y) annotation(
    Line(points = {{-222, -94}, {-232, -94}, {-232, -60}, {-239, -60}}, color = {0, 0, 127}));
  connect(constFalse.y, lagPOrd.freeze) annotation(
    Line(points = {{190, -121}, {190, -158}}, color = {255, 0, 255}));
  connect(lagtOmegaRef.y, omegaRefPu) annotation(
    Line(points = {{-159, -160}, {-120, -160}, {-120, -288}, {310, -288}}, color = {0, 0, 127}));
  connect(PWTCFiltPu, combiTableOmegaP.u[1]) annotation(
    Line(points = {{-320, -160}, {-242, -160}}, color = {0, 0, 127}));
  connect(omegaWTRPu, tfDtd.u) annotation(
    Line(points = {{-320, 60}, {-284, 60}, {-284, -260}, {38, -260}}, color = {0, 0, 127}));
  connect(addOmegaErr.y, torquePi.omegaErrPu) annotation(
    Line(points = {{-59, -160}, {-25, -160}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-300, -300}, {300, 300}})),
    Icon(coordinateSystem(extent = {{-300, -300}, {300, 300}}), graphics = {Rectangle(extent = {{-298, 298}, {298, -298}}), Text(origin = {-11, 0}, extent = {{-243, 206}, {243, -206}}, textString = "IEC WT 3 AB 2020 P Control")}));
end PControl3AB2020;
