within Dynawo.Electrical.Controls.Converters.BaseControls;

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

model IECWT4ACurrentLimitation "IEC Wind Turbine type 4A Current Limitation"


  import Modelica;
  import Dynawo.Types;

  extends Dynawo.Electrical.Controls.Converters.Parameters.Params_CurrentLimit;

  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  /*Current Limiter Parameters*/
  parameter Types.PerUnit upquMax "WT voltage in the operation point where zero reactive power can be delivered";
  parameter Types.PerUnit iMax "Maximum continuous current at the WTT terminals";
  parameter Types.PerUnit iMaxDip "Maximun current during voltage dip at the WT terlinals";
  parameter Types.PerUnit iMaxHookPu;
  parameter Types.PerUnit iqMaxHook;
  parameter Types.PerUnit Kpqu "Partial derivative of reactive current limits vs. voltage";
  parameter Integer Mqpri "Priorisation of reactive current during FRT (0: active power priority - 1: reactive power priority";
  parameter Types.PerUnit Mdfslim "Limitation of type 3 stator current (O: total current limitation, 1: stator current limitation)";
  /*Parameters for initialization from load flow*/
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in p.u (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in p.u (base SnRef) (receptor convention)";
  /*Parameters for internal initialization*/
  parameter Types.PerUnit IpMax0Pu "Start value maximum active current (Ibase)";
  parameter Types.PerUnit IqMax0Pu "Start value maximum reactive current (Ibase)";
  parameter Types.PerUnit IqMin0Pu "Start value minimum reactive current (Ibase)";
  final parameter Types.PerUnit ipCmd0Pu = -P0Pu*SystemBase.SnRef/(SNom*sqrt(u0Pu.re*u0Pu.re + u0Pu.im*u0Pu.im)) "Initial value of the d-axis reference current at the generator system module terminals (converter) in p.u (Ubase,SNom) (generator convention)";
  final parameter Types.PerUnit iqCmd0Pu = -Q0Pu*SystemBase.SnRef/(SNom*sqrt(u0Pu.re*u0Pu.re + u0Pu.im*u0Pu.im)) "Initial value of the q-axis reference current at the generator system module terminals (converter) in p.u (Ubase,SNom) (generator convention)";
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = ipCmd0Pu) "Active current command to generator system (Ibase)" annotation(
    Placement(visible = true, transformation(origin = {-200, 186}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = iqCmd0Pu) "Rective current command to generator system (Ibase)" annotation(
    Placement(visible = true, transformation(origin = {-200, -180}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, -160}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uWTCfiltPu(start = sqrt(u0Pu.re*u0Pu.re + u0Pu.im*u0Pu.im)) "Filtered voltage measurement for WT control (Ubase)" annotation(
    Placement(visible = true, transformation(origin = { -200, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = { -200, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput OmegaPu(start = 1) "Convereter frequency in p.u" annotation(
  Placement(visible = true, transformation(origin = {-200, 150}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.IntegerInput Ffrt annotation(
    Placement(visible = true, transformation(origin = {-200, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = IpMax0Pu) "Maximum active current (Ibase)" annotation(
    Placement(visible = true, transformation(origin = {200, -142}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {200, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu(start = IqMax0Pu) "Maximum reactive current (Ibase)" annotation(
    Placement(visible = true, transformation(origin = {200, -98}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu(start = IqMin0Pu) "Minimum reactive current (Ibase)" annotation(
    Placement(visible = true, transformation(origin = {200, 148}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {200, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  /*Blocks*/
  Modelica.Blocks.Sources.Constant const1(k = iMaxDip) annotation(
    Placement(visible = true, transformation(origin = {-170, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = iMax) annotation(
    Placement(visible = true, transformation(origin = {-170, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const4(k = Mdfslim) annotation(
    Placement(visible = true, transformation(origin = {-172, 120}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const5(k = iqMaxHook)  annotation(
    Placement(visible = true, transformation(origin = {-170, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const6(k = iMaxHookPu) annotation(
    Placement(visible = true, transformation(origin = {-170, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {-110, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = 100, uMin = 0)  annotation(
    Placement(visible = true, transformation(origin = {-8, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt11 annotation(
    Placement(visible = true, transformation(origin = {22, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min1 annotation(
    Placement(visible = true, transformation(origin = {58, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {150, -142}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-10, -122}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = upquMax)  annotation(
    Placement(visible = true, transformation(origin = {-36, -122}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-80, -100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpqu)  annotation(
    Placement(visible = true, transformation(origin = {14, -122}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Min min2 annotation(
    Placement(visible = true, transformation(origin = {42, -116}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch11 annotation(
    Placement(visible = true, transformation(origin = {150, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less annotation(
    Placement(visible = true, transformation(origin = {90, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {-74, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt12 annotation(
    Placement(visible = true, transformation(origin = {-36, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch13 annotation(
    Placement(visible = true, transformation(origin = {-120, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-172, 90}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt13 annotation(
    Placement(visible = true, transformation(origin = {-38, 174}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(visible = true, transformation(origin = {-4, 166}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = 100, uMin = 0)  annotation(
    Placement(visible = true, transformation(origin = {24, 166}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt14 annotation(
    Placement(visible = true, transformation(origin = {52, 166}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Min min3 annotation(
    Placement(visible = true, transformation(origin = {82, 156}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {160, 148}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.RealToBoolean realToBoolean1 annotation(
    Placement(visible = true, transformation(origin = {-148, 120}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {-36, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min4 annotation(
    Placement(visible = true, transformation(origin = {-74, 174}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-122, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchThree switch15 annotation(
    Placement(visible = true, transformation(origin = {-126, 20}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchThree switch12 annotation(
    Placement(visible = true, transformation(origin = {126, 148}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchThree switch14 annotation(
    Placement(visible = true, transformation(origin = {96, -148}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k = Mqpri)  annotation(
    Placement(visible = true, transformation(origin = {-82, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathInteger.Product product2(nu = 2)  annotation(
    Placement(visible = true, transformation(origin = {-40, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D1(table = tableIpMaxUwt) annotation(
    Placement(visible = true, transformation(origin = {-130, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = tableIqMaxUwt) annotation(
    Placement(visible = true, transformation(origin = {-130, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Abs abs1 annotation(
    Placement(visible = true, transformation(origin = {-160, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt1 annotation(
    Placement(visible = true, transformation(origin = {-78, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(sqrt11.y, min1.u2) annotation(
    Line(points = {{33, -180}, {40, -180}, {40, -186}, {46, -186}}, color = {0, 0, 127}));
  connect(product.y, ipMaxPu) annotation(
    Line(points = {{161, -142}, {200, -142}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, feedback.u2) annotation(
    Line(points = {{-200, -120}, {-80, -120}, {-80, -150}, {-10, -150}, {-10, -130}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-1, -122}, {7, -122}}, color = {0, 0, 127}));
  connect(gain.y, min2.u2) annotation(
    Line(points = {{21, -122}, {30, -122}}, color = {0, 0, 127}));
  connect(min2.y, less.u2) annotation(
    Line(points = {{53, -116}, {70, -116}, {70, -78}, {78, -78}}, color = {0, 0, 127}));
  connect(switch11.y, iqMaxPu) annotation(
    Line(points = {{161, -98}, {200, -98}}, color = {0, 0, 127}));
  connect(feedback2.y, sqrt12.u) annotation(
    Line(points = {{-65, 20}, {-48, 20}}, color = {0, 0, 127}));
  connect(const.y, feedback.u1) annotation(
    Line(points = {{-27, -122}, {-18, -122}}, color = {0, 0, 127}));
  connect(less.y, switch11.u2) annotation(
    Line(points = {{101, -70}, {110, -70}, {110, -98}, {138, -98}}, color = {255, 0, 255}));
  connect(switch13.y, product.u1) annotation(
    Line(points = {{-109, 120}, {120, 120}, {120, -136}, {138, -136}}, color = {0, 0, 127}));
  connect(feedback4.y, limiter1.u) annotation(
    Line(points = {{5, 166}, {14, 166}}, color = {0, 0, 127}));
  connect(feedback1.y, min3.u2) annotation(
    Line(points = {{-71, -100}, {0, -100}, {0, 150}, {70, 150}}, color = {0, 0, 127}));
  connect(gain1.y, less.u1) annotation(
    Line(points = {{167, 148}, {170, 148}, {170, -40}, {70, -40}, {70, -70}, {78, -70}}, color = {0, 0, 127}));
  connect(sqrt14.y, min3.u1) annotation(
    Line(points = {{61, 166}, {70, 166}, {70, 162}}, color = {0, 0, 127}));
  connect(gain1.y, iqMinPu) annotation(
    Line(points = {{167, 148}, {200, 148}}, color = {0, 0, 127}));
  connect(realToBoolean1.y, switch13.u2) annotation(
    Line(points = {{-139, 120}, {-132, 120}}, color = {255, 0, 255}));
  connect(const4.y, realToBoolean1.u) annotation(
    Line(points = {{-163, 120}, {-158, 120}}, color = {0, 0, 127}));
  connect(const5.y, feedback1.u2) annotation(
    Line(points = {{-159, -72}, {-80, -72}, {-80, -92}}, color = {0, 0, 127}));
  connect(const6.y, feedback2.u2) annotation(
    Line(points = {{-159, -36}, {-74, -36}, {-74, 12}}, color = {0, 0, 127}));
  connect(feedback3.y, limiter.u) annotation(
    Line(points = {{-27, -180}, {-20, -180}}, color = {0, 0, 127}));
  connect(sqrt12.y, feedback3.u1) annotation(
    Line(points = {{-25, 20}, {-12, 20}, {-12, -20}, {-50, -20}, {-50, -180}, {-44, -180}}, color = {0, 0, 127}));
  connect(sqrt13.y, feedback4.u2) annotation(
    Line(points = {{-27, 174}, {-4, 174}}, color = {0, 0, 127}));
  connect(sqrt12.y, feedback4.u1) annotation(
    Line(points = {{-25, 20}, {-12, 20}, {-12, 166}}, color = {0, 0, 127}));
  connect(division.y, min4.u1) annotation(
    Line(points = {{-111, 180}, {-86, 180}}, color = {0, 0, 127}));
  connect(ipCmdPu, division.u1) annotation(
    Line(points = {{-200, 186}, {-134, 186}}, color = {0, 0, 127}));
  connect(switch13.y, division.u2) annotation(
    Line(points = {{-109, 120}, {-106, 120}, {-106, 160}, {-150, 160}, {-150, 174}, {-134, 174}}, color = {0, 0, 127}));
  connect(constant1.y, switch13.u3) annotation(
    Line(points = {{-164, 90}, {-136, 90}, {-136, 112}, {-132, 112}}, color = {0, 0, 127}));
  connect(gain1.y, switch11.u3) annotation(
    Line(points = {{167, 148}, {170, 148}, {170, -40}, {128, -40}, {128, -106}, {138, -106}}, color = {0, 0, 127}));
  connect(min2.y, switch11.u1) annotation(
    Line(points = {{54, -116}, {70, -116}, {70, -90}, {138, -90}, {138, -90}}, color = {0, 0, 127}));
  connect(switch15.y, feedback2.u1) annotation(
    Line(points = {{-110, 20}, {-82, 20}}, color = {0, 0, 127}));
  connect(const1.y, switch15.u1) annotation(
    Line(points = {{-158, 2}, {-158, 20}, {-142, 20}}, color = {0, 0, 127}));
  connect(const2.y, switch15.u2) annotation(
    Line(points = {{-158, 40}, {-150, 40}, {-150, 12}, {-142, 12}, {-142, 12}}, color = {0, 0, 127}));
  connect(const2.y, switch15.u0) annotation(
    Line(points = {{-158, 40}, {-150, 40}, {-150, 28}, {-142, 28}, {-142, 28}}, color = {0, 0, 127}));
  connect(switch12.y, gain1.u) annotation(
    Line(points = {{141, 148}, {153, 148}}, color = {0, 0, 127}));
  connect(min3.y, switch12.u0) annotation(
    Line(points = {{94, 156}, {111, 156}}, color = {0, 0, 127}));
  connect(feedback1.y, switch12.u2) annotation(
    Line(points = {{-70, -100}, {0, -100}, {0, 140}, {110, 140}, {110, 140}}, color = {0, 0, 127}));
  connect(feedback1.y, switch12.u1) annotation(
    Line(points = {{-70, -100}, {0, -100}, {0, 140}, {100, 140}, {100, 148}, {110, 148}, {110, 148}}, color = {0, 0, 127}));
  connect(switch12.y, min2.u1) annotation(
    Line(points = {{142, 148}, {146, 148}, {146, 0}, {20, 0}, {20, -110}, {30, -110}}, color = {0, 0, 127}));
  connect(switch14.y, product.u2) annotation(
    Line(points = {{111, -148}, {138, -148}}, color = {0, 0, 127}));
  connect(min1.y, switch14.u1) annotation(
    Line(points = {{70, -180}, {74, -180}, {74, -148}, {81, -148}}, color = {0, 0, 127}));
  connect(min1.y, switch14.u2) annotation(
    Line(points = {{70, -180}, {74, -180}, {74, -156}, {81, -156}}, color = {0, 0, 127}));
  connect(limiter.y, sqrt11.u) annotation(
    Line(points = {{4, -180}, {10, -180}}, color = {0, 0, 127}));
  connect(limiter1.y, sqrt14.u) annotation(
    Line(points = {{33, 166}, {42, 166}}, color = {0, 0, 127}));
  connect(min4.y, sqrt13.u) annotation(
    Line(points = {{-63, 174}, {-50, 174}}, color = {0, 0, 127}));
  connect(Ffrt, product2.u[1]) annotation(
    Line(points = {{-200, 70}, {-50, 70}, {-50, 70}, {-50, 70}}, color = {255, 127, 0}));
  connect(integerConstant.y, product2.u[2]) annotation(
    Line(points = {{-70, 50}, {-60, 50}, {-60, 70}, {-50, 70}, {-50, 70}}, color = {255, 127, 0}));
  connect(product2.y, switch12.M) annotation(
    Line(points = {{-28, 70}, {126, 70}, {126, 132}, {126, 132}}, color = {255, 127, 0}));
  connect(product2.y, switch14.M) annotation(
    Line(points = {{-28, 70}, {60, 70}, {60, -164}, {96, -164}, {96, -164}}, color = {255, 127, 0}));
  connect(Ffrt, switch15.M) annotation(
    Line(points = {{-200, 70}, {-154, 70}, {-154, 0}, {-126, 0}, {-126, 4}, {-126, 4}}, color = {255, 127, 0}));
  connect(feedback1.y, min.u1) annotation(
    Line(points = {{-70, -100}, {-66, -100}, {-66, -160}, {-130, -160}, {-130, -174}, {-122, -174}, {-122, -174}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, combiTable1D.u[1]) annotation(
    Line(points = {{-200, -120}, {-162, -120}, {-162, -100}, {-142, -100}, {-142, -100}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, combiTable1D1.u[1]) annotation(
    Line(points = {{-200, -120}, {-162, -120}, {-162, -140}, {-142, -140}, {-142, -140}}, color = {0, 0, 127}));
  connect(iqCmdPu, abs1.u) annotation(
    Line(points = {{-200, -180}, {-172, -180}}, color = {0, 0, 127}));
  connect(abs1.y, min.u2) annotation(
    Line(points = {{-149, -180}, {-140, -180}, {-140, -186}, {-122, -186}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], feedback1.u1) annotation(
    Line(points = {{-118, -100}, {-88, -100}, {-88, -100}, {-88, -100}}, color = {0, 0, 127}));
  connect(combiTable1D1.y[1], min1.u1) annotation(
    Line(points = {{-118, -140}, {40, -140}, {40, -174}, {46, -174}, {46, -174}}, color = {0, 0, 127}));
  connect(combiTable1D1.y[1], switch14.u0) annotation(
    Line(points = {{-118, -140}, {78, -140}, {78, -140}, {80, -140}}, color = {0, 0, 127}));
  connect(combiTable1D1.y[1], min4.u2) annotation(
    Line(points = {{-118, -140}, {-100, -140}, {-100, 168}, {-86, 168}, {-86, 168}}, color = {0, 0, 127}));
  connect(sqrt1.y, feedback3.u2) annotation(
    Line(points = {{-67, -180}, {-54, -180}, {-54, -194}, {-36, -194}, {-36, -188}}, color = {0, 0, 127}));
  connect(min.y, sqrt1.u) annotation(
    Line(points = {{-98, -180}, {-90, -180}, {-90, -180}, {-90, -180}}, color = {0, 0, 127}));
  connect(OmegaPu, switch13.u1) annotation(
    Line(points = {{-200, 150}, {-136, 150}, {-136, 128}, {-132, 128}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-180, -220}, {180, 220}})),
    Icon(coordinateSystem(extent = {{-180, -220}, {180, 220}}, initialScale = 0.1), graphics = {Rectangle(origin = {0, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-180, 221}, {180, -219}}), Text(origin = {-54, 133}, extent = {{-70, 37}, {172, -143}}, textString = "Current"), Text(origin = {-56, 53}, extent = {{-104, 87}, {214, -193}}, textString = "limitation"), Text(origin = {6, -97}, extent = {{-106, 81}, {92, -45}}, textString = "module")}));

end IECWT4ACurrentLimitation;
