within Dynawo.Electrical.Transformers.TransformersVariableTapControlled;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

model IdealTransformerVariableTapControlled
  extends AdditionalIcons.Transformer;
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffTransformer;

  // TapChanger parameters
  type State = enumeration(MoveDownN "1: tap-changer/phase-shifter has decreased the next tap",
                           MoveDown1 "2: tap-changer/phase-shifter has decreased the first tap",
                           WaitingToMoveDown "3: tap-changer/phase-shifter is waiting to decrease the first tap",
                           Standard "4: tap-changer/phase-shifter is in standard state with UThresholdDown <= UMonitored <= UThresholdUp",
                           WaitingToMoveUp "5: tap-changer/phase-shifter is waiting to increase the first tap",
                           MoveUp1 "6: tap-changer/phase-shifter has increased the first tap",
                           MoveUpN "7: tap-changer/phase-shifter has increased the next tap",
                           Locked "8: tap-changer/phase-shifter locked");

  parameter Boolean increaseTapToIncreaseValue "Whether increasing the tap will increase the monitored value";
  parameter Boolean regulating0 "Whether the tap-changer/phase-shifter is initially regulating";
  parameter State state0 "Initial state";
  parameter Integer tapMin "Minimum tap";
  parameter Integer tapMax "Maximum tap";
  parameter Integer Tap0 "Initial tap";
  parameter Types.Time t1st(min = 0) "Time lag before changing the first tap in s";
  parameter Types.Time tNext(min = 0) "Time lag before changing subsequent taps in s";
  parameter Types.VoltageModule U0 "Initial voltage";
  parameter Types.VoltageModule UDeadBand(min = 0) "Voltage dead-band";
  parameter Types.VoltageModule UTarget "Voltage set-point";
  parameter Types.VoltageModule UNom = 1 "Nominal voltage in kV";

  // Transformer parameters
  parameter Types.PerUnit rTfoMinPu "Minimum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.PerUnit rTfoMaxPu "Maximum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Integer NbTap "Number of taps";

  // Terminals
  Dynawo.Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Ideal transformer
  Dynawo.Electrical.Transformers.TransformersVariableTap.IdealTransformerVariableTap idealTransformerVariableTap(NbTap = NbTap, P10Pu = P10Pu, Q10Pu = Q10Pu, Tap0 = Tap0, U10Pu = U10Pu, U20Pu = U20Pu, i10Pu = i10Pu, i20Pu = i20Pu, rTfo0Pu = rTfo0Pu, rTfoMaxPu = rTfoMaxPu, rTfoMinPu = rTfoMinPu, u10Pu = u10Pu, u20Pu = u20Pu)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Tap Changer
  Dynawo.Electrical.Controls.Transformers.TapChanger tapChanger(U0 = U0, UDeadBand = UDeadBand, UTarget = UTarget, increaseTapToIncreaseValue = increaseTapToIncreaseValue, regulating0 = regulating0, state0 = state0, t1st = t1st, tNext = tNext, tap0 = Tap0, tapMax = tapMax, tapMin = tapMin, UNom = UNom)  annotation(
    Placement(visible = true, transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Boolean locked(start = tapChanger.locked0) "Whether the tap-changer is locked";

  // Initial parameters from initialization model
  parameter Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base U2Nom, SnRef) (receptor convention)";
  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base U1Nom, SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base U1Nom)";
  parameter Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in pu (base U2Nom)";
  parameter Types.PerUnit rTfo0Pu "Start value of transformer ratio";

  // Initial parameters
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base U1Nom)";
  parameter Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base U2Nom)";

equation
  tapChanger.UMonitored = idealTransformerVariableTap.U2Pu;
  locked = tapChanger.locked;

  when tapChanger.tap.value <> pre(tapChanger.tap.value) then
    idealTransformerVariableTap.tap.value = tapChanger.tap.value;
  end when;

  idealTransformerVariableTap.switchOffSignal1.value = tapChanger.switchOffSignal1.value;
  idealTransformerVariableTap.switchOffSignal2.value = tapChanger.switchOffSignal2.value;

  switchOffSignal1.value = idealTransformerVariableTap.switchOffSignal1.value;
  switchOffSignal2.value = idealTransformerVariableTap.switchOffSignal2.value;

  connect(idealTransformerVariableTap.terminal1, terminal1) annotation(
    Line(points = {{-10, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(idealTransformerVariableTap.terminal2, terminal2) annotation(
    Line(points = {{10, 0}, {100, 0}}, color = {0, 0, 255}));

end IdealTransformerVariableTapControlled;
