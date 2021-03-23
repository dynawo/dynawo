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
  import Dynawo;

  extends Dynawo.Electrical.Controls.Converters.Parameters.Params_CurrentLimit;

  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  /*Current Limiter Parameters*/
  parameter Types.PerUnit IMax "Maximum continuous current at the WT terminals in pu (base UNom, SNom) (generator convention)"  annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  parameter Types.PerUnit IMaxDip "Maximun current during voltage dip at the WT terlinals in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  parameter Boolean Mdfslim "Limitation of type 3 stator current (O: total current limitation, 1: stator current limitation)" annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  parameter Boolean Mqpri "Priorisation of reactive current during FRT (0: active power priority, 1: reactive power priority" annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  parameter Types.PerUnit IMaxHookPu annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  parameter Types.PerUnit IqMaxHook annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  parameter Types.PerUnit UpquMax "WT voltage in the operation point where zero reactive power can be delivered" annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  parameter Types.PerUnit Kpqu "Partial derivative of reactive current limits vs. voltage" annotation(
    Dialog(group = "group", tab = "CurrentLimit"));

  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle UPhase0 "Start value of voltage angle at plan terminal (PCC) in radians" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));

  /*Parameters for internal initialization*/
  parameter Types.PerUnit IpMax0Pu "Start value of the maximum active current in pu (base UNom, SNom) (generator convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqMax0Pu "Start value of the maximum reactive current in pu (base UNom, SNom) (generator convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqMin0Pu "Start value of the minimum reactive current in pu (base UNom, SNom) (generator convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));

  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = -P0Pu*SystemBase.SnRef / (SNom*U0Pu)) "d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-270, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = -Q0Pu*SystemBase.SnRef / (SNom*U0Pu)) "q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-270, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, -160}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
   Modelica.Blocks.Interfaces.RealInput uWTCfiltPu(start = U0Pu) "Filtered voltage measurement for WT control (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-270, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = { -200, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput OmegaPu(start = SystemBase.omegaRef0Pu) "Convereter frequency in p.u" annotation(
  Placement(visible = true, transformation(origin = {-270, 130}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.IntegerInput Ffrt(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-270, 219}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-200, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = IpMax0Pu) "Maximum active current (Ibase)" annotation(
    Placement(visible = true, transformation(origin = {270, -75}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {200, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu(start = IqMax0Pu) "Maximum reactive current (Ibase)" annotation(
    Placement(visible = true, transformation(origin = {270, 200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu(start = IqMin0Pu) "Minimum reactive current (Ibase)" annotation(
    Placement(visible = true, transformation(origin = {270, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {200, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  /*Blocks*/
  Modelica.Blocks.Logical.Switch switch11 annotation(
    Placement(visible = true, transformation(origin = {230, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
//Modelica.Blocks.Logical.Less less annotation(
  //  Placement(visible = true, transformation(origin = {190, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min2 annotation(
    Placement(visible = true, transformation(origin = {150, 225}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpqu)  annotation(
    Placement(visible = true, transformation(origin = {110, 231}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {70, 231}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = UpquMax)  annotation(
    Placement(visible = true, transformation(origin = {30, 231}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {150, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchThree switch12 annotation(
    Placement(visible = true, transformation(origin = {110, 100}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));

  Modelica.Blocks.Math.Min min3 annotation(
    Placement(visible = true, transformation(origin = {70, 108}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt14 annotation(
    Placement(visible = true, transformation(origin = {35, 118}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = 999, uMin = 0.001)  annotation(
    Placement(visible = true, transformation(origin = {0, 118}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(visible = true, transformation(origin = {-29, 118}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min4 annotation(
    Placement(visible = true, transformation(origin = {-98, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-136, 155}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch13 annotation(
    Placement(visible = true, transformation(origin = {-193, 122}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = Mdfslim)  annotation(
    Placement(visible = true, transformation(origin = {-233, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-233, 75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = Mqpri) annotation(
    Placement(visible = true, transformation(origin = {-140, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.BooleanToInteger booleanToInteger annotation(
    Placement(visible = true, transformation(origin = {-100, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathInteger.Product product2(nu = 2)  annotation(
    Placement(visible = true, transformation(origin = {-60, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {-125, 95}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant const6(k = IMaxHookPu) annotation(
    Placement(visible = true, transformation(origin = {-150, 91}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchThree switch15 annotation(
    Placement(visible = true, transformation(origin = {-150, 45}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = IMaxDip) annotation(
    Placement(visible = true, transformation(origin = {-190, 45}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = IMax) annotation(
    Placement(visible = true, transformation(origin = {-225, 45}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {200, -75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchThree switch14 annotation(
    Placement(visible = true, transformation(origin = {89, -100}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));

  Modelica.Blocks.Math.Min min1 annotation(
    Placement(visible = true, transformation(origin = {50, -123}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt11 annotation(
    Placement(visible = true, transformation(origin = {10, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = 999, uMin = 0.001)  annotation(
    Placement(visible = true, transformation(origin = {-30, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {-70, -114}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Math.Abs abs1 annotation(
    Placement(visible = true, transformation(origin = {-225, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {-185, -114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant const5(k = IqMaxHook)  annotation(
    Placement(visible = true, transformation(origin = {-200, -29}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D1(table = tableIpMaxUwt) annotation(
    Placement(visible = true, transformation(origin = {-200, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = tableIqMaxUwt) annotation(
    Placement(visible = true, transformation(origin = {-200, -1}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback5 annotation(
    Placement(visible = true, transformation(origin = {-160, -1}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter5(limitsAtInit = true, uMax = 999, uMin = 0.001) annotation(
    Placement(visible = true, transformation(origin = {-166, 142}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product3 annotation(
    Placement(visible = true, transformation(origin = {-110, -114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product4 annotation(
    Placement(visible = true, transformation(origin = {-50, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(visible = true, transformation(origin = {190, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  connect(iqMaxPu, switch11.y) annotation(
    Line(points = {{270, 200}, {241, 200}}, color = {0, 0, 127}));
  connect(gain.y, min2.u1) annotation(
    Line(points = {{122, 232}, {134, 232}, {134, 232}, {138, 232}, {138, 232}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{80, 232}, {98, 232}, {98, 232}, {98, 232}}, color = {0, 0, 127}));
  connect(const.y, feedback.u1) annotation(
    Line(points = {{42, 232}, {64, 232}, {64, 232}, {62, 232}}, color = {0, 0, 127}));
  connect(gain1.y, iqMinPu) annotation(
    Line(points = {{162, 100}, {258, 100}, {258, 100}, {270, 100}}, color = {0, 0, 127}));
  connect(switch12.y, gain1.u) annotation(
    Line(points = {{124, 100}, {136, 100}, {136, 100}, {138, 100}}, color = {0, 0, 127}));
  connect(min3.y, switch12.u0) annotation(
    Line(points = {{81, 108}, {96, 108}}, color = {0, 0, 127}));
  connect(sqrt14.y, min3.u1) annotation(
    Line(points = {{46, 118}, {56, 118}, {56, 114}, {58, 114}}, color = {0, 0, 127}));
  connect(limiter1.y, sqrt14.u) annotation(
    Line(points = {{11, 118}, {23, 118}}, color = {0, 0, 127}));
  connect(feedback4.y, limiter1.u) annotation(
    Line(points = {{-20, 118}, {-12, 118}}, color = {0, 0, 127}));
  connect(ipCmdPu, division.u1) annotation(
    Line(points = {{-270, 160}, {-148, 160}, {-148, 161}}, color = {0, 0, 127}));
  connect(division.y, min4.u1) annotation(
    Line(points = {{-125, 155}, {-110, 155}, {-110, 156}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch13.u2) annotation(
    Line(points = {{-222, 110}, {-216, 110}, {-216, 122}, {-205, 122}}, color = {255, 0, 255}));
  connect(constant1.y, switch13.u3) annotation(
    Line(points = {{-222, 75}, {-208, 75}, {-208, 114}, {-205, 114}}, color = {0, 0, 127}));
  connect(booleanConstant1.y, booleanToInteger.u) annotation(
    Line(points = {{-128, 200}, {-110, 200}, {-110, 200}, {-112, 200}}, color = {255, 0, 255}));
  connect(booleanToInteger.y, product2.u[1]) annotation(
    Line(points = {{-88, 200}, {-70, 200}, {-70, 200}, {-70, 200}}, color = {255, 127, 0}));
  connect(product2.y, switch12.M) annotation(
    Line(points = {{-48, 200}, {110, 200}, {110, 114}, {110, 114}, {110, 114}}, color = {255, 127, 0}));
  connect(Ffrt, product2.u[2]) annotation(
    Line(points = {{-270, 219}, {-80, 219}, {-80, 202}, {-70, 202}, {-70, 200}}, color = {255, 127, 0}));
  connect(const6.y, feedback2.u2) annotation(
    Line(points = {{-139, 91}, {-135, 91}, {-135, 96}, {-132, 96}}, color = {0, 0, 127}));
  connect(switch15.y, feedback2.u1) annotation(
    Line(points = {{-136, 46}, {-126, 46}, {-126, 88}, {-124, 88}}, color = {0, 0, 127}));
  connect(const1.y, switch15.u1) annotation(
    Line(points = {{-178, 46}, {-162, 46}, {-162, 44}, {-164, 44}, {-164, 46}}, color = {0, 0, 127}));
  connect(const2.y, switch15.u2) annotation(
    Line(points = {{-214, 46}, {-208, 46}, {-208, 26}, {-170, 26}, {-170, 38}, {-164, 38}, {-164, 38}}, color = {0, 0, 127}));
  connect(const2.y, switch15.u0) annotation(
    Line(points = {{-214, 46}, {-208, 46}, {-208, 64}, {-170, 64}, {-170, 52}, {-164, 52}, {-164, 52}}, color = {0, 0, 127}));
  connect(product.y, ipMaxPu) annotation(
    Line(points = {{212, -74}, {258, -74}, {258, -74}, {270, -74}}, color = {0, 0, 127}));
  connect(OmegaPu, switch13.u1) annotation(
    Line(points = {{-270, 130}, {-205, 130}}, color = {0, 0, 127}));
  connect(Ffrt, switch15.M) annotation(
    Line(points = {{-270, 219}, {-168, 219}, {-168, 70}, {-150, 70}, {-150, 58}}, color = {255, 127, 0}));
  connect(product2.y, switch14.M) annotation(
    Line(points = {{-48, 200}, {89, 200}, {89, -87}}, color = {255, 127, 0}));
  connect(switch14.y, product.u2) annotation(
    Line(points = {{102, -100}, {150, -100}, {150, -82}, {188, -82}, {188, -80}}, color = {0, 0, 127}));
  connect(sqrt11.y, min1.u2) annotation(
    Line(points = {{22, -130}, {38, -130}, {38, -128}, {38, -128}}, color = {0, 0, 127}));
  connect(limiter.y, sqrt11.u) annotation(
    Line(points = {{-18, -130}, {-2, -130}, {-2, -130}, {-2, -130}}, color = {0, 0, 127}));
  connect(min1.y, switch14.u2) annotation(
    Line(points = {{62, -122}, {66, -122}, {66, -107}, {76, -107}}, color = {0, 0, 127}));
  connect(min1.y, switch14.u1) annotation(
    Line(points = {{62, -122}, {66, -122}, {66, -100}, {76, -100}}, color = {0, 0, 127}));
  connect(feedback3.y, limiter.u) annotation(
    Line(points = {{-70, -123}, {-70, -130}, {-42, -130}}, color = {0, 0, 127}));
  connect(abs1.y, min.u2) annotation(
    Line(points = {{-214, -120}, {-198, -120}, {-198, -120}, {-196, -120}}, color = {0, 0, 127}));
  connect(iqCmdPu, abs1.u) annotation(
    Line(points = {{-270, -120}, {-236, -120}, {-236, -120}, {-236, -120}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, feedback.u2) annotation(
    Line(points = {{-270, -50}, {84, -50}, {84, 212}, {68, 212}, {68, 224}, {70, 224}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, combiTable1D.u[1]) annotation(
    Line(points = {{-270, -50}, {-230, -50}, {-230, -2}, {-212, -2}, {-212, 0}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, combiTable1D1.u[1]) annotation(
    Line(points = {{-270, -50}, {-230, -50}, {-230, -82}, {-212, -82}, {-212, -80}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], feedback5.u1) annotation(
    Line(points = {{-188, 0}, {-168, 0}, {-168, 0}, {-168, 0}}, color = {0, 0, 127}));
  connect(const5.y, feedback5.u2) annotation(
    Line(points = {{-188, -28}, {-160, -28}, {-160, -8}, {-160, -8}}, color = {0, 0, 127}));
  connect(combiTable1D1.y[1], min1.u1) annotation(
    Line(points = {{-188, -80}, {30, -80}, {30, -118}, {38, -118}, {38, -116}}, color = {0, 0, 127}));
  connect(combiTable1D1.y[1], switch14.u0) annotation(
    Line(points = {{-188, -80}, {30, -80}, {30, -92}, {76, -92}}, color = {0, 0, 127}));
  connect(feedback5.y, min.u1) annotation(
    Line(points = {{-150, 0}, {-142, 0}, {-142, -96}, {-206, -96}, {-206, -108}, {-196, -108}, {-196, -108}}, color = {0, 0, 127}));
  connect(feedback5.y, min3.u2) annotation(
    Line(points = {{-150, 0}, {46, 0}, {46, 102}, {58, 102}, {58, 102}}, color = {0, 0, 127}));
  connect(feedback5.y, switch12.u2) annotation(
    Line(points = {{-150, 0}, {46, 0}, {46, 92}, {96, 92}, {96, 92}}, color = {0, 0, 127}));
  connect(feedback5.y, switch12.u1) annotation(
    Line(points = {{-150, 0}, {46, 0}, {46, 92}, {92, 92}, {92, 100}, {96, 100}, {96, 100}}, color = {0, 0, 127}));
  connect(switch12.y, min2.u2) annotation(
    Line(points = {{124, 100}, {132, 100}, {132, 220}, {138, 220}, {138, 220}}, color = {0, 0, 127}));
  connect(combiTable1D1.y[1], min4.u2) annotation(
    Line(points = {{-188, -80}, {-122, -80}, {-122, 144}, {-110, 144}}, color = {0, 0, 127}));
  connect(switch13.y, product.u1) annotation(
    Line(points = {{-182, 122}, {-172, 122}, {-172, -70}, {188, -70}, {188, -68}}, color = {0, 0, 127}));
  connect(limiter5.y, division.u2) annotation(
    Line(points = {{-154, 142}, {-152, 142}, {-152, 148}, {-148, 148}, {-148, 150}}, color = {0, 0, 127}));
  connect(switch13.y, limiter5.u) annotation(
    Line(points = {{-182, 122}, {-180, 122}, {-180, 144}, {-178, 144}, {-178, 142}}, color = {0, 0, 127}));
  connect(feedback2.y, product1.u1) annotation(
    Line(points = {{-124, 104}, {-126, 104}, {-126, 116}, {-102, 116}, {-102, 116}}, color = {0, 0, 127}));
  connect(feedback2.y, product1.u2) annotation(
    Line(points = {{-124, 104}, {-102, 104}, {-102, 104}, {-102, 104}}, color = {0, 0, 127}));
  connect(product1.y, feedback3.u1) annotation(
    Line(points = {{-78, 110}, {-70, 110}, {-70, -106}, {-70, -106}}, color = {0, 0, 127}));
  connect(product1.y, feedback4.u1) annotation(
    Line(points = {{-78, 110}, {-70, 110}, {-70, 118}, {-37, 118}}, color = {0, 0, 127}));
  connect(product3.y, feedback3.u2) annotation(
    Line(points = {{-99, -114}, {-78, -114}}, color = {0, 0, 127}));
  connect(min.y, product3.u1) annotation(
    Line(points = {{-174, -114}, {-160, -114}, {-160, -108}, {-122, -108}}, color = {0, 0, 127}));
  connect(min.y, product3.u2) annotation(
    Line(points = {{-174, -114}, {-160, -114}, {-160, -120}, {-122, -120}}, color = {0, 0, 127}));
  connect(min4.y, product4.u1) annotation(
    Line(points = {{-87, 150}, {-80, 150}, {-80, 156}, {-62, 156}}, color = {0, 0, 127}));
  connect(min4.y, product4.u2) annotation(
    Line(points = {{-87, 150}, {-80, 150}, {-80, 144}, {-62, 144}}, color = {0, 0, 127}));
  connect(product4.y, feedback4.u2) annotation(
    Line(points = {{-39, 150}, {-30, 150}, {-30, 126}, {-29, 126}}, color = {0, 0, 127}));
  connect(gain1.y, switch11.u3) annotation(
    Line(points = {{162, 100}, {210, 100}, {210, 192}, {218, 192}}, color = {0, 0, 127}));
  connect(min2.y, switch11.u1) annotation(
    Line(points = {{162, 226}, {210, 226}, {210, 208}, {218, 208}}, color = {0, 0, 127}));
  connect(gain1.y, greater.u2) annotation(
    Line(points = {{162, 100}, {170, 100}, {170, 190}, {178, 190}, {178, 192}}, color = {0, 0, 127}));
  connect(min2.y, greater.u1) annotation(
    Line(points = {{162, 226}, {168, 226}, {168, 200}, {178, 200}, {178, 200}}, color = {0, 0, 127}));
  connect(greater.y, switch11.u2) annotation(
    Line(points = {{202, 200}, {218, 200}}, color = {255, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-250, -150}, {250, 250}})),
    Icon(coordinateSystem(extent = {{-180, -180}, {180, 180}}, initialScale = 0.1), graphics = {Rectangle(origin = {0, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-180, -180}, {180, 180}}), Text(origin = {-54, 133}, extent = {{-70, 37}, {172, -143}}, textString = "Current"), Text(origin = {-56, 53}, extent = {{-104, 87}, {214, -193}}, textString = "limitation"), Text(origin = {6, -97}, extent = {{-106, 81}, {92, -45}}, textString = "module")}));

end IECWT4ACurrentLimitation;
