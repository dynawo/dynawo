within Dynawo.Electrical.Controls.PEIR.BaseControls.Simplified;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model ElectricalControlNordic "Control model for an injector in the modified Nordic system"

  // Plant control parameters
  parameter Types.PerUnit Ki "Integrator gain of plant control";
  parameter Types.PerUnit Kp "Proportional gain of plant control";
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power in pu (base SNom)";
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power in pu (base SNom)";
  parameter Types.Time t1 "Filter time constant for the voltage at the PCC, in s";
  parameter Types.Time t2 "Lead time constant of plant control in s";
  parameter Types.Time t3 "Lag time constant of plant control in s";
  parameter Types.VoltageModulePu VRegDbPu "Half-width of dead band for voltage at the PCC in pu (base UNom)";

  // Electrical control parameters
  parameter Types.CurrentModulePu IMaxPu "Maximum current module in pu (base SNom, UNom)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.Time t4 "Filter time constant for the voltage, in s";
  parameter Types.Time t5 "Reactive current filter time constant in s";
  parameter Types.Time t6 "Active power filter time constant in s";
  parameter Types.VoltageModulePu VtDbPu "Half-width of dead band for voltage at the terminal in pu (base UNom)";

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Reference active power in pu (base SNom)" annotation(
    Placement(transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VRefPu(start = VReg0Pu) "Reference voltage amplitude at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VRegPu(start = VReg0Pu) "Voltage amplitude at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VtPu(start = U0Pu) "Voltage amplitude at the terminal in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VtRefPu(start = U0Pu) "Reference voltage amplitude at the terminal in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealOutput IdRefPu(start = Id0Pu) "Active current reference in pu (base SNom, UNom)" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput IqRefPu(start = Iq0Pu) "Reactive current reference in pu (base SNom, UNom)" annotation(
    Placement(transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.Controls.PEIR.BaseControls.Simplified.ElectricalController electricalController(
    Id0Pu = Id0Pu,
    IMaxPu = IMaxPu,
    Iq0Pu = Iq0Pu,
    P0Pu = P0Pu,
    QExt0Pu = QExt0Pu,
    SNom = SNom,
    t4 = t4,
    t5 = t5,
    t6 = t6,
    U0Pu = U0Pu,
    VtDbPu = VtDbPu) annotation(
    Placement(transformation(origin = {0, -60}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Simplified.PlantController plantController(
    Ki = Ki,
    Kp = Kp,
    QExt0Pu = QExt0Pu,
    QMaxPu = QMaxPu,
    QMinPu = QMinPu,
    t1 = t1,
    t2 = t2,
    t3 = t3,
    VReg0Pu = VReg0Pu,
    VRegDbPu = VRegDbPu) annotation(
    Placement(transformation(origin = {0, 60}, extent = {{-20, -20}, {20, 20}})));

  parameter Types.PerUnit Id0Pu "Initial active current in pu (base SNom, UNom)";
  parameter Types.PerUnit Iq0Pu "Initial reactive current in pu (base SNom, UNom)";
  parameter Types.ActivePowerPu P0Pu "Initial active power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QExt0Pu "Initial reactive power output of the plant controller in pu (base SNom, UNom) (generator convention)";
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at the terminal in pu (base UNom)";
  parameter Types.VoltageModulePu VReg0Pu "Initial voltage amplitude at the PCC in pu (base UNom)";

equation
  connect(VRefPu, plantController.VRefPu) annotation(
    Line(points = {{-120, 80}, {-40, 80}, {-40, 72}, {-24, 72}}, color = {0, 0, 127}));
  connect(VRegPu, plantController.VRegPu) annotation(
    Line(points = {{-120, 40}, {-40, 40}, {-40, 48}, {-24, 48}}, color = {0, 0, 127}));
  connect(VtPu, electricalController.VtPu) annotation(
    Line(points = {{-120, 0}, {-60, 0}, {-60, -60}, {-24, -60}}, color = {0, 0, 127}));
  connect(VtRefPu, electricalController.VtRefPu) annotation(
    Line(points = {{-120, -40}, {-80, -40}, {-80, -68}, {-24, -68}}, color = {0, 0, 127}));
  connect(PRefPu, electricalController.PRefPu) annotation(
    Line(points = {{-120, -80}, {-40, -80}, {-40, -76}, {-24, -76}}, color = {0, 0, 127}));
  connect(plantController.QExtPu, electricalController.QExtPu) annotation(
    Line(points = {{22, 60}, {40, 60}, {40, 0}, {-40, 0}, {-40, -48}, {-24, -48}}, color = {0, 0, 127}));
  connect(electricalController.IdRefPu, IdRefPu) annotation(
    Line(points = {{22, -48}, {80, -48}, {80, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(electricalController.IqRefPu, IqRefPu) annotation(
    Line(points = {{22, -72}, {80, -72}, {80, -80}, {110, -80}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body><div>The control model is described in the paper <a href=\"https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=9446224\">\"Impact of Inverter-Based Generation on Voltage Stability in a Modiﬁed Nordic Test System\"</a>.</div><div><p dir=\"auto\">Plant control : V control</p>
<p dir=\"auto\">Converter control :<br>
Q control : constant reactive power control + voltage control for reactive current injection during voltage dips<br>
P control : constant active power control</p>
<p dir=\"auto\">Current limits logic with Q priority</p></div></body></html>"));
end ElectricalControlNordic;
