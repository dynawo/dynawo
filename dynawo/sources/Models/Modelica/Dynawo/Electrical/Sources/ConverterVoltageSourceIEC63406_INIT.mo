within Dynawo.Electrical.Sources;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model ConverterVoltageSourceIEC63406_INIT "Converter model from IEC63406 standard : initialization model"
  extends AdditionalIcons.Init;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.QLimitParameters;

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //General parameters
  parameter Types.PerUnit PMaxPu "Maximum active power at converter terminal in pu (base SNom)" annotation(
    Dialog(tab = "General"));
  parameter Boolean StorageFlag "1 if it is a storage unit, 0 if not" annotation(
    Dialog(tab = "General"));

  //Circuit parameters
  parameter Types.PerUnit BesPu "Shunt susceptance in pu (base UNom, SNom)";
  parameter Types.PerUnit GesPu "Shunt conductance in pu (base UNom, SNom)";
  parameter Types.PerUnit ResPu "Serial resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XesPu "Serial reactance in pu (base UNom, SNom)";

  //Current limiter parameters
  parameter Types.CurrentModulePu IMaxPu "Maximum current at converter terminal in pu (base UNom, SNom)";
  parameter Types.PerUnit QMaxPu "Maximum reactive power defined by users in pu (base SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit QMinPu "Minimum reactive power defined by users in pu (base SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Boolean QLimFlag "0 to use the defined lookup tables, 1 to use the constant values" annotation(
    Dialog(tab = "QControl"));
  parameter Boolean PriorityFlag "0 for active current priority, 1 for reactive current priority";

  //Init variables
  Types.PerUnit PAvailIn0Pu "Initial minimum output electrical power available to the active power control module in pu (base SNom)";
  Types.PerUnit IPMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IPMin0Pu "Initial minimum active current at converter terminal in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IQMax0Pu "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IQMin0Pu "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)";
  Types.ReactivePowerPu QMax0Pu "Initial maximum reactive power at grid terminal in pu (base SNom)";
  Types.ReactivePowerPu QMin0Pu "Initial minimum reactive power at grid terminal in pu (base SNom)";

  Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)";
  Types.ComplexCurrentPu i0Pu "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.PerUnit Ued0Pu "Initial direct component of the voltage at converter terminal in pu (base UNom)";
  Types.PerUnit Ueq0Pu "Initial direct component of the voltage at converter terminal in pu (base UNom)";
  Types.PerUnit UeIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)";
  Types.PerUnit UeRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)";
  Types.PerUnit Id0Pu "Initial direct component of current imposed in the contol in pu (generator convention)";
  Types.PerUnit Iq0Pu "Initial quadratic component of current imposed in the contol in pu (base UNom, SnRef) (generator convention)";
  Types.PerUnit Ud0Pu "Initial direct component of the voltage at converter terminal in pu (base UNom)";
  Types.PerUnit Uq0Pu "Initial direct component of the voltage at converter terminal in pu (base UNom)";

  //Load flow parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad";

  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {-50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds2(table = TableQMaxPwtcFilt) annotation(
    Placement(visible = true, transformation(origin = {-130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max0 annotation(
    Placement(visible = true, transformation(origin = {-50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds1(table = TableQMinUwtcFilt) annotation(
    Placement(visible = true, transformation(origin = {-130, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table = TableQMaxUwtcFilt) annotation(
    Placement(visible = true, transformation(origin = {-130, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds3(table = TableQMinPwtcFilt) annotation(
    Placement(visible = true, transformation(origin = {-130, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-190, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-190, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {80, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = -1) annotation(
    Placement(visible = true, transformation(origin = {160, 22}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  Modelica.Blocks.Math.Division division2 annotation(
    Placement(visible = true, transformation(origin = {30, -20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch16 annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.Controls.BaseControls.AuxiliaryControls.IqLimitation iqLimitation(IMaxPu = IMaxPu, P0Pu = P0Pu, SNom = SNom, U0Pu = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression4(y = IMaxPu) annotation(
    Placement(visible = true, transformation(origin = {30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression10(y = -IMaxPu) annotation(
    Placement(visible = true, transformation(origin = {30, -47}, extent = {{-10, -11}, {10, 11}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression7(y = PriorityFlag) annotation(
    Placement(visible = true, transformation(origin = {140, 122}, extent = {{-23, -25}, {23, 25}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switch11 annotation(
    Placement(visible = true, transformation(origin = {190, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = IMaxPu) annotation(
    Placement(visible = true, transformation(origin = {30, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {150, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.AuxiliaryBlocks.Min3 min3 annotation(
    Placement(visible = true, transformation(origin = {80, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch12 annotation(
    Placement(visible = true, transformation(origin = {190, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch13 annotation(
    Placement(visible = true, transformation(origin = {190, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = Modelica.Constants.inf, uMin = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.Controls.BaseControls.AuxiliaryControls.IpLimitation ipLimitation(IMaxPu = IMaxPu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {30, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min1 annotation(
    Placement(visible = true, transformation(origin = {80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {30, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = IMaxPu) annotation(
    Placement(visible = true, transformation(origin = {30, -160}, extent = {{-10, -12}, {10, 12}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-50, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = -Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-10, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  PAvailIn0Pu = if StorageFlag then -PMaxPu else 0;
  QMax0Pu = if QLimFlag then QMaxPu else max0.y;
  QMin0Pu = if QLimFlag then QMinPu else min.y;
  IPMax0Pu = switch12.y;
  IPMin0Pu = switch13.y;
  IQMax0Pu = switch11.y;
  IQMin0Pu = switch16.y;

  u0Pu=ComplexMath.fromPolar(U0Pu, UPhase0);
  Complex(P0Pu, Q0Pu) = u0Pu * ComplexMath.conj(i0Pu);
  UeRe0Pu = Ued0Pu * cos(UPhase0) - Ueq0Pu * sin(UPhase0);
  UeIm0Pu = Ued0Pu * sin(UPhase0) + Ueq0Pu * cos(UPhase0);
  Id0Pu = -P0Pu * SystemBase.SnRef / (SNom * U0Pu);
  Iq0Pu = Q0Pu * SystemBase.SnRef / (SNom * U0Pu);
  Ud0Pu = u0Pu.re * cos(UPhase0) + u0Pu.im * sin(UPhase0);
  Uq0Pu = -(u0Pu.re * sin(UPhase0)) + u0Pu.im * cos(UPhase0);

//  Complex(Ued0Pu, Ueq0Pu) = Complex(Ud0Pu, Uq0Pu) + Complex(ResPu, XesPu)*Complex(Id0Pu, Iq0Pu);
  Complex(UeRe0Pu, UeIm0Pu) = u0Pu + Complex(ResPu, XesPu)*(-i0Pu);


  connect(const1.y, combiTable1Ds.u) annotation(
    Line(points = {{-179, 60}, {-161, 60}, {-161, 80}, {-143, 80}}, color = {0, 0, 127}));
  connect(const1.y, combiTable1Ds1.u) annotation(
    Line(points = {{-179, 60}, {-161, 60}, {-161, 40}, {-143, 40}}, color = {0, 0, 127}));
  connect(const2.y, combiTable1Ds2.u) annotation(
    Line(points = {{-179, -60}, {-161, -60}, {-161, -40}, {-143, -40}}, color = {0, 0, 127}));
  connect(const2.y, combiTable1Ds3.u) annotation(
    Line(points = {{-179, -60}, {-161, -60}, {-161, -80}, {-143, -80}}, color = {0, 0, 127}));
  connect(combiTable1Ds3.y[1], max0.u2) annotation(
    Line(points = {{-119, -80}, {-101, -80}, {-101, -86}, {-63, -86}}, color = {0, 0, 127}));
  connect(combiTable1Ds2.y[1], min.u2) annotation(
    Line(points = {{-119, -40}, {-81, -40}, {-81, 74}, {-63, 74}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], max0.u1) annotation(
    Line(points = {{-119, 40}, {-101, 40}, {-101, -74}, {-63, -74}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], min.u1) annotation(
    Line(points = {{-119, 80}, {-101, 80}, {-101, 86}, {-63, 86}}, color = {0, 0, 127}));
  connect(division2.y, max.u1) annotation(
    Line(points = {{41, -20}, {49, -20}, {49, -34}, {67, -34}}, color = {0, 0, 127}));
  connect(booleanExpression7.y, switch16.u2) annotation(
    Line(points = {{140, 97}, {140, 0}, {178, 0}}, color = {255, 0, 255}));
  connect(ipLimitation.iPMaxPu, switch12.u1) annotation(
    Line(points = {{41, -115}, {109, -115}, {109, -92}, {178, -92}}, color = {0, 0, 127}));
  connect(division1.y, min3.u1) annotation(
    Line(points = {{41, 20}, {59, 20}, {59, 64}, {67, 64}}, color = {0, 0, 127}));
  connect(limiter.y, division1.u2) annotation(
    Line(points = {{1, 0}, {12, 0}, {12, 14}, {18, 14}}, color = {0, 0, 127}));
  connect(realExpression.y, min3.u3) annotation(
    Line(points = {{41, 96}, {59, 96}, {59, 76}, {67, 76}}, color = {0, 0, 127}));
  connect(iqLimitation.iQMaxPu, min3.u2) annotation(
    Line(points = {{41, 80}, {49, 80}, {49, 70}, {67, 70}}, color = {0, 0, 127}));
  connect(realExpression4.y, min1.u1) annotation(
    Line(points = {{41, 40}, {49, 40}, {49, 26}, {67, 26}}, color = {0, 0, 127}));
  connect(booleanExpression7.y, switch13.u2) annotation(
    Line(points = {{140, 97}, {140, -140}, {178, -140}}, color = {255, 0, 255}));
  connect(realExpression2.y, switch12.u3) annotation(
    Line(points = {{41, -160}, {129, -160}, {129, -108}, {178, -108}}, color = {0, 0, 127}));
  connect(booleanExpression7.y, switch11.u2) annotation(
    Line(points = {{140, 97}, {140, 60}, {178, 60}}, color = {255, 0, 255}));
  connect(division1.y, min1.u2) annotation(
    Line(points = {{41, 20}, {49, 20}, {49, 14}, {67, 14}}, color = {0, 0, 127}));
  connect(gain3.y, switch16.u3) annotation(
    Line(points = {{160, 15}, {160, 8}, {178, 8}}, color = {0, 0, 127}));
  connect(realExpression10.y, max.u2) annotation(
    Line(points = {{41, -47}, {67, -47}}, color = {0, 0, 127}));
  connect(limiter.y, division2.u2) annotation(
    Line(points = {{1, 0}, {11, 0}, {11, -14}, {18, -14}}, color = {0, 0, 127}));
  connect(ipLimitation.iPMinPu, switch13.u1) annotation(
    Line(points = {{41, -125}, {109, -125}, {109, -132}, {178, -132}}, color = {0, 0, 127}));
  connect(booleanExpression7.y, switch12.u2) annotation(
    Line(points = {{140, 97}, {140, -100}, {178, -100}}, color = {255, 0, 255}));
  connect(realExpression2.y, gain.u) annotation(
    Line(points = {{41, -160}, {135, -160}}, color = {0, 0, 127}));
  connect(gain.y, switch13.u3) annotation(
    Line(points = {{161, -160}, {162, -160}, {162, -148}, {178, -148}}, color = {0, 0, 127}));
  connect(constant1.y, iqLimitation.iPcmdPu) annotation(
    Line(points = {{-39, 140}, {0, 140}, {0, 80}, {18, 80}}, color = {0, 0, 127}));
  connect(const1.y, limiter.u) annotation(
    Line(points = {{-178, 60}, {-160, 60}, {-160, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(min.y, division1.u1) annotation(
    Line(points = {{-38, 80}, {-20, 80}, {-20, 26}, {18, 26}}, color = {0, 0, 127}));
  connect(max0.y, division2.u1) annotation(
    Line(points = {{-38, -80}, {-20, -80}, {-20, -26}, {18, -26}}, color = {0, 0, 127}));
  connect(constant2.y, ipLimitation.iQcmdPu) annotation(
    Line(points = {{2, -120}, {18, -120}}, color = {0, 0, 127}));
  connect(min3.y, switch11.u3) annotation(
    Line(points = {{92, 70}, {160, 70}, {160, 68}, {178, 68}}, color = {0, 0, 127}));
  connect(min1.y, switch11.u1) annotation(
    Line(points = {{92, 20}, {120, 20}, {120, 52}, {178, 52}}, color = {0, 0, 127}));
  connect(min3.y, gain3.u) annotation(
    Line(points = {{92, 70}, {160, 70}, {160, 29}}, color = {0, 0, 127}));
  connect(max.y, switch16.u1) annotation(
    Line(points = {{92, -40}, {160, -40}, {160, -8}, {178, -8}}, color = {0, 0, 127}));

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})));
end ConverterVoltageSourceIEC63406_INIT;
