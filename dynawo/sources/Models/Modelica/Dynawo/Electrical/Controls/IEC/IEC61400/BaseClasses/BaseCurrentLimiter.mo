within Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses;

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

partial model BaseCurrentLimiter "Current limitation base module for wind turbines (IEC N°61400-27-1)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.CurrentLimitParameters;

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Current limiter parameters
  parameter Types.CurrentModulePu IMaxPu "Maximum current module at converter terminal in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.CurrentModulePu IMaxDipPu "Maximum current module during voltage dip at converter terminal in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.PerUnit Kpqu "Partial derivative of reactive current limit against voltage in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Boolean MdfsLim "Limitation of type 3 stator current (false: total current limitation, true: stator current limitation)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Boolean Mqpri "Prioritization of reactive power during FRT (false: active power priority, true: reactive power priority)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.VoltageModulePu UpquMaxPu "WT voltage in the operation point where zero reactive power can be delivered, in pu (base UNom)" annotation(
    Dialog(tab = "CurrentLimiter"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-320, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-320, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaGenPu(start = SystemBase.omegaRef0Pu) "Generator angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = IpMax0Pu) "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {310, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu(start = IqMax0Pu) "Maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {310, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu(start = IqMin0Pu) "Minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {310, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gain1(k = Kpqu) annotation(
    Placement(visible = true, transformation(origin = {90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const4(k = UpquMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {140, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch switch1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {110, 100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min1 annotation(
    Placement(visible = true, transformation(origin = {70, 114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.SqrtNoEvent sqrtNoEvent annotation(
    Placement(visible = true, transformation(origin = {30, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-60, 80}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {-150, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-190, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-230, 100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = MdfsLim) annotation(
    Placement(visible = true, transformation(origin = {-290, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-270, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = Mqpri) annotation(
    Placement(visible = true, transformation(origin = {-30, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.BooleanToInteger booleanToInteger annotation(
    Placement(visible = true, transformation(origin = {10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathInteger.Product product1(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch switch2(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = IMaxDipPu) annotation(
    Placement(visible = true, transformation(origin = {-290, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = IMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-290, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product4 annotation(
    Placement(visible = true, transformation(origin = {210, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min4 annotation(
    Placement(visible = true, transformation(origin = {90, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.SqrtNoEvent sqrtNoEvent1 annotation(
    Placement(visible = true, transformation(origin = {30, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(visible = true, transformation(origin = {-100, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Abs abs annotation(
    Placement(visible = true, transformation(origin = {-270, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min3 annotation(
    Placement(visible = true, transformation(origin = {-210, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds1(table = TableIpMaxUwt) annotation(
    Placement(visible = true, transformation(origin = {-250, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table = TableIqMaxUwt) annotation(
    Placement(visible = true, transformation(origin = {-250, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product3 annotation(
    Placement(visible = true, transformation(origin = {-150, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-110, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max1 annotation(
    Placement(visible = true, transformation(origin = {-30, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const5(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-70, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {-10, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-50, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(visible = true, transformation(origin = {270, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max2 annotation(
    Placement(visible = true, transformation(origin = {170, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch switch4(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {130, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit IpMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IqMax0Pu "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IqMin0Pu "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(booleanConstant1.y, booleanToInteger.u) annotation(
    Line(points = {{-18, 20}, {-2, 20}}, color = {255, 0, 255}));
  connect(iqCmdPu, abs.u) annotation(
    Line(points = {{-320, -140}, {-282, -140}}, color = {0, 0, 127}));
  connect(product3.y, feedback4.u2) annotation(
    Line(points = {{-138, -140}, {-100, -140}, {-100, -128}}, color = {0, 0, 127}));
  connect(feedback4.y, max1.u1) annotation(
    Line(points = {{-90, -120}, {-60, -120}, {-60, -114}, {-42, -114}}, color = {0, 0, 127}));
  connect(const5.y, max1.u2) annotation(
    Line(points = {{-58, -140}, {-50, -140}, {-50, -126}, {-42, -126}}, color = {0, 0, 127}));
  connect(max1.y, sqrtNoEvent1.u) annotation(
    Line(points = {{-18, -120}, {18, -120}}, color = {0, 0, 127}));
  connect(product4.y, ipMaxPu) annotation(
    Line(points = {{222, -100}, {310, -100}}, color = {0, 0, 127}));
  connect(sqrtNoEvent1.y, min4.u2) annotation(
    Line(points = {{42, -120}, {60, -120}, {60, -126}, {78, -126}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], min4.u1) annotation(
    Line(points = {{-239, -100}, {60, -100}, {60, -114}, {78, -114}}, color = {0, 0, 127}));
  connect(product1.y, switch1.f) annotation(
    Line(points = {{62, 40}, {110, 40}, {110, 88}}, color = {255, 127, 0}));
  connect(booleanToInteger.y, product1.u[2]) annotation(
    Line(points = {{22, 20}, {30, 20}, {30, 40}, {40, 40}}, color = {255, 127, 0}));
  connect(min1.y, switch1.u[1]) annotation(
    Line(points = {{81, 114}, {90, 114}, {90, 100}, {100, 100}}, color = {0, 0, 127}));
  connect(sqrtNoEvent.y, min1.u1) annotation(
    Line(points = {{42, 120}, {58, 120}}, color = {0, 0, 127}));
  connect(max.y, sqrtNoEvent.u) annotation(
    Line(points = {{2, 120}, {18, 120}}, color = {0, 0, 127}));
  connect(const1.y, max.u1) annotation(
    Line(points = {{-38, 140}, {-30, 140}, {-30, 126}, {-22, 126}}, color = {0, 0, 127}));
  connect(feedback.y, max.u2) annotation(
    Line(points = {{-60, 89}, {-60, 114}, {-22, 114}}, color = {0, 0, 127}));
  connect(product.y, feedback.u2) annotation(
    Line(points = {{-98, 140}, {-80, 140}, {-80, 80}, {-68, 80}}, color = {0, 0, 127}));
  connect(min3.y, product3.u1) annotation(
    Line(points = {{-198, -140}, {-180, -140}, {-180, -134}, {-162, -134}}, color = {0, 0, 127}));
  connect(min3.y, product3.u2) annotation(
    Line(points = {{-198, -140}, {-180, -140}, {-180, -146}, {-162, -146}}, color = {0, 0, 127}));
  connect(min.y, product.u1) annotation(
    Line(points = {{-138, 140}, {-130, 140}, {-130, 146}, {-122, 146}}, color = {0, 0, 127}));
  connect(min.y, product.u2) annotation(
    Line(points = {{-138, 140}, {-130, 140}, {-130, 134}, {-122, 134}}, color = {0, 0, 127}));
  connect(ipCmdPu, division.u1) annotation(
    Line(points = {{-320, 140}, {-290, 140}, {-290, 146}, {-202, 146}}, color = {0, 0, 127}));
  connect(switch.y, division.u2) annotation(
    Line(points = {{-219, 100}, {-210, 100}, {-210, 134}, {-202, 134}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch.u2) annotation(
    Line(points = {{-278, 100}, {-242, 100}}, color = {255, 0, 255}));
  connect(omegaGenPu, switch.u1) annotation(
    Line(points = {{-320, 80}, {-250, 80}, {-250, 92}, {-242, 92}}, color = {0, 0, 127}));
  connect(switch.y, product4.u1) annotation(
    Line(points = {{-219, 100}, {-100, 100}, {-100, -40}, {180, -40}, {180, -94}, {198, -94}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], min.u2) annotation(
    Line(points = {{-238, -100}, {-170, -100}, {-170, 134}, {-162, 134}}, color = {0, 0, 127}));
  connect(product2.y, feedback4.u1) annotation(
    Line(points = {{-139, 0}, {-120, 0}, {-120, -120}, {-108, -120}}, color = {0, 0, 127}));
  connect(product2.y, feedback.u1) annotation(
    Line(points = {{-139, 0}, {-60, 0}, {-60, 72}}, color = {0, 0, 127}));
  connect(const2.y, switch2.u[1]) annotation(
    Line(points = {{-278, 20}, {-270, 20}, {-270, 4}, {-260, 4}}, color = {0, 0, 127}));
  connect(const3.y, switch2.u[2]) annotation(
    Line(points = {{-278, -20}, {-270, -20}, {-270, 0}, {-260, 0}}, color = {0, 0, 127}));
  connect(const2.y, switch2.u[3]) annotation(
    Line(points = {{-278, 20}, {-270, 20}, {-270, 4}, {-265, 4}, {-265, -4}, {-260, -4}}, color = {0, 0, 127}));
  connect(division.y, min.u1) annotation(
    Line(points = {{-178, 140}, {-170, 140}, {-170, 146}, {-162, 146}}, color = {0, 0, 127}));
  connect(const.y, switch.u3) annotation(
    Line(points = {{-258, 130}, {-250, 130}, {-250, 108}, {-242, 108}}, color = {0, 0, 127}));
  connect(abs.y, min3.u2) annotation(
    Line(points = {{-258, -140}, {-240, -140}, {-240, -146}, {-222, -146}}, color = {0, 0, 127}));
  connect(gain1.y, max2.u2) annotation(
    Line(points = {{102, -20}, {120, -20}, {120, -26}, {158, -26}}, color = {0, 0, 127}));
  connect(switch1.y, iqMaxPu) annotation(
    Line(points = {{122, 100}, {310, 100}}, color = {0, 0, 127}));
  connect(switch1.y, gain.u) annotation(
    Line(points = {{122, 100}, {140, 100}, {140, 82}}, color = {0, 0, 127}));
  connect(gain.y, max2.u1) annotation(
    Line(points = {{140, 60}, {140, -14}, {158, -14}}, color = {0, 0, 127}));
  connect(greater.y, switch3.u2) annotation(
    Line(points = {{222, 0}, {258, 0}}, color = {255, 0, 255}));
  connect(switch3.y, iqMinPu) annotation(
    Line(points = {{282, 0}, {310, 0}}, color = {0, 0, 127}));
  connect(max2.y, switch3.u1) annotation(
    Line(points = {{182, -20}, {240, -20}, {240, -8}, {258, -8}}, color = {0, 0, 127}));
  connect(max2.y, greater.u2) annotation(
    Line(points = {{182, -20}, {190, -20}, {190, -8}, {198, -8}}, color = {0, 0, 127}));
  connect(add1.y, gain1.u) annotation(
    Line(points = {{62, -20}, {78, -20}}, color = {0, 0, 127}));
  connect(const4.y, add1.u1) annotation(
    Line(points = {{2, -20}, {20, -20}, {20, -14}, {38, -14}}, color = {0, 0, 127}));
  connect(switch1.y, greater.u1) annotation(
    Line(points = {{122, 100}, {180, 100}, {180, 0}, {198, 0}}, color = {0, 0, 127}));
  connect(switch1.y, switch3.u3) annotation(
    Line(points = {{122, 100}, {240, 100}, {240, 8}, {258, 8}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], switch4.u[1]) annotation(
    Line(points = {{-238, -100}, {112, -100}, {112, -106}, {120, -106}}, color = {0, 0, 127}));
  connect(min4.y, switch4.u[2]) annotation(
    Line(points = {{102, -120}, {112, -120}, {112, -106}, {120, -106}}, color = {0, 0, 127}));
  connect(min4.y, switch4.u[3]) annotation(
    Line(points = {{102, -120}, {112, -120}, {112, -106}, {120, -106}}, color = {0, 0, 127}));
  connect(switch4.y, product4.u2) annotation(
    Line(points = {{141, -106}, {198, -106}}, color = {0, 0, 127}));
  connect(product1.y, switch4.f) annotation(
    Line(points = {{62, 40}, {130, 40}, {130, -94}}, color = {255, 127, 0}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-300, -160}, {300, 160}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {-36, 96}, extent = {{-43, 23}, {107, -90}}, textString = "Current"), Text(origin = {-32, 29}, extent = {{-61, 49}, {125, -106}}, textString = "Limitation"), Text(origin = {-35, -65}, extent = {{-55, 38}, {47, -22}}, textString = "Module")}));
end BaseCurrentLimiter;
