within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.ACVoltageControl;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model ACVoltageControl "AC voltage control for HVDC"
  import Modelica;
  import Dynawo.Electrical.HVDC;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_ACVoltageControl;
  parameter Types.CurrentModulePu InPu "Nominal current in pu (base SNom, UNom)";

  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) "Active power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage module in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = Q0Pu) "Reactive power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = U0Pu + Lambda * Q0Pu) "Reference voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = Q0Pu) "Reference reactive power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput modeU(start = modeU0) "Boolean assessing the mode of the control: true if U mode, false if Q mode" annotation(
    Placement(visible = true, transformation(origin = {-110, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput blocked(start = false) "Boolean assessing the state of the HVDC link: true if blocked, false if not blocked" annotation(
    Placement(visible = true, transformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput IqMaxPu(start = sqrt(InPu ^ 2 - Ip0Pu ^ 2)) "Max reactive current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput IqMinPu(start = - sqrt(InPu ^ 2 - Ip0Pu ^ 2)) "Min reactive current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = Iq0Pu) "Reactive current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {210, 7}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqModPu(start = 0) "Additional reactive current in case of fault or overvoltage in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {210, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  HVDC.HvdcVSC.BaseControls.ACVoltageControl.QRefQU qRefQU(DeadBandU = DeadBandU, KiACVoltageControl = KiACVoltageControl, KpACVoltageControl = KpACVoltageControl, Lambda = Lambda, Q0Pu = Q0Pu, QMaxCombPu = QMaxCombPu, QMinCombPu = QMinCombPu, SlopeQRefPu = SlopeQRefPu, SlopeURefPu = SlopeURefPu, U0Pu = U0Pu) "Function that calculates QRef for the Q mode and the U mode depending on the setpoints for URef and QRef" annotation(
    Placement(visible = true, transformation(origin = {-84, -13}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HVDC.HvdcVSC.BaseControls.ACVoltageControl.QRefLim qRefLim(P0Pu = P0Pu,Q0Pu = Q0Pu, QMaxOPPu = QMaxOPPu, QMinOPPu = QMinOPPu, U0Pu = U0Pu, tableQMaxPPu = tableQMaxPPu, tableQMaxUPu = tableQMaxUPu, tableQMinPPu = tableQMinPPu, tableQMinUPu = tableQMinUPu) "Function that applies the limitations to QRef" annotation(
    Placement(visible = true, transformation(origin = {-29, -13}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {49, -7}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = TQ, y_start = - Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {77, -7}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {104, -1}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {159, 7}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {40, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {186, 7}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D iqMod(table = tableiqMod)  annotation(
    Placement(visible = true, transformation(origin = {54, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-55, -13}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {131, -1}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {7, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {-29, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit Ip0Pu "Start value of active current in pu (base SNom)";
  parameter Types.PerUnit Iq0Pu "Start value of reactive current in pu (base SNom)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in pu (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SNom) (generator convention)";
  parameter Boolean modeU0 "Start value of the boolean assessing the mode of the control: true if U mode, false if Q mode";

equation
  connect(qRefLim.QRefLimPu, division.u1) annotation(
    Line(points = {{-18, -13}, {37, -13}}, color = {0, 0, 127}));
  connect(division.y, firstOrder.u) annotation(
    Line(points = {{60, -7}, {65, -7}}, color = {0, 0, 127}));
  connect(firstOrder.y, add.u2) annotation(
    Line(points = {{88, -7}, {92, -7}}, color = {0, 0, 127}));
  connect(switch1.y, gain.u) annotation(
    Line(points = {{170, 7}, {174, 7}}, color = {0, 0, 127}));
  connect(gain.y, iqRefPu) annotation(
    Line(points = {{197, 7}, {210, 7}}, color = {0, 0, 127}));
  connect(gain.y, iqRefPu) annotation(
    Line(points = {{197, 7}, {210, 7}}, color = {0, 0, 127}));
  connect(URefPu, qRefQU.URefPu) annotation(
    Line(points = {{-110, -10}, {-95, -10}}, color = {0, 0, 127}));
  connect(QRefPu, qRefQU.QRefPu) annotation(
    Line(points = {{-110, -30}, {-98, -30}, {-98, -16}, {-95, -16}}, color = {0, 0, 127}));
  connect(UPu, iqMod.u[1]) annotation(
    Line(points = {{-110, 30}, {42, 30}}, color = {0, 0, 127}));
  connect(iqMod.y[1], add.u1) annotation(
    Line(points = {{65, 30}, {89, 30}, {89, 5}, {92, 5}}, color = {0, 0, 127}));
  connect(qRefQU.QRefUPu, switch.u1) annotation(
    Line(points = {{-73, -5}, {-67, -5}}, color = {0, 0, 127}));
  connect(qRefQU.QRefQPu, switch.u3) annotation(
    Line(points = {{-73, -21}, {-67, -21}}, color = {0, 0, 127}));
  connect(switch.y, qRefLim.QRefUQPu) annotation(
    Line(points = {{-44, -13}, {-40, -13}}, color = {0, 0, 127}));
  connect(QPu, qRefQU.QPu) annotation(
    Line(points = {{-110, -50}, {-97, -50}, {-97, -20}, {-95, -20}}, color = {0, 0, 127}));
  connect(UPu, qRefQU.UPu) annotation(
    Line(points = {{-110, 30}, {-97, 30}, {-97, -6}, {-95, -6}}, color = {0, 0, 127}));
  connect(modeU, switch.u2) annotation(
    Line(points = {{-110, 10}, {-71, 10}, {-71, -13}, {-67, -13}}, color = {255, 0, 255}));
  connect(PPu, qRefLim.PPu) annotation(
    Line(points = {{-110, -70}, {-43, -70}, {-43, -21}, {-40, -21}}, color = {0, 0, 127}));
  connect(UPu, qRefLim.UPu) annotation(
    Line(points = {{-110, 30}, {-43, 30}, {-43, -5}, {-40, -5}}, color = {0, 0, 127}));
  connect(blocked, switch1.u2) annotation(
    Line(points = {{-110, 70}, {142, 70}, {142, 7}, {147, 7}}, color = {255, 0, 255}));
  connect(zero.y, switch1.u1) annotation(
    Line(points = {{51, 90}, {143, 90}, {143, 15}, {147, 15}}, color = {0, 0, 127}));
  connect(add.y, variableLimiter.u) annotation(
    Line(points = {{115, -1}, {119, -1}}, color = {0, 0, 127}));
  connect(variableLimiter.y, switch1.u3) annotation(
    Line(points = {{142, -1}, {147, -1}}, color = {0, 0, 127}));
  connect(IqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{-110, -90}, {115, -90}, {115, -9}, {119, -9}}, color = {0, 0, 127}));
  connect(IqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{-110, 50}, {115, 50}, {115, 7}, {119, 7}}, color = {0, 0, 127}));
  connect(iqMod.y[1], iqModPu) annotation(
    Line(points = {{65, 30}, {210, 30}}, color = {0, 0, 127}));
  connect(const.y, max.u2) annotation(
    Line(points = {{-18, 14}, {-11.5, 14}, {-11.5, 8}, {-5, 8}}, color = {0, 0, 127}));
  connect(UPu, max.u1) annotation(
    Line(points = {{-110, 30}, {-14, 30}, {-14, 20}, {-5, 20}}, color = {0, 0, 127}));
  connect(max.y, division.u2) annotation(
    Line(points = {{18, 14}, {26, 14}, {26, -1}, {37, -1}, {37, -1}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -100}, {200, 100}})),
    Icon(coordinateSystem(grid = {1, 1})));
end ACVoltageControl;
