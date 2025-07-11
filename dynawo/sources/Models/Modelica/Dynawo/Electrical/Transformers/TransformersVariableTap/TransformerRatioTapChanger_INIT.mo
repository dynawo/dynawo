within Dynawo.Electrical.Transformers.TransformersVariableTap;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model TransformerRatioTapChanger_INIT "Initialization model for TransformerRatioTapChanger"
  extends TransformersFixedTap.TransformerFixedRatioAndPhase_INIT(RatioTfo0Pu = RatioTfoMinPu + (RatioTfoMaxPu - RatioTfoMinPu) * (Tap0 / (NbTap - 1))) ;

  parameter Integer NbTap "Number of taps";
  parameter Types.PerUnit RatioTfoMinPu "Minimum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.PerUnit RatioTfoMaxPu "Maximum transformation ratio in pu: U2/U1 in no load conditions";

  parameter Integer Tap0 "Start value of transformer tap";

  annotation(preferredView = "text");
end TransformerRatioTapChanger_INIT;
