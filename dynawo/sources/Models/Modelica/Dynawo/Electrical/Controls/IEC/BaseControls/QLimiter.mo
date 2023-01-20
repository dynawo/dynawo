within Dynawo.Electrical.Controls.IEC.BaseControls;

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

model QLimiter "Reactive power limitation module for wind turbines (IEC N°61400-27-1)"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  extends Dynawo.Electrical.Controls.IEC.Parameters.QLimitParameters;

  //Nominal parameters
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

  //QLimiter parameters
  parameter Boolean QlConst "True if limits are constant" annotation(
    Dialog(tab = "QLimiter"));
  parameter Types.ReactivePowerPu QMaxPu "Constant maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "QLimiter"));
  parameter Types.ReactivePowerPu QMinPu "Constant minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "QLimiter"));

  //Input variables
  Modelica.Blocks.Interfaces.IntegerInput fFrt(start = 0) "Fault status (0: Normal operation, 1: During fault, 2: Post-fault)" annotation(
    Placement(visible = true, transformation(origin = {-140, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCFiltPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-140, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWTCFiltPu(start = -P0Pu* SystemBase.SnRef / SNom) "Filtered active power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-140, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput QWTMaxPu(start = QMax0Pu) "Maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QWTMinPu(start = QMin0Pu) "Minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {90,60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
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
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFeedthroughFreeze absLimRateLimFeedthroughFreeze(DyMax = 999, Y0 = U0Pu, YMax = 999, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFeedthroughFreeze absLimRateLimFeedthroughFreeze1(DyMax = 999, Y0 = -P0Pu * SystemBase.SnRef / SNom, YMax = 999, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ReactivePowerPu QMax0Pu "Initial maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu QMin0Pu "Initial minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(integerToBoolean.y, absLimRateLimFeedthroughFreeze1.freeze) annotation(
    Line(points = {{-78, 0}, {-70, 0}, {-70, -48}}, color = {255, 0, 255}));
  connect(integerToBoolean.y, absLimRateLimFeedthroughFreeze.freeze) annotation(
    Line(points = {{-78, 0}, {-70, 0}, {-70, 50}}, color = {255, 0, 255}));
  connect(UWTCFiltPu, absLimRateLimFeedthroughFreeze.u) annotation(
    Line(points = {{-140, 60}, {-80, 60}}, color = {0, 0, 127}));
  connect(PWTCFiltPu, absLimRateLimFeedthroughFreeze1.u) annotation(
    Line(points = {{-140, -60}, {-80, -60}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreeze1.y, combiTable1Ds3.u) annotation(
    Line(points = {{-58, -60}, {-50, -60}, {-50, -80}, {-42, -80}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreeze1.y, combiTable1Ds2.u) annotation(
    Line(points = {{-58, -60}, {-50, -60}, {-50, -40}, {-42, -40}}, color = {0, 0, 127}));
  connect(combiTable1Ds3.y[1], max.u2) annotation(
    Line(points = {{-18, -80}, {0, -80}, {0, -86}, {38, -86}}, color = {0, 0, 127}));
  connect(fFrt, integerToBoolean.u) annotation(
    Line(points = {{-140, 0}, {-102, 0}}, color = {255, 127, 0}));
  connect(absLimRateLimFeedthroughFreeze.y, combiTable1Ds.u) annotation(
    Line(points = {{-58, 60}, {-50, 60}, {-50, 80}, {-42, 80}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreeze.y, combiTable1Ds1.u) annotation(
    Line(points = {{-58, 60}, {-50, 60}, {-50, 40}, {-42, 40}}, color = {0, 0, 127}));
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
    Icon(graphics = {Rectangle( fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {27, 17}, extent = {{-57, 51}, {3, 11}}, textString = "Q"), Text(origin = {-37, 43}, extent = {{-53, 49}, {127, -133}}, textString = "limitation"), Text(origin = {-3, -53}, extent = {{-53, 49}, {61, -39}}, textString = "module")}, coordinateSystem(initialScale = 0.1)));
end QLimiter;
