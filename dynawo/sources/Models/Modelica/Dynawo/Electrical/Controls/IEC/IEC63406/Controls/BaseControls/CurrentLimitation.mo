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

model CurrentLimitation "Global current limitation block (IEC 63406)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.QLimitParameters;

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Parameters
  parameter Types.PerUnit IMaxPu "Maximum current at converter terminal in pu (base in UNom, SNom) (generator convention)";
  parameter Boolean PriorityFlag "0 for active current priority, 1 for reactive current priority";
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power defined by users in pu (base SNom)";
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power defined by users in pu (base SNom)";

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput FFlag(start = false) "Flag indicating the generating unit operating condition" annotation(
    Placement(visible = true, transformation(origin = {10, 140}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 140}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iPcmdPu(start = - P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-140, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-140, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iQcmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-140, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-140, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qMaxPu(start = QMaxPu) "Maximum reactive power at converter terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-140, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-134, 40}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qMinPu(start = QMinPu) "Minimum reactive power at converter terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-140, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-134, -40}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uMeasPu(start = U0Pu) "Measured (and filtered) voltage component in pu (base UNom)"  annotation(
    Placement(visible = true, transformation(origin = {-140, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-134, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput iPMaxPu(start = IPMax0Pu) "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {130, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iPMinPu(start = IPMin0Pu) "Minimum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {130, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {130, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iQMaxPu(start = IQMax0Pu) "Maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {130, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iQMinPu(start = IQMin0Pu) "Minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {130, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit IPMax0Pu = if PriorityFlag then sqrt(IMaxPu ^ 2 - (Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) ^ 2) else IMaxPu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit IPMin0Pu = if PriorityFlag then -sqrt(IMaxPu ^ 2 - (Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) ^ 2) else -IMaxPu "Initial minimum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit IQMax0Pu = if PriorityFlag then IMaxPu else sqrt(IMaxPu ^ 2 - (-P0Pu * SystemBase.SnRef / (SNom * U0Pu)) ^ 2)  "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit IQMin0Pu = if PriorityFlag then -IMaxPu else -sqrt(IMaxPu ^ 2 - (-P0Pu * SystemBase.SnRef / (SNom * U0Pu)) ^ 2)  "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));

  Dynawo.Electrical.Controls.IEC.IEC63406.Controls.BaseControls.AuxiliaryControls.IqLimitation iqLimitation(IMaxPu = IMaxPu, P0Pu = P0Pu, PriorityFlag = PriorityFlag, SNom = SNom, U0Pu = U0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-60, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch12 annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {58, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch13 annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.Controls.BaseControls.AuxiliaryControls.IpLimitation ipLimitation(IMaxPu = IMaxPu, PriorityFlag = PriorityFlag, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-60, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch11 annotation(
    Placement(visible = true, transformation(origin = {90, 80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {-60, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy,limitsAtInit = false, uMax = Modelica.Constants.inf, uMin = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-100, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch freeze annotation(
    Placement(visible = true, transformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch freeze1 annotation(
    Placement(visible = true, transformation(origin = {40, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division2 annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch freeze4 annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {-10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch16 annotation(
    Placement(visible = true, transformation(origin = {90, 20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = -1) annotation(
    Placement(visible = true, transformation(origin = {60, 40}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  Modelica.Blocks.Math.MinMax minMax(nu = 3)  annotation(
    Placement(visible = true, transformation(origin = {-10, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant IMax(k = IMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-60, 72}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant IMin(k = -IMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-60, -26}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = IMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-60, -100}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant Pritority(k = PriorityFlag) annotation(
    Placement(visible = true, transformation(origin = {74, 130}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant const(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {-5, 115}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-5, 68}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant3(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-5, 7}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

equation
  connect(switch11.y, iQMaxPu) annotation(
    Line(points = {{101, 80}, {130, 80}}, color = {0, 0, 127}));
  connect(switch16.y, iQMinPu) annotation(
    Line(points = {{101, 20}, {130, 20}}, color = {0, 0, 127}));
  connect(iPcmdPu, iqLimitation.iPcmdPu) annotation(
    Line(points = {{-140, 100}, {-72, 100}}, color = {0, 0, 127}));
  connect(qMaxPu, division1.u1) annotation(
    Line(points = {{-140, 60}, {-100, 60}, {-100, 46}, {-72, 46}}, color = {0, 0, 127}));
  connect(uMeasPu, limiter.u) annotation(
    Line(points = {{-140, 20}, {-112, 20}}, color = {0, 0, 127}));
  connect(limiter.y, division1.u2) annotation(
    Line(points = {{-89, 20}, {-80, 20}, {-80, 34}, {-72, 34}}, color = {0, 0, 127}));
  connect(qMinPu, division2.u1) annotation(
    Line(points = {{-140, -20}, {-80, -20}, {-80, -6}, {-72, -6}}, color = {0, 0, 127}));
  connect(limiter.y, division2.u2) annotation(
    Line(points = {{-89, 20}, {-81, 20}, {-81, 6}, {-73, 6}}, color = {0, 0, 127}));
  connect(division1.y, min.u2) annotation(
    Line(points = {{-49, 40}, {-41, 40}, {-41, 34}, {-23, 34}}, color = {0, 0, 127}));
  connect(division2.y, max.u1) annotation(
    Line(points = {{-49, 0}, {-41, 0}, {-41, -14}, {-23, -14}}, color = {0, 0, 127}));
  connect(max.y, freeze4.u3) annotation(
    Line(points = {{1, -20}, {19, -20}, {19, -8}, {27, -8}}, color = {0, 0, 127}));
  connect(min.y, freeze1.u3) annotation(
    Line(points = {{1, 40}, {21, 40}, {21, 52}, {29, 52}}, color = {0, 0, 127}));
  connect(freeze1.y, switch11.u1) annotation(
    Line(points = {{51, 60}, {69, 60}, {69, 72}, {77, 72}}, color = {0, 0, 127}));
  connect(freeze.y, switch11.u3) annotation(
    Line(points = {{51, 100}, {69, 100}, {69, 88}, {77, 88}}, color = {0, 0, 127}));
  connect(freeze4.y, switch16.u1) annotation(
    Line(points = {{51, 0}, {59, 0}, {59, 12}, {77, 12}}, color = {0, 0, 127}));
  connect(freeze.y, gain3.u) annotation(
    Line(points = {{51, 100}, {60, 100}, {60, 47}}, color = {0, 0, 127}));
  connect(FFlag, freeze.u2) annotation(
    Line(points = {{10, 140}, {10, 100}, {28, 100}}, color = {255, 0, 255}));
  connect(FFlag, freeze1.u2) annotation(
    Line(points = {{10, 140}, {10, 60}, {28, 60}}, color = {255, 0, 255}));
  connect(FFlag, freeze4.u2) annotation(
    Line(points = {{10, 140}, {10, 0}, {28, 0}}, color = {255, 0, 255}));
  connect(switch13.y, iPMinPu) annotation(
    Line(points = {{101, -80}, {130, -80}}, color = {0, 0, 127}));
  connect(switch12.y, iPMaxPu) annotation(
    Line(points = {{101, -40}, {130, -40}}, color = {0, 0, 127}));
  connect(gain3.y, switch16.u3) annotation(
    Line(points = {{60, 33}, {60, 27.4}, {78, 27.4}}, color = {0, 0, 127}));
  connect(iQcmdPu, ipLimitation.iQcmdPu) annotation(
    Line(points = {{-140, -80}, {-100, -80}, {-100, -60}, {-72, -60}}, color = {0, 0, 127}));
  connect(ipLimitation.iPMaxPu, switch12.u1) annotation(
    Line(points = {{-48, -54}, {20, -54}, {20, -32}, {78, -32}}, color = {0, 0, 127}));
  connect(ipLimitation.iPMinPu, switch13.u1) annotation(
    Line(points = {{-48, -64}, {20, -64}, {20, -72}, {78, -72}}, color = {0, 0, 127}));
  connect(gain.y, switch13.u3) annotation(
    Line(points = {{69, -100}, {70, -100}, {70, -88}, {78, -88}}, color = {0, 0, 127}));
  connect(division1.y, minMax.u[1]) annotation(
    Line(points = {{-48, 40}, {-34, 40}, {-34, 90}, {-20, 90}}, color = {0, 0, 127}));
  connect(iqLimitation.iQMaxPu, minMax.u[2]) annotation(
    Line(points = {{-48, 100}, {-34, 100}, {-34, 90}, {-20, 90}}, color = {0, 0, 127}));
  connect(minMax.yMin, freeze.u3) annotation(
    Line(points = {{2, 84}, {6, 84}, {6, 92}, {28, 92}}, color = {0, 0, 127}));
  connect(IMax.y, min.u1) annotation(
    Line(points = {{-51, 72}, {-40, 72}, {-40, 46}, {-22, 46}}, color = {0, 0, 127}));
  connect(IMin.y, max.u2) annotation(
    Line(points = {{-52, -26}, {-22, -26}}, color = {0, 0, 127}));
  connect(constant1.y, gain.u) annotation(
    Line(points = {{-52, -100}, {46, -100}}, color = {0, 0, 127}));
  connect(Pritority.y, switch11.u2) annotation(
    Line(points = {{74, 120}, {74, 80}, {78, 80}}, color = {255, 0, 255}));
  connect(Pritority.y, switch16.u2) annotation(
    Line(points = {{74, 120}, {74, 20}, {78, 20}}, color = {255, 0, 255}));
  connect(Pritority.y, switch12.u2) annotation(
    Line(points = {{74, 120}, {74, -40}, {78, -40}}, color = {255, 0, 255}));
  connect(Pritority.y, switch13.u2) annotation(
    Line(points = {{74, 120}, {74, -80}, {78, -80}}, color = {255, 0, 255}));
  connect(IMax.y, minMax.u[3]) annotation(
    Line(points = {{-52, 72}, {-40, 72}, {-40, 90}, {-20, 90}}, color = {0, 0, 127}));
  connect(constant1.y, switch12.u3) annotation(
    Line(points = {{-52, -100}, {40, -100}, {40, -48}, {78, -48}}, color = {0, 0, 127}));
  connect(const.y, freeze.u1) annotation(
    Line(points = {{0, 116}, {20, 116}, {20, 108}, {28, 108}}, color = {0, 0, 127}));
  connect(constant2.y, freeze1.u1) annotation(
    Line(points = {{0, 68}, {28, 68}}, color = {0, 0, 127}));
  connect(constant3.y, freeze4.u1) annotation(
    Line(points = {{0.5, 7}, {14, 7}, {14, 8}, {28, 8}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(extent = {{-120, 120}, {120, -120}}), Text(extent = {{-120, 120}, {120, -120}}, textString = "Current
Limitation")}, coordinateSystem(extent = {{-120, -120}, {120, 120}})),
    Diagram(coordinateSystem(extent = {{-120, -120}, {120, 120}})));
end CurrentLimitation;
