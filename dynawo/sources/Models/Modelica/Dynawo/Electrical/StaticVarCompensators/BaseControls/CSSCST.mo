within Dynawo.Electrical.StaticVarCompensators.BaseControls;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model CSSCST "Static var compensator control model with voltage override as susceptance command for switched shunts"
  import Modelica;
  import Dynawo;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Types;

  parameter Real BMax "Maximum capacitive output of the SVarC in S";
  parameter Real BMin "Maximum inductive output of the SVarC in S";
  parameter Types.PerUnit K "Control gain constant";
  parameter Types.Time t3 "Control lag time constant in s";
  parameter Types.Time t5 "Thyristor bridge time constant in s";
  parameter Types.VoltageModulePu UOvPu "Overvoltage threshold in pu (base UNom)";
  parameter Real VMax "Maximum capacitive range of the SVarC in kV";
  parameter Real VMin "Maximum inductive range of the SVarC in kV";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput BRefPu(start = BRef0Pu) "Reference susceptance in pu (base UNom, SBase = 1)" annotation(
    Placement(visible = true, transformation(origin = {-180, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -26}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UOtherPu(start = 0) "Other input signals in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -76}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage amplitude at terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 76}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = U0Pu) "Reference voltage amplitude at terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 26}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput BVarPu(start = BVar0Pu) "Susceptance command in pu (base UNom, SnRef)" annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain PuConversion(k = 1 / SystemBase.SnRef) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = -1, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(K = K, YMax = VMax, YMin = VMin, tFilter = t3) annotation(
    Placement(visible = true, transformation(origin = {-30, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder1(YMax = BMax, YMin = BMin, tFilter = t5) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {10, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = BMax) annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = BMin) annotation(
    Placement(visible = true, transformation(origin = {-70, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold = -UOvPu) annotation(
    Placement(visible = true, transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold(threshold = UOvPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-120, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu U0Pu "Initial value of voltage amplitude at terminal in pu (base UNom)";
  parameter Types.PerUnit BVar0Pu "Initial value of susceptance command in pu (base UNom, SnRef)";

  final parameter Types.PerUnit BRef0Pu = -BVar0Pu * SystemBase.SnRef / K "Susceptance reference in pu (base UNom, SBase = 1)";

equation
  connect(PuConversion.y, BVarPu) annotation(
    Line(points = {{141, 0}, {170, 0}}, color = {0, 0, 127}));
  connect(UOtherPu, add3.u1) annotation(
    Line(points = {{-180, 100}, {-100, 100}, {-100, 68}, {-82, 68}}, color = {0, 0, 127}));
  connect(BRefPu, add3.u2) annotation(
    Line(points = {{-180, 60}, {-82, 60}}, color = {0, 0, 127}));
  connect(URefPu, feedback.u1) annotation(
    Line(points = {{-180, -20}, {-128, -20}}, color = {0, 0, 127}));
  connect(UPu, feedback.u2) annotation(
    Line(points = {{-180, -60}, {-120, -60}, {-120, -28}}, color = {0, 0, 127}));
  connect(feedback.y, add3.u3) annotation(
    Line(points = {{-111, -20}, {-100, -20}, {-100, 52}, {-82, 52}}, color = {0, 0, 127}));
  connect(feedback.y, greaterEqualThreshold.u) annotation(
    Line(points = {{-111, -20}, {-82, -20}}, color = {0, 0, 127}));
  connect(feedback.y, lessEqualThreshold.u) annotation(
    Line(points = {{-111, -20}, {-100, -20}, {-100, 20}, {-82, 20}}, color = {0, 0, 127}));
  connect(and1.y, switch1.u2) annotation(
    Line(points = {{21, 0}, {78, 0}}, color = {255, 0, 255}));
  connect(const.y, switch.u1) annotation(
    Line(points = {{-59, -60}, {-40, -60}, {-40, -72}, {-2, -72}}, color = {0, 0, 127}));
  connect(const1.y, switch.u3) annotation(
    Line(points = {{-59, -100}, {-40, -100}, {-40, -88}, {-2, -88}}, color = {0, 0, 127}));
  connect(switch.y, switch1.u3) annotation(
    Line(points = {{21, -80}, {60, -80}, {60, -8}, {78, -8}}, color = {0, 0, 127}));
  connect(limitedFirstOrder1.y, switch1.u1) annotation(
    Line(points = {{21, 60}, {60, 60}, {60, 8}, {78, 8}}, color = {0, 0, 127}));
  connect(add3.y, limitedFirstOrder.u) annotation(
    Line(points = {{-59, 60}, {-43, 60}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, limitedFirstOrder1.u) annotation(
    Line(points = {{-19, 60}, {-2, 60}}, color = {0, 0, 127}));
  connect(switch1.y, PuConversion.u) annotation(
    Line(points = {{101, 0}, {117, 0}}, color = {0, 0, 127}));
  connect(greaterEqualThreshold.y, switch.u2) annotation(
    Line(points = {{-59, -20}, {-20, -20}, {-20, -80}, {-3, -80}}, color = {255, 0, 255}));
  connect(lessEqualThreshold.y, and1.u1) annotation(
    Line(points = {{-58, 20}, {-20, 20}, {-20, 0}, {-2, 0}}, color = {255, 0, 255}));
  connect(greaterEqualThreshold.y, and1.u2) annotation(
    Line(points = {{-58, -20}, {-20, -20}, {-20, -8}, {-2, -8}}, color = {255, 0, 255}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, -120}, {160, 120}})));
end CSSCST;
