within Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

partial model BaseControl4 "Whole generator base control module for type 4 wind turbines (IEC N°61400-27-1)"

  //Nominal parameters
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

  //PControl parameters
  parameter Types.PerUnit Kpaw "Anti-windup gain for active power in pu/s (base SNom)" annotation(
    Dialog(tab = "PControl"));

  //Current limiter parameters
  parameter Types.CurrentModulePu IMaxDipPu "Maximum current during voltage dip at converter terminal in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.CurrentModulePu IMaxPu "Maximum continuous current at converter terminal in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.PerUnit Kpqu "Partial derivative of reactive current limit against voltage in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Boolean MdfsLim "Limitation of type 3 stator current (false: total current limitation, true: stator current limitation)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Boolean Mqpri "Prioritization of reactive power during FRT (false: active power priority, true: reactive power priority)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.VoltageModulePu UpquMaxPu "WT voltage in the operation point where zero reactive power can be delivered, in pu (base UNom)" annotation(
    Dialog(tab = "CurrentLimiter"));

  //QControl parameters
  parameter Types.PerUnit IqH1Pu "Maximum reactive current injection during dip in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit IqMaxPu "Maximum reactive current injection in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit IqMinPu "Minimum reactive current injection in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit IqPostPu "Post-fault reactive current injection in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kiq "Reactive power PI controller integration gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kiu "Voltage PI controller integration gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpq "Reactive power PI controller proportional gain in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpu "Voltage PI controller proportional gain in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kqv "Voltage scaling factor for FRT current in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Integer MqG "General Q control mode (0-4) : Voltage control (0), Reactive power control (1), Open loop reactive power control (2), Power factor control (3), Open loop power factor control (4)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit RDropPu "Resistive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tPost "Length of time period where post-fault reactive power is injected, in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tQord "Reactive power order lag time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UMaxPu "Maximum voltage in voltage PI controller integral term in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UMinPu "Minimum voltage in voltage PI controller integral term in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UqDipPu "Voltage threshold for UVRT detection in Q control in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu URef0Pu "User-defined bias in voltage reference in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit XDropPu "Inductive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));

  //QLimiter parameters
  parameter Boolean QlConst "True if limits are constant" annotation(
    Dialog(tab = "QLimiter"));
  parameter Types.ReactivePowerPu QMaxPu "Constant maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "QLimiter"));
  parameter Types.ReactivePowerPu QMinPu "Constant minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "QLimiter"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaGenPu(start = SystemBase.omega0Pu) "Generator angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PWTRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tanPhi(start = Q0Pu / P0Pu) "Tangent phi (can be figured as QPu / PPu)" annotation(
    Placement(visible = true, transformation(origin = {-180, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput xWTRefPu(start = XWT0Pu) "Reactive power loop reference : reactive power or voltage reference depending on the Q control mode (MqG), in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -59.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = IpMax0Pu) "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu(start = IqMax0Pu) "Maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu(start = IqMin0Pu) "Minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
  parameter Types.ReactivePowerPu QMax0Pu "Initial maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu QMin0Pu "Initial minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit XWT0Pu "Initial reactive power or voltage reference at grid terminal in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));

equation

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {-16, 31}, extent = {{-76, -18}, {92, 28}}, textString = "IEC WT 4"), Text(origin = {-11, -34}, extent = {{-77, -16}, {100, 30}}, textString = "Generator Control")}),
    Diagram(coordinateSystem(extent = {{-160, -160}, {160, 160}})));
end BaseControl4;
