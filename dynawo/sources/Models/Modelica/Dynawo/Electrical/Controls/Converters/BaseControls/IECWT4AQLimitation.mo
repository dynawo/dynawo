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

model IECWT4AQLimitation "IEC WT type 4A Reactive power limitation"

  import Modelica;
  import Dynawo.Types;
  import Dynawo;

  extends Dynawo.Electrical.Controls.Converters.Parameters.Params_QLimit;

  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));

  /*Parameters for internal initialization*/
  parameter Types.PerUnit QMax0Pu "Start value of the maximum reactive power (base SNom) (generator convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit QMin0Pu "Start value of the minimum reactive power (base SNom) (generator convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));

  /*Control parameters*/
  parameter Types.Time Ts "Integration time step";
  parameter Boolean QlConst "Fixed reactive power limits (1), 0 otherwise" annotation(
  Dialog(group = "group", tab = "Qlimit"));
  parameter Types.PerUnit QMax "Fixed value of the maximum reactive power (base SNom) (generator convention)" annotation(
  Dialog(group = "group", tab = "Qlimit"));
  parameter Types.PerUnit QMin "Fixed value of the minimum reactive power (base SNom) (generator convention)" annotation(
  Dialog(group = "group", tab = "Qlimit"));

  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput uWTCfiltPu(start = U0Pu) "Filtered voltage amplitude at wind turbine terminals in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pWTCfiltPu(start = -P0Pu* SystemBase.SnRef / SNom) "Filtered active power at PCC in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-160, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerInput Ffrt(start = 0) "Function of FRT state (0-2): Normal operation (0), Fault (1), Post fault (2)" annotation(
    Placement(visible = true, transformation(origin = {-160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput qWTMaxPu(start = QMax0Pu) "Maximum WTT reactive power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput qWTMinPu(start = QMin0Pu) "Maximum WTT reactive power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  /*Blocks*/
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {80,60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = QlConst)  annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = QMax)  annotation(
    Placement(visible = true, transformation(origin = {40, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = tableQMaxuWTCfilt)  annotation(
    Placement(visible = true, transformation(origin = {-40, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D1(table = tableQMinuWTCfilt)  annotation(
    Placement(visible = true, transformation(origin = {-40, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D2(table = tableQMaxpWTCfilt)  annotation(
    Placement(visible = true, transformation(origin = {-40, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D3(table = tableQMinpWTCfilt)  annotation(
    Placement(visible = true, transformation(origin = {-40, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {40, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {40, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {80, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = QMin) annotation(
    Placement(visible = true, transformation(origin = {40, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.IntegerToBoolean integerToBoolean(threshold = 1)  annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(visible = true, transformation(origin = {-80, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay1(delayTime = Ts)  annotation(
    Placement(visible = true, transformation(origin = {-100, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = Ts)  annotation(
    Placement(visible = true, transformation(origin = {-100, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation

  connect(switch.y, qWTMinPu) annotation(
    Line(points = {{92, -60}, {106, -60}, {106, -60}, {110, -60}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{12, 60}, {68, 60}}, color = {255, 0, 255}));
  connect(booleanConstant.y, switch.u2) annotation(
    Line(points = {{12, 60}, {18, 60}, {18, -60}, {68, -60}, {68, -60}}, color = {255, 0, 255}));
  connect(min.y, switch1.u3) annotation(
    Line(points = {{52, 40}, {58, 40}, {58, 52}, {68, 52}, {68, 52}}, color = {0, 0, 127}));
  connect(switch1.y, qWTMaxPu) annotation(
    Line(points = {{92, 60}, {104, 60}, {104, 60}, {110, 60}}, color = {0, 0, 127}));
  connect(max.y, switch.u3) annotation(
    Line(points = {{52, -80}, {60, -80}, {60, -68}, {68, -68}, {68, -68}}, color = {0, 0, 127}));
  connect(const.y, switch1.u1) annotation(
    Line(points = {{52, 80}, {60, 80}, {60, 68}, {68, 68}, {68, 68}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], min.u1) annotation(
    Line(points = {{-28, 80}, {-18, 80}, {-18, 46}, {28, 46}, {28, 46}}, color = {0, 0, 127}));
  connect(combiTable1D2.y[1], min.u2) annotation(
    Line(points = {{-28, -40}, {12, -40}, {12, 34}, {28, 34}, {28, 34}}, color = {0, 0, 127}));
  connect(combiTable1D1.y[1], max.u1) annotation(
    Line(points = {{-28, 40}, {4, 40}, {4, -74}, {28, -74}, {28, -74}}, color = {0, 0, 127}));
  connect(combiTable1D3.y[1], max.u2) annotation(
    Line(points = {{-28, -80}, {-16, -80}, {-16, -86}, {28, -86}, {28, -86}}, color = {0, 0, 127}));
  connect(Ffrt, integerToBoolean.u) annotation(
    Line(points = {{-160, 0}, {-141, 0}, {-141, 0}, {-142, 0}}, color = {255, 127, 0}));
  connect(switch3.y, combiTable1D3.u[1]) annotation(
    Line(points = {{-69, -80}, {-53, -80}, {-53, -80}, {-52, -80}}, color = {0, 0, 127}));
  connect(switch3.y, combiTable1D2.u[1]) annotation(
    Line(points = {{-69, -80}, {-61, -80}, {-61, -41}, {-52, -41}, {-52, -40}}, color = {0, 0, 127}));
  connect(switch2.y, combiTable1D1.u[1]) annotation(
    Line(points = {{-69, 40}, {-54, 40}, {-54, 40}, {-52, 40}}, color = {0, 0, 127}));
  connect(switch2.y, combiTable1D.u[1]) annotation(
    Line(points = {{-69, 40}, {-63, 40}, {-63, 80}, {-52, 80}, {-52, 80}}, color = {0, 0, 127}));
  connect(integerToBoolean.y, switch2.u2) annotation(
    Line(points = {{-119, 0}, {-116, 0}, {-116, 39}, {-92, 39}, {-92, 40}}, color = {255, 0, 255}));
  connect(integerToBoolean.y, switch3.u2) annotation(
    Line(points = {{-119, 0}, {-116, 0}, {-116, -80}, {-92, -80}}, color = {255, 0, 255}));
  connect(pWTCfiltPu, switch3.u3) annotation(
    Line(points = {{-160, -88}, {-92, -88}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, switch2.u3) annotation(
    Line(points = {{-160, 32}, {-92, 32}}, color = {0, 0, 127}));
  connect(switch2.y, fixedDelay.u) annotation(
    Line(points = {{-69, 40}, {-63, 40}, {-63, 80}, {-88, 80}}, color = {0, 0, 127}));
  connect(fixedDelay.y, switch2.u1) annotation(
    Line(points = {{-111, 80}, {-129, 80}, {-129, 47}, {-92, 47}, {-92, 48}}, color = {0, 0, 127}));
  connect(switch3.y, fixedDelay1.u) annotation(
    Line(points = {{-69, -80}, {-61, -80}, {-61, -41}, {-88, -41}, {-88, -40}}, color = {0, 0, 127}));
  connect(fixedDelay1.y, switch3.u1) annotation(
    Line(points = {{-111, -40}, {-129, -40}, {-129, -72}, {-92, -72}, {-92, -72}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u1) annotation(
    Line(points = {{51, -40}, {59, -40}, {59, -53}, {68, -53}, {68, -52}}, color = {0, 0, 127}));

annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-150, -100}, {100, 100}})),
    preferredView = "diagram",
    Icon(graphics = {Rectangle(origin = {-1, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {27, 17}, extent = {{-57, 51}, {3, 11}}, textString = "Q"), Text(origin = {-37, 43}, extent = {{-53, 49}, {127, -133}}, textString = "limitation"), Text(origin = {-3, -53}, extent = {{-53, 49}, {61, -39}}, textString = "module")}, coordinateSystem(initialScale = 0.1)));

end IECWT4AQLimitation;
