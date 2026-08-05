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

model TransformerVariableTapPQControlled_INIT
  extends AdditionalIcons.Init;

  // Transformer parameters
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.Percent R "Resistance in % (base U2Nom, SNom)";
  parameter Types.Percent X "Reactance in % (base U2Nom, SNom)";
  parameter Types.Percent G "Conductance in % (base U2Nom, SNom)";
  parameter Types.Percent B "Susceptance in % (base U2Nom, SNom)";
  parameter Types.PerUnit rTfoMinPu "Minimum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.PerUnit rTfoMaxPu "Maximum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Integer NbTap "Number of taps";
  parameter Types.VoltageModulePu Uc20Pu "Voltage set-point on side 2 in pu (base U2Nom)";

  // Tap changer parameters
  parameter Types.VoltageModule UTarget "Voltage set-point";
  parameter Types.VoltageModule UDeadBand "Voltage dead-band";
  parameter Boolean regulating0 "Whether the phase-shifter is initially regulating";

  // Transformer initialization model
  Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerVariableTapPQ_INIT transformerVariableTapPQ_INIT(B = B, G = G, NbTap = NbTap, P10Pu = P10Pu, Q10Pu = Q10Pu, R = R, SNom = SNom, U10Pu = U10Pu, U1Phase0 = U1Phase0, Uc20Pu = Uc20Pu, X = X, rTfoMaxPu = rTfoMaxPu, rTfoMinPu = rTfoMinPu) annotation(
    Placement(visible = true, transformation(origin = {-30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Tap changer with transformer initialization model
  Dynawo.Electrical.Controls.Transformers.TapChangerWithTransformer_INIT tapChangerWithTransformer_INIT(UDeadBand = UDeadBand, UTarget = UTarget, regulating0 = regulating0) annotation(
    Placement(visible = true, transformation(origin = {30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Terminals for init connections
  Dynawo.Connectors.ACPower terminal20 "Connector on side 2 at initialization";

  Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base U1Nom, SnRef) (receptor convention)";
  Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base U2Nom, SnRef) (receptor convention)";
  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base U1Nom)";
  Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in pu (base U2Nom)";

  Boolean increaseTapToIncreaseValue "Whether increasing the tap will increase the monitored value";
  Types.PerUnit rTfo0Pu "Start value of transformer ratio";
  Integer Tap0 "Initial tap";
  Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base U2Nom)";
  Types.VoltageModule U0 "Initial absolute voltage";

  type State = enumeration(MoveDownN "1: phase shifter has decreased the next tap",
                           MoveDown1 "2: phase shifter has decreased the first tap",
                           WaitingToMoveDown "3: phase shifter is waiting to decrease the first tap",
                           Standard "4:phase shifter is in Standard state with UThresholdDown <= UMonitored <= UThresholdUp",
                           WaitingToMoveUp "5: phase shifter is waiting to increase the first tap",
                           MoveUp1 "6: phase shifter has increased the first tap",
                           MoveUpN "7: phase shifter has increased the next tap",
                           Locked "8: phase shifter locked");
  State state0 "Initial state";

  // Initial parameters from users
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base UNom)";
  parameter Types.Angle U1Phase0 "Start value of voltage angle at terminal 1 in rad";

equation
  connect(terminal20, transformerVariableTapPQ_INIT.terminal20);
  i10Pu = transformerVariableTapPQ_INIT.i10Pu;
  i20Pu = transformerVariableTapPQ_INIT.i20Pu;
  u10Pu = transformerVariableTapPQ_INIT.u10Pu;
  u20Pu = transformerVariableTapPQ_INIT.u20Pu;

  transformerVariableTapPQ_INIT.Tap0 = tapChangerWithTransformer_INIT.tap0;
  transformerVariableTapPQ_INIT.U20Pu = tapChangerWithTransformer_INIT.U0;

  increaseTapToIncreaseValue = tapChangerWithTransformer_INIT.increaseTapToIncreaseValue;
  rTfo0Pu = transformerVariableTapPQ_INIT.rTfo0Pu;
  state0 = tapChangerWithTransformer_INIT.state0;
  Tap0 = tapChangerWithTransformer_INIT.tap0;
  U0 = tapChangerWithTransformer_INIT.U0;
  U20Pu = transformerVariableTapPQ_INIT.U20Pu;

  annotation(preferredView = "text");
end TransformerVariableTapPQControlled_INIT;
