within Dynawo.Examples.Nordic.Components.TransformerWithControl;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
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

model TransformerWithControl "Model of transformer with variable tap, for the Nordic 32 test system"
  import Dynawo;
  import Dynawo.Types;

  extends Dynawo.AdditionalIcons.Transformer;

  parameter TransformerParameters.tfoPreset tfo;

  //Terminals
  Dynawo.Connectors.ACPower terminal1 "Connector used to connect the transformer to the grid" annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2 "Connector used to connect the transformer to the grid" annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.Transformers.TapChanger tapChanger(
    U0 = U10Pu, UDeadBand = 0.01, UTarget = 1, increaseTapToIncreaseValue = false, locked0 = false, regulating0 = true,
    state0 = Dynawo.Electrical.Controls.Transformers.BaseClasses.TapChangerPhaseShifterParams.State.Standard,
    t1st = TransformerParameters.tfoParamValues[tfo, TransformerParameters.tfoParams.t1st],
    tNext = TransformerParameters.tfoParamValues[tfo, TransformerParameters.tfoParams.tNext], tap0(fixed = false),
    tapMax = TransformerParameters.NbTap - 1, tapMin = 0) annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.Nordic.Components.TransformerWithControl.BaseClasses.InitializedTransformerVariableTap tfoVariableTap(
    SNom = TransformerParameters.tfoParamValues[tfo, TransformerParameters.tfoParams.SNom],
    X = TransformerParameters.tfoParamValues[tfo, TransformerParameters.tfoParams.X],
    Uc20Pu = TransformerParameters.tfoParamValues[tfo, TransformerParameters.tfoParams.Uc20Pu],
    G = 0, B = 0, R = 0,
    P10Pu = P10Pu, Q10Pu = Q10Pu, U10Pu = U10Pu, U1Phase0 = U1Phase0) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-50, -50}, {50, 50}}, rotation = 0)));

  parameter Types.ActivePowerPu P10Pu;
  parameter Types.ReactivePowerPu Q10Pu;
  parameter Types.VoltageModulePu U10Pu;
  parameter Types.Angle U1Phase0;

initial algorithm
  tapChanger.tap0 := tfoVariableTap.Tap0;

initial equation
  tapChanger.tap.value = tfoVariableTap.Tap0;
  tfoVariableTap.tap.value = tfoVariableTap.Tap0;

equation
  tapChanger.locked = false;
  tapChanger.switchOffSignal1.value = false;
  tapChanger.switchOffSignal2.value = false;
  tfoVariableTap.switchOffSignal1.value = false;
  tfoVariableTap.switchOffSignal2.value = false;

  when tapChanger.tap.value <> pre(tapChanger.tap.value) then
    tfoVariableTap.tap.value = tapChanger.tap.value;
  end when;

  connect(tfoVariableTap.U1Pu, tapChanger.UMonitored);
  connect(tfoVariableTap.terminal1, terminal1) annotation(
    Line(points = {{-50, 0}, {-110, 0}}, color = {0, 0, 255}));
  connect(tfoVariableTap.terminal2, terminal2) annotation(
    Line(points = {{50, 0}, {110, 0}}, color = {0, 0, 255}));

  annotation(preferredView = "text",
    Icon(graphics = {Rectangle(lineThickness = 0.75, extent = {{-100, 100}, {100, -100}})}),
    Documentation(info = "<html><head></head><body>The controlled tfo frame represents the regulated transformer of the Nordic 32 test system.<div>It consists of a variable tap transformer and an on-load tap changer with 33 positions, keeping the transformer ratios in the interval [0.88, 1.20] and the distribution voltage in the deadband [0.99, 1.01].</div><div><div style=\"font-size: 12px;\">The implementation uses a transformer preset, which automatically sets the parameters of all elements to those of the corresponding chosen transformer.</div><div style=\"font-size: 12px;\">To add another configuration, append a new line to \"tfoParamValues\" in TransformerParameters and append a fitting name in the \"tfoPreset\" enumeration.</div></div></body></html>"));
end TransformerWithControl;
