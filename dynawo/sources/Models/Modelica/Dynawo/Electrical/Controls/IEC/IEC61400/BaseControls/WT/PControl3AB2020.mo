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
  extends Dynawo.Electrical.Wind.IEC.Parameters.PControlWT3;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialPGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialGenSystemP;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialIGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.XEqv_;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGrid;
  
  // inputs
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMax0Pu) "Maximum active current (base SNom/sqrt(3)/UNom) in pu" annotation(
    Placement(visible = true, transformation(origin = {-320, 180}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-320, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaGenPu(start = SystemBase.omega0Pu) "Angular velocity of generator in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-320, 110}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaWTRPu(start = SystemBase.omega0Pu) "Angular velocity of Wind Turbine Rotor (WTR) in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-320, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWTCFiltPu(start = -P0Pu * SystemBase.SnRef / SNom) "Measured (=filtered) active power for Wind Turbine Control (WTC) in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-352, -166}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-320, -160}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWTRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Wind Turbine (WT) active power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-320, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-320, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UTCHookPu(start = 0) "Optional voltage input (TC = turbine control) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, -280}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-320, -270}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCFiltPu(start = U0Pu) "Filtered voltage for Wind Turbine Control (WTC) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, 260}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-320, 260}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCPu(start = U0Pu) "Unfiltered voltage for Wind Turbine Control (WTC) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, 220}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-320, 210}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  
  // outputs
  Modelica.Blocks.Interfaces.RealOutput ipCmdPu(start=lagPOrd.Y0/U0Pu) "Active current command for generator system model in pu (base SNom/sqrt(3)/UNom)" annotation(
    Placement(visible = true, transformation(origin = {310, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {310, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaRefPu(start=SystemBase.omegaRef0Pu) "Angular velocity reference value in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {310, -288}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {310, -240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput POrdPu(start=lagPOrd.Y0) "Active power order from wind turbine controller in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {316, -176}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {310, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
  Modelica.Blocks.Math.Add addDtd annotation(
    Placement(visible = true, transformation(origin = {237, -177}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addOmegaErr(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-76, -166}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.And andUPdipMPuscale annotation(
    Placement(visible = true, transformation(origin = {-192, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTableOmegaP(table = TableOmegaPPu) annotation(
    Placement(visible = true, transformation(origin = {-232, -166}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = OmegaOffsetPu) annotation(
    Placement(visible = true, transformation(origin = {-95, -193}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanConstant constFalse(k = false) annotation(
    Placement(visible = true, transformation(origin = {188, -144}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constInftyNeg(k = -9999) annotation(
    Placement(visible = true, transformation(origin = {155, -187}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant constMOmegaTMax(k = MOmegaTMax) annotation(
    Placement(visible = true, transformation(origin = {-138, 42}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant constMOmegaTqpi(k = MOmegaTqpi) annotation(
    Placement(visible = true, transformation(origin = {-222, 106}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant constMpUScale(k = MpUScale) annotation(
    Placement(visible = true, transformation(origin = {-228, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constOmegaOffset(k = OmegaOffsetPu) annotation(
    Placement(visible = true, transformation(origin = {-95, -193}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant constUPdip(k = UpDipPu) annotation(
    Placement(visible = true, transformation(origin = {-249, -13}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Modelica.Blocks.Math.Division divisionIPcmd annotation(
    Placement(visible = true, transformation(origin = {272, 242}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Division divisionTauEmax annotation(
    Placement(visible = true, transformation(origin = {-54, -74}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.NonLinear.FirstOrderVariableLimitsAntiWindup lagPOrd(DyMax = DPMaxPu, DyMin = -9999, Y0 = ((IGsRe0Pu + UGsIm0Pu / XEqv) * cos(UPhase0) + (IGsIm0Pu - UGsRe0Pu / XEqv) * sin(UPhase0)) * U0Pu, tI = tPord) annotation(
    Placement(visible = true, transformation(origin = {188, -172}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lagtOmegaFiltp3(T = tOmegafiltp3, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, -118}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.FirstOrder lagtOmegaRef(T = tOmegaRef, y_start = OmegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-174, -166}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less lessUpdip annotation(
    Placement(visible = true, transformation(origin = {-228, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limitDtd(limitsAtInit = true, uMax = PDtdMaxPu, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {142, -244}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limitLargerZero(limitsAtInit = true, uMax = 9999, uMin = 0.01, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {230, 248}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product productPmax annotation(
    Placement(visible = true, transformation(origin = {144, 214}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product productPord annotation(
    Placement(visible = true, transformation(origin = {126, -172}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product productPuScale annotation(
    Placement(visible = true, transformation(origin = {-216, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter ratelimPWtRef(Falling = DPRefMin4abPu, Rising = DPRefMax4abPu, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = PWTRef0Pu, y(start = PWTRef0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-252, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchMOmegaTMax annotation(
    Placement(visible = true, transformation(origin = {-106, 42}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchMOmegaTqpi annotation(
    Placement(visible = true, transformation(origin = {-180, 106}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchUDip annotation(
    Placement(visible = true, transformation(origin = {-154, -58}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction tfDtd(a = {1, 2 * Zeta * OmegaDtdPu, OmegaDtdPu * OmegaDtdPu}, b = {0, 2 * Zeta * OmegaDtdPu * KDtd, 0}, initType = Modelica.Blocks.Types.Init.SteadyState) annotation(
    Placement(visible = true, transformation(origin = {36, -244}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.TorquePi torquePi(DPMaxPu = DPMaxPu, DPRefMax4abPu = DPRefMax4abPu, DPRefMin4abPu = DPRefMin4abPu, DTauMaxPu = DTauMaxPu, DTauUvrtMaxPu = DTauUvrtMaxPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, KDtd = KDtd, KIp = KIp, KPp = KPp, MOmegaTMax = MOmegaTMax, MOmegaTqpi = MOmegaTqpi, MPUvrt = MPUvrt, MpUScale = MpUScale, OmegaDtdPu = OmegaDtdPu, OmegaOffsetPu = OmegaOffsetPu, P0Pu = P0Pu, PDtdMaxPu = PDtdMaxPu, PWTRef0Pu = PWTRef0Pu, SNom = SNom, TableOmegaPPu = TableOmegaPPu, TauEMinPu = TauEMinPu, TauUscalePu = TauUscalePu, U0Pu = U0Pu, UDvsPu = UDvsPu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, UpDipPu = UpDipPu, XEqv = XEqv, Zeta = Zeta, tDvs = tDvs, tOmegaRef = tOmegaRef, tOmegafiltp3 = tOmegafiltp3, tPord = tPord, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {47.2409, -173.192}, extent = {{-60.4935, -37.8084}, {31.7591, 30.2467}}, rotation = 0)));


equation
  connect(limitLargerZero.y, divisionIPcmd.u2) annotation(
    Line(points = {{241, 248}, {260, 248}}, color = {0, 0, 127}));
  connect(divisionIPcmd.y, ipCmdPu) annotation(
    Line(points = {{283, 242}, {301.5, 242}, {301.5, 240}, {310, 240}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, limitLargerZero.u) annotation(
    Line(points = {{-320, 260}, {110, 260}, {110, 248}, {218, 248}}, color = {0, 0, 127}));
  connect(UWTCPu, productPmax.u1) annotation(
    Line(points = {{-320, 220}, {132, 220}}, color = {0, 0, 127}));
  connect(ipMaxPu, productPmax.u2) annotation(
    Line(points = {{-320, 180}, {-292, 180}, {-292, 208}, {132, 208}}, color = {0, 0, 127}));
  connect(productPmax.y, lagPOrd.yMax) annotation(
    Line(points = {{155, 214}, {164, 214}, {164, -166}, {176, -166}}, color = {0, 0, 127}));
  connect(lagPOrd.yMin, constInftyNeg.y) annotation(
    Line(points = {{176, -178}, {164, -178}, {164, -187}, {160.5, -187}}, color = {0, 0, 127}));
  connect(POrdPu, addDtd.y) annotation(
    Line(points = {{316, -176}, {281, -176}, {281, -177}, {247, -177}}, color = {0, 0, 127}));
  connect(lagPOrd.y, addDtd.u1) annotation(
    Line(points = {{199, -172}, {226, -172}}, color = {0, 0, 127}));
  connect(addDtd.y, divisionIPcmd.u1) annotation(
    Line(points = {{247, -177}, {252, -177}, {252, 236}, {260, 236}}, color = {0, 0, 127}));
  connect(productPord.y, lagPOrd.u) annotation(
    Line(points = {{137, -172}, {176, -172}}, color = {0, 0, 127}));
  connect(productPord.u1, omegaGenPu) annotation(
    Line(points = {{114, -166}, {88, -166}, {88, 140}, {-320, 140}}, color = {0, 0, 127}));
  connect(torquePi.tauOutPu, productPord.u2) annotation(
    Line(points = {{78, -178}, {114, -178}}, color = {0, 0, 127}));
  connect(tfDtd.y, limitDtd.u) annotation(
    Line(points = {{47, -244}, {130, -244}}, color = {0, 0, 127}));
  connect(limitDtd.y, addDtd.u2) annotation(
    Line(points = {{153, -244}, {200, -244}, {200, -182}, {226, -182}}, color = {0, 0, 127}));
  connect(addOmegaErr.y, torquePi.omegaErrPu) annotation(
    Line(points = {{-65, -166}, {-91.5, -166}, {-91.5, -165}, {-22, -165}}, color = {0, 0, 127}));
  connect(constOmegaOffset.y, addOmegaErr.u3) annotation(
    Line(points = {{-95, -185.3}, {-96, -185.3}, {-96, -174.3}, {-88, -174.3}}, color = {0, 0, 127}));
  connect(lagtOmegaRef.y, addOmegaErr.u2) annotation(
    Line(points = {{-163, -166}, {-88, -166}}, color = {0, 0, 127}));
  connect(constMOmegaTMax.y, switchMOmegaTMax.u2) annotation(
    Line(points = {{-131, 42}, {-118, 42}}, color = {255, 0, 255}));
  connect(constMOmegaTqpi.y, switchMOmegaTqpi.u2) annotation(
    Line(points = {{-215, 106}, {-192, 106}}, color = {255, 0, 255}));
  connect(switchMOmegaTqpi.y, lagtOmegaFiltp3.u) annotation(
    Line(points = {{-169, 106}, {-80, 106}, {-80, -106}}, color = {0, 0, 127}));
  connect(omegaWTRPu, switchMOmegaTMax.u3) annotation(
    Line(points = {{-320, 60}, {-118, 60}, {-118, 50}}, color = {0, 0, 127}));
  connect(lagtOmegaRef.y, switchMOmegaTMax.u1) annotation(
    Line(points = {{-163, -166}, {-118, -166}, {-118, 34}}, color = {0, 0, 127}));
  connect(addOmegaErr.u1, lagtOmegaFiltp3.y) annotation(
    Line(points = {{-88, -158}, {-96, -158}, {-96, -140}, {-80, -140}, {-80, -128}}, color = {0, 0, 127}));
  connect(switchMOmegaTMax.y, divisionTauEmax.u2) annotation(
    Line(points = {{-95, 42}, {-48, 42}, {-48, -62}}, color = {0, 0, 127}));
  connect(divisionTauEmax.y, torquePi.tauEMaxPu) annotation(
    Line(points = {{-54, -85}, {-54, -152}, {-22, -152}}, color = {0, 0, 127}));
  connect(switchUDip.y, divisionTauEmax.u1) annotation(
    Line(points = {{-143, -58}, {-60, -58}, {-60, -62}}, color = {0, 0, 127}));
  connect(lessUpdip.u2, constUPdip.y) annotation(
    Line(points = {{-240, -2}, {-249, -2}, {-249, -5}}, color = {0, 0, 127}));
  connect(constMpUScale.y, andUPdipMPuscale.u1) annotation(
    Line(points = {{-221, 40}, {-212.4, 40}, {-212.4, 14}, {-204, 14}}, color = {255, 0, 255}));
  connect(lessUpdip.y, andUPdipMPuscale.u2) annotation(
    Line(points = {{-217, 6}, {-204, 6}}, color = {255, 0, 255}));
  connect(PWTRefPu, ratelimPWtRef.u) annotation(
    Line(points = {{-320, -50}, {-264, -50}}, color = {0, 0, 127}));
  connect(ratelimPWtRef.y, switchUDip.u3) annotation(
    Line(points = {{-241, -50}, {-166, -50}}, color = {0, 0, 127}));
  connect(lessUpdip.u1, UWTCPu) annotation(
    Line(points = {{-240, 6}, {-276, 6}, {-276, 220}, {-320, 220}}, color = {0, 0, 127}));
  connect(UWTCPu, productPuScale.u2) annotation(
    Line(points = {{-320, 220}, {-276, 220}, {-276, -106}, {-228, -106}}, color = {0, 0, 127}));
  connect(productPuScale.y, switchUDip.u1) annotation(
    Line(points = {{-204, -100}, {-200, -100}, {-200, -66}, {-166, -66}}, color = {0, 0, 127}));
  connect(combiTableOmegaP.y[1], lagtOmegaRef.u) annotation(
    Line(points = {{-220, -166}, {-186, -166}}, color = {0, 0, 127}));
  connect(torquePi.uTcHookPu, UTCHookPu) annotation(
    Line(points = {{-22, -205}, {-40, -205}, {-40, -280}, {-320, -280}}, color = {0, 0, 127}));
  connect(torquePi.uWtcPu, UWTCPu) annotation(
    Line(points = {{-22, -190}, {-48, -190}, {-48, -234}, {-276, -234}, {-276, 220}, {-320, 220}}, color = {0, 0, 127}));
  connect(switchMOmegaTqpi.u3, omegaGenPu) annotation(
    Line(points = {{-192, 114}, {-204, 114}, {-204, 140}, {-320, 140}}, color = {0, 0, 127}));
  connect(omegaWTRPu, switchMOmegaTqpi.u1) annotation(
    Line(points = {{-320, 60}, {-206, 60}, {-206, 98}, {-192, 98}}, color = {0, 0, 127}));
  connect(switchUDip.u2, andUPdipMPuscale.y) annotation(
    Line(points = {{-166, -58}, {-174, -58}, {-174, 14}, {-180, 14}}, color = {255, 0, 255}));
  connect(productPuScale.u1, ratelimPWtRef.y) annotation(
    Line(points = {{-228, -94}, {-236, -94}, {-236, -50}, {-240, -50}}, color = {0, 0, 127}));
  connect(constFalse.y, lagPOrd.freeze) annotation(
    Line(points = {{188, -151}, {188, -160}}, color = {255, 0, 255}));
  connect(lagtOmegaRef.y, omegaRefPu) annotation(
    Line(points = {{-163, -166}, {-120, -166}, {-120, -288}, {310, -288}}, color = {0, 0, 127}));
  connect(PWTCFiltPu, combiTableOmegaP.u[1]) annotation(
    Line(points = {{-352, -166}, {-244, -166}}, color = {0, 0, 127}));
  connect(omegaWTRPu, tfDtd.u) annotation(
    Line(points = {{-320, 60}, {-284, 60}, {-284, -244}, {24, -244}}, color = {0, 0, 127}));
  
annotation(
  preferredView = "diagram",
  Diagram(coordinateSystem(extent = {{-300, -300}, {300, 300}})),
  Icon(coordinateSystem(extent = {{-300, -300}, {300, 300}}), graphics = {Rectangle(extent = {{-298, 298}, {298, -298}}), Text(origin = {-11, 0}, extent = {{-243, 206}, {243, -206}}, textString = "IEC WT 3 AB 2020 P Control")}));
end PControl3AB2020;
