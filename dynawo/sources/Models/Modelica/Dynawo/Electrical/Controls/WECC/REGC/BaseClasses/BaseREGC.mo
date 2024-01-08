within Dynawo.Electrical.Controls.WECC.REGC.BaseClasses;

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

partial model BaseREGC "WECC Renewable Energy Generator Converter base model"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.BaseREGCParameters;

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = uInj0Pu.re), im(start = uInj0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(origin = {310, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput frtOn(start = false) "Boolean signal for iq ramp after fault: true if FRT detected, false otherwise" annotation(
    Placement(visible = true, transformation(origin = {-280, 220}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = Ip0Pu) "Active current setpoint from electrical control in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Iq0Pu) "Reactive current setpoint from electrical control in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput PInjPu(start = PInj0Pu) "Active power at injector in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {310, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QInjPu(start = QInj0Pu) "Reactive power at injector in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {310, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UInjPu(start = UInj0Pu) "Voltage module at injector in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {310, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uInjPu(re(start = uInj0Pu.re), im(start = uInj0Pu.im)) "Complex voltage at injector in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {310, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.MathBoolean.OffDelay offDelay(tDelay = max(abs(1 / IqrMaxPu), abs(1 / IqrMinPu))) annotation(
    Placement(visible = true, transformation(origin = {-250, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = IqrMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-130, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-70, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = IqrMinPu) annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze(UseRateLim = true) annotation(
    Placement(visible = true, transformation(origin = {-10, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 9999) annotation(
    Placement(visible = true, transformation(origin = {-130, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-70, 80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = -9999) annotation(
    Placement(visible = true, transformation(origin = {-130, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze1(UseRateLim = true) annotation(
    Placement(visible = true, transformation(origin = {-10, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tFilterGC, y_start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const4(k = RrpwrPu) annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const5(k = -RrpwrPu) annotation(
    Placement(visible = true, transformation(origin = {-70, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {-130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant annotation(
    Placement(visible = true, transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const6 annotation(
    Placement(visible = true, transformation(origin = {-190, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Vt(y = UInjPu) annotation(
    Placement(visible = true, transformation(origin = {-310, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = QInj0Pu > 0)  annotation(
    Placement(visible = true, transformation(origin = {-250, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant2(k = QInj0Pu < 0)  annotation(
    Placement(visible = true, transformation(origin = {-250, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(origin = {-170, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.And and2 annotation(
    Placement(visible = true, transformation(origin = {-170, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit Ip0Pu "Start value of active current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit Iq0Pu "Start value of reactive current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu UInj0Pu "Start value of voltage module at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexVoltagePu uInj0Pu "Start value of complex voltage at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));

equation
  connect(frtOn, offDelay.u) annotation(
    Line(points = {{-280, 220}, {-280, 180}, {-264, 180}}, color = {255, 0, 255}));
  connect(switch.y, rateLimFirstOrderFreeze.dyMax) annotation(
    Line(points = {{-58, 160}, {-40, 160}, {-40, 126}, {-22, 126}}, color = {0, 0, 127}));
  connect(switch1.y, rateLimFirstOrderFreeze.dyMin) annotation(
    Line(points = {{-58, 80}, {-40, 80}, {-40, 114}, {-22, 114}}, color = {0, 0, 127}));
  connect(iqCmdPu, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-320, 120}, {-22, 120}}, color = {0, 0, 127}));
  connect(const.y, switch.u1) annotation(
    Line(points = {{-118, 180}, {-100, 180}, {-100, 168}, {-82, 168}}, color = {0, 0, 127}));
  connect(const3.y, switch1.u1) annotation(
    Line(points = {{-118, 60}, {-100, 60}, {-100, 72}, {-82, 72}}, color = {0, 0, 127}));
  connect(const1.y, switch.u3) annotation(
    Line(points = {{-118, 140}, {-100, 140}, {-100, 152}, {-82, 152}}, color = {0, 0, 127}));
  connect(const2.y, switch1.u3) annotation(
    Line(points = {{-118, 100}, {-100, 100}, {-100, 88}, {-82, 88}}, color = {0, 0, 127}));
  connect(const4.y, rateLimFirstOrderFreeze1.dyMax) annotation(
    Line(points = {{-58, -80}, {-40, -80}, {-40, -114}, {-22, -114}}, color = {0, 0, 127}));
  connect(const5.y, rateLimFirstOrderFreeze1.dyMin) annotation(
    Line(points = {{-58, -160}, {-40, -160}, {-40, -126}, {-22, -126}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch2.u2) annotation(
    Line(points = {{-178, -40}, {-142, -40}}, color = {255, 0, 255}));
  connect(const6.y, switch2.u3) annotation(
    Line(points = {{-178, -80}, {-160, -80}, {-160, -48}, {-142, -48}}, color = {0, 0, 127}));
  connect(Vt.y, firstOrder.u) annotation(
    Line(points = {{-298, 0}, {-262, 0}}, color = {0, 0, 127}));
  connect(and1.y, switch.u2) annotation(
    Line(points = {{-158, 160}, {-82, 160}}, color = {255, 0, 255}));
  connect(and2.y, switch1.u2) annotation(
    Line(points = {{-158, 80}, {-82, 80}}, color = {255, 0, 255}));
  connect(offDelay.y, and1.u1) annotation(
    Line(points = {{-238, 180}, {-200, 180}, {-200, 160}, {-182, 160}}, color = {255, 0, 255}));
  connect(offDelay.y, and2.u1) annotation(
    Line(points = {{-238, 180}, {-200, 180}, {-200, 80}, {-182, 80}}, color = {255, 0, 255}));
  connect(booleanConstant2.y, and2.u2) annotation(
    Line(points = {{-238, 60}, {-220, 60}, {-220, 72}, {-182, 72}}, color = {255, 0, 255}));
  connect(booleanConstant1.y, and1.u2) annotation(
    Line(points = {{-238, 140}, {-220, 140}, {-220, 152}, {-182, 152}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-300, -200}, {300, 200}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-23, 52}, extent = {{-57, 58}, {103, -102}}, textString = "Generator Converter"), Text(origin = {-158, 78}, extent = {{-22, 16}, {36, -28}}, textString = "iqCmdPu"), Text(origin = {-158, -66}, extent = {{-22, 16}, {36, -28}}, textString = "ipCmdPu"), Text(origin = {-158, 18}, extent = {{-22, 16}, {36, -28}}, textString = "frtOn")}));
end BaseREGC;
