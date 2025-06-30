within Dynawo.Examples.RVS.Components.TransformerWithControl;

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

model TransformerWithControl "Model of transformer with variable tap and built-in initialization, for the RVS test system"
  import Dynawo.Examples.RVS.Components.TransformerWithControl.BaseClasses.TransformerParameters;

  extends Dynawo.AdditionalIcons.Transformer;

  parameter TransformerParameters.tfoPreset tfo "Transformer name";

  //Terminals
  Dynawo.Connectors.ACPower terminal1 "Connector used to connect the transformer to the grid" annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2 "Connector used to connect the transformer to the grid" annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Examples.RVS.Components.TransformerWithControl.BaseClasses.InitializedTransformerVariableTap tfoVariableTap(
    B = 0,
    G = 0,
    increaseTapToIncreaseValue = false,
    P10Pu = P10Pu,
    Q10Pu = Q10Pu,
    R = TransformerParameters.tfoParamValues[tfo, TransformerParameters.tfoParams.R],
    regulating0 = true,
    SNom = TransformerParameters.tfoParamValues[tfo, TransformerParameters.tfoParams.SNom],
    state0 = Dynawo.Electrical.Controls.Transformers.BaseClasses.TapChangerPhaseShifterParams.State.Standard,
    t1st = TransformerParameters.tfoParamValues[tfo, TransformerParameters.tfoParams.t1st],
    tapMax = TransformerParameters.NbTap - 1,
    tapMin = 0,
    tNext = TransformerParameters.tfoParamValues[tfo, TransformerParameters.tfoParams.tNext],
    U0 = U10Pu,
    U10Pu = U10Pu,
    U1Phase0 = U1Phase0,
    Uc20Pu = TransformerParameters.tfoParamValues[tfo, TransformerParameters.tfoParams.Uc20Pu],
    UDeadBand = 0.01,
    UTarget = U10Pu,
    X = TransformerParameters.tfoParamValues[tfo, TransformerParameters.tfoParams.X]) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-50, -50}, {50, 50}}, rotation = 0)));

  parameter Types.ActivePowerPu P10Pu "Initial active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Initial reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Initial voltage amplitude at terminal 1 in pu (base U1Nom)";
  parameter Types.Angle U1Phase0 "Initial voltage angle at terminal 1 in rad";

initial algorithm
  tfoVariableTap.tapChanger.tap0 := tfoVariableTap.transformerVariableTap.Tap0;

initial equation
  tfoVariableTap.tapChanger.tap.value = tfoVariableTap.Tap0;
  tfoVariableTap.transformerVariableTap.tap.value = tfoVariableTap.Tap0;

equation
  tfoVariableTap.locked = false;
  tfoVariableTap.switchOffSignal1.value = false;
  tfoVariableTap.switchOffSignal2.value = false;

  connect(tfoVariableTap.terminal1, terminal1) annotation(
    Line(points = {{-50, 0}, {-110, 0}}, color = {0, 0, 255}));
  connect(tfoVariableTap.terminal2, terminal2) annotation(
    Line(points = {{50, 0}, {110, 0}}, color = {0, 0, 255}));

  annotation(
    preferredView = "text",
    Icon(graphics = {Rectangle(lineThickness = 0.75, extent = {{-100, 100}, {100, -100}})}),
    Documentation(info = "<html><head></head><body>The controlled tfo frame represents the regulated transformer of the Nordic 32 test system.<div>It consists of a variable tap transformer and an on-load tap changer with 33 positions, keeping the transformer ratios in the interval [0.88, 1.20] and the distribution voltage in the deadband [0.99, 1.01].</div><div><div style=\"font-size: 12px;\">The implementation uses a transformer preset, which automatically sets the parameters of all elements to those of the corresponding chosen transformer.</div><div style=\"font-size: 12px;\">To add another configuration, append a new line to \"tfoParamValues\" in TransformerParameters and append a fitting name in the \"tfoPreset\" enumeration.</div></div></body></html>"));
end TransformerWithControl;
