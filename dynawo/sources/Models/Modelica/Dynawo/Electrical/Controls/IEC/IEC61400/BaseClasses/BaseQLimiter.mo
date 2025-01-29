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

partial model BaseQLimiter "Reactive power limitation base module for wind turbines (IEC N°61400-27-1)"
  extends Dynawo.Electrical.Wind.IEC.Parameters.TableQLimit;

  //Nominal parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.SNom_;
  extends Dynawo.Electrical.Wind.IEC.Parameters.IntegrationTimeStep;

  //QLimiter parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.QLimiter;
  
  //Output variables
  Modelica.Blocks.Interfaces.RealOutput QWTMaxPu(start = QMax0Pu) "Maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QWTMinPu(start = QMin0Pu) "Minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {90, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = QlConst) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = QMaxPu) annotation(
    Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table = TableQMaxUwtcFilt) annotation(
    Placement(visible = true, transformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds1(table = TableQMinUwtcFilt) annotation(
    Placement(visible = true, transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds2(table = TableQMaxPwtcFilt) annotation(
    Placement(visible = true, transformation(origin = {-30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds3(table = TableQMinPwtcFilt) annotation(
    Placement(visible = true, transformation(origin = {-30, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {90, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = QMinPu) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.IntegerToBoolean integerToBoolean(threshold = 1) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialQLimits;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialPGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUModuleGrid;
  
equation
  connect(combiTable1Ds3.y[1], max.u2) annotation(
    Line(points = {{-18, -80}, {0, -80}, {0, -86}, {38, -86}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], min.u1) annotation(
    Line(points = {{-18, 80}, {0, 80}, {0, 86}, {38, 86}}, color = {0, 0, 127}));
  connect(min.y, switch1.u3) annotation(
    Line(points = {{62, 80}, {70, 80}, {70, 68}, {78, 68}}, color = {0, 0, 127}));
  connect(max.y, switch.u3) annotation(
    Line(points = {{62, -80}, {70, -80}, {70, -68}, {78, -68}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u1) annotation(
    Line(points = {{62, -40}, {70, -40}, {70, -52}, {78, -52}}, color = {0, 0, 127}));
  connect(const.y, switch1.u1) annotation(
    Line(points = {{62, 40}, {70, 40}, {70, 52}, {78, 52}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch.u2) annotation(
    Line(points = {{22, 0}, {30, 0}, {30, -60}, {78, -60}}, color = {255, 0, 255}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{22, 0}, {30, 0}, {30, 60}, {78, 60}}, color = {255, 0, 255}));
  connect(combiTable1Ds1.y[1], max.u1) annotation(
    Line(points = {{-18, 40}, {-12, 40}, {-12, -74}, {38, -74}}, color = {0, 0, 127}));
  connect(combiTable1Ds2.y[1], min.u2) annotation(
    Line(points = {{-18, -40}, {-8, -40}, {-8, 74}, {38, 74}}, color = {0, 0, 127}));
  connect(switch.y, QWTMinPu) annotation(
    Line(points = {{102, -60}, {130, -60}}, color = {0, 0, 127}));
  connect(switch1.y, QWTMaxPu) annotation(
    Line(points = {{102, 60}, {130, 60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-120, -100}, {120, 100}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {27, 49}, extent = {{-57, 51}, {3, 11}}, textString = "Q"), Text(origin = {-37, 81}, extent = {{-53, 49}, {127, -133}}, textString = "Limitation"), Text(origin = {-3, -9}, extent = {{-53, 49}, {61, -39}}, textString = "Module")}, coordinateSystem(initialScale = 0.1)));
end BaseQLimiter;
