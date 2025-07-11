within Dynawo.Electrical.Wind.IEC.WT;

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

model WT4CurrentSource_INIT "Wind Turbine Type 4 model from IEC 61400-27-1 standard : initialization model"
  extends AdditionalIcons.Init;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.QLimitParameters;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.CurrentLimitParameters;

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Circuit parameters
  parameter Types.PerUnit BesPu "Shunt susceptance in pu (base UNom, SNom)";
  parameter Types.PerUnit GesPu "Shunt conductance in pu (base UNom, SNom)";
  parameter Types.PerUnit ResPu "Serial resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XesPu "Serial reactance in pu (base UNom, SNom)";

  //Current limiter parameters
  parameter Types.CurrentModulePu IMaxPu "Maximum current at converter terminal in pu (base UNom, SNom)";
  parameter Types.PerUnit Kpqu "Partial derivative of reactive current limit against voltage in pu (base UNom, SNom)";
  parameter Types.VoltageModulePu UpquMaxPu "WT voltage in the operation point where zero reactive power can be delivered, in pu (base UNom)";

  //QControl parameter
  parameter Integer MqG "General Q control mode (0-4): Voltage control (0), Reactive power control (1), Open loop reactive power control (2), Power factor control (3), Open loop power factor control (4)";

  //QLimiter parameters
  parameter Boolean QlConst "True if limits are constant";
  parameter Types.ReactivePowerPu QMaxPu "Constant maximum reactive power at grid terminal in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QMinPu "Constant minimum reactive power at grid terminal in pu (base SNom) (generator convention)";

  Types.PerUnit IpMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IqMax0Pu "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IqMin0Pu "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit UGsRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)";
  Types.PerUnit UGsIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)";
  Types.PerUnit IGsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IGsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)";
  Types.ActivePowerPu PAg0Pu "Initial active power at converter terminal in pu (base SNom) (generator convention)";
  Types.ReactivePowerPu QMax0Pu "Initial maximum reactive power at grid terminal in pu (base SNom)";
  Types.ReactivePowerPu QMin0Pu "Initial minimum reactive power at grid terminal in pu (base SNom)";
  Types.PerUnit XWT0Pu "Initial reactive power or voltage reference at grid terminal in pu (base SNom or UNom) (generator convention)";
  Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)";
  Types.ComplexCurrentPu i0Pu "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)";

  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds2(table = TableQMaxPwtcFilt) annotation(
    Placement(visible = true, transformation(origin = {110, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max0 annotation(
    Placement(visible = true, transformation(origin = {190, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds1(table = TableQMinUwtcFilt) annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table = TableQMaxUwtcFilt) annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds3(table = TableQMinPwtcFilt) annotation(
    Placement(visible = true, transformation(origin = {110, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {50, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds4(table = TableIpMaxUwt) annotation(
    Placement(visible = true, transformation(origin = {-150, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {10, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.SqrtNoEvent sqrtNoEvent annotation(
    Placement(visible = true, transformation(origin = {110, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max1 annotation(
    Placement(visible = true, transformation(origin = {70, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {50, 140}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {10, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min1 annotation(
    Placement(visible = true, transformation(origin = {150, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {30, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min2 annotation(
    Placement(visible = true, transformation(origin = {-30, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-190, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-70, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {170, 130}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Max max3 annotation(
    Placement(visible = true, transformation(origin = {190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kpqu) annotation(
    Placement(visible = true, transformation(origin = {130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const4(k = UpquMaxPu) annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = IMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds5(table = TableIqMaxUwt) annotation(
    Placement(visible = true, transformation(origin = {90, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const5(k = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.Product product1(useConjugateInput2 = true) annotation(
    Placement(visible = true, transformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal annotation(
    Placement(visible = true, transformation(origin = {-50, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexExpression complexExpr(y = Complex(UGsRe0Pu, UGsIm0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-170, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexExpression complexExpr1(y = Complex(IGsRe0Pu, IGsIm0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-170, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {90, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Load flow parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad";

equation
  XWT0Pu = if MqG == 0 then U0Pu else -Q0Pu * SystemBase.SnRef / SNom;
  QMax0Pu = if QlConst then QMaxPu else max0.y;
  QMin0Pu = if QlConst then QMinPu else min.y;
  IpMax0Pu = combiTable1Ds4.y[1];
  IqMax0Pu = min1.y;
  IqMin0Pu = max3.y;
  IGsRe0Pu = (-P0Pu * SystemBase.SnRef / (SNom * U0Pu)) * cos(UPhase0) - Q0Pu * SystemBase.SnRef / (SNom * U0Pu) * sin(UPhase0);
  IGsIm0Pu = (-P0Pu * SystemBase.SnRef / (SNom * U0Pu)) * sin(UPhase0) + Q0Pu * SystemBase.SnRef / (SNom * U0Pu) * cos(UPhase0);
  u0Pu = Complex(UGsRe0Pu, UGsIm0Pu) - Complex(ResPu, XesPu) * (-i0Pu * SystemBase.SnRef / SNom);
  Complex(IGsRe0Pu, IGsIm0Pu) = (-i0Pu * SystemBase.SnRef / SNom) + Complex(GesPu, BesPu) * Complex(UGsRe0Pu, UGsIm0Pu);
  u0Pu = Modelica.ComplexMath.fromPolar(U0Pu, UPhase0);
  PAg0Pu = complexToReal.re;

  connect(const1.y, combiTable1Ds.u) annotation(
    Line(points = {{62, -40}, {80, -40}, {80, -20}, {98, -20}}, color = {0, 0, 127}));
  connect(const1.y, combiTable1Ds1.u) annotation(
    Line(points = {{62, -40}, {80, -40}, {80, -60}, {98, -60}}, color = {0, 0, 127}));
  connect(const2.y, combiTable1Ds2.u) annotation(
    Line(points = {{62, -160}, {80, -160}, {80, -140}, {98, -140}}, color = {0, 0, 127}));
  connect(const2.y, combiTable1Ds3.u) annotation(
    Line(points = {{62, -160}, {80, -160}, {80, -180}, {98, -180}}, color = {0, 0, 127}));
  connect(combiTable1Ds3.y[1], max0.u2) annotation(
    Line(points = {{122, -180}, {140, -180}, {140, -186}, {178, -186}}, color = {0, 0, 127}));
  connect(combiTable1Ds2.y[1], min.u2) annotation(
    Line(points = {{122, -140}, {160, -140}, {160, -26}, {178, -26}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], max0.u1) annotation(
    Line(points = {{122, -60}, {140, -60}, {140, -174}, {178, -174}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], min.u1) annotation(
    Line(points = {{122, -20}, {140, -20}, {140, -14}, {178, -14}}, color = {0, 0, 127}));
  connect(sqrtNoEvent.y, min1.u1) annotation(
    Line(points = {{122, 180}, {130, 180}, {130, 186}, {138, 186}}, color = {0, 0, 127}));
  connect(max1.y, sqrtNoEvent.u) annotation(
    Line(points = {{82, 180}, {98, 180}}, color = {0, 0, 127}));
  connect(constant1.y, max1.u1) annotation(
    Line(points = {{42, 180}, {50, 180}, {50, 186}, {58, 186}}, color = {0, 0, 127}));
  connect(gain1.y, max3.u2) annotation(
    Line(points = {{141, 20}, {170, 20}, {170, 14}, {178, 14}}, color = {0, 0, 127}));
  connect(feedback.y, max1.u2) annotation(
    Line(points = {{50, 150}, {50, 174}, {58, 174}}, color = {0, 0, 127}));
  connect(product.y, feedback.u2) annotation(
    Line(points = {{22, 140}, {42, 140}}, color = {0, 0, 127}));
  connect(min2.y, product.u1) annotation(
    Line(points = {{-18, 140}, {-10, 140}, {-10, 146}, {-2, 146}}, color = {0, 0, 127}));
  connect(const3.y, min2.u1) annotation(
    Line(points = {{-58, 140}, {-50, 140}, {-50, 146}, {-42, 146}}, color = {0, 0, 127}));
  connect(const.y, combiTable1Ds4.u) annotation(
    Line(points = {{-178, 100}, {-162, 100}}, color = {0, 0, 127}));
  connect(combiTable1Ds4.y[1], min2.u2) annotation(
    Line(points = {{-138, 100}, {-50, 100}, {-50, 134}, {-42, 134}}, color = {0, 0, 127}));
  connect(product2.y, feedback.u1) annotation(
    Line(points = {{22, 80}, {50, 80}, {50, 132}}, color = {0, 0, 127}));
  connect(constant2.y, product2.u1) annotation(
    Line(points = {{-18, 80}, {-10, 80}, {-10, 86}, {-2, 86}}, color = {0, 0, 127}));
  connect(constant2.y, product2.u2) annotation(
    Line(points = {{-18, 80}, {-10, 80}, {-10, 74}, {-2, 74}}, color = {0, 0, 127}));
  connect(min2.y, product.u2) annotation(
    Line(points = {{-18, 140}, {-10, 140}, {-10, 134}, {-2, 134}}, color = {0, 0, 127}));
  connect(const5.y, combiTable1Ds5.u) annotation(
    Line(points = {{62, 60}, {78, 60}}, color = {0, 0, 127}));
  connect(combiTable1Ds5.y[1], min1.u2) annotation(
    Line(points = {{102, 60}, {130, 60}, {130, 174}, {138, 174}}, color = {0, 0, 127}));
  connect(product1.y, complexToReal.u) annotation(
    Line(points = {{-98, -100}, {-62, -100}}, color = {85, 170, 255}));
  connect(complexExpr.y, product1.u1) annotation(
    Line(points = {{-158, -60}, {-140, -60}, {-140, -94}, {-122, -94}}, color = {85, 170, 255}));
  connect(complexExpr1.y, product1.u2) annotation(
    Line(points = {{-158, -140}, {-140, -140}, {-140, -106}, {-122, -106}}, color = {85, 170, 255}));
  connect(min1.y, gain.u) annotation(
    Line(points = {{162, 180}, {170, 180}, {170, 142}}, color = {0, 0, 127}));
  connect(gain.y, max3.u1) annotation(
    Line(points = {{170, 120}, {170, 26}, {178, 26}}, color = {0, 0, 127}));
  connect(add.y, gain1.u) annotation(
    Line(points = {{101, 20}, {118, 20}}, color = {0, 0, 127}));
  connect(const4.y, add.u2) annotation(
    Line(points = {{61, 20}, {70, 20}, {70, 14}, {78, 14}}, color = {0, 0, 127}));
  connect(const5.y, add.u1) annotation(
    Line(points = {{62, 60}, {70, 60}, {70, 26}, {78, 26}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})));
end WT4CurrentSource_INIT;
