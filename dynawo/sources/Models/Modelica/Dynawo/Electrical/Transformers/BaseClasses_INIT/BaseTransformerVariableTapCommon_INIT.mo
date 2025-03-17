within Dynawo.Electrical.Transformers.BaseClasses_INIT;

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

partial model BaseTransformerVariableTapCommon_INIT "Base model for initialization of transformers with variable tap"

/*
  The initialization scheme is specific and considers that the values on only one side of the transformer are known plus the voltage set point on the other side.
  From these values, the tap position and its corresponding ratio are determined.
  From the tap and ratio values, the final U2, P2 and Q2 values are calculated.
*/

  // Transformer parameters
  parameter Types.PerUnit rTfoMinPu "Minimum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.PerUnit rTfoMaxPu "Maximum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Integer NbTap "Number of taps";
  parameter Types.VoltageModulePu Uc20Pu "Voltage set-point on side 2 in pu (base U2Nom)";

  // Transformer start values
  Dynawo.Connectors.ComplexVoltagePuConnector u20Pu "Start value of complex voltage at terminal 2 in pu (base U2Nom)";
  flow Dynawo.Connectors.ComplexCurrentPuConnector i20Pu "Start value of complex current at terminal 2 in pu (base U2Nom, SnRef) (receptor convention)";
  Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base U2Nom)";

  Integer Tap0 "Start value of transformer tap";
  Types.PerUnit rTfo0Pu "Start value of transformer ratio";
  Constants.state state0 = Constants.state.Closed "Start value of connection state";

equation
  // Initial ratio estimation
  if (NbTap == 1) then
    rTfo0Pu = rTfoMinPu;
  else
    rTfo0Pu = rTfoMinPu + (rTfoMaxPu - rTfoMinPu) * (Tap0 / (NbTap - 1));
  end if;

  // Voltage at terminal 2
  U20Pu = ComplexMath.'abs'(u20Pu);

  annotation(preferredView = "text");
end BaseTransformerVariableTapCommon_INIT;
