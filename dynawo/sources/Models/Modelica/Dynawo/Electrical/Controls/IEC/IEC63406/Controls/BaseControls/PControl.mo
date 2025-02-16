within Dynawo.Electrical.Controls.IEC.IEC63406.Controls.BaseControls;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PControl "Active power control (IEC 63406)"

  //General parameters
  parameter Types.PerUnit PMaxPu "Maximum active power at converter terminal in pu (base SNom)" annotation(
    Dialog(tab = "StorageSys"));
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Parameters
  parameter Real KIp "Integral gain in the active power PI controller" annotation(
    Dialog(tab = "PControl"));
  parameter Real KPp "Proportional gain in the active power PI controller" annotation(
    Dialog(tab = "PControl"));
  parameter Boolean PFlag "1 for closed-loop active power control, 0 for open-loop active power control" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time TpRef "Time constant in the active power filter" annotation(
    Dialog(tab = "PControl"));

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput FFlag(start = false) "Flag indicating the generating unit operating condition" annotation(
    Placement(visible = true, transformation(origin = {-80, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-120, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iPMinPu(start = IPMin0Pu) "Minimum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {126, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {140, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iPMaxPu(start = IPMax0Pu) "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {140, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {170, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput pAvailInPu(start = PAvailIn0Pu) "Minimum output electrical power available to the active power control module in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-56, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput pAvailOutPu(start = PMaxPu) "Maximum output electrical power available to the active power control module in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput pFFRPu(start = 0) "Active power in pu (base SNom) added to the main order due to the Fast Frequency Response" annotation(
    Placement(visible = true, transformation(origin = {-90, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-160, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput pMeasPu(start = -P0Pu * SystemBase.SnRef / SNom) "Measured (and filtered) active power component in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-40, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-190, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference provided by the plant controller in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-190, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uMeasPu(start = U0Pu) "Measured (and filtered) voltage component in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {10, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput iPcmdPu(start = P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Inner variables
  Real iPcmdFreezePu(start = P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Value of iPcmdPu pre-fault that is kept until a new fault";
  Real pRefFreezePu(start = -P0Pu * SystemBase.SnRef / SNom) "Value of pRefPu pre-fault that is kept until a new fault";

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = TpRef, y_start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = Modelica.Constants.inf, uMin = 0.01) annotation(
    Placement(visible = true, transformation(origin = {10, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {16, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y = PFlag) annotation(
    Placement(visible = true, transformation(origin = {80, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1(limitsAtInit = true)  annotation(
    Placement(visible = true, transformation(origin = {162, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch11 annotation(
    Placement(visible = true, transformation(origin = {82, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = iPcmdFreezePu)  annotation(
    Placement(visible = true, transformation(origin = {41, -80}, extent = {{-19, -10}, {19, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = pRefFreezePu)  annotation(
    Placement(visible = true, transformation(origin = {-127, -59}, extent = {{-18, -18}, {18, 18}}, rotation = 90)));
  Dynawo.NonElectrical.Blocks.Continuous.PIFreeze pIFreeze(Gain = KPp, Y0 = -P0Pu * SystemBase.SnRef / (SNom * U0Pu), tIntegral = 1 / KIp) annotation(
    Placement(visible = true, transformation(origin = {50, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit IPMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit IPMin0Pu "Initial minimum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit PAvailIn0Pu "Initial minimum output electrical power available to the active power control module in pu (base SNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group="Operating point"));

equation
  when FFlag == true then
    pRefFreezePu = pre(pRefPu);
    iPcmdFreezePu = pre(iPcmdPu);
  end when;

  connect(pRefPu, firstOrder.u) annotation(
    Line(points = {{-200, 0}, {-162, 0}}, color = {0, 0, 127}));
  connect(add.y, variableLimiter.u) annotation(
    Line(points = {{-59, 0}, {-32, 0}}, color = {0, 0, 127}));
  connect(division.y, switch1.u3) annotation(
    Line(points = {{41, 0}, {60.5, 0}, {60.5, 8}, {98, 8}}, color = {0, 0, 127}));
  connect(switch1.y, variableLimiter1.u) annotation(
    Line(points = {{121, 0}, {150, 0}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, iPcmdPu) annotation(
    Line(points = {{173, 0}, {200, 0}}, color = {0, 0, 127}));
  connect(realExpression1.y, switch.u1) annotation(
    Line(points = {{-127, -39.2}, {-127.2, -39.2}, {-127.2, -8.2}, {-122, -8.2}}, color = {0, 0, 127}));
  connect(firstOrder.y, switch.u3) annotation(
    Line(points = {{-139, 0}, {-134.5, 0}, {-134.5, 8}, {-122, 8}}, color = {0, 0, 127}));
  connect(add1.y, pIFreeze.u) annotation(
    Line(points = {{27, -32}, {38, -32}}, color = {0, 0, 127}));
  connect(pIFreeze.y, switch11.u3) annotation(
    Line(points = {{61, -32}, {70, -32}}, color = {0, 0, 127}));
  connect(switch.y, add.u2) annotation(
    Line(points = {{-98, 0}, {-90, 0}, {-90, -6}, {-82, -6}}, color = {0, 0, 127}));
  connect(pFFRPu, add.u1) annotation(
    Line(points = {{-90, 120}, {-90, 6}, {-82, 6}}, color = {0, 0, 127}));
  connect(variableLimiter.y, add1.u1) annotation(
    Line(points = {{-8, 0}, {0, 0}, {0, -26}, {4, -26}}, color = {0, 0, 127}));
  connect(variableLimiter.y, division.u1) annotation(
    Line(points = {{-8, 0}, {0, 0}, {0, -6}, {18, -6}}, color = {0, 0, 127}));
  connect(pMeasPu, add1.u2) annotation(
    Line(points = {{-40, -40}, {0, -40}, {0, -38}, {4, -38}}, color = {0, 0, 127}));
  connect(pAvailOutPu, variableLimiter.limit1) annotation(
    Line(points = {{-40, 110}, {-40, 8}, {-32, 8}}, color = {0, 0, 127}));
  connect(pAvailInPu, variableLimiter.limit2) annotation(
    Line(points = {{-56, 110}, {-56, -8}, {-32, -8}}, color = {0, 0, 127}));
  connect(uMeasPu, limiter.u) annotation(
    Line(points = {{10, 120}, {10, 82}}, color = {0, 0, 127}));
  connect(limiter.y, division.u2) annotation(
    Line(points = {{10, 60}, {10, 6}, {18, 6}}, color = {0, 0, 127}));
  connect(realExpression.y, switch11.u1) annotation(
    Line(points = {{62, -80}, {66, -80}, {66, -48}, {70, -48}}, color = {0, 0, 127}));
  connect(booleanExpression.y, switch1.u2) annotation(
    Line(points = {{80, 60}, {80, 0}, {98, 0}}, color = {255, 0, 255}));
  connect(switch11.y, switch1.u1) annotation(
    Line(points = {{94, -40}, {98, -40}, {98, -8}}, color = {0, 0, 127}));
  connect(iPMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{140, 110}, {140, 8}, {150, 8}}, color = {0, 0, 127}));
  connect(iPMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{126, 110}, {126, -8}, {150, -8}}, color = {0, 0, 127}));
  connect(FFlag, pIFreeze.freeze) annotation(
    Line(points = {{-80, -120}, {-80, -60}, {50, -60}, {50, -44}}, color = {255, 0, 255}));
  connect(FFlag, switch11.u2) annotation(
    Line(points = {{-80, -120}, {-80, -60}, {62, -60}, {62, -40}, {70, -40}}, color = {255, 0, 255}));
  connect(FFlag, switch.u2) annotation(
    Line(points = {{-80, -120}, {-80, -20}, {-130, -20}, {-130, 0}, {-122, 0}}, color = {255, 0, 255}));

  annotation(
    Icon(graphics = {Rectangle(extent = {{-180, 100}, {180, -100}}), Text(extent = {{-180, 100}, {180, -100}}, textString = "PControl")}, coordinateSystem(extent = {{-180, -100}, {180, 100}})),
    Diagram(coordinateSystem(extent = {{-180, -100}, {180, 100}})));
end PControl;
