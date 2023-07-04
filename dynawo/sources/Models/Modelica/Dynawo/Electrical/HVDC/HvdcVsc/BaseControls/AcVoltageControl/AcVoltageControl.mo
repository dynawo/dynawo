within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.AcVoltageControl;

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

model AcVoltageControl "AC voltage control for HVDC"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;

  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsAcVoltageControl;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsQRefLim;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsQRefQU;

  parameter Types.CurrentModulePu InPu "Nominal current in pu (base SNom, UNom) (DC to AC)";

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput blocked(start = false) "If true, HVDC link is blocked" annotation(
    Placement(visible = true, transformation(origin = {160, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqMaxPu(start = sqrt(InPu ^ 2 - Ip0Pu ^ 2)) "Maximum reactive current reference in pu (base UNom, SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-320, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqMinPu(start = -sqrt(InPu ^ 2 - Ip0Pu ^ 2)) "Minimum reactive current reference in pu (base UNom, SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-320, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanInput modeU(start = ModeU0) "If true, control in U mode, if false, control in Q mode" annotation(
    Placement(visible = true, transformation(origin = {-220, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) "Active power in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-320, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = Q0Pu) "Reactive power in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-320, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = Q0Pu) "Reference reactive power in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-320, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage module in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = U0Pu + LambdaPu * Q0Pu) "Reference voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput iqModPu(start = 0) "Additional reactive current in case of fault or overvoltage in pu (base UNom, SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {310, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = Iq0Pu) "Reactive current reference in pu (base UNom, SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {310, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.AcVoltageControl.QRefQU qRefQU(KiAc = KiAc, KpAc = KpAc, LambdaPu = LambdaPu, Q0Pu = Q0Pu, SlopeQRefPu = SlopeQRefPu, SlopeURefPu = SlopeURefPu, U0Pu = U0Pu) "Function that calculates QRef for the Q mode and the U mode depending on the setpoints for URef and QRef" annotation(
    Placement(visible = true, transformation(origin = {-210, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.AcVoltageControl.QRefLim qRefLim(P0Pu = P0Pu, Q0Pu = Q0Pu, QOpMaxPu = QOpMaxPu, QOpMinPu = QOpMinPu, QPMaxTableName = QPMaxTableName, QPMinTableName = QPMinTableName, QUMaxTableName = QUMaxTableName, QUMinTableName = QUMinTableName, TablesFile = TablesFile, tMeasure = tMeasure, U0Pu = U0Pu) "Function that applies the limitations to QRef" annotation(
    Placement(visible = true, transformation(origin = {-90, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {10, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tQ, y_start = -Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {230, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {170, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {270, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds IqMod(fileName = TablesFile, tableName = IqModTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-90, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-150, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {170, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = InPu) annotation(
    Placement(visible = true, transformation(origin = {-50, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tMeasure, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-270, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tMeasure, y_start = Q0Pu) annotation(
    Placement(visible = true, transformation(origin = {-270, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tMeasure, y_start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-270, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 2, uMin = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-90, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold annotation(
    Placement(visible = true, transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit Ip0Pu "Start value of active current in pu (base SNom) (DC to AC)";
  parameter Types.PerUnit Iq0Pu "Start value of reactive current in pu (base SNom) (DC to AC)";
  parameter Boolean ModeU0 "Initial mode of control : if true, U mode, if false, Q mode";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SNom) (DC to AC)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SNom) (DC to AC)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in pu (base UNom)";

equation
  connect(qRefLim.QRefLimPu, division.u1) annotation(
    Line(points = {{-78, 20}, {-60, 20}, {-60, -86}, {-2, -86}}, color = {0, 0, 127}));
  connect(division.y, firstOrder.u) annotation(
    Line(points = {{21, -80}, {39, -80}}, color = {0, 0, 127}));
  connect(firstOrder.y, add.u2) annotation(
    Line(points = {{62, -81}, {62, -80}, {80, -80}, {80, -46}, {98, -46}}, color = {0, 0, 127}));
  connect(switch1.y, gain.u) annotation(
    Line(points = {{241, 0}, {241, -1}, {259, -1}}, color = {0, 0, 127}));
  connect(URefPu, qRefQU.URefPu) annotation(
    Line(points = {{-320, 60}, {-280, 60}, {-280, 24}, {-222, 24}}, color = {0, 0, 127}));
  connect(QRefPu, qRefQU.QRefPu) annotation(
    Line(points = {{-320, -20}, {-280, -20}, {-280, 16}, {-222, 16}}, color = {0, 0, 127}));
  connect(switch.y, qRefLim.QRefUQPu) annotation(
    Line(points = {{-140, 20}, {-100, 20}}, color = {0, 0, 127}));
  connect(blocked, switch1.u2) annotation(
    Line(points = {{160, 0}, {218, 0}}, color = {255, 0, 255}));
  connect(zero.y, switch1.u1) annotation(
    Line(points = {{181, 40}, {200, 40}, {200, 8}, {217, 8}}, color = {0, 0, 127}));
  connect(add.y, variableLimiter.u) annotation(
    Line(points = {{121, -40}, {158, -40}}, color = {0, 0, 127}));
  connect(variableLimiter.y, switch1.u3) annotation(
    Line(points = {{181, -40}, {200, -40}, {200, -8}, {218, -8}}, color = {0, 0, 127}));
  connect(qRefQU.QRefUPu, switch.u1) annotation(
    Line(points = {{-199, 28}, {-163, 28}}, color = {0, 0, 127}));
  connect(modeU, switch.u2) annotation(
    Line(points = {{-220, 60}, {-180, 60}, {-180, 20}, {-163, 20}}, color = {255, 0, 255}));
  connect(qRefQU.QRefQPu, switch.u3) annotation(
    Line(points = {{-199, 12}, {-163, 12}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(IqMod.y[1], gain1.u) annotation(
    Line(points = {{-79, 100}, {-62, 100}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{-39, 100}, {80, 100}, {80, -34}, {98, -34}}, color = {0, 0, 127}));
  connect(iqModPu, gain1.y) annotation(
    Line(points = {{310, 100}, {-39, 100}}, color = {0, 0, 127}));
  connect(firstOrder1.u, UPu) annotation(
    Line(points = {{-282, 100}, {-320, 100}}, color = {0, 0, 127}));
  connect(firstOrder1.y, qRefQU.UPu) annotation(
    Line(points = {{-259, 100}, {-240, 100}, {-240, 28}, {-222, 28}}, color = {0, 0, 127}));
  connect(firstOrder1.y, IqMod.u) annotation(
    Line(points = {{-259, 100}, {-102, 100}}, color = {0, 0, 127}));
  connect(qRefLim.UPu, firstOrder1.y) annotation(
    Line(points = {{-100, 28}, {-120, 28}, {-120, 100}, {-259, 100}}, color = {0, 0, 127}));
  connect(firstOrder2.y, qRefQU.QPu) annotation(
    Line(points = {{-259, -60}, {-240, -60}, {-240, 12}, {-222, 12}}, color = {0, 0, 127}));
  connect(QPu, firstOrder2.u) annotation(
    Line(points = {{-320, -60}, {-282, -60}}, color = {0, 0, 127}));
  connect(qRefLim.QRefLimPu, qRefQU.QRefLimPu) annotation(
    Line(points = {{-78, 20}, {-60, 20}, {-60, -20}, {-180, -20}, {-180, 16}, {-198, 16}}, color = {0, 0, 127}));
  connect(iqRefPu, gain.y) annotation(
    Line(points = {{310, 0}, {281, 0}}, color = {0, 0, 127}));
  connect(iqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{-320, 140}, {140, 140}, {140, -32}, {158, -32}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(iqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{-320, -140}, {140, -140}, {140, -48}, {158, -48}}, color = {0, 0, 127}));
  connect(firstOrder1.y, limiter.u) annotation(
    Line(points = {{-258, 100}, {-120, 100}, {-120, 60}, {-102, 60}}, color = {0, 0, 127}));
  connect(limiter.y, division.u2) annotation(
    Line(points = {{-78, 60}, {-20, 60}, {-20, -74}, {-2, -74}}, color = {0, 0, 127}));
  connect(gain1.y, lessEqualThreshold.u) annotation(
    Line(points = {{-38, 100}, {0, 100}, {0, 60}, {18, 60}}, color = {0, 0, 127}));
  connect(lessEqualThreshold.y, qRefQU.iqModNeg) annotation(
    Line(points = {{42, 60}, {60, 60}, {60, -40}, {-260, -40}, {-260, 20}, {-222, 20}}, color = {255, 0, 255}));
  connect(firstOrder3.y, qRefLim.PPu) annotation(
    Line(points = {{-280, -100}, {-120, -100}, {-120, 12}, {-102, 12}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(PPu, firstOrder3.u) annotation(
    Line(points = {{-320, -100}, {-282, -100}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-300, -160}, {300, 160}})));
end AcVoltageControl;
