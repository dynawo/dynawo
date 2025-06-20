within Dynawo.Electrical.Controls.WECC.REEC;

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
  
model REECd "WECC Electrical Control type D"
  extends Dynawo.Electrical.Controls.WECC.REEC.BaseClasses.BaseREEC;
  
  //REECd Parameters
  parameter Types.PerUnit VDLIp11 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp12 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp21 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp22 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp31 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp32 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp41 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp42 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp51 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp52 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp61 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp62 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp71 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp72 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp81 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp82 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp91 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp92 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp101 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp102 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq11 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq12 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq21 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq22 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq31 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq32 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq41 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq42 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq51 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq52 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq61 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq62 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq71 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq72 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq81 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq82 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq91 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq92 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq101 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq102 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIpPoints[:, :] = [VDLIp11, VDLIp12; VDLIp21, VDLIp22; VDLIp31, VDLIp32; VDLIp41, VDLIp42; VDLIp51, VDLIp52; VDLIp61, VDLIp62; VDLIp71, VDLIp72; VDLIp81, VDLIp82; VDLIp91, VDLIp92; VDLIp101, VDLIp102] "Pair of points for voltage-dependent active current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIqPoints[:, :] = [VDLIq11, VDLIq12; VDLIq21, VDLIq22; VDLIq31, VDLIq32; VDLIq41, VDLIq42; VDLIq51, VDLIq52; VDLIq61, VDLIq62; VDLIq71, VDLIq72; VDLIq81, VDLIq82; VDLIq91, VDLIq92; VDLIq101, VDLIq102] "Pair of points for voltage-dependent reactive current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Boolean PFlag "Power reference flag: const. Pref (0) or consider generator speed (1)" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageModulePu VRef1Pu "User-defined reference/bias on the inner-loop voltage control in pu (base UNom) (typical: 0 pu)" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Real Kc "Reactive droop gain" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Boolean VCompFlag "Type of compensation = 1 - current compensation or 0 reactive droop" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.Time tR1 "Filter time constant" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit Ke "Scaling on the Ipmin: 0 < ke ≤ 1, set to 0 for generator and non-zero for a storage device" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit XcPu "Current compensation reactance" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit RcPu "Current compensation resistance" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at regulated bus in pu (base UNom)";
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current at regulated bus in pu (generator convention) (base SNom, UNom)";
   parameter Types.Time tHoldIpMax "Time delay for which the active current limit (ipMaxPu) is held after voltage dip in s" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.Time tHoldIq "Absolute value of tHoldIq defines seconds to hold current command after voltage dip ended. tHoldIq > 0 for constant, 0 for continuous commmand, tHoldIq < 0 to hold command after a dip (typical: -1 .. 1 s)" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit IqFrzPu "Constant reactive current command value in pu (base UNom, SNom) (typical: -0.1 .. 0.1 pu)" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit UBlkHPu "Voltage above which the converter will block"  annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit UBlkLPu "Voltage below which the converter will block"  annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.Time tBlkDelay "Time delay for unblocking after voltage recovers (UBlkL < UtFiltered < UBlkH)"  annotation(
    Dialog(tab = "Electrical Control"));

// Input Variables
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary input in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-268, -170}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput omegaGPu(start = SystemBase.omegaRef0Pu) "Generator frequency from drive train control in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-270, -101}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-51, -110}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = QInjPu) annotation(
    Placement(transformation(origin = {-182, -260}, extent = {{-10, -10}, {10, 10}})));
  Modelica.ComplexBlocks.Interfaces.ComplexInput iPu(re(start = i0Pu.re), im(start = i0Pu.im)) "Complex current at regulated bus in pu (generator convention) (base SnRef, UNom)" annotation(
    Placement(transformation(origin = {-270, -202}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at regulated bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-270, -228}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-69, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

//Output Variable 
  Modelica.Blocks.Interfaces.BooleanOutput Blk(start=false) annotation(
    Placement(transformation(origin = {284, 266}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 34}, extent = {{-10, -10}, {10, 10}})));
 
  Modelica.Blocks.Sources.RealExpression UFilteredPu5(y = UFilteredPu) annotation(
    Placement(transformation(origin = {213, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression IqMax(y = currentLimitsCalculationD.iqMaxPu) annotation(
    Placement(transformation(origin = {130, 130}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression IqMin(y = currentLimitsCalculationD.iqMinPu) annotation(
    Placement(transformation(origin = {132, 96}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanExpression FRTOn21(y = frtOn) annotation(
    Placement(transformation(origin = {281, 9}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanExpression FRTOn2(y = frtOn) annotation(
    Placement(transformation(origin = {59, -105}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant VRefConst1(k = VRef1Pu) annotation(
    Placement(transformation(origin = {-83, 96}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant PFlagConst(k = PFlag) annotation(
    Placement(transformation(origin = {-119, -65}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant VCompFlagConst(k = VCompFlag) annotation(
    Placement(transformation(origin = {-100, -220}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(transformation(origin = {-6, -220}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch4 annotation(
    Placement(transformation(origin = {-40, -66}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Math.Add add2(k2 = Kc) annotation(
    Placement(transformation(origin = {-80, -256}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(transformation(origin = {144, -112}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add4 annotation(
    Placement(transformation(origin = {-18, 74}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product product4 annotation(
    Placement(transformation(origin = {-166, -94}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds IpmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIpPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(transformation(origin = {307, 36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds IqmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIqPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(transformation(origin = {309, -36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tR1, k = 1, y_start = if VCompFlag == true then UInj0Pu else UInj0Pu + Kc*QInj0Pu) annotation(
    Placement(transformation(origin = {46, -220}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter1(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = Iqh1Pu, uMin = Iql1Pu) annotation(
    Placement(transformation(origin = {264, 220}, extent = {{-10, -10}, {10, 10}})));
  BaseControls.LineDropCompensation lineDropCompensation(RcPu = RcPu, XcPu = XcPu) annotation(
    Placement(transformation(origin = {-185, -215}, extent = {{-21, -21}, {21, 21}})));
  BaseControls.CurrentLimitsCalculationD currentLimitsCalculationD(IMaxPu = IMaxPu, PQFlag = PQFlag, Ke = Ke, tHoldIpMax = tHoldIpMax, tBlkDelay = tBlkDelay) annotation(
    Placement(transformation(origin = {392, 12}, extent = {{-10, -10}, {10, 10}})));
  BaseControls.IqCommandBlLogic iqCommandBlLogic(IqFrzPu = IqFrzPu, tHoldIq = tHoldIq, iqCmdBlPu(start = Iq0Pu), iqCmdPu(start = Iq0Pu)) annotation(
    Placement(transformation(origin = {378, 110}, extent = {{-10, -10}, {10, 10}})));
  BaseControls.IpCommandBlLogic ipCommandBlLogic(tHoldIp = tHoldIpMax, IpCmdBlPu(start = Id0Pu), IpCmdPu(start = Id0Pu)) annotation(
    Placement(transformation(origin = {378, -120}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.BaseControls.VoltageCheck voltageCheck1(UMaxPu = UBlkHPu, UMinPu = UBlkLPu) annotation(
    Placement(transformation(origin = {244, 267}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(uPu, lineDropCompensation.u2Pu) annotation(
    Line(points = {{-271, -227}, {-271, -228}, {-208, -228}}, color = {85, 170, 255}));
  connect(lineDropCompensation.U2Pu, add2.u1) annotation(
    Line(points = {{-161.9, -227.6}, {-113.9, -227.6}, {-113.9, -250}, {-92, -250}}, color = {0, 0, 127}));
  connect(realExpression.y, add2.u2) annotation(
    Line(points = {{-171, -260}, {-140.5, -260}, {-140.5, -262}, {-92, -262}}, color = {0, 0, 127}));
  connect(switch3.y, firstOrder2.u) annotation(
    Line(points = {{5, -220}, {34, -220}}, color = {0, 0, 127}));
  connect(lineDropCompensation.U1Pu, switch3.u1) annotation(
    Line(points = {{-162, -202}, {-18, -202}, {-18, -212}}, color = {0, 0, 127}));
  connect(add2.y, switch3.u3) annotation(
    Line(points = {{-69, -256}, {-69, -228}, {-18, -228}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, product4.u1) annotation(
    Line(points = {{-218, -40}, {-218, -42}, {-178, -42}, {-178, -88}}, color = {0, 0, 127}));
  connect(product4.y, switch4.u1) annotation(
    Line(points = {{-155, -94}, {-66.5, -94}, {-66.5, -74}, {-52, -74}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, switch4.u3) annotation(
    Line(points = {{-218, -40}, {-218, -42}, {-52, -42}, {-52, -58}}, color = {0, 0, 127}));
  connect(switch4.y, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-29, -66}, {14.5, -66}, {14.5, -70}, {54, -70}}, color = {0, 0, 127}));
  connect(gain.y, limiter1.u) annotation(
    Line(points = {{216, 220}, {252, 220}}, color = {0, 0, 127}));
  connect(limiter1.y, add1.u1) annotation(
    Line(points = {{276, 220}, {318, 220}, {318, 116}}, color = {0, 0, 127}));
  connect(UFilteredPu5.y, IpmaxFromUPu.u) annotation(
    Line(points = {{224, 0}, {263, 0}, {263, 36}, {295, 36}}, color = {0, 0, 127}));
  connect(UFilteredPu5.y, IqmaxFromUPu.u) annotation(
    Line(points = {{224, 0}, {259, 0}, {259, -36}, {297, -36}}, color = {0, 0, 127}));
  connect(iPu, lineDropCompensation.iPu) annotation(
    Line(points = {{-270, -202}, {-208, -202}}, color = {85, 170, 255}));
  connect(omegaGPu, product4.u2) annotation(
    Line(points = {{-270, -100}, {-178, -100}}, color = {0, 0, 127}));
  connect(IqMax.y, varLimPIDFreeze.yMax) annotation(
    Line(points = {{142, 130}, {168, 130}, {168, 118}}, color = {0, 0, 127}));
  connect(IqMin.y, varLimPIDFreeze.yMin) annotation(
    Line(points = {{143, 96}, {168, 96}, {168, 106}}, color = {0, 0, 127}));
  connect(PFlagConst.y, switch4.u2) annotation(
    Line(points = {{-108, -65}, {-78, -65}, {-78, -66}, {-52, -66}}, color = {255, 0, 255}));
  connect(switch1.y, add4.u2) annotation(
    Line(points = {{-108, 150}, {-100, 150}, {-100, 68}, {-30, 68}}, color = {0, 0, 127}));
  connect(VRefConst1.y, add4.u1) annotation(
    Line(points = {{-72, 96}, {-30, 96}, {-30, 80}}, color = {0, 0, 127}));
  connect(add4.y, switch.u3) annotation(
    Line(points = {{-6, 74}, {16, 74}, {16, 104}}, color = {0, 0, 127}));
  connect(PAuxPu, add3.u2) annotation(
    Line(points = {{-268, -170}, {-80, -170}, {-80, -118}, {132, -118}}, color = {0, 0, 127}));
  connect(add3.y, division1.u1) annotation(
    Line(points = {{155, -112}, {159.5, -112}, {159.5, -114}, {170, -114}}, color = {0, 0, 127}));
  connect(limiter3.y, add3.u1) annotation(
    Line(points = {{142, -70}, {150, -70}, {150, -90}, {114, -90}, {114, -106}, {132, -106}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationD.iqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{403, 5}, {474, 5}, {474, 102}, {498, 102}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationD.iqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{403, 9}, {468, 9}, {468, 118}, {498, 118}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationD.ipMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{403, 15}, {444, 15}, {444, -128}, {500, -128}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationD.ipMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{403, 19}, {460, 19}, {460, -112}, {500, -112}}, color = {0, 0, 127}));
  connect(IpmaxFromUPu.y[1], currentLimitsCalculationD.ipVdlPu) annotation(
    Line(points = {{318, 36}, {325.5, 36}, {325.5, 16}, {381, 16}}, color = {0, 0, 127}));
  connect(IqmaxFromUPu.y[1], currentLimitsCalculationD.iqVdlPu) annotation(
    Line(points = {{320, -36}, {328, -36}, {328, 8.5}, {381, 8.5}}, color = {0, 0, 127}));
  connect(variableLimiter.y, currentLimitsCalculationD.iqCmdPu) annotation(
    Line(points = {{522, 110}, {526, 110}, {526, 48}, {336, 48}, {336, 5}, {381, 5}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, currentLimitsCalculationD.ipCmdPu) annotation(
    Line(points = {{522, -120}, {530, -120}, {530, -36}, {340, -36}, {340, 20}, {381, 20}}, color = {0, 0, 127}));
  connect(VCompFlagConst.y, switch3.u2) annotation(
    Line(points = {{-89, -220}, {-18, -220}}, color = {255, 0, 255}));
  connect(firstOrder2.y, varLimPIDFreeze.u_m) annotation(
    Line(points = {{58, -220}, {210, -220}, {210, -28}, {180, -28}, {180, 100}}, color = {0, 0, 127}));
  connect(add1.y, iqCommandBlLogic.iqCmdBlPu) annotation(
    Line(points = {{342, 110}, {366, 110}}, color = {0, 0, 127}));
  connect(iqCommandBlLogic.iqCmdPu, variableLimiter.u) annotation(
    Line(points = {{390, 110}, {498, 110}}, color = {0, 0, 127}));
  connect(division1.y, ipCommandBlLogic.IpCmdBlPu) annotation(
    Line(points = {{192, -120}, {366, -120}}, color = {0, 0, 127}));
  connect(ipCommandBlLogic.IpCmdPu, variableLimiter1.u) annotation(
    Line(points = {{389, -120}, {500, -120}}, color = {0, 0, 127}));
  connect(FRTOn21.y, iqCommandBlLogic.vDip) annotation(
    Line(points = {{292, 9}, {292, 80}, {352, 80}, {352, 118}, {366, 118}}, color = {255, 0, 255}));
  connect(FRTOn21.y, ipCommandBlLogic.vDip) annotation(
    Line(points = {{292, 9}, {292, -112}, {366, -112}}, color = {255, 0, 255}));
  connect(FRTOn21.y, currentLimitsCalculationD.vDip) annotation(
    Line(points = {{292, 9}, {304, 9}, {304, 12}, {380, 12}}, color = {255, 0, 255}));
  connect(firstOrder.y, voltageCheck1.UPu) annotation(
    Line(points = {{62, 240}, {80, 240}, {80, 256}, {220, 256}, {220, 267}, {233, 267}}, color = {0, 0, 127}));
  connect(voltageCheck1.freeze, Blk) annotation(
    Line(points = {{255, 267}, {267, 267}, {267, 266}, {284, 266}}, color = {255, 0, 255}));
  connect(voltageCheck1.freeze, currentLimitsCalculationD.vBlk) annotation(
    Line(points = {{255, 267}, {255, 254.5}, {257, 254.5}, {257, 244}, {392, 244}, {392, 24}}, color = {255, 0, 255}));
  connect(firstOrder.y, voltageCheck.UPu) annotation(
    Line(points = {{62, 240}, {80, 240}, {80, 272}, {132, 272}}, color = {0, 0, 127}));
  
  annotation(
    Diagram,
    Icon(graphics = {Text(origin = {-37, 130.5}, extent = {{-16, 7}, {24, -10}}, textString = "PAuxPu"), Text(origin = {65, 132.5}, extent = {{-16, 7}, {24, -10}}, textString = "iInjPu"), Text(origin = {-81, 130.5}, extent = {{-16, 7}, {24, -10}}, textString = "uInjPu"), Ellipse(origin = {-67, -126}, extent = {{-9, 0}, {9, 0}}), Text(origin = {-30.3275, -106.118}, extent = {{-14.6724, 6.11766}, {22.3276, -9.88234}}, textString = "omegaG"), Text(origin = {-19, 11}, extent = {{-45, 23}, {84, -40}}, textString = "REEC D"), Text(origin = {129, 49}, extent = {{-23, 13}, {35, -21}}, textString = "Blk", fontSize = 14)}),
    Documentation(info = "<html><head></head><body><div class=\"htmlDoc\" style=\"font-family: 'MS Shell Dlg 2';\"><p>This block contains the electrical inverter control of the generic WECC PV model according to (in case page cannot be found, copy link in browser):&nbsp;<a href=\"https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/\">https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf&nbsp;</a></p><p>Following control modes can be activated:<span style=\"font-size: 12px;\">Local coordinated V/Q control: QFlag = true, VFlag = true</span></p><li><li style=\"font-size: 12px;\">Only plant level control active: QFlag = false, VFlag = false</li><li style=\"font-size: 12px;\">If plant level control not connected: local power factor control: PfFlag = true, otherwise PfFlag = false.</li><li style=\"font-size: 12px;\">Active power can be dependent or independent on drive train speed by setting PFlag to false (independent from drive train speed) or true. If PFlag is set to false, the model behaves as a Wind turbine generator type 4B, where the drive train is neglected by setting the speed to constant 1&nbsp;</li><p style=\"font-size: 12px;\">The block calculates the Id and Iq setpoint values for the generator control based on the selected control algorithm.</p></li><div><br></div></div><div class=\"textDoc\"><p style=\"font-family: 'Courier New'; font-size: 12px;\"></p></div></body></html>"));
end REECd;
